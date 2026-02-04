# key pair login 

resource "aws_key_pair" "my_key" {
  key_name = "terra-key-ec2"
    public_key = file("terra-key-ec2.pub")
}

# VPC & security group

resource "aws_default_vpc" "default" {
  
}


resource "aws_security_group" "my_security_group" {
    name = "automate-security-group"
    description = "this will add a TF generated security group"
    vpc_id = aws_default_vpc.default.id

    # inbound rule 

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allow SSH access from anywhere"
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allow HTTP access from anywhere" 
    }

    # outbound rule
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "allow all outbound traffic"
    }

    tags = {
        Name = "automate-security-group"
    } 
}

 # ec2 instance   

resource "aws_instance" "my_ec2_instance" {
     key_name = aws_key_pair.my_key.key_name
     security_groups = [aws_security_group.my_security_group.name]
     instance_type = "t3.micro"
     ami = "ami-06e3c045d79fd65d9" #ubuntu 20.04 in us-east-2

     root_block_device {
       volume_size = 15
       volume_type = "gp3" 
     }

     tags = {
        Name = "automate-ec2-instance-for-TASK3"
     }

}