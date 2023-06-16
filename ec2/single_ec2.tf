provider "aws" {
  region = "us-east-1"
}

data "aws_key_pair" "my-ubuntu" {
# filter Configuration Block
# The following arguments are supported by the filter configuration block:
# name - (Required) The name of the filter field. Valid values can be found 
# in the EC2 DescribeKeyPairs API Reference.
  filter {
    name = "key-name"
    values = ["my-ubuntu"]
  }
  # key_name = "my-ubuntu"
}

data "aws_ami" "img" {
  most_recent = true
  filter {
    name = "name"
    values = ["al2023-ami-2023.0.20230614.0-*"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "test" {
  ami = "${data.aws_ami.img.id}"
  availability_zone = "us-east-1a"
  instance_type = "t3.micro"
  key_name = "${data.aws_key_pair.my-ubuntu.key_name}"
  security_groups = ["default"]
  tags = {
    Name = "test"
  }
}

resource "aws_ebs_volume" "test" {
  availability_zone = "us-east-1a"
  size              = 8
  tags = {
    Name = "Test_ebs"
  }
}

resource "aws_volume_attachment" "test" {
  device_name = "/dev/sdz"
  volume_id   = aws_ebs_volume.test.id
  instance_id = aws_instance.test.id
}

output "instance_id" {
  value = "${aws_instance.test.id} ${aws_instance.test.public_ip}"
}