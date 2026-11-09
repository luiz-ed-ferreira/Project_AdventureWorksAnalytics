# Adventure Works Analytics — Conceptual Dimensional Model

## 1. Purpose

This document defines the proposed analytical model for the Adventure Works sales domain. The model is designed to support the six business questions in the project brief, preserve financial reconciliation, and provide a consistent foundation for dbt transformations and BI reporting.

The source data is read from the `fea_academy.adventure_works` schema. The source tables remain unchanged; standardization and business rules are applied in the transformation layer.

## 2. Modeling approach

The solution follows a dimensional modeling approach with a central sales fact table and conformed dimensions.

### Fact table grain

`fact_sales` contains one row per sales order detail (sales order line).

The natural source-level identifier is the combination of:
- `salesorderid`
- `salesorderdetailid`

This grain supports analysis by product, customer, sale date, geography, credit card type, salesperson, and sales territory while retaining the detail-level quantities and financial values.

### Fact table measures

| Measure | Definition |
|---|---|
| `order_quantity` | `OrderQty` |
| `gross_sales_amount` | `UnitPrice * OrderQty` |
| `discount_amount` | `UnitPrice * OrderQty * UnitPriceDiscount` |
| `net_sales_amount` | `UnitPrice * OrderQty * (1 - UnitPriceDiscount)` |

The model will also retain `salesorderid` and `salesorderdetailid` as degenerate identifiers, plus `order_status_code`.

Order-level attributes such as customer, salesperson, dates, addresses, credit card, and territory are repeated across the corresponding order lines. This is expected at the selected grain.

## 3. Dimensions and supporting structures

| Model | Grain | Main content |
|---|---|---|
| `dim_date` | One row per calendar date | Date, day, month, quarter, year and descriptive calendar attributes |
| `dim_product` | One row per product | Product attributes enriched with subcategory and category |
| `dim_customer` | One row per customer | Customer identifier and person/store descriptive attributes |
| `dim_geography` | One row per address | Address, city, state/province and country |
| `dim_credit_card` | One row per credit card reference | Credit card type only; no card number |
| `dim_salesperson` | One row per salesperson | Salesperson and employee descriptive attributes |
| `dim_sales_territory` | One row per sales territory | Territory name, country and group |
| `dim_sales_reason` | One row per sales reason | Reason name and type |
| `bridge_order_sales_reason` | One row per order/reason association | Resolves the many-to-many relationship between orders and sales reasons |

### Role-playing dimensions

`dim_date` is referenced through separate keys for order date, due date, and ship date.

`dim_geography` is referenced through separate keys for ship-to and bill-to addresses. The initial dashboard geography perspective should use ship-to geography, while bill-to geography remains available as a separate role. This is a modeling assumption because the business brief does not explicitly define which address should represent sales geography.

### Customer representation

The source contains customers associated with a person, a store, or both. `dim_customer` must preserve these cases instead of forcing every customer into a single category. Person and store names should be retained in separate attributes where available, alongside a customer classification.

### Credit card handling

Some orders do not contain a credit card reference. These orders must remain in the fact table. The credit card dimension must not store card numbers; only the descriptive card type is required for the analysis.

### Sales reason bridge

An order may be associated with multiple sales reasons. The bridge table preserves this many-to-many relationship at order grain.

The bridge must not be joined directly to order-line measures in a way that duplicates sales. Filtering or reporting by sales reason must use a bridge-aware approach. If the business later requires revenue allocation across multiple reasons, an explicit allocation rule must be agreed before implementation.

## 4. Source-to-model mapping

| Analytical model | Source tables |
|---|---|
| `fact_sales` | `sales_salesorderheader`, `sales_salesorderdetail` |
| `dim_date` | Generated calendar based on order, due and ship dates |
| `dim_product` | `production_product`, `production_productsubcategory`, `production_productcategory` |
| `dim_customer` | `sales_customer`, `person_person`, `sales_store` |
| `dim_geography` | `person_address`, `person_stateprovince`, `person_countryregion` |
| `dim_credit_card` | `sales_creditcard` |
| `dim_salesperson` | `sales_salesperson`, `humanresources_employee`, `person_person` |
| `dim_sales_territory` | `sales_salesterritory` |
| `dim_sales_reason` | `sales_salesreason` |
| `bridge_order_sales_reason` | `sales_salesorderheadersalesreason`, with order identifier from `sales_salesorderheader` |

All source tables are located in `fea_academy.adventure_works`.

## 5. Business questions supported

The model is designed to support:
1. Orders, purchased quantity and negotiated value by product, card type, sales reason, sale date, customer, status and geography.
2. Product with the highest average ticket by month, year and geography.
3. Top 10 customers by negotiated value, with the requested filters.
4. Top 5 cities by negotiated value, with the requested filters.
5. Orders, quantity and negotiated value by month and year.
6. Product with the highest units sold for the `Promotion` sales reason.

The average-ticket calculation and the exact definition of negotiated value must be confirmed as business rules before final KPI implementation. The initial candidate for net negotiated value is `net_sales_amount`; the denominator for average ticket must be explicitly defined (for example, distinct orders containing the product).

## 6. Financial reconciliation and data quality

The source exploration confirmed that 2011 gross sales, calculated as `SUM(UnitPrice * OrderQty)`, equal USD 12,646,112.16, matching the required reconciliation reference.

The model must retain gross sales, discounts, net sales, tax, freight and total due as distinct concepts. The detail-level net sales calculation is expected to reconcile closely with the order header subtotal; small differences may occur due to decimal precision and should be handled with appropriate decimal data types and rounding rules.

Known source conditions to preserve or address in transformations:
- One NULL `countryregioncode` exists for Namibia. Any proposed correction (`NA`) must be applied only in the transformation layer, documented, and validated against geographic relationships.
- 1,131 orders have no credit card reference; retain them.
- All observed orders currently have status code 5; retain the code without assuming an undocumented status description.
- Source identifier columns include some DOUBLE types and date columns are STRING; standardize types in staging models.
- June 2014 has an unusual reduction in sales. It is an investigation item, not currently classified as a data error.

## 7. Implementation sequence

1. Create dbt staging models to standardize source column names and data types.
2. Build intermediate models for customer, product, geography, salesperson and order-level relationships.
3. Build dimensions and the `fact_sales` table.
4. Build the sales reason dimension and order/reason bridge separately.
5. Add dbt tests for primary keys, not-null constraints, relationships and accepted values where applicable.
6. Reconcile annual gross sales, especially the 2011 reference value, and validate all dashboard KPIs.
7. Build the BI dashboard after the metric definitions and geographic role are confirmed.

## 8. Open business definitions

The following definitions should be confirmed before the BI layer is finalized:
- Whether sales geography should be based on ship-to or bill-to address.
- Whether “total negotiated value” means gross sales or net sales after discounts.
- Whether average ticket is calculated per distinct order containing a product, or by another denominator.
- Whether sales reason filtering should include all associated reasons or apply a specific attribution rule when an order has multiple reasons.
