resource "aws_elasticache_cluster" "default" {
    cluster_id           = "websocket-cluster-c1"
    engine               = "redis"
    node_type            = "cache.t2.micro"
    num_cache_nodes      = 1
    parameter_group_name = "default.redis6.x"
    engine_version       = "6.0.5"
    port                 = 6379
}

# data "aws_elasticache_cluster" "default" {

#   filter {
#     name   = "tag:Name"
#     values = ["websocket-cluster-c1"]
#   }
# }
# output "aws_elasticache_clusterd" {
#   value = data.aws_elasticache_cluster.default
# }
# resource "aws_route53_record" "www" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "redis.internal.websocket.mykenshomedia.com.au"
#   type    = "CNAME"
#   ttl     = "300"
#   records = [aws_eip.lb.public_ip]
# }