resource "aws_autoscaling_group" "subject" {
    health_check_type         = "EC2"
    name                      = local.moduleName
    #launch_configuration      = "subject_ASGC_4.0.2_S3"
    launch_configuration      = aws_launch_configuration.subject.name

    capacity_rebalance        = false
    default_cooldown          = 300
    enabled_metrics           = []
    health_check_grace_period = 60
    load_balancers            = []

    min_size                  = 1
    desired_capacity          = 1
    max_size                  = 4
    metrics_granularity       = "1Minute"
    protect_from_scale_in     = false
    max_instance_lifetime     = 0

    suspended_processes       = []
    target_group_arns         = []
    termination_policies      = []
    vpc_zone_identifier       = local.subnets

    tag {
        key                 = "Name"
        propagate_at_launch = true
        value               = local.moduleName
    }

    timeouts {}
}
# aws_autoscaling_policy.jvb_octo_free:
resource "aws_autoscaling_policy" "jvb_octo_free" {
    adjustment_type           = "ChangeInCapacity"
    autoscaling_group_name    = aws_autoscaling_group.subject.name
    cooldown                  = 60
    estimated_instance_warmup = 0
    name                      = "jvb_octo_free"
    policy_type               = "SimpleScaling"
    scaling_adjustment        = -1
}
# aws_autoscaling_policy.jvb_octo_need:
resource "aws_autoscaling_policy" "jvb_octo_need" {
    adjustment_type           = "ChangeInCapacity"
    autoscaling_group_name    = aws_autoscaling_group.subject.name
    cooldown                  = 60
    estimated_instance_warmup = 0
    name                      = "jvb_octo_need"
    policy_type               = "SimpleScaling"
    scaling_adjustment        = 1
}

# aws_launch_configuration.subject:
resource "aws_launch_configuration" "subject" {
    #name                             = "subject_ASGC_v5--tf"
    name                             =  local.moduleName
    associate_public_ip_address      = false
    ebs_optimized                    = false
    enable_monitoring                = false
    #iam_instance_profile             = "arn:aws:iam::988339190536:instance-profile/ASG_subject_ROLE"
    image_id                         = local.ami_id
    instance_type                    = local.instanceType
    key_name                         = "meet"
    security_groups                  = [aws_security_group.subject.id]
    #user_data                        = "c6800251b5d7bb0c1dd88caaf4f26e7089998c80"
    vpc_classic_link_security_groups = []

    root_block_device {
        delete_on_termination = true
        encrypted             = false
        iops                  = 0
        throughput            = 0
        volume_size           = 20
        volume_type           = "gp2"
    }
    # tags = {
    #     "Name"      = "subject-v5--tf"
    #     //"Name"      = data.aws_ami.manager_ami.name
    #     "id" : "subject-v5--tf",
    #     "Role"      = "subject"
    #     "Env"       = "prod"
    #     "managedBy" : "myken-infras-manger@terrafom",
    # }
}