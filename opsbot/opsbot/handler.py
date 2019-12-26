import boto3

def thingy():
    return 42

def sns_handler(request, context):
    sns = boto3.client('sns')
    print(sns)

    return "Hello"
