import json as json
import boto3

dynamodb = boto3.client('dynamodb')

def lambda_handler(event, context):
    auctionId=event['pathParameters']['id']
    body=json.loads(event['body'])
    aim = body['aim']
    userId=body['userId']
    bid=body['bid']
    result = dynamodb.update_item(
        TableName='Auctions',
        Key={'Id' : {'S': auctionId}, 'Aim' : {'S' : aim}},
        UpdateExpression='SET Bids = list_append(Bids, :bid_obj)',
        ExpressionAttributeValues={
            ":bid_obj": {
                "L": [
                    {
                        "M": {
                            "Offer": {"N" : str(bid)},
                            "UserId": {"N" : str(userId)}
                        }
                    }
                ]
            }
        })

    return {
        'statusCode': 200,
        'body':json.dumps(result),
        'headers' : {
            "Access-Control-Allow-Origin" : "*"
        }
    }