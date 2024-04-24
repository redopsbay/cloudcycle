#!/usr/bin/python3

import boto3
import botocore
from services.ec2.ec2 import EC2Instances, GetInstances

def lambda_handler(event, context):
    Instances = GetInstances()
    isAvailable = Instances.SetupInstancesForTermination()
    if isAvailable:
        Instances.CleanUp()
    else:
        print("There's no available instances for termination")
    response = {'result': "Done"}
    return response