# Data Engineering ZoomCamp - Final project
# Victims or perpetrators of hate crimes and discrimination in Catalonia

## Introduction

For this project I chose an official dataset that contains the people involved
in hate crimes and discrimination in the region.

The data can be found at [the official government page](https://analisi.transparenciacatalunya.cat/Seguretat/V-ctimes-o-persones-autores-de-delictes-d-odi-i-di/gci6-2ubm) and is updated yearly.

The problem we want to solve is being able to see where this kind of
crimes are happening, which are the trends on criminality and which
is the profile of the victims and the agressors.

## Scoring

There are several points we have to cover to get a high score.

>Problem description
>0 points: Problem is not described
>2 points: Problem is described but shortly or not clearly
>4 points: Problem is well described and it's clear what the problem the project solves

This is what the introductory part of the document is for.

>Cloud
>0 points: Cloud is not used, things run only locally
>2 points: The project is developed in the cloud
>4 points: The project is developed in the cloud and IaC tools are used

The project have been developed in the cloud using Terraform to create
the resources needed.
Terraform could had been integrated into Kestra, but it have been decided that it would be
clearer to have it independent and running by itself.

>Batch / Workflow orchestration
>0 points: No workflow orchestration
>2 points: Partial workflow orchestration: some steps are orchestrated, some run manually
>4 points: End-to-end pipeline: multiple steps in the DAG, uploading data to data lake

Kestra have been used to retrieve the information periodically and
uploading it to the cloud. To a GCP bucket, to be precise.
Several steps have been added to the workflow:

- Querying the API
- Uploading the query results to a GCP bucket
- Creating the corresponding table in BigQuery
- Creating the main table in BigQuery
- Copying the data from GCP bucket to BigQuery with new fields:
  - a deduplication field
  - a date field for proper partition
- Merging the table (without duplicates) into a main table
- Removing no longer needed data in parallel:
  - file in the bucket
  - external table
  - enriched table
  - Kestra internal files

All these steps have been performed in parallel in all the places that made sense.

>Data warehouse
>0 points: No DWH is used
>2 points: Tables are created in DWH, but not optimized
>4 points: Tables are partitioned and clustered in a way that makes sense for the upstream queries (with explanation)

BigQuery have been used as the DataWarehouse where to store the data.
They have been partitioned and clustered according to the
posterior queries.

The partition have been done by date, as we usually are interested
in the data in a time span.
The clustering have been done by city, as this is a common sorting
request.

>Transformations (dbt, spark, etc)
>0 points: No tranformations
>2 points: Simple SQL transformation (no dbt or similar tools)
>4 points: Tranformations are defined with dbt, Spark or similar technologies

DBT have been used to transform the data in an easier to use,
better distilled, dataset for easy visualization in the dashboard.

>Dashboard
>0 points: No dashboard
>2 points: A dashboard with 1 tile
>4 points: A dashboard with 2 tiles

A dashboard with several tiles have been generated to be able to
navigate the data easily.

>Reproducibility
>0 points: No instructions how to run the code at all
>2 points: Some instructions are there, but they are not complete
>4 points: Instructions are clear, it's easy to run the code, and the code works

Finally, I hope that this document is good enough to run and
reproduce all the calculus I've been doing here.
