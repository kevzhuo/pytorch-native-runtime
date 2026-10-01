"""Fail early on an incomplete public PyTorch checkout."""

from pathlib import Path
import subprocess
import sys
import tomllib


root = Path("/app")
revision = subprocess.check_output(["git", "rev-parse", "HEAD"], text=True).strip()
if revision != sys.argv[1]:
    raise RuntimeError("Unexpected PyTorch source revision")
statuses = subprocess.check_output(
    ["git", "submodule", "status", "--recursive"], text=True
).splitlines()
if not statuses or any(not line.startswith(" ") for line in statuses):
    raise RuntimeError("Incomplete or unpinned PyTorch submodules")
for pattern in tomllib.loads((root / "pyproject.toml").read_text())["project"]["license-files"]:
    if not any(path.is_file() for path in root.glob(pattern)):
        raise RuntimeError(f"Missing required source license: {pattern}")
print(f"Verified public PyTorch source and {len(statuses)} pinned submodules")
