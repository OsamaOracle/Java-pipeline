resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  key_name               = var.keypair
  instance_type          = var.web_instance_type
  subnet_id              = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  tags = {
    Name        = "Bastion"
    Environment = var.env
  }
}