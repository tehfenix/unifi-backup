provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_s3_bucket" "backup-bucket" {
  acl    = "private"
}

resource "aws_iam_user" "unifi-backup-user" {
  name = "unifi-backup-user"
  path = "/system/"
}

resource "aws_iam_access_key" "unifi-key" {
  user = "${aws_iam_user.unifi-backup-user.name}"
}

data "aws_iam_policy_document" "s3policy" {
  statement {
    actions   = ["s3:PutObject", "S3:AbortMultipartUpload", "s3:PutObjectTagging"]
    resources = ["${aws_s3_bucket.backup-bucket.arn}/*"]
  }
}

resource "aws_iam_policy" "policy" {
    name        = "WriteOnly_S3_UnifiBackup"
    path        = "/"
    description = "Allows backup of UniFi auto-backup files"

    policy = "${data.aws_iam_policy_document.s3policy.json}"
  }

resource "aws_iam_policy_attachment" "attach-policy" {
  name       = "policy-attachment"
  users      = ["${aws_iam_user.unifi-backup-user.id}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

output "key-id" {
  value = "${aws_iam_access_key.unifi-key.id}"
}

output "key-secret" {
  value = "${aws_iam_access_key.unifi-key.secret}"
}

output "bucket-name" {
  value = "${aws_s3_bucket.backup-bucket.id}"
}
