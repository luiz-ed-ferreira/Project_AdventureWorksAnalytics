# Reporting Layer

## Purpose and Architecture

The Reporting layer contains business-oriented analytical models built on top of the Marts layer. Its purpose is to provide curated datasets that simplify business analysis, support dashboard development, and answer the key business questions defined for the project.

The models use dbt references to the dimensional model, preserving the data lineage and avoiding unnecessary duplication of transformation logic.

The Reporting layer contains 8 models:

| Model | Grain | Purpose |
|---|---|---|
| `rpt_sales__monthly_performance` | One row per calendar month | Analyzes monthly sales trends and performance. |
| `rpt_sales__product_performance` | One row per product with sales | Evaluates product sales volume and financial performance. |
| `rpt_sales__customer_performance` | One row per customer with sales | Analyzes customer purchasing behavior and identifies top customers. |
| `rpt_sales__geography_performance` | One row per shipping address with sales | Analyzes sales performance by city, state, and country. |
| `rpt_sales__salesperson_performance` | One row per salesperson with sales | Evaluates salesperson performance and sales contribution. |
| `rpt_sales__territory_performance` | One row per sales territory | Compares sales performance across territories and regional groups. |
| `rpt_sales__promotion_performance` | One row per product sold in orders associated with Promotion | Identifies products with the highest purchased quantities in promotional orders. |
| `rpt_sales__reason_analysis` | One row per sales reason associated with orders | Compares sales performance across different sales reasons. |

## Business Metrics

The Reporting models provide consistent business metrics, including:

- Total Orders: distinct sales orders within the reporting grain.
- Total Quantity: sum of units sold.
- Gross Sales: sum of unit price multiplied by order quantity.
- Total Discounts: sum of item-level discounts.
- Net Sales: gross sales minus discounts.
- Average Order Value (AOV): net sales divided by the number of distinct orders.
- Average Selling Price: net sales divided by total quantity, where applicable.

Metrics are calculated according to each model's grain. Consequently, order counts aggregated across products, customers, or geographic locations represent dimension-level order incidences and should not be interpreted as globally distinct orders.

## Sales Reason Attribution

The `rpt_sales__promotion_performance` and `rpt_sales__reason_analysis` models use the `bridge_order_sales_reason` table to associate sales orders with their respective reasons.

Since a sales order may have multiple associated reasons, financial metrics in the reason analysis are non-additive across reasons. The same order may contribute to more than one reason's results.

The Promotion analysis identifies the product with the highest purchased quantity among orders associated with the Promotion sales reason.

Validated result:

- Product ID: 870
- Product: Water Bottle - 30 oz.
- Total Quantity: 546 units

## Data Quality and Validation

All Reporting models were executed and validated successfully using dbt.

The validation process includes:

- `not_null` tests on required columns.
- `unique` tests on model grain keys.
- Custom SQL tests to verify uniqueness at the expected grain.
- Reconciliation of reporting metrics against the underlying `fact_sales` model.
- Validation of sales reason associations through the bridge table.

The Reporting layer preserves the financial measures established in the Marts layer and applies aggregation logic according to each model's analytical purpose.

## Business Value

The Reporting layer provides a consistent analytical foundation for the project's business questions:

- Sales performance and trends over time.
- Product performance and sales contribution.
- Customer ranking and purchasing behavior.
- Geographic sales distribution.
- Salesperson and territory performance.
- Promotion-related product analysis.
- Sales reason analysis.

These datasets are designed to support interactive dashboards and facilitate business decision-making through reliable and traceable metrics.