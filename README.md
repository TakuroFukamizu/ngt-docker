# NGT docker

This is a docker image to use [yahoojapan/NGT](https://github.com/yahoojapan/NGT) and those python binding.  
If you create own docker image from this image, you can create a service work with NGT easier.  


## How to use

```sh
$ docker run --name ngtdev -it --rm -v `pwd`:/opt/dev fkmy/ngt-docker:latest bash
root@8918f9ee6584:/opt/NGT# ngt
Usage : ngt command database data
           command : create search remove append export import reconstruct-graph
root@8918f9ee6584:/opt/NGT# python
Python 3.6.6 (default, Sep  5 2018, 03:40:52)
[GCC 6.3.0 20170516] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> from ngt import base as ngt
```


## Rebuild image

```sh
$ docker build \
    --build-arg NGT_VERSION=1.4.0 \
    --build-arg PYBIND_COMMIT=9343e68b4611926fb9bae4c01a61c83841b1a0a8 \
    -t fkmy/ngt-docker:1.4.0 .
```
