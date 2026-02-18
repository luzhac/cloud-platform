import boto3
from botocore.exceptions import ClientError


class S3Service:
    def __init__(self, bucket_name: str, region: str):
        self.bucket_name = bucket_name
        self.client = boto3.client("s3", region_name=region)

    def upload(self, file_bytes: bytes, key: str) -> str:
        try:
            self.client.put_object(
                Bucket=self.bucket_name,
                Key=key,
                Body=file_bytes,
                ContentType="application/octet-stream"
            )
            return f"s3://{self.bucket_name}/{key}"
        except ClientError as e:
            raise RuntimeError(f"S3 upload failed: {e}")
