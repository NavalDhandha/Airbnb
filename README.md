# Airbnb Data Pipeline with Snowflake + dbt

## Overview
This project demonstrates an end-to-end modern analytics engineering workflow for Airbnb-style booking data using **Snowflake** and **dbt**. It is designed to show how raw operational data can be transformed into clean, business-ready datasets for analytics, reporting, and downstream decision-making.

The pipeline follows a layered data architecture:
- **Bronze layer** for raw ingestion
- **Silver layer** for cleaned and enriched transformations
- **Gold layer** for analytics-ready outputs, including both a **One Big Table (OBT)** and a **star-schema-oriented fact model**

This project highlights practical skills in:
- data warehouse design
- SQL-based ELT pipelines
- dbt model development
- incremental processing
- reusable dbt macros
- dimensional modeling
- analytics-ready data product creation

---

## Why this project matters
In most real-world analytics environments, raw source data is not immediately usable for reporting. It often contains:
- inconsistent field formats
- duplicate or unstructured values
- missing business logic
- no modeling layer for BI tools

Without a proper transformation layer, reporting becomes slow, inconsistent, and difficult to maintain.

This project solves that problem by creating a structured analytics pipeline that transforms raw booking, host, and listing data into curated datasets that can support:
- booking performance analysis
- host quality analysis
- pricing analysis
- property-level analytics
- dimensional reporting for BI dashboards

---

## Business problem
Airbnb-style platforms generate data across multiple entities such as:
- bookings
- listings
- hosts

If these entities remain separated as raw tables, analysts and business users face several challenges:
- repeated joins in every report
- inconsistent metric definitions
- poor reporting performance
- difficulty scaling analytics models
- lack of trust in raw operational data

The business needs a reliable data model that:
1. ingests raw source data into the warehouse
2. standardizes and enriches the records
3. creates analytics-ready outputs for self-service reporting
4. supports both simple exploration and dimensional BI use cases

---

## Solution
This project implements a **Snowflake + dbt ELT pipeline** that turns raw Airbnb data into curated analytical models.

### End-to-end solution flow
1. Raw source data is loaded into Snowflake staging tables.
2. dbt transforms the raw source data into **Bronze** models using incremental logic.
3. Bronze models are refined into **Silver** models with business rules and derived fields.
4. Silver models are joined into a **Gold One Big Table (OBT)** for easier exploration.
5. A downstream **Fact table** is created from the OBT to support dimensional analytics.

This approach gives flexibility for both:
- **wide-table analytics** using OBT
- **structured reporting** using fact/dimensional modeling

---

## Architecture
Based on the architecture shared for this project, the flow is:

**Source files → Snowflake staging / Bronze → dbt transformations → Silver → Gold OBT → Star-schema-oriented analytics layer**

The repo also shows:
- Snowflake DDL for core tables: `HOSTS`, `LISTINGS`, and `BOOKINGS`
- Snowflake file format + stage + `COPY INTO` loading pattern for CSV ingestion
- dbt project configuration with separate `bronze`, `silver`, and `gold` schemas
- dbt source definitions pointing to the `AIRBNB.STAGING` schema
- gold models including an `obt.sql` and `fact.sql` model. :contentReference[oaicite:1]{index=1}

---

## Tech stack
- **Snowflake** – cloud data warehouse
- **dbt** – SQL-based transformation framework
- **SQL** – transformation logic and warehouse modeling
- **GitHub** – version control and project management
- **CSV source files** – raw input data

---

## Data model layers

### Bronze layer
The Bronze layer is used for raw ingestion from source tables with incremental loading logic.

Models:
- `bronze_bookings`
- `bronze_hosts`
- `bronze_listings`

These models are configured as **incremental** and load only records with `CREATED_AT` greater than the maximum already loaded in the target table. This reduces unnecessary full refreshes and makes the pipeline more efficient. :contentReference[oaicite:2]{index=2}

### Silver layer
The Silver layer cleans and enriches the bronze data.

Models:
- `silver_bookings`
- `silver_hosts`
- `silver_listings`

Key transformations include:
- deriving `total_amount` in bookings
- standardizing host names
- classifying host response performance into rating buckets
- categorizing listing price ranges into tags such as low, medium, and high
- applying unique keys like `BOOKING_ID`, `HOST_ID`, and `LISTING_ID` for model integrity. :contentReference[oaicite:3]{index=3}

### Gold layer
The Gold layer contains business-ready analytical models.

Models:
- `obt.sql` → One Big Table combining bookings, listings, and hosts
- `fact.sql` → a fact-style model derived from the OBT

The OBT joins the silver models into a denormalized analytics table, while the fact model exposes core measures and dimensions needed for downstream reporting. :contentReference[oaicite:4]{index=4}

---

## Key transformations implemented

### 1. Incremental ingestion
The bronze models use dbt incremental materialization and filter new rows using `CREATED_AT`, which is a common pattern in scalable ELT pipelines. :contentReference[oaicite:5]{index=5}

### 2. Derived revenue logic
In `silver_bookings`, total booking value is calculated using nights booked, booking amount, cleaning fee, and service fee. A custom macro is used to calculate rounded values. :contentReference[oaicite:6]{index=6}

### 3. Host quality enrichment
In `silver_hosts`, host response rate is translated into a business-friendly rating scale such as:
- EXCELLENT
- VERY GOOD
- GOOD
- FAIR
- POOR :contentReference[oaicite:7]{index=7}

### 4. Price segmentation
In `silver_listings`, listing prices are categorized into pricing buckets using a reusable dbt macro. :contentReference[oaicite:8]{index=8}

### 5. Reusable dbt macros
The project includes custom macros such as:
- `multiply.sql`
- `tag.sql`
- `trim.sql`

This shows modular design and reusable transformation logic rather than repeating SQL patterns in multiple models. :contentReference[oaicite:9]{index=9}

### 6. One Big Table modeling
The Gold OBT combines bookings, listings, and hosts into a single denormalized model for easier analyst access and simplified exploration. :contentReference[oaicite:10]{index=10}

### 7. Fact model for reporting
The final fact table exposes analytics-friendly fields like:
- booking_id
- listing_id
- host_id
- total_amount
- accommodates
- bedrooms
- bathrooms
- price_per_night
- response_rate :contentReference[oaicite:11]{index=11}

---

## Why this solution is required
This solution is required because analytics teams need more than raw data dumps. They need a transformation layer that makes data:
- consistent
- trusted
- reusable
- performant
- business-friendly

By implementing bronze, silver, and gold layers, this project creates a cleaner separation between:
- raw ingestion
- transformation logic
- reporting-ready data products

That separation is critical in production analytics environments because it improves:
- maintainability
- data quality
- pipeline scalability
- BI usability
- analyst productivity

---

## Significance of the project
This project is significant because it demonstrates the core responsibilities of an analytics engineer / data engineer in a modern cloud stack:

- designing warehouse-ready table structures in Snowflake
- loading data from staged files into warehouse tables
- organizing dbt models by medallion architecture
- building incremental pipelines
- creating business logic with reusable macros
- modeling data for both denormalized and dimensional reporting use cases
- enabling downstream analytics with curated data models

It also reflects a practical industry pattern where organizations want both:
1. a **One Big Table** for fast exploratory analysis
2. a **fact/dimension-style structure** for scalable dashboarding

---

## Repository structure
```text
Airbnb/
│
├── Data/
├── SnowFlake/
│   ├── ddl.sql
│   └── resources.sql
│
├── dbt_airbnb/
│   ├── macros/
│   │   ├── generate_schema.sql
│   │   ├── multiply.sql
│   │   ├── tag.sql
│   │   └── trim.sql
│   │
│   ├── models/
│   │   ├── bronze/
│   │   │   ├── bronze_bookings.sql
│   │   │   ├── bronze_hosts.sql
│   │   │   ├── bronze_listings.sql
│   │   │   └── properties.yml
│   │   │
│   │   ├── silver/
│   │   │   ├── silver_bookings.sql
│   │   │   ├── silver_hosts.sql
│   │   │   └── silver_listings.sql
│   │   │
│   │   ├── gold/
│   │   │   ├── obt.sql
│   │   │   ├── fact.sql
│   │   │   └── ephemeral/
│   │   │
│   │   └── sources/
│   │       └── sources.yml
│   │
│   └── dbt_project.yml
│
└── README.md
