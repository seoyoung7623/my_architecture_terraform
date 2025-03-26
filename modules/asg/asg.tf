# ASG 생성
resource "aws_autoscaling_group" "aws_asg" {
  name                = "aws-asg-${var.stage}-${var.servicename}"
  vpc_zone_identifier = var.asg-subnets # 프라이빗 서브넷에 넣었음
  min_size            = 1
  max_size            = 1
  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 60
    }
  }
  health_check_type = "ELB"
  target_group_arns = [var.target_group_arn]
}