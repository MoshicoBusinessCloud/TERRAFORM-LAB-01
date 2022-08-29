
#==============================================================================================================================================
# Allocate Elastic IP Address (EIP 1)  # ---This EIP will be attached to NAT-Gateway (1 in AZ1 us-east-1a)
#==============================================================================================================================================
# Find this code@ [terraform aws allocate elastic ip]
#--------------------------------------------------------------------
# --This EIP will be attached to NAT-Gateway ((1) in AZ2 us-east-1a)
#====================================================================
resource "aws_eip" "eip-for-nat-gateway-1" {                        #--The resource type  and the local name
  vpc                                       = true                  #--The question here is the EIP going to be created in the inside of the a 
                                                                    #--vpc, and the anwser is -->>[true]
                #(1-EIP-1)
  tags = {
    Name                                    = "EIP for Nat Gateway (1)"  # The description must be in a double quote, this ia a name_tag
  }
}
#===================================================================
# Allocate Elastic IP Address (EIP 2)  
#--------------------------------------------------------------------
#---This EIP will be attached to NAT-Gateway ((2) in AZ2 us-east-1b)
#====================================================================
resource "aws_eip" "eip-for-nat-gateway-2" {                       #--The resource type  and the local name
  vpc                                       = true                 #--The question here is the EIP going to be created in the inside of the a 
                #(2-EIP-2)
  tags = {
    Name                                    = "EIP for Nat Gateway (2)"  # The description must be in a double quote, this ia a name_tag
  }
}
#==============================================================================================================================================
# Create NAT-Gateway (NAT-1) The 2 NAT-Gateway will be placed in the public subnets to connect the resources in the private subnets to the internet.
#==============================================================================================================================================
# Find this code@ [terraform create aws nat gateway]
#----------------------------------------------------------------------
#  EIP #1 will be attached to this NAT-Gateway (1) in AZ1 us-east-1a)
#======================================================================
resource "aws_nat_gateway" "nat-gateway-1" {                       #--The resource type  and the local name
  allocation_id                             = aws_eip.eip-for-nat-gateway-1.id  # This is how to refference and allocate the nat_gateway_id
  subnet_id                                 = aws_subnet.Public_subnet_1.id # This is how to refference the subnet_id 
                #(3-NAT-!)
  tags = {
    Name                                    = "NAT-Gateway Public Subnet #1"  # The description must be in a double quote, this ia a name_tag
  }
}
#----------------------------------------------------------------------
#  EIP #2 will be attached to this NAT-Gateway (#2) in AZ1 us-east-1b)
#======================================================================
resource "aws_nat_gateway" "nat-gateway-2" {                       #--The resource type  and the local name
  allocation_id                             = aws_eip.eip-for-nat-gateway-2.id  # This is how to refference and allocate the nat_gateway_id
  subnet_id                                 = aws_subnet.Public_subnet_2.id  # This is how to refference the subnet_id
                #(4-NAT-2)
  tags = {
    Name                                    = "NAT-Gateway Public Subnet #2"  # The description must be in a double quote, this ia a name_tag
  }
 } 
#============================================================================================================================================
# Create private table 1 and 2 route traffic to the NAT-Gateway in the public subnets to connect the resources in the private subnet to internet
#============================================================================================================================================
#----------------------------------------------------------------------------------------
#  Create Private Route table #1 to direct traffic to NAT-Gateway (#1) in AZ1 us-east-1a)
#=========================================================================================
resource "aws_route_table" "private-route-table-1" {               #--The resource type  and the local name
  vpc_id                                    = aws_vpc.vpc.id       # This is how to refference the vpc_id

  route {
    cidr_block                              = "0.0.0.0/0"
    gateway_id                              = aws_nat_gateway.nat-gateway-1.id   # This is how to refference the nat_gateway_id
  }
                #(5-RTP-1)
  tags = {
    Name                                    = "Private Route Table (#1)"  # The description must be in a double quote, this ia a name_tag
  }
}
#---------------------------------------------------------------------------------
# Associate Private Subnet (#1) with [Private Route Table (#1)] (AZ1 us-east-1a)
#---------------------------------------------------------------------------------
resource "aws_route_table_association" "private-subnet-1-route-table-association" {  #--The resource type  and the local name
  subnet_id                                    = aws_subnet.Private_subnet_1.id  # This is how to refference the subnet_id
  route_table_id                            = aws_route_table.private-route-table-1.id  # This is how to refference the route_table_id
}               #(6-RTAP-1)
#---------------------------------------------------------------------------------
# Associate Private Subnet (#3) with [Private Route Table (#1)] (AZ1 us-east-1a)
#---------------------------------------------------------------------------------
resource "aws_route_table_association" "private-subnet-3-route-table-association" {  #--The resource type  and the local name
  subnet_id                                    = aws_subnet.Private_subnet_3.id  # This is how to refference the subnet_id
  route_table_id                            = aws_route_table.private-route-table-1.id  # This is how to refference the route_table_id
}               #(7-RTAP-3)
###############################################################################################################################################
###############################################################################################################################################
#----------------------------------------------------------------------------------------
#  Create Private Route table #2 to direct traffic to NAT-Gateway (#2) in AZ2 us-east-1b)
#=========================================================================================
resource "aws_route_table" "private-route-table-2" {                                 #--The resource type  and the local name
  vpc_id                                    = aws_vpc.vpc.id   # This is how to refference the vpc_id

  route {
    cidr_block                              = "0.0.0.0/0"
    gateway_id                              = aws_nat_gateway.nat-gateway-2.id   # This is how to refference the nat_gateway_id
  }
                #(8-RTP-2)
  tags = {
    Name                                    = "Private Route Table (#2)"  # The description must be in a double quote, this ia a name_tag
  }
}
#---------------------------------------------------------------------------------
# Associate Private Subnet (#2) with [Private Route Table (#2)] (AZ1 us-east-1b)
#---------------------------------------------------------------------------------
resource "aws_route_table_association" "private-subnet-2-route-table-association" {  #--The resource type  and the local name
  subnet_id                                    = aws_subnet.Private_subnet_2.id  # This is how to refference the subnet_id
  route_table_id                               = aws_route_table.private-route-table-2.id  # This is how to refference the route_table_id
}               #(9-RTAP-2)

#---------------------------------------------------------------------------------
# Associate Private Subnet (#4) with [Private Route Table (#2)] (AZ1 us-east-1b)
#---------------------------------------------------------------------------------
resource "aws_route_table_association" "private-subnet-4-route-table-association" {  #--The resource type  and the local name
  subnet_id                                    = aws_subnet.Private_subnet_4.id  # This is how to refference the subnet_id
  route_table_id                               = aws_route_table.private-route-table-2.id  # This is how to refference the route_table_id
}               #(10-RTAP-4)
###############################################################################################################################################