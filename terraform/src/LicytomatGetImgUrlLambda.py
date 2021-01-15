import json
import boto3
import uuid

s3 = boto3.client('s3')

def lambda_handler(event, context):
    
    imgType= event["queryStringParameters"]['imgType']
    print(imgType)
    result = s3.generate_presigned_post('licytomat-photos',str(uuid.uuid4())+"."+imgType,ExpiresIn=3600)
    print(result)
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps(result),
        'headers' : {
            "Access-Control-Allow-Origin" : "*"
        }
    }