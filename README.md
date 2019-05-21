# unifi-backup
Sets up AWS to receive backups to S3. This is a first working draft, I'm really open to pull requests for improvements.

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

### Ubuntu server Part
On your Cloud Controller you first need to give your user account access to where UniFi Cloud Controller Stores its auto-backups.

1. At a prompt run `sudo usermod -a -G unifi your_user_name` replacing *your_user_name* with the login you use. This adds your Linux user into the group with permissions to where the backups are stored.

2. Logout by typing `logout` and then connect again (SSH or local console).

3. Create a folder in your home directory (*~*) named s3-backups, `mkdir ~/s3-backups`.

4. Create the backup script in your home directory by typing `nano run-backup.sh`.

5. Copy the contents of *run-backup.sh* from this repo into *nano* and then to save and quit do `CTRL + O` (letter O), *Enter*, `CTRL + X`.

6. Lastly we need to add the cron timer job so do `crontab -e` and at the bottom paste: `0 2 * * * ~/run-backup.sh` This will run the script every day at 02:00am. Use `CTRL + O` (letter O), *Enter*, `CTRL + X` to quit nano like you did in the previous step.
