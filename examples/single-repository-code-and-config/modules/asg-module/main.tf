resource "aws_security_group" "instance_sg" {
  name        = "${var.deployment.name-prefix}-instance-sg"
  description = "Security group for EC2 instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "apache2" {
  name          = "${var.deployment.name-prefix}-apache2-config"
  //image_id      = "ami-df5de72bdb3b"
  image_id      = data.aws_ami.ubuntu-image.id
  instance_type = "t2.micro"
  user_data = base64encode(file("${path.module}/user-data.sh"))
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity          = var.deployment.starting-instances
  health_check_type         = "ELB"
  health_check_grace_period = 300
  max_size                  = var.deployment.max-instances
  min_size                  = var.deployment.min-instances
  vpc_zone_identifier = module.vpc.private_subnets
  target_group_arns         = [aws_lb_target_group.asg.arn]
  launch_template {
    id      = aws_launch_template.apache2.id
    version = "$Latest"
  }

}