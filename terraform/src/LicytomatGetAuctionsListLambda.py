import json as json
import boto3

dynamodb = boto3.client('dynamodb')

def lambda_handler(event, context):
    result = dynamodb.query(
        TableName='Auctions',
        Limit=10,
        KeyConditionExpression='Aim = :aim',
        ExpressionAttributeValues={
            ':aim': {'S': event['pathParameters']['aim']}
        }
    )
    print(result)
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps(result),
        'headers' : {
            "Access-Control-Allow-Origin" : "*"
        }
    }