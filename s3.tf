## aws_iam_role
resource "aws_iam_role" "allow_nginx_s3" {
  name = "allow_nginx_s3"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_instance_profile" "nginx_profile" {
  name = "nginx_profile"
  role = aws_iam_role.allow_nginx_s3.name

  tags = local.common_tags
}

resource "aws_iam_role_policy" "allow_s3_all" {
  name = "allow_s3_all"
  role = aws_iam_role.allow_nginx_s3.name

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : [
          "s3:*"
        ],
        Effect : "Allow",
        Resource : [
          "arn:aws:s3:::${local.s3_bucket_name}",
          "arn:aws:s3:::${local.s3_bucket_name}/*"
        ]
      }
    ]
  })

}


resource "aws_s3_bucket_acl" "web_bucket_acl" {
  bucket = local.s3_bucket_name
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.web_bucket.bucket
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

## https://stackoverflow.com/questions/76049290/error-accesscontrollistnotsupported-when-trying-to-create-a-bucket-acl-in-aws
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls


resource "aws_s3_bucket" "web_bucket" {
  bucket = local.s3_bucket_name
  #acl = "private"
  force_destroy = true

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          AWS : "${data.aws_elb_service_account.main.arn}"
        },
        Action : "s3:PutObject",
        Resource : "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*"
      },
      {
        Effect : "Allow",
        Principal : {
          Service : "delivery.logs.amazonaws.com"
        },
        Action : "s3:PutObject",
        Resource : "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
        Condition : {
          StringEquals : {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
      },
      {
        Effect : "Allow",
        Principal : {
          Service : "delivery.logs.amazonaws.com"
        },
        Action : "s3:GetBucketAcl",
        Resource : "arn:aws:s3:::${local.s3_bucket_name}"
      }
    ]
  })

  tags = local.common_tags

}

resource "aws_s3_object" "website_content" {
  for_each = {
    website = "/website/index.html"
    logo    = "/website/Globo_logo_Vert.png"
  }

  bucket = aws_s3_bucket.web_bucket.bucket
  key    = each.value
  source = ".${each.value}"

  tags = local.common_tags

}

####
#deleted the below object and used a for each map.
####
# resource "aws_s3_object" "graphic" {
#   bucket = local.s3_bucket_name
#   key    = 
#   source = "./website/Globo_logo_Vert.png"

#   tags = local.common_tags

# }