FROM nvidia/cuda:13.0.2-cudnn-devel-ubuntu24.04@sha256:ae7f650405a3964972dacfa889273bf8e3fbe9709899afd187da01c4cdff3105

ARG UPSTREAM_BASE_COMMIT=fd23299d9690b7cf08bba0b3e3f89195026c455a
ARG MAX_JOBS=8
ARG TORCH_CUDA_ARCH_LIST="8.0;9.0;10.0;12.0+PTX"

ENV DEBIAN_FRONTEND=noninteractive PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH=/opt/venv/bin:${PATH} \
    OMP_NUM_THREADS=2 MKL_NUM_THREADS=2 OPENBLAS_NUM_THREADS=1 \
    TOKENIZERS_PARALLELISM=false \
    USE_CUDA=1 USE_ROCM=0 USE_XPU=0 \
    USE_DISTRIBUTED=1 USE_MPI=0 USE_TENSORPIPE=0 USE_NCCL=0 \
    USE_MKLDNN=0 USE_FBGEMM=0 USE_NNPACK=0 USE_XNNPACK=0 \
    USE_PYTORCH_QNNPACK=0 USE_KINETO=1 USE_CPU_VECTORIZATION=0 \
    USE_FLASH_ATTENTION=0 USE_MEM_EFF_ATTENTION=0 USE_MAGMA=0 \
    BUILD_TEST=0 BUILD_LAZY_TS_BACKEND=0 \
    CUDA_HOME=/usr/local/cuda

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ca-certificates git libopenblas-dev patch python3-dev python3-venv \
    && rm -rf /var/lib/apt/lists/* && python3 -m venv /opt/venv
COPY requirements.txt /tmp/task-requirements.txt
RUN python -m pip install --no-cache-dir --no-deps -r /tmp/task-requirements.txt

WORKDIR /app
COPY fetch_source.sh verify_source.py /tmp/
RUN sh /tmp/fetch_source.sh "${UPSTREAM_BASE_COMMIT}" && rm /tmp/fetch_source.sh /tmp/verify_source.py
RUN MAX_JOBS=${MAX_JOBS} python -m pip install -e . -v --no-build-isolation \
    --config-settings="cmake.define.TORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_LIST}"
# This exact Triton revision is pinned by the upstream source checkout.
RUN python -m pip install --no-cache-dir --no-deps \
    --index-url https://download.pytorch.org/whl/nightly/ triton==3.8.0+gitc01b6774
