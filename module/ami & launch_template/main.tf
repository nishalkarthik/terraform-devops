# creating ami from instance

resource "aws_ami_from_instance" "asg-ami" {
  name               = "asg-ami"
  source_instance_id = var.asginstanceid
}

#creating launch template from instance

resource "aws_launch_template" "asg-launch-template" {
  name = "asg-launch-template-${var.name}"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 8
    }
  }
  image_id = aws_ami_from_instance.asg-ami.id
  instance_type = var.machinetype
  vpc_security_group_ids = var.vpcsg-id
  key_name = var.keyname
  placement {
    availability_zone = "us-west-2a"
  }

}