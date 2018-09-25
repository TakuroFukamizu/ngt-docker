# NGT with Python binding
FROM python:3.6-stretch

LABEL maintainer "Takuro Fukamizu <takuro.f.1987@gmail.com>"

ARG NGT_VERSION
ARG PYBIND_COMMIT=9343e68b4611926fb9bae4c01a61c83841b1a0a8

# -------------------------------

ENV NGT_ROOT=/opt/NGT
ENV NGT_SRC_URL=https://github.com/yahoojapan/NGT/archive/v${NGT_VERSION}.zip

# -------------------------------

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
            build-essential \
            cmake \
            git \
            wget \
            unzip \
    ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# -------------------------------
# install NGT

RUN set -ex; \
    mkdir -p $NGT_ROOT; \
    wget --no-check-certificate $NGT_SRC_URL -O NGT.zip; \
    unzip NGT.zip; \
    mv -T NGT-$NGT_VERSION $NGT_ROOT; \
    rm -f NGT.zip; \
    rm -rf NGT-$NGT_VERSION

WORKDIR $NGT_ROOT
RUN set -ex; \
    mkdir build; \
    cd build; \
    cmake .. && make && make install; \
    ldconfig

# -------------------------------
# install python bind

## install pybind11
WORKDIR /opt
RUN set -ex; \
    git config --global http.sslVerify false; \
    git clone https://github.com/pybind/pybind11.git; \
    (cd ./pybind11 && git checkout $PYBIND_COMMIT); \
    pip3 install /opt/pybind11; \
    export PATH=/opt/pybind11/include:${PATH}; \
    export LD_LIBRARY_PATH=/opt/pybind11/include:${LD_LIBRARY_PATH}

## install ngt bind
WORKDIR $NGT_ROOT
RUN set -ex; \
    cd $NGT_ROOT/python; \
    python3 setup.py sdist; \
    pip3 install dist/ngt-1.2.0.tar.gz; \
    export LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}

# -------------------------------

CMD ["python3"]
