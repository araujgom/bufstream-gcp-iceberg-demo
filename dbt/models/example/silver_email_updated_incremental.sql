{{ config(
    materialized='incremental',
    unique_key='event_id',
    incremental_strategy='merge',
    table_format='iceberg',
    storage_uri='gs://bufstream-gcs-iceberg-demo-gcs',
    storage_sub_path='silver/email_updated_incremental',
    cluster_by=['old_email_address'],
    tags=['dbt_iceberg_table']
) }}

with source_data as (
    select
        val.id AS event_id,
        kafka.event_timestamp,
        kafka.ingest_timestamp AS bronze_ingestion_timestamp,
        CURRENT_TIMESTAMP() AS table_ingestion_timestamp,
        val.old_email_address,
        val.new_email_address
    from {{ source('bronze_data', 'email_updated') }}
    {% if is_incremental() %}
      where kafka.event_timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 2 DAY)
    {% endif %}
)

select * from source_data