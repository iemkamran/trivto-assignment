


resource "aws_launch_template" "eks" {

  name_prefix = "${var.cluster_name}-"

  instance_type = var.instance_type

  update_default_version = true

  vpc_security_group_ids = [

    aws_security_group.nodes.id

  ]

  monitoring {

    enabled = true

  }

metadata_options {

  http_endpoint = "enabled"

  http_tokens = "required"

  http_put_response_hop_limit = 2

  instance_metadata_tags = "enabled"
}

  block_device_mappings {

    device_name = "/dev/xvda"

    ebs {

      volume_size = var.disk_size

      volume_type = "gp3"

      encrypted = true

      delete_on_termination = true

    }

  }

  tag_specifications {

    resource_type = "instance"

    tags = merge(

      local.common_tags,

      {

        Name = "${var.cluster_name}-worker"

      }

    )

  }

}