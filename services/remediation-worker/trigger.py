import boto3
import json


sqs = boto3.client('sqs', region_name="eu-central-1", endpoint_url="http://127.0.0.1:4566", aws_access_key_id="test", aws_secret_access_key="test")

queue_url = sqs.get_queue_url(QueueName="security-alerts-queue")['QueueUrl']


event_payload = {
    "bucket_name": "company-confidential-data"
}


sqs.send_message(
    QueueUrl=queue_url,
    MessageBody=json.dumps(event_payload)
)

print("🚨 [SİMÜLASYON] 'company-confidential-data' kovası için zafiyet alarmı SQS kuyruğuna fırlatıldı!")