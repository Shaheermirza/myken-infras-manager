# aws_elasticache_global_replication_group.main:
resource "aws_elasticache_global_replication_group" "main" {
    actual_engine_version                = "6.0.5"
    at_rest_encryption_enabled           = false
    auth_token_enabled                   = false
    cache_node_type                      = "cache.m5.large"
    cluster_enabled                      = false
    engine                               = "redis"
    engine_version_actual                = "6.0.5"
    global_replication_group_description = "ds1"
    #global_replication_group_id          = "erpgt-ds1"
    global_replication_group_id_suffix   = "ds1"
    id                                   = "erpgt-ds1"
    primary_replication_group_id         = "redis-c1"
    transit_encryption_enabled           = false
}
# aws_elasticache_replication_group.primary:
resource "aws_elasticache_replication_group" "primary" {
    at_rest_encryption_enabled    = false
    auto_minor_version_upgrade    = true
    automatic_failover_enabled    = true
    cluster_enabled               = false
    engine                        = "redis"
    engine_version                = "6.x"
    engine_version_actual         = "6.0.5"
    global_replication_group_id   = "erpgt-ds1"
    id                            = "redis-c1"
    #maintenance_window            = "sun:18:00-sun:19:00"
    # member_clusters               = [
    #     "redis-c1-001",
    #     "redis-c1-002",
    # ]
    multi_az_enabled              = false
    node_type                     = "cache.m5.large"
    number_cache_clusters         = 2
    parameter_group_name          = "global-datastore-redis-c1srwu"
    port                          = 6379
    #primary_endpoint_address      = "redis-c1.luxohp.ng.0001.aps1.cache.amazonaws.com"
    #reader_endpoint_address       = "redis-c1-ro.luxohp.ng.0001.aps1.cache.amazonaws.com"
    replication_group_description = "redis-c1"
    replication_group_id          = "redis-c1"
    security_group_ids            = [
        "sg-077c2b0865e95d49a",
    ]
    #security_group_names          = []
    snapshot_retention_limit      = 1
    snapshot_window               = "05:00-06:00"
    subnet_group_name             = "default-subnetgroup"
    tags                          = {}
    tags_all                      = {}
    transit_encryption_enabled    = false

    cluster_mode {
        num_node_groups         = 1
        replicas_per_node_group = 1
    }

    timeouts {}
}