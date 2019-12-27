import boto3

def thingy():
    return 42

def sns_handler(event, context):
    sns = boto3.client('sns')
    print(event)
    print(context)

    return '{"a":2}'
