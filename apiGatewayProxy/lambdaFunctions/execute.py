import json
import logging

LOGGER = logging.getLogger(__name__)
LOGGER.setLevel(logging.INFO)


def handler(event, context):
    LOGGER.info(event)
    # if "SubscribeURL" in post_data:
    #     requests.get(post_data["SubscribeURL"])
    # messages = post_data["Message"]
    # user_ids = []
    # status = []
    # json_encoded = json.dumps(messages)
    # print(json_encoded)
    # json_decoded = json.loads(json_encoded)
    # print(type(json_decoded))
    # for record in json_decoded:
    #     print(record)
    return {
        "isBase64Encoded": False,
        "statusCode": 200,
        "statusDescription": "200 OK",
        "headers": {
            "Set-cookie": "cookies",
            "Content-Type": "application/json"
        },
        "body": "Hello from Lambda (optional)"
    }
