import json as json
import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.client('dynamodb')

def lambda_handler(event, context):
    result = dynamodb.query(
        TableName='Auctions',
        IndexName='ById',
        ExpressionAttributeValues={
            ':id': {
            'S': event['pathParameters']['id'],
            },
        },
        KeyConditionExpression='Id =:id')
    items = result.get('Items')
    first_item = items[0]
    # TODO implement
    return {
        'statusCode': 200,
        'body':json.dumps(first_item),
        'headers' : {
            "Access-Control-Allow-Origin" : "*"
        }
    }