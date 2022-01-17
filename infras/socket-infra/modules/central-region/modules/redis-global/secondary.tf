# aws_elasticache_replication_group.secondary:
resource "aws_elasticache_replication_group" "secondary" {
    arn                           = "arn:aws:elasticache:eu-west-2:988339190536:replicationgroup:redis-c1-a"
    at_rest_encryption_enabled    = false
    auto_minor_version_upgrade    = true
    automatic_failover_enabled    = true
    cluster_enabled               = false
    engine                        = "redis"
    engine_version                = "6.x"
    engine_version_actual         = "6.0.5"
    global_replication_group_id   = "erpgt-ds1"
    id                            = "redis-c1-a"
    maintenance_window            = "fri:00:30-fri:01:30"
    member_clusters               = [
        "redis-c1-a-001",
        "redis-c1-a-002",
    ]
    multi_az_enabled              = true
    node_type                     = "cache.m5.large"
    number_cache_clusters         = 2
    parameter_group_name          = "global-datastore-redis-c1-ajkza"
    port                          = 6379
    primary_endpoint_address      = "redis-c1-a.o3beft.ng.0001.euw2.cache.amazonaws.com"
    reader_endpoint_address       = "redis-c1-a-ro.o3beft.ng.0001.euw2.cache.amazonaws.com"
    replication_group_description = "redis-c1-a"
    replication_group_id          = "redis-c1-a"
    security_group_ids            = [
        "sg-d7f854ba",
    ]
    security_group_names          = []
    snapshot_retention_limit      = 0
    snapshot_window               = "02:00-03:00"
    subnet_group_name             = "default-group"
    tags                          = {}
    tags_all                      = {}
    transit_encryption_enabled    = false

    cluster_mode {
        num_node_groups         = 1
        replicas_per_node_group = 1
    }

    timeouts {}
}