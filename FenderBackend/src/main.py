from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from pydantic import BaseModel

import logging
import os
import base64

import cv2
import numpy as np

import detectron2

from detectron2 import model_zoo
from detectron2.engine import DefaultPredictor
from detectron2.config import get_cfg
from detectron2.data import MetadataCatalog

logging.basicConfig(level=logging.INFO)
logging.info(f"Detectron2 version is {detectron2.__version__}")

def initialize_predictor():
    cfg = get_cfg()
    cfg.merge_from_file(model_zoo.get_config_file("COCO-Detection/faster_rcnn_R_50_FPN_3x.yaml"))

    cfg.MODEL.WEIGHTS = model_zoo.get_checkpoint_url("COCO-Detection/faster_rcnn_R_50_FPN_3x.yaml")
    cfg.MODEL.ROI_HEADS.SCORE_THRESH_TEST = 0.8
    cfg.MODEL.DEVICE = "cpu"

    classes = MetadataCatalog.get(cfg.DATASETS.TRAIN[0]).thing_classes

    predictor = DefaultPredictor(cfg)
    logging.info("Predictor has been initialized.")

    return (predictor, classes)

def score_image(predictor: DefaultPredictor, image_stream_data: str):
    decoded_string = base64.b64decode(image_stream_data)
    im_arr = np.frombuffer(decoded_string, dtype=np.uint8)
    image = cv2.imdecode(im_arr, flags=cv2.IMREAD_COLOR)

    return predictor(image)

app = FastAPI()
origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class ImageData(BaseModel):
    imgStream: str

predictor, classes = initialize_predictor()

@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.post("/api/detect")
async def say_hello(imgData: ImageData):
    scoring_result = score_image(predictor, imgData.imgStream)

    instances = scoring_result["instances"]
    scores = instances.get_fields()["scores"].tolist()
    pred_classes = instances.get_fields()["pred_classes"].tolist()
    pred_boxes = instances.get_fields()["pred_boxes"].tensor.tolist()

    response = {
        "scores": scores,
        "pred_classes": pred_classes,
        "pred_boxes" : pred_boxes,
        "classes": classes,
    }

    return response
