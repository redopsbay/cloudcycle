#!/usr/bin/python3

import os
import boto3
from core.core import Core

class EC2:
    def __init__(self, region=None, client=None):
        self.region = region
        self.STS_LOCAL = os.getenv("STS_LOCAL")
        self.STS_HOST = os.getenv("STS_HOST")
        self.LaunchTime = None
        self.Tags = None
        
    def GenerateClient(self):
        if self.STS_LOCAL == True and self.STS_HOST is not None:
            self.client = boto3.client("ec2", endpoint=self.STS_HOST)
        else:
            self.client = boto3.client("ec2")
            
    def GetReservations(self):
        """Returns a dictionary
        
        Containing EC2 instance details.
        """
        reservations = self.client.describe_instances(Filters=[{ "Name": "tag-key",
                                                        "Values": [f"{Core.CloudCycleTagKey}"]}])
        