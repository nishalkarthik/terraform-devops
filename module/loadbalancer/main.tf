

# create application load balancer
resource "aws_lb" "application_load_balancer" {
  name               = "app-lb-${var.name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb-sg]
  subnets            = var.lb-pub-subnets # or [aws_subnet.public-subnet[0].id,aws_subnet.public-subnet[1].id]
  enable_deletion_protection = false
  tags   = var.alb-tag
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "alb-tg-${var.name}"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.lb-vpcid

  health_check {

    enabled             = true
    interval            = 300
    path                = "/index.html"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }
  tags = var.alb-tag
}

/*
# create a listener on port 80 with redirect action

resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
*/

# create a listener on port 80 with forward action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn  = aws_lb.application_load_balancer.arn
  port               = 80
  protocol           = "HTTP"
  #ssl_policy         = "ELBSecurityPolicy-2016-08"
  #certificate_arn    = # for https

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}


resource "aws_lb_target_group_attachment" "attach-inst" {
  count = length(var.webservers) #or count = var.instancecount
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id = element(var.webservers,count.index) #or aws_instance.public-webservers[count.index].id
  # target_id = aws_instance.vpc-public[0].id  # for single atttachment
}

/*
resource "aws_lb_target_group_attachment" "attach-inst2" {
  #count = length(aws_instance.vpc-public1)
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  # target_id = aws_instance.vpc-public1[count.index].id
  target_id = aws_instance.vpc-public2.id
}
*/


