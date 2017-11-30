#!/usr/bin/python
import boto3
import json

client=boto3.client("rds")

def lambda_handler(event, context):

 messagge = event['Records'][0]['Sns']['Message']
 parsed_message=json.loads(message)
 db_instance=parsed_message['Trigger']['Dimensions'][0]['value']
 print 'DB Instance:' + db_instance

 response=client.modify_db_instance(DBINstanceIdentifier=db_instance, DBInstanceClass='db.m4.large', ApplyImmediately=True)

 print response
