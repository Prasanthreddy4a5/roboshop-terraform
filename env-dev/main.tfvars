#Common Variables


default_vpc_id             = "vpc-0066015daedfe34fe"
default_vpc_cidr           = "172.31.0.0/16"
default_vpc_route_table_id = "rtb-04964fb7eac12e9a2"
env                        = "dev"
ssh_ingress_cidr           = ["172.31.88.94/32"]                           #(This is workstation IP address CIDR)
#The CIDR block 172.31.20.57/32 represents a single IP address, as indicated by the subnet mask of /32. This IP address is used to define the source or destination in networking rules, such as security group ingress or egress rules.

#In the context of an EC2 instance, if you have an instance with the CIDR block set to ["172.31.20.57/32"], it means that the instance can be identified by the IP address 172.31.20.57. The /32 indicates that only this specific IP address is included in the CIDR block.
zone_id                    = "Z011613123HK78BRRY0DI"
monitoring_ingress_cidr    =



#VPC Module
vpc = {
  main = {
    cidr    = "10.0.0.0/16"
    subnets = {
      public = {
        public1 = { cidr = "10.0.0.0/24", az = "us-east-1a" }
        public2 = { cidr = "10.0.1.0/24", az = "us-east-1b" }
      }
      app = {
        app1 = { cidr = "10.0.2.0/24", az = "us-east-1a" }
        app2 = { cidr = "10.0.3.0/24", az = "us-east-1b" }
      }

      db = {
        db1 = { cidr = "10.0.4.0/24", az = "us-east-1a" }
        db2 = { cidr = "10.0.5.0/24", az = "us-east-1b" }
      }
    }
  }
}
# Tagging
tags = {
  company_name  = "Prash Tech_DevopS"
  business_unit = "Ecommerce"
  project_name  = "Prash Robotshop"
  cost_center   = "IT"
  created_by    = "terraform"
}

#Application Load Balancer Module

alb = {
  public = {
    internal = false
    lb_type  = "application"
    sg_ingress_cidr = ["0.0.0.0/0"]
    sg_port = 80

  }

  private = {
    internal = true
    lb_type  = "application"
    sg_ingress_cidr = ["172.31.0.0/16", "10.0.0.0/16"]
    sg_port = 80
  }

}

#docdb Module
docdb = {
  main = {
    backup_retention_period  = 5
    preferred_backup_window = "07:00-09:00"
    skip_final_snapshot     = true
    engine_version          = "4.0.0"
    engine_family           = "docdb4.0"
    instance_count          =  1
    instance_class          = "db.t3.medium"
  }
}

#rds Module
rds = {
  main = {
    rds_type                = "mysql"
    db_port                 = 3306
    engine_family           = "aurora-mysql5.7"
    engine                  = "aurora-mysql"
    engine_version          = "5.7.mysql_aurora.2.11.3"
    backup_retention_period = 5
    preferred_backup_window = "07:00-09:00"
    skip_final_snapshot     = true
    instance_count          = 1
    instance_class          = "db.t3.small"
  }
}

#docdb Module
elasticache = {
  main = {
    elasticache_type = "redis"
    family           = "redis6.x"
    port             = 6379
    engine           = "redis"
    node_type        = "cache.t3.micro"
    num_cache_nodes  = 1
    engine_version   = "6.2"
  }
}

#rabbitmq Module
rabbitmq = {
  main = {
    instance_type = "t3.small"
  }
}



#App module
apps = {
  frontend = {
    instance_type    = "t3.micro"
    port             = 80
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    lb_priority      = 1
    lb_type          = "public"
    parameters       = []
    tags             = { Monitor_Nginx = "yes" }
  }
  catalogue = {
    instance_type    = "t3.micro"
    port             = 8080
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    lb_priority      = 2
    lb_type          = "private"
    parameters       = ["docdb"]
    tags             = {}
  }
  user = {
    instance_type    = "t3.micro"
    port             = 8080
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    lb_priority      = 3
    lb_type          = "private"
    parameters       = ["docdb"]
    tags             = {}
  }
  cart = {
    instance_type    = "t3.micro"
    port             = 8080
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    lb_priority      = 4
    lb_type          = "private"
    parameters       = []
    tags             = {}
  }
  payment = {
    instance_type    = "t3.micro"
    port             = 8080
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    lb_priority      = 5
    lb_type          = "private"
    parameters       = ["rabbitmq"]
    tags             = {}
  }
  shipping = {
    instance_type    = "t3.micro"
    port             = 8080
    desired_capacity = 1
    max_size         = 3
    min_size         = 1
    lb_priority      = 6
    lb_type          = "private"
    parameters       = ["rds"]
    tags             = {}
  }
}











#default_vpc_id             = "vpc-0066015daedfe34fe"
#default_vpc_cidr           = "172.31.0.0/16"
#default_vpc_route_table_id = "rtb-04964fb7eac12e9a2"
#zone_id                    = "Z0021413JFIQEJP9ZO9Z"
#env                        = "dev"
#ssh_ingress_cidr           = ["172.31.85.208/32"]
#monitoring_ingress_cidr    = ["172.31.91.26/32"]
#
#tags = {
#  company_name  = "ABC Tech"
#  business_unit = "Ecommerce"
#  project_name  = "Prash robotshop"
#  cost_center   = "ecom_rs"
#  created_by    = "terraform"
#}
#
#vpc = {
#  main = {
#    cidr = "10.0.0.0/16"
#    subnets = {
#      public = {
#        public1 = { cidr = "10.0.0.0/24", az = "us-east-1a" }
#        public2 = { cidr = "10.0.1.0/24", az = "us-east-1b" }
#      }
#      app = {
#        app1 = { cidr = "10.0.2.0/24", az = "us-east-1a" }
#        app2 = { cidr = "10.0.3.0/24", az = "us-east-1b" }
#      }
#      db = {
#        db1 = { cidr = "10.0.4.0/24", az = "us-east-1a" }
#        db2 = { cidr = "10.0.5.0/24", az = "us-east-1b" }
#      }
#    }
#  }
#}
#
#alb = {
#  public = {
#    internal        = false
#    lb_type         = "application"
#    sg_ingress_cidr = ["0.0.0.0/0"]
#    sg_port         = 80
#  }
#
#  private = {
#    internal        = true
#    lb_type         = "application"
#    sg_ingress_cidr = ["172.31.0.0/16", "10.0.0.0/16"]
#    sg_port         = 80
#  }
#}
#
#docdb = {
#  main = {
#    backup_retention_period = 5
#    preferred_backup_window = "07:00-09:00"
#    skip_final_snapshot     = true
#    engine_version          = "4.0.0"
#    engine_family           = "docdb4.0"
#    instance_count          = 1
#    instance_class          = "db.t3.medium"
#  }
#}
#
#rds = {
#  main = {
#    rds_type                = "mysql"
#    db_port                 = 3306
#    engine_family           = "aurora-mysql5.7"
#    engine                  = "aurora-mysql"
#    engine_version          = "5.7.mysql_aurora.2.11.3"
#    backup_retention_period = 5
#    preferred_backup_window = "07:00-09:00"
#    skip_final_snapshot     = true
#    instance_count          = 1
#    instance_class          = "db.t3.small"
#  }
#}
#
#elasticache = {
#  main = {
#    elasticache_type = "redis"
#    family           = "redis6.x"
#    port             = 6379
#    engine           = "redis"
#    node_type        = "cache.t3.micro"
#    num_cache_nodes  = 1
#    engine_version   = "6.2"
#  }
#}
#
#rabbitmq = {
#  main = {
#    instance_type = "t3.small"
#  }
#}
#
#apps = {
#  frontend = {
#    instance_type    = "t3.micro"
#    port             = 80
#    desired_capacity = 1
#    max_size         = 3
#    min_size         = 1
#    lb_priority      = 1
#    lb_type          = "public"
#    parameters       = []
#    tags             = { Monitor_Nginx = "yes" }
#  }
#  catalogue = {
#    instance_type    = "t3.micro"
#    port             = 8080
#    desired_capacity = 1
#    max_size         = 3
#    min_size         = 1
#    lb_priority      = 2
#    lb_type          = "private"
#    parameters       = ["docdb"]
#    tags             = {}
#  }
#  user = {
#    instance_type    = "t3.micro"
#    port             = 8080
#    desired_capacity = 1
#    max_size         = 3
#    min_size         = 1
#    lb_priority      = 3
#    lb_type          = "private"
#    parameters       = ["docdb"]
#    tags             = {}
#  }
#  cart = {
#    instance_type    = "t3.micro"
#    port             = 8080
#    desired_capacity = 1
#    max_size         = 3
#    min_size         = 1
#    lb_priority      = 4
#    lb_type          = "private"
#    parameters       = []
#    tags             = {}
#  }
#  payment = {
#    instance_type    = "t3.micro"
#    port             = 8080
#    desired_capacity = 1
#    max_size         = 3
#    min_size         = 1
#    lb_priority      = 5
#    lb_type          = "private"
#    parameters       = ["rabbitmq"]
#    tags             = {}
#  }
#  shipping = {
#    instance_type    = "t3.micro"
#    port             = 8080
#    desired_capacity = 1
#    max_size         = 3
#    min_size         = 1
#    lb_priority      = 6
#    lb_type          = "private"
#    parameters       = ["rds"]
#    tags             = {}
#  }
#}
