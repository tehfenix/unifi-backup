# unifi-backup
Sets up AWS to receive backups to S3.

## Defaults
In *variables.tf* the deafult region is set to **eu-west-2** (London).

## Usage
### Terraform / AWS Part

You need to have an AWS account ([register one here](https://aws.amazon.com/)) and know your IAM user's **access key** and **secret key**.

1. Install *Terraform* on your system and make sure it's in your PATH. [Instructions from Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html).

2. From your command line, clone this repo. `git clone https://github.com/tehfenix/unifi-backup.git`.

3. Run `terraform init` to download dependencies.

4. Run `terraform apply` and supply the requested values, your **access key** and **secret key**.

5. Review the implementation plan and if happy type `yes` and hit *Enter*.

You will get 3 values returned: -

* **bucket-name** = terraform-{unique-value}
* **key-id** = {WriteOnly key for use with backup script}
* **key-secret** = {WriteOnly secret for use with backup script}

Save these for later.

**Disclaimer: the secret will be stored in plain text in your local .tfstate file.**
