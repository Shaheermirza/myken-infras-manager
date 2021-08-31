# aws_cloudwatch_metric_alarm.jibri_free:
resource "aws_cloudwatch_metric_alarm" "jibri_free" {
    actions_enabled           = true
    alarm_actions             = [
        aws_autoscaling_policy.jibri_free.arn
    ]
    alarm_description         = "jibri_free"
    alarm_name                = "jibri_free"
    comparison_operator       = "GreaterThanOrEqualToThreshold"
    datapoints_to_alarm       = 1
    dimensions                = {}
    evaluation_periods        = 1
    insufficient_data_actions = []
    metric_name               = "RecorderState"
    namespace                 = "RecorderData"
    ok_actions                = []
    period                    = 60
    statistic                 = "Sum"
    tags                      = {}
    tags_all                  = {}
    threshold                 = 4
}
# aws_cloudwatch_metric_alarm.jibri_need:
resource "aws_cloudwatch_metric_alarm" "jibri_need" {
    actions_enabled           = true
    alarm_actions             = [
        aws_autoscaling_policy.jibri_need.arn
    ]
    alarm_description         = "jibri_need"
    alarm_name                = "jibri_need"
    comparison_operator       = "LessThanThreshold"
    datapoints_to_alarm       = 1
    dimensions                = {}
    evaluation_periods        = 1
    insufficient_data_actions = []
    metric_name               = "RecorderState"
    namespace                 = "RecorderData"
    ok_actions                = []
    period                    = 60
    statistic                 = "Sum"
    tags                      = {}
    tags_all                  = {}
    threshold                 = 3
}
