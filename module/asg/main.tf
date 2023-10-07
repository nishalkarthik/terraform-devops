resource "aws_autoscaling_group" "new" {
  #availability_zones = var.launchtemplate-asg-AZs
  desired_capacity = var.desiredcap
  max_size = var.maxcap
  min_size = var.mincap
vpc_zone_identifier = [var.asgzonesubnet1,var.asgzonesubnet2]

  launch_template {
    id = var.launchtemplateid
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "new" {
  #max_size = 0
  #min_size = 0
  autoscaling_group_name = aws_autoscaling_group.new.name
  name = "test-policy-asg"
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    target_value = var.cputargetval

    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
      # resource_label = "testLabel"
    }
  }
}

resource "aws_autoscaling_attachment" "asg-alb" {
  autoscaling_group_name = aws_autoscaling_group.new.name
  lb_target_group_arn = var.targetgrouparn
}