# Intermediate Layer

## Overview

The Intermediate layer integrates and enriches standardized data from the Staging layer, preparing it for dimensional modeling and business analysis.

Its main responsibilities are:

- Combining related staging models.
- Establishing consistent business entities and relationships.
- Applying reusable business logic.
- Preparing reliable datasets for the Marts layer.
- Preserving data granularity to prevent metric duplication.

Intermediate models are materialized as views.

## Model Inventory

| Model | Description | Grain |
|---|---|---|
| `int_sales__order_details` | Integrates sales order details with sales order header attributes and calculates financial measures. | One row per sales order detail. |

## Model: int_sales__order_details

### Purpose

Integrates sales order detail records with their corresponding sales order header information.

The model provides a consolidated dataset containing order-level attributes and item-level measures, serving as the foundation for the sales fact table.

### Source Models

- `stg_sales__sales_order_detail`
- `stg_sales__sales_order_header`

### Grain

One row per sales order detail.

The combination of `sales_order_id` and `sales_order_detail_id` identifies each sales order item.

### Key Attributes

The model includes:

- Sales order identifiers and dates.
- Order status and online order indicator.
- Customer, salesperson, and territory identifiers.
- Billing and shipping address identifiers.
- Shipping method and credit card identifiers.
- Product and special offer identifiers.
- Order quantity, unit price, and discount rate.
- Financial measures.
- Source modification timestamps.

### Financial Measures

The model calculates three item-level financial measures:

Gross Sales:

`unit_price * order_quantity`

Discount Amount:

`unit_price * order_quantity * unit_price_discount`

Net Sales:

`gross_sales_amount - discount_amount`

Gross sales and discount amounts are individually cast to `DECIMAL(19,4)`. Net sales is calculated by subtracting these already-rounded values, ensuring consistency between the three measures at the item level.

### Modeling Decisions

#### Sales Order Header Measures

Header-level measures such as subtotal, tax, freight, and total due are intentionally excluded from this item-level model.

Repeating these values across order detail records would cause duplication when aggregating financial measures.

These attributes will be handled separately when designing the dimensional model and its reporting logic.

#### Sales Reasons

The many-to-many relationship between sales orders and sales reasons is not incorporated into this model.

It will be handled separately to prevent duplication of order detail records and financial measures.

#### Data Types and Precision

Financial measures use `DECIMAL(19,4)` to preserve decimal precision during calculations and aggregation.

Order dates and modification timestamps retain their standardized types from the Staging layer.

## Data Quality and Validation

The model was successfully executed using dbt.

The following validations were completed:

| Validation | Result |
|---|---|
| Total records | 121,317 |
| Distinct sales order details | 121,317 |
| Distinct sales orders | 31,465 |
| Null sales order IDs | 0 |
| Null sales order detail IDs | 0 |
| Null product IDs | 0 |
| Total quantity sold | 274,914 |
| Duplicate order detail records | 0 |
| dbt model tests | Passed |
| Referential integrity tests | Passed |

The model preserves the expected grain and contains no duplicate sales order detail records.

## Financial Reconciliation

Annual financial measures were validated against the source data.

| Year | Orders | Gross Sales | Discounts | Net Sales |
|---|---:|---:|---:|---:|
| 2011 | 1,607 | 12,646,112.1607 | 4,439.9480 | 12,641,672.2127 |
| 2012 | 3,915 | 33,710,896.9379 | 186,595.6156 | 33,524,301.3223 |
| 2013 | 14,182 | 43,922,050.7113 | 299,571.6703 | 43,622,479.0410 |
| 2014 | 11,761 | 20,094,829.5035 | 36,900.6923 | 20,057,928.8112 |

The mandatory business reconciliation requirement was achieved:

2011 Gross Sales = USD 12,646,112.16.

Minor differences may remain between the aggregated item-level net sales and the source sales order header subtotal due to decimal precision and rounding. These differences are retained transparently rather than artificially adjusting the item-level measures.

## Execution and Testing

Model execution:

`dbt run --select int_sales__order_details`

Model tests:

`dbt test --select int_sales__order_details`

Referential integrity tests:

`dbt test --select "test_name:relationships"`

All commands completed successfully.

## Next Steps

The next Intermediate models will address additional business relationships and transformations required for dimensional modeling.

The sales order-to-sales reason many-to-many relationship will be handled separately, preserving the integrity of sales measures and aggregation logic.