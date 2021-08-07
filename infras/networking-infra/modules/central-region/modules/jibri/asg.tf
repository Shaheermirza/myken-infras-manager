resource "aws_autoscaling_group" "jibri" {
    health_check_type         = "EC2"
    name                      = "JibriAutoScaleGroup--tf"
    #launch_configuration      = "JIBRI_ASGC_4.0.2_S3"
    launch_configuration      = aws_launch_configuration.jibri.name

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
        value               = "JIBRI"
    }

    timeouts {}
    depends_on = [aws_launch_configuration.jibri]
}
# aws_autoscaling_policy.jibri_need:
resource "aws_autoscaling_policy" "jibri_need" {
    adjustment_type           = "ChangeInCapacity"
    autoscaling_group_name    = aws_autoscaling_group.jibri.name
    cooldown                  = 60
    estimated_instance_warmup = 0
    name                      = "jibri_need"
    policy_type               = "SimpleScaling"
    scaling_adjustment        = 1

}
# aws_autoscaling_policy.jibri_free:
resource "aws_autoscaling_policy" "jibri_free" {
    adjustment_type           = "ChangeInCapacity"
    autoscaling_group_name    = aws_autoscaling_group.jibri.name
    cooldown                  = 60
    estimated_instance_warmup = 0
    name                      = "jibri_free"
    policy_type               = "SimpleScaling"
    scaling_adjustment        = -1

}

# aws_launch_configuration.jibri:
resource "aws_launch_configuration" "jibri" {
    #name                             = "JIBRI_ASGC_v5--tf"
    name                             = "jibri-v5--tf"
    associate_public_ip_address      = false
    ebs_optimized                    = false
    enable_monitoring                = false
    #iam_instance_profile             = "arn:aws:iam::988339190536:instance-profile/ASG_JIBRI_ROLE"
    iam_instance_profile             = "arn:aws:iam::182695311751:instance-profile/ASG_JIBRI_ROLE"
    image_id                         = "ami-01af747a82cdd687c"
    instance_type                    = "t2.xlarge"
    key_name                         = "meet"
    security_groups                  = [aws_security_group.jibri.id]
    user_data = filebase64("${path.module}/data/lauch-template.user-data.sh")
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
    #     "Name"      = "jibri-v5--tf"
    #     //"Name"      = data.aws_ami.manager_ami.name
    #     "id" : "jibri-v5--tf",
    #     "Role"      = "jibri"
    #     "Env"       = "prod"
    #     "managedBy" : "myken-infras-manger@terrafom",
    # }
}