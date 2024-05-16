package job


import(
	"context"
	"github.com/redopsbay/cloudcycle/internal"
	"github.com/redopsbay/cloudcycle/internal/services"

)

// TODO Terminator
func Terminator(ctx context.Context) {
	ec2Client := internal.EC2Client(ctx)
	services.StartEC2InstanceTermination(context.TODO(), ec2Client)
}
