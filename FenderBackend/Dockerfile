FROM python:3.10-slim-buster

RUN apt-get update -y

# gcc compiler and opencv prerequisites
RUN apt-get -y install nano git build-essential ffmpeg libglib2.0-0 libsm6 libxext6 libxrender-dev

WORKDIR /app

# Detectron2 prerequisites
RUN pip install torch torchvision --extra-index-url https://download.pytorch.org/whl/cpu
RUN pip install cython

# Detectron2 - CPU copy
RUN python -m pip install pyyaml==5.1
RUN python -m pip install 'git+https://github.com/facebookresearch/detectron2.git'

#Install Dev Packages
RUN pip install fastapi[all]
RUN pip install opencv-python

COPY src /app/src

WORKDIR /app/src

CMD ["uvicorn", "main:app", "--host=0.0.0.0", "--port=80"]