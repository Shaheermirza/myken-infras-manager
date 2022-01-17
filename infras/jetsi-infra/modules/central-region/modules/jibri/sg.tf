# aws_security_group.jibri:
resource "aws_security_group" "jibri" {
    name        = "jibri-sg-v1--tf"
    #owner_id    = "988339190536"
    description = "jibri workers sg"
    
    egress      = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
    ingress     = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 10000
            ipv6_cidr_blocks = [
                "::/0",
            ]
            prefix_list_ids  = []
            protocol         = "udp"
            security_groups  = []
            self             = false
            to_port          = 20000
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 1935
            ipv6_cidr_blocks = [
                "::/0",
            ]
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 1935
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 4096
            ipv6_cidr_blocks = [
                "::/0",
            ]
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 4096
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 443
            ipv6_cidr_blocks = [
                "::/0",
            ]
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 443
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 5222
            ipv6_cidr_blocks = [
                "::/0",
            ]
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 5222
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 8080
            ipv6_cidr_blocks = [
                "::/0",
            ]
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 8080
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 80
            ipv6_cidr_blocks = [
                "::/0",
            ]
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 80
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 8
            ipv6_cidr_blocks = [
                "::/0",
            ]
            prefix_list_ids  = []
            protocol         = "icmp"
            security_groups  = []
            self             = false
            to_port          = -1
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 9090
            ipv6_cidr_blocks = [
                "::/0",
            ]
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 9090
        },
        {
            cidr_blocks      = [
                "196.217.20.153/32",
            ]
            description      = "Youssef Yoletech IP"
            from_port        = 22
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 22
        },
        {
            cidr_blocks      = [
                "39.52.194.214/32",
                "39.52.214.79/32",
            ]
            description      = ""
            from_port        = 22
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 22
        },
        {
            cidr_blocks      = [
                "58.65.214.19/32",
                "39.52.228.39/32",
                "39.52.223.226/32",
                "41.248.161.249/32",
                "39.52.194.214/32",
                "39.52.214.79/32",
            ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 65535
        },
    ]
    tags_all    = {}
    vpc_id      = data.aws_vpc.default.id

    timeouts {}
    tags = {
        "Name"      = "jibri-sg-v1--tf"
        //"Name"      = data.aws_ami.manager_ami.name
        "id" : "jibri-sg-v1--tf",
        "Role"      = "jibri"
        "Env"       = "prod"
        "managedBy" : "myken-infras-manger@terrafom",
    }
}