provider "aws" {
 region = "us-east-1"
 access_key= "AKIA2F2VO2Y4JRGIRUX4"
 secret_key= "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"
}



resource "aws_instance" "k8-server" {
 ami = "ami-007855ac798b5175e"
 instance_type = "t2.medium"
 availability_zone = "us-east-1a"
 vpc_security_group_ids = [aws_security_group.my_sg.id]
 key_name = "abhishek"
 tags = {
 name = "deployment_instance"
 }
 provisioner "remote-exec" {
 inline = [
 "sudo apt-get update -y",
 "sudo apt-get install docker.io -y",
 "sudo wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
 "sudo chmod +x /home/ubuntu/minikube-linux-amd64",
 "sudo cp minikube-linux-amd64 /usr/local/bin/minikube",
 "curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s 
https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl",
 "sudo chmod +x /home/ubuntu/kubectl",
 "sudo cp kubectl /usr/local/bin/kubectl",
 "sudo groupadd docker",
 "sudo usermod -aG docker ubuntu"
 ]
 connection {
 type = "ssh"
 host = self.public_ip
 user = "ubuntu"
 private_key = file("abhishek.pem")
 }
 }
}



resource "aws_security_group" "my_sg" {
 name = "my_sg"
 ingress {
 description = "enable port 22"
 from_port = 22
 to_port = 22
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
 description = "outbound"
 from_port = 0
 to_port = 0
 protocol = "-1"
 cidr_blocks = ["0.0.0.0/0"]
 }
}