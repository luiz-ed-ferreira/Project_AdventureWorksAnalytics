# Intermediate Layer

## Overview

The Intermediate layer integrates and enriches standardized data from the Staging layer, preparing it for dimensional modeling and business analysis.

Its main responsibilities are:

- Combining related staging models.
- Establishing consistent business entities and relationships.
- Applying reusable business logic.
- Preparing reliable datasets for the Marts layer.
- Preserving data granularity to prevent metric duplication.
- Separating measures with different aggregation grains.

Intermediate models are materialized as views.

## Model Inventory

| Model | Description | Grain |
|---|---|---|
| `int_sales__order_details` | Integrates sales order details with sales order header attributes and calculates financial measures. | One row per sales order detail. |
| `int_sales__order_reasons` | Integrates sales orders with their associated sales reasons. | One row per sales order and reason combination. |
| `int_sales__customer` | Combines customer records with individual and store information. | One row per customer. |
| `int_sales__product` | Integrates products with their subcategory and category attributes. | One row per product. |
| `int_sales__geography` | Combines addresses with state/province and country information. | One row per address. |
| `int_sales__salesperson` | Integrates salesperson, employee, and person attributes. | One row per salesperson. |
| `int_sales__credit_card` | Prepares credit card attributes for dimensional modeling. | One row per credit card. |
| `int_sales__order_header_metrics` | Provides order-level financial measures and dimensional keys. | One row per sales order. |
| `int_sales__sales_territory` | Integrates sales territory attributes, including territory name, country, group, and financial performance metrics. |

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

These attributes are handled separately by `int_sales__order_header_metrics`.

#### Sales Reasons

The many-to-many relationship between sales orders and sales reasons is not incorporated into this model.

It is handled separately by `int_sales__order_reasons` to prevent duplication of order detail records and financial measures.

#### Data Types and Precision

Financial measures use `DECIMAL(19,4)` to preserve decimal precision during calculations and aggregation.

Order dates and modification timestamps retain their standardized types from the Staging layer.

## Model: int_sales__order_reasons

### Purpose

Integrates sales order and sales reason records, providing a consolidated representation of the reasons associated with each order.

This model preserves the many-to-many relationship between sales orders and sales reasons without introducing duplication into the sales order detail model.

### Source Models

- `stg_sales__sales_order_header_sales_reason`
- `stg_sales__sales_reason`

### Grain

One row per sales order and sales reason combination.

The combination of `sales_order_id` and `sales_reason_id` uniquely identifies each association.

### Key Attributes

The model includes:

- Sales order identifier.
- Sales reason identifier.
- Sales reason name.
- Sales reason type.
- Source modification timestamp.

### Modeling Decisions

#### Many-to-Many Relationship

A sales order may have multiple associated reasons, and a sales reason may be associated with multiple orders.

The model preserves each association independently.

This structure supports sales reason analysis while avoiding direct joins between the raw association table and the item-level sales model, which could multiply sales records and financial measures.

### Data Quality and Validation

The model contains:

| Validation | Result |
|---|---:|
| Total associations | 27,647 |
| Distinct sales orders | 23,012 |
| Distinct sales reasons | 7 |
| Duplicate order/reason combinations | 0 |
| Null key values | 0 |
| dbt model tests | Passed |

The composite key is validated using `dbt_utils.unique_combination_of_columns`.

## Model: int_sales__customer

### Purpose

Integrates customer records with their corresponding individual and store information.

The model provides a unified customer entity while preserving the distinction between individual customers and business customers.

### Source Models

- `stg_sales__customer`
- `stg_person__person`
- `stg_sales__store`

### Grain

One row per customer.

`sales customer_id` uniquely identifies each customer record.

### Key Attributes

The model includes:

- Customer identifier.
- Person and store identifiers.
- Sales territory identifier.
- Person type and name attributes.
- Store name.
- Store salesperson identifier.
- Source modification timestamps for customer, person, and store records.

### Modeling Decisions

#### Individual and Store Customers

Customer records may reference an individual, a store, or both.

The integration uses LEFT JOIN operations to preserve every customer record, including customers without a matching individual or store record.

The source data contains:

| Customer classification | Records |
|---|---:|
| Individual only | 18,484 |
| Store only | 701 |
| Both individual and store | 635 |
| Total customers | 19,820 |

The model retains person and store attributes independently rather than forcing customers into mutually exclusive categories.

#### Optional Relationships

The person and store relationships are preserved as optional attributes. No customer records were lost during integration.

### Data Quality and Validation

| Validation | Result |
|---|---:|
| Total customers | 19,820 |
| Distinct customer IDs | 19,820 |
| Null customer IDs | 0 |
| Customers with person information | 19,119 |
| Customers with store information | 1,336 |
| Customers without either relationship | 0 |
| Unmatched person/store relationships | 0 |
| dbt model tests | Passed |

## Model: int_sales__product

### Purpose

Integrates product records with their associated subcategory and category attributes.

The model provides a consolidated product hierarchy for product-level sales analysis and dimensional modeling.

### Source Models

- `stg_production__product`
- `stg_production__product_subcategory`
- `stg_production__product_category`

### Grain

One row per product.

`product_id` uniquely identifies each product.

### Key Attributes

The model includes:

- Product identifier and name.
- Product number.
- Make and finished goods indicators.
- Product color, size, weight, and product line.
- Product class and style.
- Product model and subcategory identifiers.
- Subcategory and category names.
- Product lifecycle dates.
- Source modification timestamp.

### Modeling Decisions

#### Product Hierarchy

The product hierarchy is integrated through the following relationships:

Product → Product Subcategory → Product Category.

LEFT JOIN operations preserve products without an assigned subcategory or category.

#### Optional Product Classification

Not all products have a subcategory or category assigned.

These records are retained rather than excluded from the integrated product dataset.

#### Discontinued Date

The source `discontinueddate` field contains NULL values for all 504 products.

The Staging layer preserves the field as a DATE using a typed NULL expression. The Intermediate layer retains this standardized attribute.

### Data Quality and Validation

| Validation | Result |
|---|---:|
| Total products | 504 |
| Distinct product IDs | 504 |
| Null product IDs | 0 |
| Products with subcategory | 295 |
| Products with category | 295 |
| Products without subcategory/category | 209 |
| Subcategory join failures | 0 |
| Category join failures | 0 |
| dbt model tests | Passed |

## Model: int_sales__geography

### Purpose

Integrates address records with their corresponding state/province and country information.

The model provides a consolidated geographic entity for location-based sales analysis.

### Source Models

- `stg_person__address`
- `stg_person__state_province`
- `stg_person__country_region`

### Grain

One row per address.

`address_id` uniquely identifies each address record.

### Key Attributes

The model includes:

- Address identifier and address lines.
- City and postal code.
- State/province identifier, code, and name.
- State/province classification indicator.
- Territory identifier.
- Country/region code and name.
- Source modification timestamps for address, state/province, and country records.

### Modeling Decisions

#### Geographic Hierarchy

The geographic hierarchy is integrated through:

Address → State/Province → Country/Region.

LEFT JOIN operations preserve address records while adding their geographic attributes.

#### Country Region Code Standardization

The source record for Namibia contains a NULL country/region code.

The Staging layer standardizes this value to `NA`, allowing the geographic relationship to be resolved.

The Intermediate model uses the standardized country/region attributes.

#### Address Roles

The model represents geographic attributes at the address level.

Billing and shipping addresses remain separate foreign key roles in the sales models. They are not merged into a single address relationship.

### Data Quality and Validation

| Validation | Result |
|---|---:|
| Total addresses | 19,614 |
| Distinct address IDs | 19,614 |
| Null address IDs | 0 |
| Addresses with state/province | 19,614 |
| Addresses with country/region | 19,614 |
| State/province join failures | 0 |
| Country/region join failures | 0 |
| dbt model tests | Passed |

## Model: int_sales__salesperson

### Purpose

Integrates salesperson records with employee and person information.

The model provides a consolidated salesperson entity, including organizational and personal attributes required for sales performance analysis.

### Source Models

- `stg_sales__sales_person`
- `stg_person__employee`
- `stg_person__person`

### Grain

One row per salesperson.

`sales_person_id` uniquely identifies each salesperson.

### Key Attributes

The model includes:

- Salesperson identifier.
- Sales territory identifier.
- Employee job title and hire date.
- Employee current status.
- Person type and name attributes.
- Sales quota.
- Bonus and commission percentage.
- Year-to-date and previous-year sales values.
- Source modification timestamps for salesperson, employee, and person records.

### Modeling Decisions

#### Salesperson and Employee Integration

Salesperson records are linked to employee records using:

`sales_person_id = business_entity_id`

Employee records are then linked to person records using:

`business_entity_id = person_id`

This integration provides the employee and personal attributes associated with each salesperson.

#### Sales Representatives and Management Roles

The source contains 17 salespeople, of which 14 have the job title Sales Representative.

Other salespeople have management roles.

The model retains all salesperson records rather than restricting the dataset to Sales Representatives.

#### Optional Attributes

Optional attributes such as sales territory, quota, and person title are preserved as NULL when unavailable in the source.

### Data Quality and Validation

| Validation | Result |
|---|---:|
| Total salespeople | 17 |
| Distinct salesperson IDs | 17 |
| Null salesperson IDs | 0 |
| Salespeople with employee job titles | 17 |
| Salespeople with first names | 17 |
| Salespeople with last names | 17 |
| Sales Representatives | 14 |
| Active salespeople | 17 |
| Employee/person integration failures | 0 |
| dbt model tests | Passed |

## Model: int_sales__credit_card

### Purpose

Prepares credit card records for dimensional modeling and sales analysis.

The model provides the credit card identifier and card type associated with each record.

### Source Models

- `stg_sales__credit_card`

### Grain

One row per credit card.

`credit_card_id` uniquely identifies each credit card record.

### Key Attributes

The model includes:

- Credit card identifier.
- Credit card type.
- Source modification timestamp.

### Modeling Decisions

#### Data Minimization and Sensitive Information

Only the attributes required for analytical purposes are retained.

Sensitive information such as card numbers and expiration dates is intentionally excluded from both the Staging and Intermediate models.

The model supports analysis by card type without exposing unnecessary payment information.

#### Optional Sales Order Relationship

The credit card identifier is optional in sales order records.

Orders without an associated credit card remain valid and are preserved in the sales models.

### Data Quality and Validation

The model-specific dbt tests validate:

- Non-null credit card identifiers.
- Unique credit card identifiers.
- Non-null card types.

All model tests completed successfully.

## Model: int_sales__order_header_metrics

### Purpose

Provides order-level financial measures and dimensional keys from sales order header records.

The model separates header-level financial metrics from item-level measures, preventing duplication when aggregating sales order details.

### Source Models

- `stg_sales__sales_order_header`

### Grain

One row per sales order.

`sales_order_id` uniquely identifies each order.

### Key Attributes

The model includes:

- Sales order identifier and order date.
- Customer, salesperson, and territory identifiers.
- Billing and shipping address identifiers.
- Credit card identifier.
- Order status and online order indicator.
- Subtotal, tax, freight, and total due amounts.
- Source modification timestamp.

### Financial Measures

The model preserves four order-level financial measures:

- `subtotal_amount`: Order subtotal after line discounts and before tax and freight.
- `tax_amount`: Total tax charged for the order.
- `freight_amount`: Shipping and handling charge.
- `total_due_amount`: Total amount due, including subtotal, tax, and freight.

Financial fields are cast to `DECIMAL(19,4)`.

### Modeling Decisions

#### Separation of Financial Grains

Header-level financial measures are maintained independently from item-level measures in `int_sales__order_details`.

Repeating subtotal, tax, freight, or total due across individual order detail records would cause duplication during aggregation.

The two models therefore serve different analytical grains:

- `int_sales__order_details`: one row per order item.
- `int_sales__order_header_metrics`: one row per order.

#### Data Reconciliation

The model preserves the financial values from the source sales order header without recalculating or artificially adjusting them.

This ensures consistency with the source system and supports financial reconciliation.

### Data Quality and Validation

| Validation | Result |
|---|---:|
| Total records | 31,465 |
| Distinct sales orders | 31,465 |
| Null sales order IDs | 0 |
| Null customer IDs | 0 |
| Null order dates | 0 |
| Subtotal difference against Staging | 0.0000 |
| Tax difference against Staging | 0.0000 |
| Freight difference against Staging | 0.0000 |
| Total due difference against Staging | 0.0000 |
| dbt model tests | Passed |

### Financial Aggregation

The validated order-level totals are:

| Metric | Total (USD) |
|---|---:|
| Subtotal | 109,846,381.40 |
| Tax | 10,186,974.46 |
| Freight | 3,183,430.25 |
| Total Due | 123,216,786.12 |

All four financial measures reconcile exactly with the corresponding Staging records at the source precision.

## Model: int_sales__sales_territory

### Purpose

Provides integrated sales territory attributes and financial performance metrics for dimensional modeling and business analysis.

The model consolidates territory information standardized in the Staging layer, preserving the original territory identifiers and descriptive attributes.

### Source Models

- `stg_sales__sales_territory`

### Grain

One row per sales territory.

`sales_territory_id` is not the column name in this model; `territory_id` uniquely identifies each territory.

### Key Attributes

The model includes:

- Sales territory identifier and name.
- Country or region code.
- Territory group.
- Year-to-date and previous-year sales amounts.
- Year-to-date and previous-year cost amounts.
- Source row GUID.
- Source modification timestamp.

### Financial Measures

The model preserves four financial measures:

- `sales_ytd`: Sales accumulated during the current year.
- `sales_last_year`: Sales recorded during the previous year.
- `cost_ytd`: Costs accumulated during the current year.
- `cost_last_year`: Costs recorded during the previous year.

Financial fields are maintained as `DECIMAL(19,4)`.

### Modeling Decisions

#### Preservation of Source Metrics

The model retains the financial performance metrics provided by the source system without recalculating or aggregating them.

This preserves the original territory-level information and supports comparisons between current-year and previous-year sales and costs.

#### Separation from Geography

Sales territories represent the company's commercial organization, whereas geography represents the physical location of addresses.

These concepts remain separate in the dimensional model, allowing independent analysis of sales by commercial territory and geographic location.

### Data Quality and Validation

| Validation | Result |
|---|---:|
| Total records | 10 |
| Distinct territories | 10 |
| Territories with name | 10 |
| Territories with country code | 10 |
| Distinct territory groups | 3 |
| Null territory IDs | 0 |
| dbt model tests | Passed |

## Data Quality and Validation

All 9 Intermediate models were successfully materialized using dbt.

Model-specific tests were executed for each model, covering applicable:

- Not-null constraints.
- Unique keys.
- Composite key uniqueness.
- Referential integrity.
- Required business attributes.

Referential integrity tests were also executed across the project.

All executed model-specific and relationship tests completed successfully.

Additional validation queries confirmed:

- Expected record counts and model grains.
- No duplicate records at the defined model grains.
- No unexpected NULL values in mandatory identifiers.
- Successful integration of related entities.
- Preservation of optional relationships.
- Financial reconciliation between the Staging and Intermediate layers.

## Key Modeling Decisions

### Separation of Sales Grains

The sales data is represented through two distinct Intermediate models:

- Item-level sales measures in `int_sales__order_details`.
- Order-level financial measures in `int_sales__order_header_metrics`.

This prevents double counting when combining order and order detail information.

### Many-to-Many Relationships

The sales order-to-sales reason relationship is maintained independently in `int_sales__order_reasons`.

This prevents multiplication of sales measures when analyzing orders by reason.

### Customer Entity Preservation

Individual and store attributes are integrated without excluding customers or forcing mutually exclusive classifications.

### Geographic Roles

Address attributes are integrated at the address level, while billing and shipping address identifiers remain distinct in the sales models.

### Sensitive Data Exclusion

Credit card numbers and expiration dates are excluded. Only the identifier and card type are retained for analytical purposes.

### Optional Relationships

LEFT JOIN operations preserve primary records when optional related attributes are unavailable.

This applies to customer, product, salesperson, and other integrated entities.

## Execution and Testing

Individual model execution follows:

`dbt run --select <model_name>`

Individual model tests follow:

`dbt test --select <model_name>`

Referential integrity tests:

`dbt test --select "test_name:relationships"`

All 9 Intermediate models were successfully executed, and their model-specific tests passed.

## Layer Completion

The Intermediate layer is complete.

It contains 9 integrated models covering sales transactions, order reasons, customers, products, geography, salespeople, credit cards, and order-level financial metrics.

The layer establishes reusable business entities, preserves analytical grain, and separates measures to prevent aggregation errors.

These models provide the foundation for the dimensional structures and analytical fact tables in the Marts layer.