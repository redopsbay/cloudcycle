package services

import (
	"context"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/ec2/types"
	"github.com/redopsbay/cloudcycle/internal"
	"github.com/redopsbay/cloudcycle/internal/schedule"
	"fmt"
)

type EC2 struct {
	InstanceId         string
	CloudCycle         string
	MarkForTermination bool
}

type EC2Instances struct {
	Instances []EC2
}

func GetEC2Instances(ctx context.Context, client *ec2.Client) ([]types.Reservation, error) {
	filters := []types.Filter{{
		Name:   aws.String("tag-key"),
		Values: []string{internal.TagKey},
	},
	}

	DescribeInputs := ec2.DescribeInstancesInput{
		Filters: filters,
	}

	instances, err := client.DescribeInstances(ctx, &DescribeInputs)

	if err != nil {
		panic(err)
		return []types.Reservation{}, err
	}

	return instances.Reservations, nil
}

func MarkInstancesForTermination(reservations []types.Reservation) (EC2Instances, error) {
	var instances EC2Instances

	for _, reservation := range reservations {
		for _, instance := range reservation.Instances {
			for _, tag := range instance.Tags {
				if *tag.Key == internal.TagKey {
					Lifecycle, err := schedule.GetLifeCycle(instance.LaunchTime, *tag.Value)
					if err != nil {
						return EC2Instances{}, err
					}

					if schedule.ValidForTermination(Lifecycle) {
						ec2instance := EC2{
							InstanceId:         *instance.InstanceId,
							CloudCycle:         *tag.Value,
							MarkForTermination: true,
						}
						instances.Instances = append(instances.Instances, ec2instance)

					} else {
						ec2instance := EC2{
							InstanceId:         *instance.InstanceId,
							CloudCycle:         *tag.Value,
							MarkForTermination: false,
						}
						instances.Instances = append(instances.Instances, ec2instance)
					}
				}
			}
		}
	}
	return instances, nil
}

func StartEC2InstanceTermination(ctx context.Context, client *ec2.Client) error {
	var instanceIds []string

	reservations, err := GetEC2Instances(ctx, client)
	if err != nil {
		fmt.Println("Unable to get instances.")
		return err
	}

	instances, err := MarkInstancesForTermination(reservations)
	if err != nil {
		fmt.Println("Unable to mark instances for termination.")
		return err
	}

	for _, instance := range instances.Instances {
		if instance.MarkForTermination {
			instanceIds = append(instanceIds, instance.InstanceId)
			fmt.Printf("\nInstanceID: %s, ForTermination: %t, CloudCycle: %s\n",
				instance.InstanceId,
				instance.MarkForTermination,
				instance.CloudCycle)
		}
	}

	TerminatedOutput, err := client.TerminateInstances(ctx, &ec2.TerminateInstancesInput{
		InstanceIds: instanceIds,
	})

	for _, state := range TerminatedOutput.TerminatingInstances {
		if *state.CurrentState.Code == 0 {
			fmt.Printf("InstanceID: %s, State: Pending for Termination", *state.InstanceId)
		} else if *state.CurrentState.Code == 32 {
			fmt.Printf("InstanceID: %s, State: Shutting down", *state.InstanceId)
		} else if *state.CurrentState.Code == 48 {
			fmt.Printf("InstanceID: %s, State: Shutting down", *state.InstanceId)
		} else if *state.CurrentState.Code == 16 {
			fmt.Printf("InstanceID: %s, State: Still running", *state.InstanceId)
		} else if *state.CurrentState.Code == 64 {
			fmt.Printf("InstanceID: %s, State: Stopping", *state.InstanceId)
		} else if *state.CurrentState.Code == 80 {
			fmt.Printf("InstanceID: %s, State: Stopped", *state.InstanceId)
		} else {
			fmt.Printf("InstanceID: %s, State: Unknown", *state.InstanceId)
		}
	}

	return nil

}
