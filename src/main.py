import os
from fastapi import FastAPI, UploadFile, File

from src.s3_service import S3Service
from src.dynamo_repository import DynamoRepository

from dotenv import load_dotenv

from src.config import AWS_REGION, S3_BUCKET, DYNAMO_TABLE

app = FastAPI(
    title="Cloud Storage Platform",
    description="Simple AWS-native file upload service",
    version="1.0.0",
)

s3_service = S3Service(S3_BUCKET, AWS_REGION)
dynamo_repo = DynamoRepository(DYNAMO_TABLE, AWS_REGION)


@app.get("/")
def health():
    return {"status": "ok"}


@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    content = await file.read()

    s3_path = s3_service.upload(content, file.filename)
    record = dynamo_repo.save(file.filename, s3_path)

    return {
        "message": "uploaded",
        "data": record
    }
