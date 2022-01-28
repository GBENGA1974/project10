# database for rds mysql

# PROJECT9 DATABASE 
# SECURITY GROUP FOR DATABASE instance

resource "aws_security_group" "project10-db-secgrp" {
  name              = "project10-db_sec-group"
  description       = "Allow mysql inbound traffic"
  vpc_id            = aws_vpc.project10_vpc_cluster.id

}

resource "aws_security_group_rule" "project10-inbound" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.project10-db-secgrp.id
}

resource "aws_security_group_rule" "PROJECT10-outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.project10-db-secgrp.id
}

# MYSQL DATABASE SUBNET GROUP

resource "aws_db_subnet_group" "project_db_group" {
  name       = "project10-db"
  subnet_ids = [aws_subnet.project10-private_subnet1.id, aws_subnet.project10-private_subnet2.id]

  tags = {
    Name = "mysqldb-subnet group"
  }
}

# aws_db_instance

resource "aws_db_instance" "mysqldatabase_cluster" {
  allocated_storage    = 8
  backup_retention_period = 2
  backup_window = "02:00-02:30"
  maintenance_window = "sat:04:00-sat:04:30"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mysql_project10"
  username             = "project10"
  password             = "Emmanuel1974"
  port = "3306"
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.project10-db-secgrp.id, aws_security_group.project10-vpc-security-group.id]
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.project_db_group.name
  publicly_accessible = false
}