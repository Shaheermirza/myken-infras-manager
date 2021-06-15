resource "aws_autoscaling_group" "web" {
    #arn                       = "arn:aws:autoscaling:ap-south-1:988339190536:autoScalingGroup:44617e44-e562-4c3d-b60c-8b46022acee2:autoScalingGroupName/JibriAutoScaleGroup"
    # availability_zones        = [
    #     "ap-south-1a",
    #     "ap-south-1b",
    #     "ap-south-1c",
    # ]
    health_check_type         = "EC2"
    #id                        = "JibriAutoScaleGroup"
    name                      = "JibriAutoScaleGroup"
    launch_configuration      = "JIBRI_ASGC_4.0.2_S3"

    capacity_rebalance        = false
    default_cooldown          = 300
    desired_capacity          = 0
    enabled_metrics           = []
    health_check_grace_period = 60
    load_balancers            = []

    max_instance_lifetime     = 0
    max_size                  = 0
    metrics_granularity       = "1Minute"
    min_size                  = 0
    protect_from_scale_in     = false

    #service_linked_role_arn   = "arn:aws:iam::988339190536:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
    suspended_processes       = []
    target_group_arns         = []
    termination_policies      = []
    vpc_zone_identifier       = local.subnets

    tag {
        key                 = "Name"
        propagate_at_launch = true
        value               = "JIBRI"
    }

    timeouts {}
}

resource "aws_autoscaling_policy" "test-policy" {
    adjustment_type           = "ChangeInCapacity"
    #arn                       = "arn:aws:autoscaling:ap-south-1:988339190536:scalingPolicy:043baba8-7d8a-41ad-b7f7-976f5bb6a044:autoScalingGroupName/JibriAutoScaleGroup:policyName/jibri_free"
    autoscaling_group_name    = "JibriAutoScaleGroup"
    cooldown                  = 60
    estimated_instance_warmup = 0
    #id                        = "jibri_free"
    name                      = "jibri_free"
    policy_type               = "SimpleScaling"
    scaling_adjustment        = -1
}