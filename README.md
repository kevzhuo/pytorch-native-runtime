# PyTorch native runtimes

Source-built native installations of public PyTorch revision
`fd23299d9690b7cf08bba0b3e3f89195026c455a` for Python 3.12 on Linux x86_64.
The public source is https://github.com/pytorch/pytorch.

The CPU build uses the pinned Python 3.12 Debian Bookworm image. The CUDA build
uses CUDA 13.0.2/cuDNN on Ubuntu 24.04 and targets SM80, SM90, SM100, SM120, and
compute_120 PTX. The recipes and dependency pins are in `cpu/` and `cuda/`.

```bash
docker build -t pytorch-native:cpu cpu
docker build -t pytorch-native:cuda cuda
```

Release archives contain the installed PyTorch distribution and its generated
`/app/torch/version.py`. They are intended for the same base image, Python
prefix, dependencies, and an editable source checkout of the pinned revision
at `/app`. They contain no source checkout or build intermediates. Each release
includes the native build configuration and source revision. Numbered parts
must be concatenated in order before extracting the Zstandard tar archive.
The distribution retains its packaged licenses and third-party notices.
