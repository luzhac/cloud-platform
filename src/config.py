from dotenv import load_dotenv
import os

load_dotenv()

AWS_REGION = os.environ["AWS_REGION"]
S3_BUCKET = os.environ["S3_BUCKET"]
DYNAMO_TABLE = os.environ["DYNAMO_TABLE"]

 