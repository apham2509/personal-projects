"""A source outage must never replace the published dashboard with partial data."""

import contextlib
import io
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import firms
import render_static


class RendererFailureTests(unittest.TestCase):
    def test_temporary_outage_exits_75_without_producing_data_or_page(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            out = root / "site" / "index.html"
            stderr = io.StringIO()
            with patch.object(render_static.sys, "argv", ["render_static.py", "--out", str(out)]), \
                    patch.object(render_static, "build_world_data", side_effect=
                                 firms.FirmsUnavailable("FIRMS unavailable after 3 attempts (ReadTimeout)")) as build, \
                    contextlib.redirect_stderr(stderr):
                with self.assertRaises(SystemExit) as raised:
                    render_static.main()
            self.assertEqual(raised.exception.code, 75)
            build.assert_called_once_with("VIIRS_SNPP_NRT")
            self.assertFalse(any(path.is_file() for path in root.rglob("*")))
            self.assertIn("FIRMS unavailable", stderr.getvalue())
            self.assertNotIn("Traceback", stderr.getvalue())

    def test_temporary_outage_preserves_existing_output_files(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            originals = {
                "index.html": "existing dashboard",
                "data_world.json": '{"existing":"world"}',
                "data_iberia.json": '{"existing":"iberia"}',
            }
            for name, contents in originals.items():
                (root / name).write_text(contents)
            with patch.object(render_static.sys, "argv", [
                "render_static.py", "--out", str(root / "index.html")
            ]), patch.object(render_static, "build_world_data", side_effect=
                            firms.FirmsUnavailable("temporary source outage")), \
                    contextlib.redirect_stderr(io.StringIO()):
                with self.assertRaises(SystemExit) as raised:
                    render_static.main()
            self.assertEqual(raised.exception.code, 75)
            self.assertEqual({path.name: path.read_text() for path in root.iterdir()}, originals)

    def test_permanent_or_programming_errors_propagate(self):
        for failure in (firms.FirmsError("HTTP 401"), ValueError("invalid archive")):
            with self.subTest(error=type(failure).__name__), tempfile.TemporaryDirectory() as directory:
                out = Path(directory) / "index.html"
                with patch.object(render_static.sys, "argv", ["render_static.py", "--out", str(out)]), \
                        patch.object(render_static, "build_world_data", side_effect=failure) as build:
                    with self.assertRaises(type(failure)) as raised:
                        render_static.main()
                self.assertIs(raised.exception, failure)
                build.assert_called_once()
                self.assertEqual(list(Path(directory).iterdir()), [])


if __name__ == "__main__":
    unittest.main()
