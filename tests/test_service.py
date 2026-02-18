import os
from src.s3_service import S3Service
from src.config import AWS_REGION, S3_BUCKET


 

def test_real_s3_upload():
    bucket = S3_BUCKET
    region = AWS_REGION

    service = S3Service(bucket, region)

    file_bytes = b"hello integration test"
    key = "test-integration.txt"

    url = service.upload(file_bytes, key)

    assert url == f"s3://{bucket}/{key}"
