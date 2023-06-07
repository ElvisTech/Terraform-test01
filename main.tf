
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "terraformprueba" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.gruposeguridad.id]

  user_data = <<-EOF
              echo "hola mundo" > index.html
              nohup busybox httpd -f -p "${var.puerto}" &
              EOF

  tags = {
    Name = "terraform-vm"
  }
}

resource "aws_security_group" "gruposeguridad" {
  name = "grupo_seguridad_instancias"

  ingress {
    from_port = var.puerto
    to_port = var.puerto
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "puerto" {
  description = "puerto servidor web"
  type = number
}

output "ippublica" {
  description="ip publica server"
  value = aws_instance.terraformprueba.public_ip
}
