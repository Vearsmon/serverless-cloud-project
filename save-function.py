import json
import os
import ydb
import ydb.iam

driver = ydb.Driver(
  endpoint=os.getenv('YDB_ENDPOINT'),
  database=os.getenv('YDB_DATABASE'),
  credentials=ydb.iam.MetadataUrlCredentials(),
)

driver.wait(fail_fast=True, timeout=5)

msg_id = ""
user_id = ""
message_text = ""
sending_time = ""

pool = ydb.SessionPool(driver)

def execute_query(session):
  return session.transaction().execute(
    "INSERT INTO messages (id, user_id, message_text, sending_time)" +
    "VALUES ('" + msg_id + "', '" + user_id + "', '" + message_text + "', '" + sending_time + "'); ",
    commit_tx=True,
    settings=ydb.BaseRequestSettings().with_timeout(3).with_operation_timeout(2)
  )

def handler(event, context):
  global msg_id, user_id, message_text, sending_time

  if event['httpMethod'] == 'OPTIONS':
          return {
              'statusCode': 200,
              'headers': {
                  'Access-Control-Allow-Origin': '*',
                  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
                  'Access-Control-Allow-Headers': '*',
                  'Access-Control-Expose-Headers': 'Location'
              }
          }

  print(json.dumps(event))
  print(len(event['body']) > 0)
  body = json.loads(event['body'])

  msg_id = body['id']
  user_id = body['user_id']
  message_text = body['message_text']
  sending_time = body['sending_time']
  result = pool.retry_operation_sync(execute_query)

  return {
    'statusCode': 200,
  }
