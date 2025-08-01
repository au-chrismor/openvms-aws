# AWS Imagebuilder Stack

This terraform stack creates an AWS Imagebuilder pipeline to create a working KVM host with the necessary components to host OpenVMS

## WARNING

These steps WILL incur AWS charges.

## Before Running

You need to register and download the OpenVMS X86 Community Edition.  Extract the files and copy the "X86_Vxxx-community.qcow2" file into a subdirectory called "files" as "openvms-community.qcow2"

copy "dev.tfvars" to "terraform.tfvars" and edit to suit your environment

Create a public key pair, and paste the public key text into "aws_key_data" in terraform.tfvars.  Don't use the example, it is deliberately corrupted.

Now you can run:

- terraform init
- terraform plan -var-file=terraform.tfvars -out tf.out
- terraform apply tf.out

Be aware that copying the virtual disc will tak a while, since it's around 8GB in size.  Be patient, you only need to do this once!

## Executing

With everything in place, you're now ready to run your first image build.  From the AWS Console, go to Imagebuilder, select your pipeline from "Image Pipelines" and then from the "Actions" menu choose "Run pipeline"

After a while, you will see the image appear in the "Output Images" list.

If you want to do this from the command line, you can issue:

"aws imagebuilder list-image-pipelines" specifying the region with "--region <region_name> if required.

Note the "arn" value, and use with with the command:

"aws imagebuilder start-image-pipeline-execution -arn *arn from the previous step*"

Finally:

"aws imagebuilder list-images" to get the id of your new image

## Removing everything
If you don't want to create any more images, issue:

terraform destroy -var-file=terraform.tfvars

