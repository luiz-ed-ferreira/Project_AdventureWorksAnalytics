# Staging Layer

## Overview

The staging layer is the first transformation layer of the Adventure Works Analytics project.

Its purpose is to standardize source data from the `fea_academy.adventure_works` schema while preserving the original source grain and business information.

The layer is implemented using dbt models materialized as Databricks views.

The transformations focus on:

- Standardizing column names using snake_case.
- Renaming columns to improve readability and consistency.
- Casting source fields to appropriate data types.
- Excluding unnecessary or sensitive attributes.
- Preserving source records and relevant NULL values.
- Applying data quality tests and documenting model columns.

## Model Inventory

The staging layer contains 16 models organized into three business domains.

### Sales

| Model | Description |
|---|---|
| `stg_sales__sales_order_header` | Sales order header attributes, dates, customer, salesperson, addresses, and financial amounts. |
| `stg_sales__sales_order_detail` | Sales order line items, quantities, products, prices, and discounts. |
| `stg_sales__sales_reason` | Sales reason descriptions and classifications. |
| `stg_sales__sales_order_header_sales_reason` | Association between sales orders and sales reasons. |
| `stg_sales__customer` | Customer identifiers and person/store associations. |
| `stg_sales__credit_card` | Credit card reference data containing identifiers and card types. |
| `stg_sales__sales_person` | Salesperson identifiers, territory, quotas, bonuses, and sales performance attributes. |
| `stg_sales__store` | Store identifiers, names, and associated salesperson references. |

### Person

| Model | Description |
|---|---|
| `stg_person__person` | Individual and employee identification attributes. |
| `stg_person__employee` | Employee identifiers, job titles, hiring dates, and employment status indicators. |
| `stg_person__address` | Address, city, state reference, and postal code. |
| `stg_person__state_province` | State and province information and country associations. |
| `stg_person__country_region` | Country and region reference data. |

### Production

| Model | Description |
|---|---|
| `stg_production__product` | Product identification, classification, pricing, manufacturing, and lifecycle attributes. |
| `stg_production__product_subcategory` | Product subcategory reference data and category association. |
| `stg_production__product_category` | Product category reference data. |

## Data Standardization

The staging models apply consistent naming and data type conventions.

Examples include:

| Source Data | Staging Data Type |
|---|---|
| Identifiers | BIGINT |
| Quantities and integer attributes | INT |
| Business dates | DATE |
| Modification timestamps | TIMESTAMP |
| Financial amounts | DECIMAL(19,4) |
| Flags | BOOLEAN |
| Text attributes | STRING |

Source column names are translated into descriptive snake_case names to improve consistency across downstream transformations.

## Data Quality and Validation

The staging layer was validated through source-to-staging comparisons and dbt data tests.

The validation process covered:

- Record count preservation.
- Primary key uniqueness.
- Mandatory field completeness.
- Referential integrity between related entities.
- Data type standardization.
- Preservation of relevant source NULL values.

The following relationships are tested:

| Child Model | Foreign Key | Parent Model |
|---|---|---|
| `stg_person__address` | `state_province_id` | `stg_person__state_province` |
| `stg_person__state_province` | `country_region_code` | `stg_person__country_region` |
| `stg_production__product` | `product_subcategory_id` | `stg_production__product_subcategory` |
| `stg_production__product_subcategory` | `product_category_id` | `stg_production__product_category` |
| `stg_sales__sales_order_header_sales_reason` | `sales_reason_id` | `stg_sales__sales_reason` |

All five registered relationship tests passed.

The `stg_sales__store` model was also validated through model-specific dbt tests and data integrity checks. Its 701 records have unique, non-null store identifiers and non-null store names and salesperson references.

The `stg_person__employee` model was validated through model-specific dbt tests. Its 290 records have unique, non-null employee identifiers and non-null job titles.

## Important Modeling and Data Quality Decisions

### Customer Representation

Customer records may be associated with an individual, a store, or both.

The staging model preserves `person_id` and `store_id` independently instead of collapsing these relationships.

The `stg_sales__store` model provides the store attributes required for downstream customer integration.

### Employee and Salesperson Representation

Employee and salesperson information is maintained in separate staging models.

The `stg_person__employee` model provides employment attributes from `humanresources_employee`, while `stg_sales__sales_person` contains sales-specific information.

Both entities share the `business_entity_id` identifier, which supports their integration with person records in downstream transformations.

### Credit Card Data Minimization

The staging model retains only the credit card identifier and card type.

Card numbers and expiration attributes are intentionally excluded because they are not required by the analytical requirements.

### Missing Country Code

One source country record, Namibia, has a NULL `countryregioncode`.

The staging model applies a specific correction, assigning `NA` to Namibia's `country_region_code`. This corresponds to Namibia's ISO 3166-1 alpha-2 country code.

The correction is applied in the staging transformation without modifying the source data.

### Product Discontinuation Date

All 504 product records have a NULL `discontinueddate` in the source.

The staging model retains `discontinued_date` as a DATE column with NULL values.

### Sales Order Status

All analyzed sales orders have status code 5.

The original status code is preserved without introducing an unvalidated status description.

### Sales Reasons

Sales orders and sales reasons have a many-to-many relationship.

The association is preserved in `stg_sales__sales_order_header_sales_reason`, avoiding premature denormalization and potential duplication of transactional measures.

### Optional Source Attributes

Missing salesperson, purchase order, credit card, currency rate, and other optional attributes are preserved as NULL values where applicable.

## Layer Completion

The staging layer contains 16 dbt models:

- 8 Sales models.
- 5 Person models.
- 3 Production models.

All 16 models were successfully materialized as Databricks views. Model-specific data tests and the five registered relationship tests were executed successfully.

The staging layer is now ready to support the next transformation layer: Intermediate.