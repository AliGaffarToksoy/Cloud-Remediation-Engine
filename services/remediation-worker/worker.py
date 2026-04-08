import boto3
import time
import json
import os


AWS_REGION = os.environ.get("AWS_REGION", "eu-central-1")
ENDPOINT_URL = os.environ.get("AWS_ENDPOINT_URL", "http://127.0.0.1:4566")
QUEUE_NAME = os.environ.get("QUEUE_NAME", "security-alerts-queue")


sqs = boto3.client('sqs', region_name=AWS_REGION, endpoint_url=ENDPOINT_URL, aws_access_key_id="test", aws_secret_access_key="test")
s3 = boto3.client('s3', region_name=AWS_REGION, endpoint_url=ENDPOINT_URL, aws_access_key_id="test", aws_secret_access_key="test")


def get_queue_url():
    response = sqs.get_queue_url(QueueName=QUEUE_NAME)
    return response['QueueUrl']


def ai_security_analysis(bucket_name):

    print(f"🔍 [ANALİZ MOTORU] '{bucket_name}' inceleniyor...")
    try:
        response = s3.get_public_access_block(Bucket=bucket_name)

        config = response['PublicAccessBlockConfiguration']
        if not config['BlockPublicAcls'] or not config['BlockPublicPolicy']:
            return True
    except Exception as e:

        return True
    return False


def auto_remediate(bucket_name):
    print(f"🚨 [MÜDAHALE MOTORU] Zafiyet tespit edildi! '{bucket_name}' dış dünyaya kapatılıyor...")
    s3.put_public_access_block(
        Bucket=bucket_name,
        PublicAccessBlockConfiguration={
            'BlockPublicAcls': True,
            'IgnorePublicAcls': True,
            'BlockPublicPolicy': True,
            'RestrictPublicBuckets': True
        }
    )
    print("✅ [BAŞARILI] Zafiyet kapatıldı. Sistem güvenli.\n")


def start_worker():
    queue_url = get_queue_url()
    print(f"🛡️ Sentinel-Ops Motoru devrede. Kuyruk dinleniyor: {QUEUE_NAME}...")

    while True:

        response = sqs.receive_message(
            QueueUrl=queue_url,
            MaxNumberOfMessages=1,
            WaitTimeSeconds=5
        )

        if 'Messages' in response:
            for message in response['Messages']:

                body = json.loads(message['Body'])
                bucket_name = body.get('bucket_name')

                print(f"\n📥 [YENİ OLAY] Olay alındı. Hedef: {bucket_name}")


                is_vulnerable = ai_security_analysis(bucket_name)

                if is_vulnerable:
                    auto_remediate(bucket_name)
                else:
                    print("✅ [GÜVENLİ] Yapılandırma kurallara uygun.")


                sqs.delete_message(
                    QueueUrl=queue_url,
                    ReceiptHandle=message['ReceiptHandle']
                )
        else:
            print(".", end="", flush=True)
            time.sleep(2)


if __name__ == "__main__":
    start_worker()