billing_code = "AWS00911"
project = "web-app"

vpc_cidr_block = {
    Development = "10.0.0.0/16"
    UAT = "10.0.0.1/16"
    Production = "10.0.0.2/16"
}

vpc_subnet_count = {
  Development = 2
  UAT = 2
  Productions = 3
}

instance_type = {
  Development = "t2.micro"
  UAT = "t2.small"
  Production = "t2.medium"
}

instance_count = {
  Development = 2
  UAT = 4
  Production = 6
}