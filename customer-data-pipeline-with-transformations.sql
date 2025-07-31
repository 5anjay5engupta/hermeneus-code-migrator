-- dbt model: customer_source.sql
-- This model represents the source data extraction from the customer source file.
-- Assumptions: The source data is loaded into a staging table `stg_customer_source`.

{{ config(
    materialized='view',
    description='Source data extraction for customer data.',
    tags=['source', 'customer']
) }}

with customer_source as (

    select
        customer_id,
        first_name,
        last_name,
        email
    from {{ source('raw', 'customer_source') }}

)

select * from customer_source;
```

```sql
-- dbt model: customer_transformed.sql
-- This model applies transformations to the customer data.
-- Assumptions: The transformation logic is preserved from Ab Initio, with additional dbt best practices.

{{ config(
    materialized='table',
    description='Transformed customer data with additional fields.',
    tags=['transform', 'customer']
) }}

with customer_source as (

    select
        customer_id,
        first_name,
        last_name,
        email
    from {{ ref('customer_source') }}

),

customer_transformed as (

    select
        customer_id,
        first_name,
        last_name,
        email,
        first_name || ' ' || last_name as full_name,
        current_date() as processed_date,
        md5(customer_id) as customer_key
    from customer_source

)

select * from customer_transformed;
```

```sql
-- dbt model: customer_target.sql
-- This model represents the final output of the customer data processing.
-- Assumptions: The target data is written to a table `customer_dw`.

{{ config(
    materialized='table',
    description='Final target table for customer data warehouse.',
    tags=['target', 'customer']
) }}

with customer_transformed as (

    select
        customer_id,
        first_name,
        last_name,
        email,
        full_name,
        processed_date,
        customer_key
    from {{ ref('customer_transformed') }}

)

select * from customer_transformed;
```

### Additional Configuration and Documentation

```yaml
# dbt_project.yml

sources:
  - name: raw
    tables:
      - name: customer_source
        description: "Raw customer data source table"

models:
  customer:
    +schema: customer_dw
    customer_source:
      description: "Model for extracting customer source data"
    customer_transformed:
      description: "Model for transforming customer data"
    customer_target:
      description: "Model for final customer data warehouse table"
```

### Explanation

1. **Data Extraction**: The `customer_source.sql` model extracts data from a source table, which is assumed to be loaded from the original source file.
2. **Data Transformation**: The `customer_transformed.sql` model applies transformations, preserving the business logic from Ab Initio. The `md5` function is used to simulate the `hash` function for generating a unique customer key.
3. **Data Targeting**: The `customer_target.sql` model represents the final output, which is stored in the data warehouse.
4. **Configuration**: The `dbt_project.yml` file includes source and model configurations, ensuring proper documentation and lineage.
5. **Error Handling and Logging**: dbt inherently provides logging and error handling through its CLI and run results.