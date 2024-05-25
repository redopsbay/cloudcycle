# Cloud Resource LifeCycle Scheduler

[![PR Checks](https://github.com/redopsbay/cloudcycle/actions/workflows/pr.yaml/badge.svg?branch=master)](https://github.com/redopsbay/cloudcycle/actions/workflows/pr.yaml)

[![Release](https://github.com/redopsbay/cloudcycle/actions/workflows/release.yaml/badge.svg)](https://github.com/redopsbay/cloudcycle/actions/workflows/release.yaml)

Cloud resource lifecycle scheduler to save and avoid surprising cost. Cloud resource lifecycle scheduler allows you to automatically cleanup temporary workloads such as EC2 instances depending on the lifecycle that you set through `resource tag`.


***Note: EventBridge will trigger CloudCycle every 15 minutes.***

## TODO's

- [ ] User Manual & Technical Documentation
- [x] Terraform Module
- [x] GitHub Action
  - [ ] SAST
  - [x] Precommit config
  - [x] Release Pipeline
- [ ] Build Script & Development scripts
- [ ] Contributor documentation

### Supported AWS Services

| AWS Service   | Test on region   | Status                      |
| ------------- | ---------------- | --------------------------- |
| ✔️ EC2         | `ap-southeast-1` | Alpha                       |
| ❌ RDS         | `N/A`            | Currently not yet supported |
| ❌ BeanStalk   | `N/A`            | Currently not yet supported |
| ❌ ECS         | `N/A`            | Currently not yet supported |
| ❌ EKS         | `N/A`            | Currently not yet supported |
| ❌ EBS         | `N/A`            | Currently not yet supported |
| ❌ Elastic IP  | `N/A`            | Currently not yet supported |
| ❌ ElastiCache | `N/A`            | Currently not yet supported |
| ❌ DocumentDB  | `N/A`            | Currently not yet supported |
| ❌ Cloud9      | `N/A`            | Currently not yet supported |
| ❌ EFS         | `N/A`            | Currently not yet supported |

## Usage

Just specify that tag and set your desired lifecycle for supported resources with ***CloudCycle*** Key. Below is the supported duration.


| Suffixes | Detail  | Sample Value |
| -------- | ------- | ------------ |
| `m`      | Minutes | `60m`        |
| `h`      | Hours   | `2h`         |
| `d`      | Days    | `7d`         |


## How does it works?

CloudCycle will get all the supported resources with a tagged key ***CloudCycle*** and it will simply compare the ***current time*** vs ***launch time*** of the supported resources with the specified `key/value` pair resource tag if the supported resources are valid for termination.


Below are the sample terraform code.


Specify ec2 lifecycle by 24 hours from it's launch date.

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    CloudCycle = "1d" // This ec2 instance will be terminated within 24 hours from it's launch date.
  }
}
```

### Terraform Deployment

For deployment, you can refer to the [Deployment Page](https://github.com/redopsbay/cloudcycle/blob/master/deploy/README.md)
