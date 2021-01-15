import json as json
import boto3
import uuid
import time


dynamodb = boto3.client('dynamodb')

def lambda_handler(event, context):
    print(event)
    auctionId=uuid.uuid4()
    body=json.loads(event['body'])

    result = dynamodb.put_item(
        TableName='Auctions',
        Item = {
              "Aim" : {
                "S": body["aim"]
              },
              "Id": {
                "S": str(auctionId)
              },
              "UserId": {
                "S": "1"
              },
              "BeginDate": {
                "S": str(time.ctime())
              },
              "StartBid" : {
                "N": str(body["start_bid"])
              },
              "Bids": {
                "L": []
              },
              "Category": {
                "S": body["category"]
              },
              "City": {
                "S": body["city"]
              },
              "Description": {
                "S": body["desc"]
              },
              "EndDate": {
                "S": body["end_date"]
              },
              "Images": {
                "L": [
                  {
                    "S":body["image"]
                  }
                ]
              },
              "Name": {
                "S": body["name"]
              }
            }
        )

    return {
        'statusCode': 200,
        'body':json.dumps(result),
        'headers' : {
            "Access-Control-Allow-Origin" : "*"
        }
    }