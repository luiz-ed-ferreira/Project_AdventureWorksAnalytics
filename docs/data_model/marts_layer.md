# Marts Layer

## Purpose and Architecture

The Marts layer contains the dimensional models designed to support business intelligence, analytical reporting, and decision-making.

It follows a dimensional modeling approach, organizing data into fact, dimension, and bridge tables. The models are materialized as Delta tables in Databricks and built using dbt.

The layer currently contains 10 models:

- 1 fact table
- 8 dimension tables
- 1 bridge table

## Fact Table

### fact_sales

- **Purpose:** Stores sales transaction data for analytical queries and business performance monitoring.
- **Source:** `int_sales__order_details`
- **Grain:** One row per sales order detail, identified by `sales_order_id` and `sales_order_detail_id`.

The fact table contains sales quantities, unit prices, discounts, gross sales, and net sales, along with foreign keys to the related dimensions.

It also includes order attributes such as order status, online order indicator, shipping method, and special offer.

Order-level financial metrics, such as subtotal, tax, freight, and total due, are not included in this item-level fact table to prevent double counting.

## Dimension Tables

### dim_date

- **Purpose:** Provides calendar attributes for time-based analysis.
- **Source:** Generated date range.
- **Grain:** One row per calendar date.

Includes year, quarter, month, day, week, weekday, and weekend indicators. It supports three date roles: order date, due date, and ship date.

### dim_product

- **Purpose:** Provides product attributes for sales analysis.
- **Source:** `int_sales__product`
- **Grain:** One row per product.

Includes product name, number, category, subcategory, model, color, size, pricing, manufacturing attributes, and product lifecycle dates.

### dim_customer

- **Purpose:** Provides customer information for customer segmentation and sales analysis.
- **Source:** `int_sales__customer`
- **Grain:** One row per customer.

Integrates person and store attributes while preserving person-only, store-only, and combined customer records.

### dim_geography

- **Purpose:** Provides geographic attributes for analyzing sales by location.
- **Source:** `int_sales__geography`
- **Grain:** One row per address.

Includes address, city, postal code, state/province, and country attributes.

The dimension is used in two roles in `fact_sales`: bill-to geography and ship-to geography.

### dim_credit_card

- **Purpose:** Provides credit card classification attributes for payment analysis.
- **Source:** `int_sales__credit_card`
- **Grain:** One row per credit card.

Includes credit card type and modification timestamp. Sensitive card details, such as card number and expiration date, are excluded.

### dim_salesperson

- **Purpose:** Provides salesperson and employee attributes for sales performance analysis.
- **Source:** `int_sales__salesperson`
- **Grain:** One row per salesperson.

Includes employee identification, job title, hire date, current status, sales quota, bonus, commission, and sales performance attributes.

### dim_sales_territory

- **Purpose:** Provides commercial territory attributes for regional sales analysis.
- **Source:** `int_sales__sales_territory`
- **Grain:** One row per sales territory.

Includes territory name, country, group, and historical sales and cost metrics.

### dim_sales_reason

- **Purpose:** Provides sales reason classifications for analyzing the motivations behind sales orders.
- **Source:** `stg_sales__sales_reason`
- **Grain:** One row per sales reason.

Includes reason name, reason type, and modification timestamp.

## Bridge Table

### bridge_order_sales_reason

- **Purpose:** Resolves the many-to-many relationship between sales orders and sales reasons.
- **Source:** `int_sales__order_reasons`, joined with `dim_sales_reason`.
- **Grain:** One row per sales order and sales reason combination.

The bridge preserves the relationship between orders and their associated reasons without duplicating sales measures in the fact table.

## Data Quality and Validation

All 10 models were successfully materialized and validated using dbt tests and SQL reconciliation queries.

Key validation rules include:

- Primary and surrogate keys are checked for uniqueness and null values where applicable.
- Foreign key relationships are validated against their respective dimensions.
- Composite key uniqueness is enforced through custom singular tests in the bridge and fact tables.
- Legitimate null values in credit card and salesperson relationships are preserved according to source data.
- Sales quantities and financial measures are reconciled against the Intermediate layer and original order header metrics.

A residual difference of USD 0.0167 was identified between aggregated net sales at order detail level and the order header subtotal. This negligible variance is attributed to rounding and decimal precision differences. Original source values are preserved without artificial adjustments.