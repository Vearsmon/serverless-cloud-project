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

pool = ydb.SessionPool(driver)

def execute_query(session):
  return session.transaction().execute(
    'select * FROM ' + 'messages' + ';',
    commit_tx=True,
    settings=ydb.BaseRequestSettings().with_timeout(3).with_operation_timeout(2)
  )

def handler(event, context):
  result = pool.retry_operation_sync(execute_query)
  return {
    'statusCode': 200,
    'body': json.dumps({
      'messages' : result[0].rows
    })
  }
