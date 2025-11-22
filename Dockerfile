FROM ubuntu:22.04

# To build:
# set -a; source .env; set +a; docker build --secret id=OPENAI_API_KEY -t slinnarsson/biomni-ki .
# To run:
# docker run --env-file .env -p 4991:4991 -v ./Biomni/biomni-http/:/Biomni/biomni-http/ slinnarsson/biomni-ki

LABEL org.opencontainers.image.authors="sten.linnarsson@ki.se"

# Update, and install curl, git, anaconda
RUN apt -yqq update
RUN apt install -y curl
RUN apt install -y git
RUN apt install -y build-essential zlib1g-dev
RUN apt install -y gfortran
RUN apt install -y libgsl-dev
RUN apt install -y wget 
RUN apt install bzip2 

# Install Anaconda
RUN wget https://repo.anaconda.com/archive/Anaconda3-2025.06-1-Linux-aarch64.sh
RUN bash Anaconda3-2025.06-1-Linux-aarch64.sh -b
RUN rm Anaconda3-2025.06-1-Linux-aarch64.sh
ENV PATH=/root/anaconda3/bin:$PATH
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
RUN conda update conda
RUN conda update --all
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# Get biomni and set up environment
COPY . /Biomni
WORKDIR /Biomni/biomni_env
RUN bash setup.sh

SHELL ["/bin/bash", "-c"]
WORKDIR /Biomni
# Install biomni package in the environment
RUN source activate biomni_e1 && pip install .
# Warm up Biomni (download data lake); this needs the OPENAI_API_KEY
RUN --mount=type=secret,id=OPENAI_API_KEY,env=OPENAI_API_KEY source activate biomni_e1 && python -c "from biomni.agent import A1; agent = A1(path='./data', llm='openai-gpt-5', source='OpenAI')"

# Install UV
ENV UV_INSTALL_DIR="/usr/local/bin"
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install supervisor
RUN apt-get update && apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
COPY ./biomni-http/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set up to run the http server using supervisord
WORKDIR /Biomni/biomni-http
RUN chmod +x /Biomni/biomni-http/startup.sh
EXPOSE 4991
CMD ["/usr/bin/supervisord"]
