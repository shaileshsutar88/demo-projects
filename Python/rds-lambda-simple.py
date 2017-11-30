import boto3
import json

client=boto3.client("rds")

def lambda_handler(event, context):
	response=client.modify_db_instance(DBINstanceIdentifier=db_instance, DBInstanceClass='db.m4.large', ApplyImmediately=True)
	print response