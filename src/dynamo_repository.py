import boto3
import uuid
from datetime import datetime


class DynamoRepository:
    def __init__(self, table_name: str, region: str):
        self.table = boto3.resource(
            "dynamodb", region_name=region
        ).Table(table_name)

    def save_metadata(self, filename: str, s3_path: str) -> dict:
        item = {
            "id": str(uuid.uuid4()),
            "filename": filename,
            "s3_path": s3_path,
            "created_at": datetime.utcnow().isoformat()
        }

        self.table.put_item(Item=item)
        return item
