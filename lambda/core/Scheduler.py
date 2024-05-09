#!/usr/bin/python3


from services.ec2.ec2 import GetInstances

class Scheduler(object):
    def __init__(self):
        """
        Initialize the scheduler
        """
        self.Instances = GetInstances()

    def Start(self) -> None:
        """Return None

        Starts the scheduler
        """
        isAvailable = self.Instances.SetupInstancesForTermination()
        if isAvailable:
            self.Instances.CleanUp()
        else:
            print("There's no available instances for termination")
