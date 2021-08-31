# aws_cloudwatch_metric_alarm.jvb_octo_need:
resource "aws_cloudwatch_metric_alarm" "jvb_octo_need" {
    actions_enabled           = true
    alarm_actions             = [
        aws_autoscaling_policy.jvb_octo_need.arn
    ]
    alarm_name                = "jvb_octo_need"
    comparison_operator       = "GreaterThanOrEqualToThreshold"
    datapoints_to_alarm       = 1
    dimensions                = {
        "AutoScalingGroupName" = aws_autoscaling_group.subject.name
    }
    evaluation_periods        = 1
    insufficient_data_actions = []
    metric_name               = "NetworkOut"
    namespace                 = "AWS/EC2"
    ok_actions                = []
    period                    = 60
    statistic                 = "Average"
    tags                      = {}
    tags_all                  = {}
    threshold                 = 750000000
}
# aws_cloudwatch_metric_alarm.jvb_octo_free:
resource "aws_cloudwatch_metric_alarm" "jvb_octo_free" {
    actions_enabled           = true
    alarm_actions             = [
        aws_autoscaling_policy.jvb_octo_free.arn
    ]
    alarm_name                = "jvb_octo_free"
    comparison_operator       = "LessThanOrEqualToThreshold"
    datapoints_to_alarm       = 1
    dimensions                = {
        "AutoScalingGroupName" = aws_autoscaling_group.subject.name
    }
    evaluation_periods        = 1
    insufficient_data_actions = []
    metric_name               = "NetworkOut"
    namespace                 = "AWS/EC2"
    ok_actions                = []
    period                    = 60
    statistic                 = "Average"
    tags                      = {}
    tags_all                  = {}
    threshold                 = 375000000
}