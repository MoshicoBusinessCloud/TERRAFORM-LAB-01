################################################################################################################################################
#--For this simulation we are creating 4 security groups(ALB_SG, SSH_SG, WebServer_SG, and Database_SG) to protect and manage traffic that can 
#--come in and out of our environmet. The ALB security group and the bastion will be placed in the public subnets directing traffic to the..
#--WebServser via HTTP/HTTPS and SSH on [Port ==80/443, and Port==22], and the WebSErver security group(which will be placed in private subnets)
#--will only accept traffic from the ALB and the Bastion security groups. Finanly, the Database security group(which is placed in the in a.. 
#--private database subnets) will only recieve traffic from WebServer_SG 0n [Port==3306].   
#===============================================================================================================================================
#--Create Security Group for the Application Load Balancer----]]
#---------------------------------------------------------------
# Find this block of code@ [terraform aws create security group]
#===============================================================
resource "aws_security_group" "alb-security-group" {
  name               = "ALB Security Group"                    #--The name of the security group
  description        = "Enable HTTP/HTTPS Access on Port 80/443" #--Description of the resource is doing
  vpc_id             = aws_vpc.vpc.id                          # --This is how refference vpc when creating your security group

  ingress {
    description      = "HTTP Access"                           #--Description of the ingress is doing
    from_port        = 80                                      #--Rule Allowing HTTP traffic from the internet
    to_port          = 80                                      #--Rule Allowing HTTP traffic to the ALB
    protocol         = "tcp"                                   #--HTTP traffic uses tcp protocol
    cidr_blocks      = ["0.0.0.0/0"]                           #--With this we are opening traffic to anywhere on the internet
  }

  ingress {
    description      = "HTTPS Access"                          #--Description of the ingress is doing
    from_port        = 443                                     #--Rule Allowing secured HTTPS traffic from the internet
    to_port          = 443                                     #--Rule Allowing secured HTTPS traffic to the ALB
    protocol         = "tcp"                                   #--HTTP traffic uses tcp protocol
    cidr_blocks      = ["0.0.0.0/0"]                           #--With this we are opening traffic to anywhere on the internet 
  }

  egress {
    from_port        = 0                                       #--We use 0 here to allow traffic out
    to_port          = 0                                       #--We use 0 here to allow traffic out
    protocol         = "-1"                                    #--We use -1 here to anywhere 
    cidr_blocks      = ["0.0.0.0/0"]                           #--With this we are allowing traffic out to anywhere on the internet
  }

  tags   = {
    Name             = "ALB Security Group"                    #--Tag name for the ALB_SG
  }
}
#==============================================================================================================================================
# Create Security Group for the Bastion Host aka Jump Box    ]]]
#---------------------------------------------------------------
# Find this block of code@ [terraform aws create security group]
#===============================================================
resource "aws_security_group" "ssh-security-group" {           # --The resource type  and the local name
  name               = "SSh Access"                            #--The name of the security group
  description        = "Enable SSH access on Port 22"          #--Description of the resource is doing
  vpc_id             = aws_vpc.vpc.id                          # --This is how refference vpc when creating your security group

  ingress {
    description      = "SSH Access"                            #--Description of the ingress is doing
    from_port        = 22                                      #--Rule Allowing secured SSH traffic from the Admin
    to_port          = 22                                      #--Rule Allowing secured SSH traffic to the Bastion
    protocol         = "tcp"                                   #--HTTP traffic uses tcp protocol
    cidr_blocks      = ["${var.ssh-location}"]                 #--Here we are variablilizing the cidr_blcok route of theSSH traffic
  }

  egress {
    from_port        = 0                                       #--We use 0 here to allow traffic out
    to_port          = 0                                       #--We use 0 here to allow traffic out
    protocol         = "-1"                                    #--We use -1 here to anywhere 
    cidr_blocks      = ["0.0.0.0/0"]                           #--With this we are allowing traffic out to anywhere on the internet
  }

  tags   = {
    Name             = "SSH Security Group"                    #--Tag name for the SSH_SG
  }
}

#==============================================================================================================================================
# Create Security Group for the Web Server     ]]]===========]]]
#---------------------------------------------------------------
# Find this block of code@ [terraform aws create security group]
#===============================================================
resource "aws_security_group" "webserver-security-group" {
  name               = "WebServer Security Group"
  description        = "Enable HTTP/HTTPS access on Port 80/443 via ALB and SSH on Port 22 via SSH SG" #--Description of the resource is doing
  vpc_id             = aws_vpc.vpc.id                          # --This is how refference vpc when creating your security group

  ingress {
    description      = "HTTPS Access"                          #--Description of the ingress is doing
    from_port        = 80                                      #--Rule Allowing HTTP traffic from the ALB
    to_port          = 80                                      #--Rule Allowing HTTP traffic to the WebSErver
    protocol         = "tcp"                                   #--HTTP traffic uses tcp protocol
    security_groups  = ["${aws_security_group.alb-security-group.id}"]  # --This is how refference your ALB_SG when creating the rule to allow 
                                                                        #--traffic from the ALB_SG to the WebServer
  }

  ingress {
    description      = "HTTPS Access"                          #--Description of the ingress is doing
    from_port        = 443                                     #--Rule Allowing secured HTTPS traffic from the ALB
    to_port          = 443                                     #--Rule Allowing secured HTTPS traffic to the WebServer
    protocol         = "tcp"                                   #--HTTP traffic uses tcp protocol
    security_groups  = ["${aws_security_group.alb-security-group.id}"]  # --This is how refference your ALB_SG when creating the rule to allow 
                                                                        #--traffic from the ALB_SG to the WebServer
  }

  ingress {
    description      = "SSH Access"                            #--Description of the ingress is doing
    from_port        = 22                                      #--Rule Allowing secured SSH traffic from the Bastion
    to_port          = 22                                      #--Rule Allowing secured SSH traffic to the WEbSErver
    protocol         = "tcp"                                   #--SSH traffic uses tcp protocol
    security_groups  = ["${aws_security_group.ssh-security-group.id}"]  # --This is how refference your Bastion_SG when creating the rule to allow 
                                                                        #--traffis from the Bastion_SG to the WebServer
  }

  egress {
    from_port        = 0                                       #--We use 0 here to allow traffic out
    to_port          = 0                                       #--We use 0 here to allow traffic out
    protocol         = "-1"                                    #--We use -1 here to anywhere 
    cidr_blocks      = ["0.0.0.0/0"]                           #--With this we are allowing traffic out to anywhere on the internet
  }

  tags   = {
    Name             = "Web Server SEcurity Group"             #--Tag name for the WebServer_SG
  }
}
 
#==============================================================================================================================================
# Create Security Group for the Database     ]]]=============]]]
#---------------------------------------------------------------
# Find this block of code@ [terraform aws create security group]
#===============================================================
resource "aws_security_group" "database-security-group" {      # --The resource type  and the local name
  name               = "Database Security Group"               #--The name of the security group
  description        = "Enable MYSQL/Aurora access on Port 3306"  #--Description of the resource is doing
  vpc_id             = aws_vpc.vpc.id                          # --This is how refference vpc when creating your security group

  ingress {
    description      = "MYSQL/Aurora Access"                   #--Description of the ingress is doing
    from_port        = 3306                                    #--Rule Allowing secured MYSQL/Aurora Access traffic from the WebSErver
    to_port          = 3306                                    #--Rule Allowing secured MYSQL/Aurora Access traffic from the Databse
    protocol         = "tcp"                                   #--MYSQL/Aurora Access traffic uses tcp protocol
    security_groups  = ["${aws_security_group.webserver-security-group.id}"]  # --This is how refference your WebServer_SG when creating the rule to allow 
                                                                        #--traffic from the WebServer_SG to the Database
  }

  egress {
    from_port        = 0                                       #--We use 0 here to allow traffic out
    to_port          = 0                                       #--We use 0 here to allow traffic out
    protocol         = "-1"                                    #--We use -1 here to anywhere 
    cidr_blocks      = ["0.0.0.0/0"]                           #--With this we are allowing traffic out to anywhere on the internet
  }

  tags   = {
    Name             = "Database SEcurity Group"               #--Tag name for the Database_SG
  }
}
#===============================================================================================================================================
################################################################################################################################################