#!/usr/bin/python3

import os
import boto3
from datetime import datetime, timedelta
from core.core import Core
from dateutil.tz import tzutc

class EC2:
    def __init__(self) -> None:
        self.LaunchTime = None
        self.LifeCycle = None
        self.ForTermination = False
        self.InstanceId = ""
        self.LifeCycleTagValue = ""
        
    def GetInstanceId(self) -> str:
        """Returns a str
        
        The returned string will contain the ec2 instance id.
        """
        return self.InstanceId
    
    def SetInstanceId(self, instance_id=None) -> None:
        """
            Sets instance id as str
        """
        self.InstanceId = instance_id
    
    def GetLaunchTime(self) -> datetime:
        return self.LaunchTime

    def SetLaunchTime(self, LaunchTime=None) -> None:
        """
            Sets EC2 LaunchTime
        """
        self.LaunchTime = LaunchTime
        
    def GetLifeCycle(self) -> datetime:
        """Returns a datetime
        
        Returns the lifecycle through datetime object.
        """
        return self.LifeCycle
    
    def SetLifecycleTagValue(self, LifeCycleTagValue=None) -> None:
        self.LifeCycleTagValue = LifeCycleTagValue

    def ValidateForTermination(self) -> bool:
        """Returns bool
        
        Validate if the instance is valid for termination or not then return True or False
        """
        
        if self.LifeCycleTagValue[-1:] == Core.DaySuffix:
            self.LifeCycle = self.LaunchTime + timedelta(days=self.LifeCycleTagValue[:-1])
        
        elif self.LifeCycleTagValue[-1:] == Core.HourSuffix:
            self.LifeCycle = self.LaunchTime + timedelta(hours=self.LifeCycleTagValue[:-1])
        
        elif self.LifeCycleTagValue[-1:] == Core.MinuteSuffix:
            self.LifeCycle = self.LaunchTime + timedelta(minutes=self.LifeCycleTagValue[:-1])
        
        elif self.LifeCycleTagValue[-1:] == Core.SecondSuffix:
            self.LifeCycle = self.LaunchTime + timedelta(seconds=self.LifeCycleTagValue[:-1])
        
        else:
            raise Exception("Unknown suffix")
        
        
        self.ForTermination = self.LaunchTime > datetime.now(tzutc())
        
        return self.ForTermination
        

class EC2Instances:
    def __init__(self):
        self.Instances = []
        self.InstancesForTermination = []
    
    def GetInstanceIds(self) -> list:
        """Returns a list
        
        Containing EC2 Instances Id's
        """
        instance_ids = []
        for instance in self.Instances:
            instance_ids.append(instance.GetInstanceId())
            
        return instance_ids

    def Add(self, Instance=None):
        """
            Add EC2 Instance Object to list.
        """
        if Instance is None:
            raise Exception("Missing Argument 'Instance'")
        
        if isinstance(EC2, Instance):
            self.Instances.append(Instance)
            
    def SetupInstancesForTermination(self) -> None:
        """
            Create a list of instances for termination.
        """
        
        for Instance in self.Instances:
            ForTermination = Instance.ValidateForTermination()
            if ForTermination:
                self.InstancesForTermination.append(Instance)
    
    def CleanUp(self) -> None:
        """
            Starts the cleanup process.
        """
        instance_ids = []
        client = Core.GenerateEC2Client()
        for instance in self.InstancesForTermination:
            if instance.ForTermination:
                instance_ids.append(instance.GetInstanceId())
        
        response = client.terminate_instances(
            InstaceIds=instance_ids
        )
        
        for terminating_instance in response:
            print(f"InstanceId: {terminating_instance["InstanceId"]}, Status: {terminating_instance["CurrentState"]["Name"]}, PreviousState: {terminating_instance["PreviousState"]["Name"]}")
                

def GetInstances() -> EC2Instances:
    """Returns a EC2Instance Object

    Containing EC2 instance details.
    """
    
    client = Core.GenerateEC2Client()
        
    instances = EC2Instances()
    
    Reservations = client.describe_instances(Filters=[{ "Name": "tag-key",
                                                    "Values": [f"{Core.CloudCycleTagKey}"]}])

    for reservation in Reservations['Reservations']:
        if reservation.get('Instances') is not None:
            for instance in reservation['Instances']:
                ec2 = EC2()
                ec2.SetInstanceId(instance_id=instance["InstanceId"])
                ec2.SetLaunchTime(LaunchTime=instance["LaunchTime"])
                for Tag in instance["Tags"]:
                    if Tag["Key"] == Core.CloudCycleTagKey:
                        ec2.SetLifecycleTagValue(LifeCycleTagValue=Tag["Value"])
                
                instances.Add(Instance=ec2)
    
    
    return instances