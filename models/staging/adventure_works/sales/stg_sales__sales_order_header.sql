
-- Standardize sales order header data.
SELECT
    CAST(salesorderid AS BIGINT) AS sales_order_id,
    CAST(revisionnumber AS INT) AS revision_number,
    CAST(orderdate AS DATE) AS order_date,
    CAST(duedate AS DATE) AS due_date,
    CAST(shipdate AS DATE) AS ship_date,
    CAST(status AS INT) AS status,
    onlineorderflag AS is_online_order,
    purchaseordernumber AS purchase_order_number,
    accountnumber AS account_number,
    CAST(customerid AS BIGINT) AS customer_id,
    CAST(salespersonid AS BIGINT) AS salesperson_id,
    CAST(territoryid AS BIGINT) AS territory_id,
    CAST(billtoaddressid AS BIGINT) AS bill_to_address_id,
    CAST(shiptoaddressid AS BIGINT) AS ship_to_address_id,
    CAST(shipmethodid AS BIGINT) AS ship_method_id,
    CAST(creditcardid AS BIGINT) AS credit_card_id,
    creditcardapprovalcode AS credit_card_approval_code,
    CAST(currencyrateid AS BIGINT) AS currency_rate_id,
    CAST(subtotal AS DECIMAL(19, 4)) AS subtotal,
    CAST(taxamt AS DECIMAL(19, 4)) AS tax_amount,
    CAST(freight AS DECIMAL(19, 4)) AS freight,
    CAST(totaldue AS DECIMAL(19, 4)) AS total_due,
    comment AS comments,
    rowguid,
    CAST(modifieddate AS TIMESTAMP) AS modified_at

FROM {{ source('adventure_works', 'sales_salesorderheader') }}

-- dbt run --select stg_sales__sales_order_header