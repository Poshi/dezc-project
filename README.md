# Data Engineering ZoomCamp - Final project
# Victims or perpetrators of hate crimes and discrimination in Catalonia

## Introduction

For this project I chose an official dataset that contains the people involved
in hate crimes and discrimination in the region.

The data can be found at [the official government page](https://analisi.transparenciacatalunya.cat/Seguretat/V-ctimes-o-persones-autores-de-delictes-d-odi-i-di/gci6-2ubm) and is updated yearly.
Currently, it contains data for 2021->2023.
Unfortunately, 2024 data is still missing.

The problem we want to solve is being able to see where this kind of
crimes are happening, which are the most common specific crime types,
which are the trends on criminality and which
is the age profile of the victims and the agressors.

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
in the data in a time span and this is also a proper way of distribute
the records evenly thru the different partitions.
The clustering have been done by crime type, as this is a common filtering
and sorting request.

>Transformations (dbt, spark, etc)
>0 points: No tranformations
>2 points: Simple SQL transformation (no dbt or similar tools)
>4 points: Tranformations are defined with dbt, Spark or similar technologies

DBT have been used to transform the data in an easier to use,
better distilled, dataset for easy visualization in the dashboard.
The transformations include tyding up transformations, because some fields
are not normalized, and aggregations, for quick representation in the
dashboard.

>Dashboard
>0 points: No dashboard
>2 points: A dashboard with 1 tile
>4 points: A dashboard with 2 tiles

A dashboard with several tiles have been generated to be able to
navigate the data easily. There are

* a bar graph showing victims and aggressors by sex
* a pie graph showing the kinds of crime
* a pie graph showing the ciries where the crimes habe been commited
* a line graph showing how the age of the aggressors and the victims have been cha ging over time

>Reproducibility
>0 points: No instructions how to run the code at all
>2 points: Some instructions are there, but they are not complete
>4 points: Instructions are clear, it's easy to run the code, and the code works

Finally, I hope that this document is good enough to run and
reproduce all the calculus I've been doing here.

## Usage instructions

### Set up

You need to start by forking/cloning the repository.
You also need to have your GCP crecentials in a file called `~/.gcp/gcp_keys.json`.
The `jq` utility must be present and available in your `PATH`.
`terraform`, `docker compose` and `curl` are also required.

Once you have all the previous requisites, you can simply start the setup script:

```
./setup.sh init
```

This script will perform several actions automatically:

* extract the project ID from your credentials file and use it to name the resources
* initialize Terraform and provision the resources
* generate the obuscated and clear text environment files for Kestra
* start Kestra
* upload the flow to Kestra
* start backfill runs for the period since the first data record (2021) to the current year.

Up to this point, we will have the data in BigQuery, ready for being processed by DBT.
But please, make sure everything ran properly, the flow was uploaded, the backfill was
executed and the data appears in BigQuery.

For DBT, you need to create the DBT project, connect to your forked repository and
modify `models/staging/schema.yml` to point to the created resources.
For that, you need to change the lines
```
sources:
  - name: staging
    database: "{{ env_var('DBT_DATABASE', 'molten-smithy-453622-n8') }}"
    schema: "{{ env_var('DBT_SCHEMA', 'dezc_project_dataset') }}"
```
to your names for `database` and `schema`.
The database is the name of your project.
It can be found in your GCP credentials file.
And the schema is constructed as:
`dezc_dataset_${project//-/_}`
That is: "dezc_dataset_" followed by the name of the project where all dashes (-)
have been substituted by underscores (_).

Once done, run `dbt build`.

The last step is to create the visualization.
Unfortunately, there is no code I can show you here, as all the configuration have
been done manually in the graphical interface.
You can see the final result at https://lookerstudio.google.com/s/je4xd0W-qEA

I'd love to be able to specify the dashboard using code, so I could push it into
a source control repository, but this is currently not possible.

### Tear down

To remove all the GCP resources generated, just run
```
./setup.sh destroy
```

---

I hope all this is enough for anyone to reproduce my outcome.
Don't hesitate to ask any questions by opening an issue. I'll be happy to help.