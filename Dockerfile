# Build the image:
# docker build . -t mlsample

# Create and start the container in interactive mode:
# docker run --gpus all -it -v home/$USER/projects/my_project:/home/ml_user/project/ mlsample
FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
LABEL version=1.0

# Dependencies
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
python3-dev python3-pip git g++ wget make libprotobuf-dev protobuf-compiler libopencv-dev \
libhdf5-dev libatlas-base-dev sudo zip unzip build-essential python3-setuptools

RUN apt-get install -y --no-install-recommends libnvinfer6=6.0.1-1+cuda10.1 \
libnvinfer-dev=6.0.1-1+cuda10.1 \
libnvinfer-plugin6=6.0.1-1+cuda10.1

RUN apt-get -y upgrade

RUN python3 -m pip install --upgrade setuptools pip

# Link pip with updated pip3
RUN ln -sf /usr/local/bin/pip3 /usr/bin/pip

RUN useradd -ms /bin/bash ml_user
USER ml_user

WORKDIR /home/ml_user
ENV PATH $PATH:/home/ml_user/.local/bin

# python requirements
#COPY ./building_env/requirements.txt /tmp/
#RUN pip install -r /tmp/requirements.txt
