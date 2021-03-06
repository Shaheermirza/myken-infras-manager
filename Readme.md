# server requirements
    install terraform
    install pip : sudo apt install python-pip
    install jinja2 : pip install jinja2

# global config
    
    Add credentials file for aws :
    '''
    $ mkdir ~/.aws/
    $ vi ~/.aws/credentials 
        [myken_infras_manager] ; myken_infras_manager profile
        aws_access_key_id = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        aws_secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# case re-using same code for other project:
    rm -rf .terraform/
    rm -rf .terraform.lock.hcl

# AWS setup
    check/change setup config on ${infra}/main.tf
    S3 :
        Create bucket : 
            bucket = "infras-deploy-repo-c0"
        Create Folder on bucket for each infra ( to store the infra state change )
            key    = "infras/jetsi-infra/terraform/terraform.tfstate"
    SSH
        Create key with name meet in each region
        import existing public keys : ssh-keygen -y -f KEYPAIR.pem

    
# infra config
    change directory to specific infra that you want to deploy , for exemple : jetsi infra :
    '''
        $ cd infras/jetsi-infra

    '''
    create .auto.tfvars.json on root project path :
    ```
        {
            "config" : {
                "access_key" : "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                "secret_key" : "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                "profile" : "myken_infras_manager",
                "region"  : "ap-south-1"
            },
            "regions" : {
                "r0" : "ap-south-1",
                "r1" : "eu-west-2",
                "r2" : "ap-southeast-2"
            },
            "stateBackend" : {
                "backend" : "s3",
                "profile" : "myken_infras_manager",
                "bucket" : "infras-deploy-repo-c0",
                "key"    : "infras/jetsi-infra/terraform/terraform.tfstate",
                "region" : "ap-south-1"
            },
            "arrays" : {
                "ami_owners" : ["self","988339190536","182695311751"]
            }
        }
    ```

# clean infra
    bash action.sh clean jetsi-infra

# Init infra
    bash action.sh init jetsi-infra

# refresh infra
    bash action.sh refresh jetsi-infra

# Deploy infra
    bash action.sh deploy jetsi-infra

# Destroy infra
    bash action.sh deploy jetsi-infra



# Notes :

#### On final prod deployment , please do not forget to uncomment the static ip association :
    resource "aws_eip_association" "eip_assoc" {
        instance_id   = aws_instance.this.id
        allocation_id = data.aws_eip.manager_ip.id
    }


###  Manual Things to setup on AWS Account:
    - ami images
    - staic ip setup : creation + tagName
    - DNS route53.


### Naming requirements
    - central region :
        - Backend :
            - requirments :
                - ami : name : meetBack-v* 
                - eip : tag:Name : meetBack-ip
            - generated :
                - security_group : meetBack--tf
                - aws_instance : tag:Name : meetBack-v0--tf
        - Jibri :
            - requirments :
                - ami : id : ami-03d7a5a64a61e1807
            - generated :
                - security_group : jibri-sg-v1--tf
                - aws_launch_configuration : name : jibri-v5--tf
                - aws_autoscaling_group : name : JibriAutoScaleGroup--tf
    - multi region :
        - FrontEnd :
            - requirments :
                - ami : name : meetFront-v* 
                - eip : tag:Name : meetFront-ip
            - generated :
                - security_group : meetFront--tf
                - aws_instance : tag:Name : meetFront-v0--tf
        - jvb :
            - requirments :
                -   ami_per_region = {
                        ap-south-1 = "ami-01f26dba3a93268e3"
                        eu-west-2 = "ami-0262f3eaca3ff4402"
                        ap-southeast-2 = "ami-057d90b2321c05951"
                    }
            - generated :
                - security_group : jvb-v1--tf
                - aws_launch_configuration : name : jvb-v1--tf
                - aws_autoscaling_group : name : jvb-v1--tf
        - recorder :
            - requirments :
                - ami : name : recorder-manager-v* , web-recorder-worker-v*
                - eip : tag:Name : recorder-manager-ip
            - generated :
                - security_group : recorder-manager-v0--tf , web-recorder-workers--tf
                - aws_instance : tag:Name : recorder-manager-v0--tf , web-recorder-worker-v*

### Networking
    vpc_cidr_per_region = {
        ap-south-1 = "10.0"
        eu-west-2 = "10.1"
        ap-southeast-2 = "10.2"
        # ap-south-1 = "10.0.0.0/16"
        # eu-west-2 = "10.1.0.0/16"
        # ap-southeast-2 = "10.2.0.0/16"
    }
    private_subnets = [join("", [local.vpc_cidr_prefix,".1.0/24"]), join("", [local.vpc_cidr_prefix,".2.0/24"]), join("", [local.vpc_cidr_prefix,".3.0/24"])]
    public_subnets  = [join("", [local.vpc_cidr_prefix,".101.0/24"]), join("", [local.vpc_cidr_prefix,".102.0/24"]), join("", [local.vpc_cidr_prefix,".103.0/24"])]
