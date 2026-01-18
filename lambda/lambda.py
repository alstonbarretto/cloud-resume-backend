import boto3
import os
import json

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["resumeVisitors"])

def lambda_handler(event, context):
    response = table.update_item(
        Key={"id": "counter"},
        UpdateExpression="ADD #count :inc",
        ExpressionAttributeNames={"#count": "count"},
        ExpressionAttributeValues={":inc": 1},
        ReturnValues="UPDATED_NEW"
    )

    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "https://alstontech.uk",
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "count": int(response["Attributes"]["count"])
        })
    }