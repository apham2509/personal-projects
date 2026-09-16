"""Offline regressions for bounded, secret-safe FIRMS requests."""

import contextlib
import io
import traceback
import unittest
from unittest.mock import Mock, call, patch

import requests

import firms


SECRET = "test-map-key-do-not-log"
URL = f"https://firms.example/api/area/csv/{SECRET}/world"


def response(status=200, text="data_id,min_date\nVIIRS_SNPP_NRT,2026-09-01\n"):
    result = Mock(spec=requests.Response)
    result.status_code = status
    result.text = text
    result.url = URL
    return result


class RequestRetryTests(unittest.TestCase):
    def test_network_failures_recover_with_bounded_backoff(self):
        for error_type in (
            requests.ConnectionError, requests.ConnectTimeout, requests.ReadTimeout
        ):
            with self.subTest(error=error_type.__name__):
                success = response()
                output = io.StringIO()
                with patch.object(firms.requests, "get", side_effect=[
                    error_type(URL), error_type(URL), success
                ]) as get, patch.object(firms.time, "sleep") as sleep, \
                        contextlib.redirect_stdout(output):
                    self.assertIs(firms._get(URL), success)
                self.assertEqual(get.call_count, 3)
                self.assertEqual(sleep.call_args_list, [call(5), call(10)])
                get.assert_called_with(URL, timeout=(10, 60))
                self.assertNotIn(SECRET, output.getvalue())
                self.assertNotIn(URL, output.getvalue())

    def test_network_exhaustion_has_no_secret_in_output_or_traceback(self):
        for error_type in (
            requests.ConnectionError, requests.ConnectTimeout, requests.ReadTimeout
        ):
            with self.subTest(error=error_type.__name__):
                output = io.StringIO()
                with patch.object(firms.requests, "get", side_effect=error_type(URL)) as get, \
                        patch.object(firms.time, "sleep") as sleep, \
                        contextlib.redirect_stdout(output):
                    try:
                        firms._get(URL)
                    except firms.FirmsUnavailable as error:
                        diagnostic = "".join(traceback.format_exception(error))
                        self.assertIn("after 3 attempts", str(error))
                        self.assertIn(error_type.__name__, str(error))
                    else:
                        self.fail("exhausted retries must raise FirmsUnavailable")
                self.assertEqual(get.call_count, 3)
                self.assertEqual(sleep.call_args_list, [call(5), call(10)])
                self.assertNotIn(SECRET, output.getvalue() + diagnostic)
                self.assertNotIn(URL, output.getvalue() + diagnostic)

    def test_retryable_http_status_recovers(self):
        for status in (429, 500, 502, 503, 504):
            with self.subTest(status=status):
                unavailable, success = response(status), response()
                with patch.object(firms.requests, "get", side_effect=[unavailable, success]) as get, \
                        patch.object(firms.time, "sleep") as sleep, \
                        contextlib.redirect_stdout(io.StringIO()):
                    self.assertIs(firms._get(URL), success)
                self.assertEqual(get.call_count, 2)
                sleep.assert_called_once_with(5)
                unavailable.close.assert_called_once_with()
                success.close.assert_not_called()

    def test_retryable_http_status_exhausts_after_three_attempts(self):
        for status in (429, 500, 502, 503, 504):
            with self.subTest(status=status):
                unavailable = [response(status) for _ in range(3)]
                output = io.StringIO()
                with patch.object(firms.requests, "get", side_effect=unavailable) as get, \
                        patch.object(firms.time, "sleep") as sleep, \
                        contextlib.redirect_stdout(output):
                    with self.assertRaises(firms.FirmsUnavailable) as raised:
                        firms._get(URL)
                self.assertEqual(get.call_count, 3)
                self.assertEqual(sleep.call_args_list, [call(5), call(10)])
                self.assertIn(f"HTTP {status}", str(raised.exception))
                self.assertNotIn(SECRET, str(raised.exception) + output.getvalue())
                for failed_response in unavailable:
                    failed_response.close.assert_called_once_with()

    def test_caller_can_override_timeout_and_attempt_count(self):
        with patch.object(firms.requests, "get", side_effect=requests.ReadTimeout(URL)) as get, \
                patch.object(firms.time, "sleep") as sleep:
            with self.assertRaises(firms.FirmsUnavailable):
                firms._get(URL, tries=1, timeout=(2, 4))
        get.assert_called_once_with(URL, timeout=(2, 4))
        sleep.assert_not_called()

    def test_invalid_attempt_count_does_not_make_a_request(self):
        with patch.object(firms.requests, "get") as get:
            with self.assertRaises(ValueError):
                firms._get(URL, tries=0)
        get.assert_not_called()

    def test_programming_error_is_not_retried_or_reclassified(self):
        failure = ValueError("invalid request configuration")
        with patch.object(firms.requests, "get", side_effect=failure) as get, \
                patch.object(firms.time, "sleep") as sleep:
            with self.assertRaises(ValueError) as raised:
                firms._get(URL)
        self.assertIs(raised.exception, failure)
        self.assertEqual(get.call_count, 1)
        sleep.assert_not_called()


class ApiCallerTests(unittest.TestCase):
    def test_data_availability_permanent_errors_fail_without_retry(self):
        for status in (400, 401, 403, 404, 422):
            with self.subTest(status=status):
                with patch.object(firms, "map_key", return_value=SECRET), \
                        patch.object(firms.requests, "get", return_value=response(status)) as get, \
                        patch.object(firms.time, "sleep") as sleep:
                    try:
                        firms.data_availability()
                    except firms.FirmsError as error:
                        self.assertNotIsInstance(error, firms.FirmsUnavailable)
                        self.assertIn(f"HTTP {status}", str(error))
                        diagnostic = "".join(traceback.format_exception(error))
                    else:
                        self.fail("permanent HTTP error must fail")
                self.assertEqual(get.call_count, 1)
                self.assertEqual(get.call_args.kwargs["timeout"], (10, 60))
                sleep.assert_not_called()
                self.assertNotIn(SECRET, diagnostic)
                self.assertNotIn(URL, diagnostic)

    def test_area_fires_preserves_transaction_limit_retry(self):
        quota = response(400, "Transaction limit exceeded")
        success = response(200, "latitude,longitude,acq_date,acq_time\n1,2,2026-09-01,123\n")
        with patch.object(firms, "map_key", return_value=SECRET), \
                patch.object(firms.requests, "get", side_effect=[quota, success]) as get, \
                patch.object(firms.time, "sleep") as sleep, \
                contextlib.redirect_stdout(io.StringIO()):
            data = firms.area_fires("VIIRS_SNPP_NRT", days=1, date="2026-09-01")
        self.assertEqual(get.call_count, 2)
        self.assertEqual(get.call_args.kwargs["timeout"], (10, 300))
        self.assertEqual(get.call_args_list[0], get.call_args_list[1])
        sleep.assert_called_once_with(60)
        self.assertEqual(len(data), 1)
        self.assertEqual(data.iloc[0]["acq_datetime"].isoformat(), "2026-09-01T01:23:00+00:00")

    def test_area_fires_does_not_retry_other_http_400_errors(self):
        with patch.object(firms, "map_key", return_value=SECRET), \
                patch.object(firms.requests, "get", return_value=response(400, "Invalid source")) as get, \
                patch.object(firms.time, "sleep") as sleep:
            with self.assertRaises(firms.FirmsError) as raised:
                firms.area_fires("invalid-source")
        self.assertNotIsInstance(raised.exception, firms.FirmsUnavailable)
        self.assertEqual(get.call_count, 1)
        sleep.assert_not_called()

    def test_key_status_uses_connect_and_read_timeouts(self):
        success = response()
        success.json.return_value = {"current_transactions": 0}
        with patch.object(firms, "map_key", return_value=SECRET), \
                patch.object(firms.requests, "get", return_value=success) as get:
            self.assertEqual(firms.key_status(), {"current_transactions": 0})
        self.assertEqual(get.call_args.kwargs["timeout"], (10, 30))
        self.assertEqual(get.call_args.kwargs["params"], {"MAP_KEY": SECRET})


if __name__ == "__main__":
    unittest.main()
