import boto3
import json

def thingy():
    return 42

def sns_handler(event, context):
    sns = boto3.client('sns')
    print(event)
    print(context)

    return {
        "statusCode": 200,
        "body": json.dumps({"a": 2})
    }
