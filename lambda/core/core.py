#!/usr/bin/python3

import boto3
import botocore
import os

class Core:
    CloudCycleTagKey = "CloudCycle"
    DaySuffix = "d"
    HourSuffix = "h"
    MinuteSuffix = "m"
    SecondSuffix = "s"
    
    
def GenerateEC2Client() -> botocore.client:
    """
        Generate EC2 client
    """
    if os.getenv("STS_LOCAL") and os.getenv("STS_HOST") is not None:
        client = boto3.client("ec2", endpoint_url=os.getenv("STS_HOST"))
    else:
        client = boto3.client("ec2")
    
    return client
