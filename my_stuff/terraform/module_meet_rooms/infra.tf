data "aws_route53_zone" "zone" {
  name = "${local.subdomain}.${local.domain}"
}

resource "aws_route53_record" "subdomain" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${local.subdomain}.${local.domain}"
  type    = "A"
  alias {
    name                   = "${local.subdomain}.${local.domain}.s3-website-${local.region}.amazonaws.com"
    zone_id                = aws_s3_bucket.website.hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_s3_bucket" "website" {
  bucket = "${local.subdomain}.${local.domain}"
  acl    = "public-read"
  policy = <<-EO_POLICY
    {"Id": "PolicyMeet","Version": "2012-10-17","Statement": [{
      "Sid": "Meet01","Action": ["s3:GetObject" ],"Effect": "Allow",
      "Resource": "arn:aws:s3:::${local.subdomain}.${local.domain}/*",
      "Principal": "*"
    }]}
  EO_POLICY
  website {
    index_document = "index.html"
    error_document = "error.html"
    routing_rules = <<-EO_ROUTING_RULES
      ${jsonencode([for entry in local.salas :
    { "Condition" = {
      "KeyPrefixEquals" = entry[0]
      }
      "Redirect" = {
        "Protocol"       = "https"
        "HostName"       = "meet.google.com"
        "ReplaceKeyWith" = "${entry[1]}"
      }
    }
])}
    EO_ROUTING_RULES
}
}

resource "aws_s3_access_point" "public_access_point" {
  bucket = aws_s3_bucket.website.id
  name   = "meeting-rooms"
}

resource "aws_s3_bucket_object" "index-object" {
  bucket       = "${local.subdomain}.${local.domain}"
  key          = "index.html"
  content      = "Private area"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "list" {
  bucket       = "${local.subdomain}.${local.domain}"
  key          = "list"
  content      = <<-EOWebPage
    <html><head><title>Channels list</title><meta name="robots" content="noindex,nofollow" /></head><body><table>%{for entry in local.salas}<tr><td><a href="/${entry[0]}">/${entry[0]}</a></td><td>${entry[2]}</td></tr>%{endfor}<tr></table></body></html>
  EOWebPage
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "error-object" {
  bucket       = "${local.subdomain}.${local.domain}"
  key          = "error.html"
  content      = "Error"
  content_type = "text/html"
}

