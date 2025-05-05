# Bufstream + dbt + BigQuery + Iceberg Demo

This repository takes from some existing repositories - [bufstream_demo](https://github.com/bufbuild/bufstream-demo) and [dbt-iceberg-poc](https://github.com/borjavb/dbt-iceberg-poc) - to create an end-to-end data flow using Bufstream, BigQuery, dbt and Apache Iceberg.

The main goal is to demonstrate an integrated data pipeline where Bufstream streams and archive event data as Iceberg Bronze tables in GCS, also enabling them for direct querying in BigQuery, and then presenting how dbt could be used to transform the data into Silver and Gold tables, also keeping storage in GCS and querying in BigQuery.
