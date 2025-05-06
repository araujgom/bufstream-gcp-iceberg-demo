# Bufstream + dbt + BigQuery + Iceberg Demo

This repository takes from some existing repositories - [bufstream_demo](https://github.com/bufbuild/bufstream-demo) and [dbt-iceberg-poc](https://github.com/borjavb/dbt-iceberg-poc) - to create an end-to-end sample data flow using Bufstream, BigQuery, dbt and Apache Iceberg.

The main intent of this demo is to demonstrate how Bufstream can be used to create an integrated environment where streaming data can serve both streaming consumer applications and as an optimized Bronze Layer for Analytics and Data Science workloads, also achieving more decouplement between storage and compute in a GCP environment.

### Prerequisites

- Docker
- Docker Compose
- Terraform
- Google Cloud CLI
- A Python Environment (e.g. Anaconda, venv, etc.)
- dbt Core

## Running the Demo

In order to run this demo, you should clone this repository and run the following steps:

1. Create a `.env` file in the root folder of the repository, using the `.env.example` as a template. You should set the following environment variables:
   1. `GCP_SERVICE_ACCOUNT_KEY_PATH` = path to your GCP service account key file
   2. `GCP_PROJECT_ID` = your GCP project ID
   3. `GCP_REGION` = your GCP region (e.g., `us-central1`, `europe-west1`, etc.)
   4. `GCS_BUCKET_NAME` = name of the GCS bucket to be created
   5. `BQ_DATASET_NAME` = name of the BigQuery dataset to be created
   6. `BQ_CONNECTION_ID` = name of the BigQuery connection to be created
   7. `BQ_LOCATION` = location of the BigQuery dataset (e.g., `US`, `EU`, etc.)
2. Run the `make tf-init` command to initialize the Terraform environment.
3. Run the `make tf-apply-auto` for letting Terraform create the required infrastructure in GCP, which includes a GCS bucket for storing data and some initial BigQuery configuration.
4. Run the `make docker-composer-run` command to start the Docker Compose environment, which includes our Bufstream instance, the Producer and Consumer demo applications and AKHQ for monitoring the `email-updated` topic.
5. Once the Docker Composer environment is up and running, you should apply the following configurations to the `email-updated` topic in AKHQ:
   1. `bufstream.archive.iceberg.catalog` = `gcp_iceberg`
   2. `bufstream.archive.iceberg.table` = `bronze_commerce_events.email_updated`
   3. `bufstream.archive.kind` = `ICEBERG`
6. In another terminal panel (at same base folder), you should run the `docker exec bufstream /usr/local/bin/bufstream admin clean topics` to force an topic archival process on Bufstream side, which in turn will generate topic files in Iceberg format.
7. Hopefully, at this moment you should have the `bronze_commerce_events.email_updated` table available on BigQuery side. So, to finish this demo you can export the environment variables placed in the `.env` file and go to the `dbt` folder to generate the Silver data model examples:
   1. `dbt run -m silver_email_updated`
   2. `dbt run -m silver_email_updated_incremental`
8. Once you tested all the above steps, you can run the `make tf-destroy` command to destroy all the infrastructure created in GCP. This will remove the GCS bucket and all the BigQuery resources created during the demo.
