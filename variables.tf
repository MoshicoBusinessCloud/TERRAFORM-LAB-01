#################################################################################################################
#--The variable section is used to hold the values of the resources in the main section to make your code more..
#--dynamic and to avoid hardcoding of values to your code. There are diffrent ways of writing terraform variables,
#--depending on the use case. We are using this simple form for this simulation.
#================================================================================================================


#===================================================
#--(1) This is the value of the vpc cidr
#===================================================

variable "vpc_cidr" {
    default = "10.0.0.0/16"
    description = "VPC CIDR Block"
    type = string
}
#====================================================
#--(2) This is the value of the pub_sub-1_cidr(AZ1)
#====================================================
variable "public_subnet_1_cidr" {
    default = "10.0.0.0/24"
    description = "Public Subnet 1 CIDR Block"
    type = string
}
#---------------------------------------------------
#--(3) This is the value of the AZ of pub_sub_1
#---------------------------------------------------
variable "availability_zone_1" {
    default = "us-east-1a"
    description = "Public Subnet availability zone 1"
    type = string
}
#====================================================
#--(4) This is the value of the pub_sub-2_cidr(AZ2)
#====================================================
variable "public_subnet_2_cidr" {
    default = "10.0.1.0/24"
    description = "Public Subnet 2 CIDR Block"
    type = string
}
#---------------------------------------------------
#--(5) This is the value of the AZ of pub_sub_2
#----------------------------- ---------------------
variable "availability_zone_2" {
    default = "us-east-1b"
    description = "Public Subnet availability zone 2"
    type = string
}
#====================================================
#--(6) This is the value of the pri_sub-1_cidr(AZ1)
#====================================================
variable "private_subnet_1_cidr" {
    default = "10.0.2.0/24"
    description = "Private Subnet 1 CIDR Block"
    type = string
}
#-----------------------------------------------------
#--(7) This is the value of the AZ of pri_sub_1
#-----------------------------------------------------
variable "availability_zone_private_1" {
    default = "us-east-1a"
    description = "Private Subnet availability zone 1"
    type = string
}
#=====================================================
#--(8) This is the value of the pri_sub-2_cidr(AZ2)
#=====================================================
variable "private_subnet_2_cidr" {
    default = "10.0.3.0/24"
    description = "Private Subnet 2 CIDR Block"
    type = string
}
#-----------------------------------------------------
#--(9) This is the value of the AZ of pri_sub_2
#-----------------------------------------------------
variable "availability_zone_private_2" {
    default = "us-east-1b"
    description = "Private Subnet availability zone 2"
    type = string
}
#=====================================================
#--(10) This is the value of the pri_sub-3_cidr(AZ1)
#=====================================================
variable "private_subnet_3_cidr" {
    default = "10.0.4.0/24"
    description = "Private Subnet 3 CIDR Block"
    type = string
}
#-----------------------------------------------------
#--(11) This is the value of the AZ of pri_sub_3
#-----------------------------------------------------
variable "availability_zone_private_3" {
    default = "us-east-1a"
    description = "Private Subnet availability zone 1"
    type = string
}
#=====================================================
#--(12) This is the value of the pri_sub-4_cidr(AZ2)
#=====================================================
variable "private_subnet_4_cidr" {
    default = "10.0.5.0/24"
    description = "Private Subnet 4 CIDR Block"
    type = string
}
#-----------------------------------------------------
#--(13) This is the value of the AZ of pri_sub_4
#-----------------------------------------------------
variable "availability_zone_private_4" {
    default = "us-east-1b"
    description = "Private Subnet availability zone 4"
    type = string
}

#=====================================================
#--(12) This is the value of the SSH secority group
#=====================================================
variable "ssh-location" {
    default = "0.0.0.0/0"
    description = "IP Address Thst Can SSH Into The EC2 Instance"
    type = string
}

#=====================================================
#--(12) This is the value of the SSH secority group
#=====================================================
variable "database_snapshot_identifier" {
    default = "arn:aws:rds:us-east-1:665511524712:snapshot:database-1-final-snapshot"
    description = "Database snapshot arn"
    type = string
}

#=====================================================
#--(12) This is the value of the SSH secority group
#=====================================================
variable "database_instance_class" {
    default = "db.t2.micro"
    description = "Database snapshot instance type"
    type = string
}

#-----------------------------------------------------
#--(13) This is the value of the AZ of pri_sub_4
#-----------------------------------------------------
variable "availability_zone_private_database_4" {
    default = "us-east-1b"
    description = "Private database Subnet availability zone 4"
    type = string
}

#=====================================================
#--(12) This is the value of the SSH secority group
#=====================================================
variable "database_instance_identifier" {
    default = "database-1"
    description = "Database snapshot instance identifier"
    type = string
}

#=====================================================
#--(12) This is the value of the SSH secority group
#=====================================================
variable "multi_az_deployment" {
    default = false
    description = "Create a standby instance"
    type = bool
}
