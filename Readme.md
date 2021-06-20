

# config
    create .auto.tfvars.json on root project path :
    ````
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
            }
        }
    ````
# Init
    terraform init

# Deploy
    terraform apply  -auto-approve


## On final prod deployment , please do not forget to un comment the static ip association :
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.this.id
  allocation_id = data.aws_eip.manager_ip.id
}




##  Manual Things to setup :
- ami images
- staic ip setup : creation + tagName
- DNS route53.
