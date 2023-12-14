provider "aws" {

}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
 
    ingress {
    description = "ssh into vpc"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    
    egress {
    description = "outbound_allowed"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_ec2"{
    ami = " xxx "
    instance_type = "t2.micro"
    key_name ="y" #key name to be used in private key. 
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]

    connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "Y" #private key pair thingy. go off file path. 
    host = self.public_ip
        }

    provisioner "remote-exec" {
        on_failure = continue
        inline = [
            "sudo amazon-linux-extras install nginx1 -y", # -y is a must. prompt will come up and will be stuck otherwise. 
            "sudo systemctl start nginx"
            # these are what ever needs to be downloaded onto the instance. 
        ]
    }

    provisioner "local-exec" { #most used approach is to run ansible books.
        command = "echo ${aws_instance.my_ec2.private_ip}>>private_ips.txt"

    }
 }
