#=========================================================================================================================================
#--In this simulation we are creating a 3 teir architecture spanning 2 availability zones with 2 public subnets(subnets in AZ1 and AZ2),.. 
#--2 NAT_Gateways(one on each of the public subnets) 4 private subnets(with subnet 1/3 in AZ1, and subnet 2/4 in AZ2), 1 internet_gateway.. 
#--pointing to the internet(0.0.0.0/0), 1 route_table, and 2 route_table_associations(to associate the public subnets to the route_table).
#
#--We need to create a variable section to hold the values of our resources and to make our code more dynamic. For the vpc, we need to..
#--variablilized the CIDR_Block. For the (2 pub-subnets) and (4 pri-subnets), we need to variablilized the CIDR_Blocks and availability zones.
#------------------------------------------------------------------------------------------------------------------------------------------
#==========================================================================================================================================
#-------Create VPC------#    #-------Create VPC------#    #-------Create VPC------#    #-------Create VPC------#  #-------Create VPC------#
#==========================================================================================================================================
#---------------------------------------
# --terraform--aws--create--vpc--#
#=======================================
resource "aws_vpc" "vpc" {              # --The resource type  and the local name
  cidr_block                            = "${var.vpc_cidr}" # --Create variable for the cidr if you dont want to hardcode the value
  instance_tenancy                      = "default" # --The [default] option is the shared model [meaning multiple host is using the hardware]
  enable_dns_hostnames                  = true      # --Thia means you want to display the dns hostname once the instance is launched

  tags = {           #(1)
    Name                                = "Test VPC"    # --The name of yoyr vpc
  }
}
#===========================================================================================================================================
#-Create Internet Gateway and Attach it to VPC--# [terraform aws create internet gateway] #--Create Internet Gateway and Attach it to VPC--#
#-------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "internet_gateway" {   # --The resource type  and the local name
  vpc_id                                = aws_vpc.vpc.id  # --This is how you refference vpc when creating your internet-gateway
  tags = {          #(2)
    Name                                = "Test IGW"   # --The name of yoyr internet-gateway
  }
}
#===========================================================================================================================================
#--Create Public Subnet 1--#--Create Public Subnet 1--#[terraform aws create subnet]#--Create Public Subnet 1--#--Create Public Subnet 1--#
#-------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "Public_subnet_1" {         # --The resource type  and the local name
  vpc_id                                = aws_vpc.vpc.id   # --This is how refference vpc when creating your subnet
  cidr_block                            = "${var.public_subnet_1_cidr}" # --Create variable for the cidr if you dont want to hardcode the value
  availability_zone                     = "${var.availability_zone_1}"  # --Create variable for the AZ if you dont want to hardcode the value
  map_public_ip_on_launch               = true    # --Specify true to indicate that instances launched into the subnet should be assigned a 
                                                  # --public IP address. Default is false

  tags = {          #(3)
    Name                                = "Public Subnet 1"  # --The name of your subnet
  }
}
#===========================================================================================================================================
#--Create Public Subnet 2--#--Create Public Subnet 1--#[terraform aws create subnet]#--Create Public Subnet 1--#--Create Public Subnet 2--#
#-------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "Public_subnet_2" {        # --The resource type  and the local name
  vpc_id                                = aws_vpc.vpc.id   # --This is how refference vpc when creating your subnet
  cidr_block                            = "${var.public_subnet_2_cidr}" # --WE are Creating  variable for the cidr for best practice
  availability_zone                     = "${var.availability_zone_2}" # --WE are Creating  variable for the AZ for best practice
  map_public_ip_on_launch               = true    # --Specify true to indicate that instances launched into the subnet should be assigned a 
                                                  # --public IP address. Default is false

  tags = {          #(4)
    Name                                = "Public Subnet 2"  # This is a name_tag of the resource, it must be in a double quote
  }
}
#===========================================================================================================================================
#--Create route table--#     #--Create association--##[terraform aws create route table]#--Create association--#    #--Create route table--#
#-------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_route_table" "public_route_table" {    # --The resource type  and the local name
  vpc_id                                = aws_vpc.vpc.id    # --This is how refference vpc when creating your route_table

  route {
    cidr_block                          = "0.0.0.0/0"     # For the internet_gateway_cidr_block we are opening traffic to anywhere
    gateway_id                          = aws_internet_gateway.internet_gateway.id # This is how to refference the internet_gateway_id 
  }
  tags = {          #(5)
    Name                                = "Public Route Table" # This is a name_tag of the resource, it must be in a double quote
  }
}
#------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_route_table_association" "public_subnet_1_route_table_association" {   # --The resource type  and the local name
  subnet_id                             = aws_subnet.Public_subnet_1.id        # This is how to refference the subnet_id
  route_table_id                        = aws_route_table.public_route_table.id  # This is how to refference the route_table_id
}                   #(6)
#------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_route_table_association" "public_subnet_2_route_table_association" {   # --The resource type  and the local name
  subnet_id                             = aws_subnet.Public_subnet_2.id         # This is how to refference the subnet_id
  route_table_id                        = aws_route_table.public_route_table.id  # This is how to refference the route_table_id
}                   #(7)
#===========================================================================================================================================
#-------------------------------------------------------------------------------------------------------------------------------------------
#===========================================================================================================================================
#-Create Private Subnet 1--#--Create Private Subnet 1--#[terraform aws create subnet]#--Create Private Subnet 1--#--Create Private Subnet1-#
#-------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "Private_subnet_1" {        # --The resource type  and the local name
  vpc_id                                = aws_vpc.vpc.id   # --This is how refference vpc when creating your subnet
  cidr_block                            = "${var.private_subnet_1_cidr}" # --WE are Creating  variable for the cidr for best practice
  availability_zone                     = "${var.availability_zone_private_1}"   # --WE are Creating  variable for the AZ for best practice
  map_public_ip_on_launch               = false   # --Specifying true here indicate that instances launched into the subnet should be assigned 
                                                  # --a public IP address. This is BAD because we dont public traffic to get to the resources 
                                                  # --in the private_subnet. Leave as default, put -->>[false]
                    #(8)
  tags = {
    Name = "Private Subnet 1"                     # This is a name_tag of the resource, it must be in a double quote
  }
}
#===========================================================================================================================================
#-Create Private Subnet 2--#--Create Private Subnet 2--#[terraform aws create subnet]#--Create Private Subnet 2--#--Create Private Subnet2-#
#-------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "Private_subnet_2" {       # --The resource type  and the local name
  vpc_id                                = aws_vpc.vpc.id    # --This is how refference vpc when creating your subnet
  cidr_block                            = "${var.private_subnet_2_cidr}"  # --WE are Creating  variable for the cidr for best practice
  availability_zone                     = "${var.availability_zone_private_2}"   # --WE are Creating  variable for the AZ for best practice
  map_public_ip_on_launch               = false  # --Specifying true here indicate that instances launched into the subnet should be assigned 
                                                 # --a public IP address. This is BAD because we dont public traffic to get to the resources 
                                                 # --in the private_subnet. Leave as default, put -->>[false]
                    #(9)
  tags = {
    Name = "Private Subnet 2"                    # This is a name_tag of the resource, it must be in a double quote
  }
}
#===========================================================================================================================================
#-Create Private Subnet 3--#--Create Private Subnet 3--#[terraform aws create subnet]#--Create Private Subnet 3--#--Create Private Subnet3-#
#-------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "Private_subnet_3" {       # --The resource type  and the local name
  vpc_id                                = aws_vpc.vpc.id    # --This is how refference vpc when creating your subnet
  cidr_block                            = "${var.private_subnet_3_cidr}"   # --WE are Creating  variable for the cidr for best practice
  availability_zone                     = "${var.availability_zone_private_3}"  # --WE are Creating  variable for the AZ for best practice
  map_public_ip_on_launch               = false  # --Specifying true here indicate that instances launched into the subnet should be assigned 
                                                 # --a public IP address. This is BAD because we dont public traffic to get to the resources 
                                                 # --in the private_subnet. Leave as default, put -->>[false] 
                  #(10)
  tags = {
    Name = "Private Subnet 3"                    # This is a name_tag of the resource, it must be in a double quote
  }
}
#===========================================================================================================================================
#-Create Private Subnet 4--#--Create Private Subnet 4--#[terraform aws create subnet]#--Create Private Subnet 4--#--Create Private Subnet4-#
#-------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "Private_subnet_4" {       # --The resource type  and the local name
  vpc_id                                = aws_vpc.vpc.id    # --This is how refference vpc when creating your subnet
  cidr_block                            = "${var.private_subnet_4_cidr}"   # --WE are Creating  variable for the cidr for best practice
  availability_zone                     = "${var.availability_zone_private_4}"  # --WE are Creating  variable for the AZ for best practice
  map_public_ip_on_launch               = false  # --Specifying true here indicate that instances launched into the subnet should be assigned 
                                                 # --a public IP address. This is BAD because we dont public traffic to get to the resources 
                                                 # --in the private_subnet. Leave as default, put -->>[false] 
                  #(11)
  tags = {
    Name = "Private Subnet 4"                    # This is a name_tag of the resource, it must be in a double quote
  }
}
#==============================================================================================================================================
###############################################################################################################################################