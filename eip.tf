resource "aws_eip" "ip_fixee" {
  instance = aws_instance.mon_ec2.id
  #vpc      = true
}