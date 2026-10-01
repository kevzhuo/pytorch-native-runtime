FROM python:3.12-slim-bookworm@sha256:9c47360a2a0355e2da18516d0b1c2126ec22c195d2185e97347c9d98398c5bef

ARG UPSTREAM_BASE_COMMIT=fd23299d9690b7cf08bba0b3e3f89195026c455a
ARG MAX_JOBS=8

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    OMP_NUM_THREADS=2 \
    MKL_NUM_THREADS=2 \
    OPENBLAS_NUM_THREADS=1 \
    TOKENIZERS_PARALLELISM=false \
    USE_CUDA=0 USE_ROCM=0 USE_XPU=0 \
    USE_DISTRIBUTED=1 USE_MPI=0 USE_TENSORPIPE=0 \
    USE_MKLDNN=0 USE_FBGEMM=0 USE_NNPACK=0 USE_XNNPACK=0 \
    USE_PYTORCH_QNNPACK=0 USE_KINETO=1 USE_CPU_VECTORIZATION=0 \
    BUILD_TEST=0 BUILD_LAZY_TS_BACKEND=0

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ca-certificates git libopenblas-dev patch \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt /tmp/task-requirements.txt
RUN python -m pip install --no-cache-dir --no-deps -r /tmp/task-requirements.txt

WORKDIR /app
COPY fetch_source.sh verify_source.py /tmp/
RUN sh /tmp/fetch_source.sh "${UPSTREAM_BASE_COMMIT}" && rm /tmp/fetch_source.sh /tmp/verify_source.py
RUN MAX_JOBS=${MAX_JOBS} python -m pip install -e . -v --no-build-isolation

