#==============================================================================================================================================
#--Here we are using a copy of previous MYSQL DB snapshot to create database. We are creating the database in the private subnet 3 and a standby
#--replica in private subnet 4. Here we are creating a subnet_group, db_snapshot, and a db_instance. 
#==============================================================================================================================================
# Create Database Subnet Group 
#=============================================================================================
#--Find this block of code@ terraform aws db subnet group
#=============================================================================================
resource "aws_db_subnet_group" "database-subnet-group" {                                     #--The resource type  and the local name
  name                    = "database subnets"                                               #--The name of the security group
  subnet_ids              = [aws_subnet.Private_subnet_3.id, aws_subnet.Private_subnet_4.id] # This is how to refference the subnet_group_id 
  description             = "Subnet For Database Instance"

  tags   = {
    Name                  = "Database Subnets"
  }
}
#===============================================================================================================================================
# Get the Latest DB Snapshot
#==============================================================================================================================================
# Find this block of code@ terraform aws data db snapshot
#=============================================================================================
data "aws_db_snapshot" "latest-db-snapshot" {                                                #--The resource type  and the local name
  db_snapshot_identifier  = "${var.database_snapshot_identifier}" # --First we need to Create a variable for the db_snapshot_identifier by going
  #-- to copy the db_snapshot_arn from the console. Next we need to refference the name of the variable here.
  most_recent             = true                                                             #--Is this the most recent snapshot--enter [true]
  snapshot_type           = "manual"                                                         #--For snapshot_type, put manual
}
#==============================================================================================================================================
# Create Database Instance Restored from DB Snapshots. For the section below, we need to create 4 variables to hold the value of the instance..
#--class, availability_zone, instance_identifierr, and muli_AZ deployment. We need some of the info from our db console: snapshot--ARN, db_name
#==============================================================================================================================================
# Find this block of code@ terraform aws db instance
#==============================================================================================
resource "aws_db_instance" "database-instance" {                                             #--The resource type  and the local name
  instance_class          = "${var.database_instance_class}"  #--Create variable for the Instance_type and refference it here
  skip_final_snapshot     = true
  availability_zone       = "${var.availability_zone_private_database_4}" # --Create variable for the AZ if you dont want to hardcode the value
  identifier              = "${var.database_instance_identifier}"         #--Create variable for the identifier, copy db_name and refference it here
  snapshot_identifier     = data.aws_db_snapshot.latest-db-snapshot.id                       # This is how to refference the route_table_id
  db_subnet_group_name    = aws_db_subnet_group.database-subnet-group.name   # This is how to refference the the name of your subnet_group
  multi_az                = "${var.multi_az_deployment}"           #--Create variable for the multi_AZ, copy db_name and refference it here
  vpc_security_group_ids  = [aws_security_group.database-security-group.id]                  # This is how to refference the database_SG_id
}