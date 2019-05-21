provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_s3_bucket" "backup-bucket" {
  bucket = var.bucket-name
  acl    = "private"
}

resource "aws_iam_user" "unifi-backup-user" {
  name = "unifi-backup-user"
  path = "/system/"
}

resource "aws_iam_access_key" "unifi-key" {
  user = "${aws_iam_user.unifi-backup-user.name}"
}

resource "aws_iam_user_policy" "iam-policy" {
  name        = "WriteOnly_S3_UnifiBackup"
  user = "${aws_iam_user.unifi-backup-user.name}"

  policy = <<EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "VisualEditor0",
              "Effect": "Allow",
              "Action": [
                  "s3:PutObject",
                  "s3:AbortMultipartUpload",
                  "s3:PutObjectTagging"
              ],
              "Resource": "arn:aws:s3:::${aws_s3_bucket.backup_bucket.id}/*"
          }
      ]
  }
EOF
}

output "key-id" {
  value = "${aws_iam_access_key.unifi-key.id}"
}

output "key-secret" {
  value = "${aws_iam_access_key.unifi-key.secret}"
}
