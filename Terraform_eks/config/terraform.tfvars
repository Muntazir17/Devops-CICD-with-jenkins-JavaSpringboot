region = "us-east-1"


vpc_config = {
    "vpc01" = {
        vpc_cidr_block = "192.168.0.0/16"
        tags = {
            "Name" = "my_vpc"
        }
    }
} 

subnet_config = {
    "public-us-east-1a" = {
        vpc_name = "vpc01"
        cidr_block = "192.168.0.0/18"
        availability_zone = "us-east-1a"
        tags = {
            "Name" = "public-us-east-1a"
        }
    }
    "public-us-east-1b" = {
        vpc_name = "vpc01"
        cidr_block = "192.168.64.0/18"
        availability_zone = "us-east-1b"
        tags = {
            "Name" = "public-us-east-1b"
        }
    }
    "private-us-east-1a" = {
        vpc_name = "vpc01"
        cidr_block = "192.168.128.0/18"
        availability_zone = "us-east-1a"
        tags = {
            "Name" = "private-us-east-1a"
        }
    }
    "private-us-east-1b" = {
        vpc_name = "vpc01"
        cidr_block = "192.168.192.0/18"
        availability_zone = "us-east-1b"
        tags = {
            "Name" = "private-us-east-1b"
        }
    }
}


internet_GW_config = {

    igw01 = {
        vpc_name = "vpc01"

        tags = {
            "Name" = "My_IGW"
        }
    }
}
elastic_IP_config = {

    eip01 = {
        tags = {
            "Name" = "nat01"
        }
    }
    eip02 = {
        tags = {
            "Name" = "nat02"
        }
    }

}
nat_GW_config = {
    natgw01 = {

        eip_name = "eip01"
        subnet_name = "public-us-east-1a"
        tags = {
            "Name" = "natgw01"
        }
    }   
    natgw02 = {

        eip_name = "eip02"
        subnet_name = "public-us-east-1b"
        tags = {
            "Name" = "natgw02"
        }        
    }
}
aws_route_table_config = {

    RT01 = {
        private = 0
        vpc_name = "vpc01"

        gateway_name = "igw01"
        
        tags = {

            "Name" = "Public-Route"
        
        }
    }
    RT02 = {
        private = 1
        vpc_name = "vpc01"

        gateway_name = "natgw01"
        
        tags = {

            "Name" = "private-Route"
        
        }
       
    }
    RT03 = {
        private = 1

        vpc_name = "vpc01"
        
        gateway_name = "natgw02"
        
        tags = {

            "Name" = "private-Route"
        
        }
    }

}
aws_route_table_association_config = {
    RT01Assoc = {
        subnet_name = "public-us-east-1a"
        route_table_name = "RT01"
        
    }
    RT02Assoc = {
        subnet_name = "public-us-east-1b"
        route_table_name = "RT01"

    }
    RT03Assoc = {
        subnet_name = "private-us-east-1a"
        route_table_name = "RT02"

    }
    RT04Assoc = {
        subnet_name = "private-us-east-1b"
        route_table_name = "RT02"

    }
}

aws_eks_cluster_config = {
    "demo-cluster" = {
        eks_cluster_name = "demo-cluster"

        subnet1 = "public-us-east-1a"
        subnet2 = "public-us-east-1b"
        subnet3 = "private-us-east-1a"
        subnet4 = "private-us-east-1b"

        tags = {
            "Name" = "Demo-cluster"
        }
    }
}
aws_eks_node_group_config = {


    "node1" = {
        node_group_name = "node1"

        eks_cluster_name = "demo-cluster"

        node_iam_role = "eks-node-general1"

        subnet1 = "private-us-east-1a"
        subnet2 = "private-us-east-1b"

        tags = {
            "Name" = "node1"
        }
    }
    "node2" = {
        node_group_name = "node2"
        eks_cluster_name = "demo-cluster"

        node_iam_role = "eks-node-general2"

        subnet1 = "private-us-east-1a"
        subnet2 = "private-us-east-1b"
        tags = {
            "Name" = "node2"
        }
    }



}