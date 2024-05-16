# Cloud Resource LifeCycle Scheduler

Cloud resource lifecycle scheduler to save and avoid surprising cost. Cloud resource lifecycle scheduler allows you to automatically cleanup temporary workloads such as EC2 instances depending on the lifecycle that you set through `resource tag`.

## TODO's

- [ ] User Manual & Technical Documentation
- [ ] Terraform Module
- [ ] GitHub Action
  - [ ] SAST
  - [ ] Precommit config
  - [ ] Release Pipeline
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
