#!/usr/bin/python3

import boto3
import botocore
from services.ec2.ec2 import EC2Instances, GetInstances
from core.Scheduler import Scheduler
def lambda_handler(event, context):
    scheduler =  Scheduler()
    scheduler.Start()
    response = {'result': "Done"}
    return response
