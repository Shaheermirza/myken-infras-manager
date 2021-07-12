resource "aws_autoscaling_group" "main" {
  name               = var.asg_name
  max_size                  = var.asg_max_capacity
  min_size                  = var.asg_min_capacity
  default_cooldown          = var.asg_default_cooldown
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = var.asg_health_check_type
  vpc_zone_identifier       = local.subnets
  #target_group_arns         = var.asg_lb_target_group_arns
  #load_balancers            = var.asg_clb_names
  termination_policies      = var.asg_termination_policies


  dynamic "launch_template" {
    for_each = var.use_mixed_instances_policy == false ? ["use plain launch template"] : []
    content {
      id      = aws_launch_template.main.id
      version = "$Latest"
    }
  }

  dynamic "mixed_instances_policy" {
    for_each = var.use_mixed_instances_policy == true ? ["use mixed instance policy"] : []
    content {
      launch_template {
        launch_template_specification {
          launch_template_id = aws_launch_template.main.id
          version            = "$Latest"
        }

        dynamic "override" {
          for_each = var.launch_template_overrides
          content {
            instance_type     = lookup(override.value, "instance_type", null)
            weighted_capacity = lookup(override.value, "weighted_capacity", null)
          }
        }
      }

      dynamic "instances_distribution" {
        for_each = [var.mixed_instances_distribution]
        content {
          on_demand_allocation_strategy            = lookup(instances_distribution.value, "on_demand_allocation_strategy", null)
          on_demand_base_capacity                  = lookup(instances_distribution.value, "on_demand_base_capacity", null)
          on_demand_percentage_above_base_capacity = lookup(instances_distribution.value, "on_demand_percentage_above_base_capacity", null)
          spot_allocation_strategy                 = lookup(instances_distribution.value, "spot_allocation_strategy", null)
          spot_instance_pools                      = lookup(instances_distribution.value, "spot_instance_pools", null)
          spot_max_price                           = lookup(instances_distribution.value, "spot_max_price", null)
        }
      }
    }
  }

  tags = concat(
    list(
      {
        key                 = "Name"
        value               = var.asg_name
        propagate_at_launch = false
      },
      {
        key                 = "Service"
        value               = var.service_name
        propagate_at_launch = false
      },
      {
        key                 = "ProductDomain"
        value               = var.product_domain
        propagate_at_launch = false
      },
      {
        key                 = "Environment"
        value               = var.environment
        propagate_at_launch = false
      },
      {
        key                 = "Description"
        value               = "ASG of the ${var.service_name}-${var.cluster_role} cluster"
        propagate_at_launch = false
      },
      {
        key                 = "ManagedBy"
        value               = "terraform"
        propagate_at_launch = false
      }
    ),
    var.asg_tags
  )

  #placement_group           = var.asg_placement_group
  #metrics_granularity       = var.asg_metrics_granularity
  #enabled_metrics           = var.asg_enabled_metrics
  #wait_for_capacity_timeout = var.asg_wait_for_capacity_timeout
  #wait_for_elb_capacity     = local.asg_wait_for_elb_capacity
  #service_linked_role_arn   = var.asg_service_linked_role_arn

  lifecycle {
    create_before_destroy = true
  }
  #depends_on = ["module.security_group.id"]
}