# biomni-ki

## Purpose

This repository tracks the official Biomni repository (as a git submodule), with minor tweaks to enable three key objectives:

* Make Biomni build without errors on ARM64 (aarch64), so that it can run (in a container) on Apple Silicon and NVIDIA DGX (Grace + Blackwell)
* Build Biomni in a Docker container so that the entire (very complex) environment can be downloaded and used directly, eliminating any installation hassles
* Make Biomni available as a HTTP service run in the container, thereby making it possible to use Biomni as a backend service (e.g. for your own custom AI chat UI)

## How to build

Download `Anaconda3-2025.06-1-Linux-aarch64.sh` from the [Anconda repository archive](https://repo.anaconda.com/archive/). Make sure to get that exact version, which is the only one we have tested.

Place the file at the top of this repository.

Run `docker build -t slinnarsson/biomni-ki .`

