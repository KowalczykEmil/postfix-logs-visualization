provider "aws" {
  region = "eu-west-1"
}

resource "aws_key_pair" "default" {
  key_name   = "postfix-demo-key"
  public_key = file("C:/Users/Emil/.ssh/postfix-demo-key.pub")
}

# SG Postfix_Dovecot
resource "aws_security_group" "mail_sg" {
  name        = "postfix-demo-mail-sg"
  description = "Allow SSH, SMTP, IMAP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 143
    to_port     = 143
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 993
    to_port     = 993
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SG OpenSearch
resource "aws_security_group" "opensearch_sg" {
  name        = "postfix-demo-opensearch-sg"
  description = "Allow SSH and OpenSearch ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Postfix Instance
resource "aws_instance" "mail_server" {
  ami           = "ami-0a91cd140a1fc148a" 
  instance_type = "t3.micro"
  key_name      = aws_key_pair.default.key_name
  security_groups = [aws_security_group.mail_sg.name]

  tags = {
    Name = "Postfix-Dovecot-Server"
  }
}

# OpenSearch Instance
resource "aws_instance" "opensearch_server" {
  ami           = "ami-0a91cd140a1fc148a"
  instance_type = "t3.small" 
  key_name      = aws_key_pair.default.key_name
  security_groups = [aws_security_group.opensearch_sg.name]

  tags = {
    Name = "OpenSearch-Server"
  }
}