data "aws_ami" "worker_ami" {
  most_recent      = true
  owners           = var.arrays.ami_owners

  filter {
    name   = "name"
    values = ["websocket-server-v*"]
  }
}

resource "aws_launch_template" "main" {
  name = var.config_name

  image_id      = data.aws_ami.worker_ami.id
  instance_type = "t2.micro"
  # iam_instance_profile {
  #   name = "JVB_ROLE"
  # }

  credit_specification {
    #cpu_credits = var.cpu_credits
  }

  key_name  = "meet"
  #user_data = base64encode(var.user_data)

  vpc_security_group_ids = [module.security_group.this_security_group_id]
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [module.security_group.this_security_group_id]
    delete_on_termination       = true
  }

  monitoring {
    enabled = false
  }

  #disable_api_termination = var.disable_api_termination
  #ebs_optimized = var.ebs_optimized

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = var.delete_on_termination
      encrypted             = var.ebs_encryption
    }
  }

  tags = {
    Name          = var.config_name
    Service       = var.service_name
    ProductDomain = var.product_domain
    Environment   = var.environment
    ManagedBy     = "terraform"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name          = "${var.service_name}-${var.cluster_role}"
      Service       = var.service_name
      Cluster       = "${var.service_name}-${var.cluster_role}"
      ProductDomain = var.product_domain
      ManagedBy     = "terraform"
    }
  }
  tag_specifications {
    resource_type = "volume"

    tags = {
      Service       = var.service_name
      ProductDomain = var.product_domain
      Environment   = var.environment
      ManagedBy     = "terraform"
    }
  }
}
