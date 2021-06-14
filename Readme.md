


Init
    terraform init

Deploy
    terraform apply  -auto-approve


** On final prod deployment , please do not forget to un comment the static ip association :
# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.this.id
#   allocation_id = data.aws_eip.manager_ip.id
# }




** Manual Things to setup :
- ami images
- staic ip setup : creation + tagName
- DNS route53.
