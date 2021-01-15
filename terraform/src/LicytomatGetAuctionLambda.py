import json as json
import boto3

dynamodb = boto3.client('dynamodb')

def lambda_handler(event, context):
    result = dynamodb.query(
        TableName='Auctions',
        KeyConditionExpression='Aim = :aim AND Id = :id',
        ExpressionAttributeValues={
            ':aim': {'S': event['pathParameters']['aim']},
            ':id': {'S' : event['pathParameters']['id']}
        }
    )
    print(result)
    # TODO implement
    return {
        'statusCode': 200,
        'body':json.dumps(result),
        'headers' : {
            "Access-Control-Allow-Origin" : "*"
        }
    }