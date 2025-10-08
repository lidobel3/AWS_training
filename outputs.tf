# 8. Output de l'IP publique
output "ec2_public_ip" {
  value = aws_instance.mon_ec2.public_ip
}

# 9. Output de l'IP publique
output "ec2_instance_state" {
  value = aws_instance.mon_ec2.instance_state
}

# 9. Output du nom du bucket
output "s3_arn" {
  value = aws_s3_bucket.mon_bucket.arn
}