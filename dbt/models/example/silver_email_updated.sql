{{ config(
    materialized='table',
    unique_key='event_id',
    table_format='iceberg',
    storage_uri='gs://bufstream-gcs-iceberg-demo-gcs',
    storage_sub_path='silver/email_updated',
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
)

select * from source_data