# Project Adventure Works e-commerce - Indicium AI's Analytics Engineer Certification

### Project Overview

> This project is being developed as part of the final assessment for Indicium AI's Analytics Engineer Certification, based on a fictional e-commerce business case involving Adventure Works.

> The goal is to design and implement an end-to-end Analytics Engineering solution using PostgreSQL, Databricks, Delta Lake, and dbt. The project covers data extraction and loading (EL), data exploration, dimensional modeling, data transformation, automated data quality testing, and financial reconciliation.

> The final solution will provide a reliable analytical foundation for business intelligence and strategic decision-making, delivering insights into sales performance, customers, products, and geographic trends through interactive Power BI dashboards.

### Criterion

- Design a conceptual Data Warehouse diagram.
- Implement data ingestion (EL) from PostgreSQL, using only the adventure_works schema.
- Implement staging, intermediate, and mart models.
- Document mart tables and columns.
- Reconcile 2011 gross sales against the accounting audit reference of $12,646,112.16.
- Ensure all dbt models and tests execute successfully.
- Provide access to the dashboard for evaluation.
- Explicitly identify the product with the highest purchased quantity for the sales reason Promotion.
- Present the fact table, dimensions, relationships, data quality tests, and dashboard insights.

### Status & Improvements

In progress [Under Review]

- [x] Environment and infrastructure setup.
- [x] Data ingestion from PostgreSQL into Databricks.
- [x] Source profiling and data exploration.
- [ ] Conceptual and dimensional data modeling.
- [ ] Data transformations using dbt.
- [ ] Automated data quality testing and financial reconciliation.
- [ ] Interactive dashboard development.
- [ ] Final validation, documentation, and delivery.

> Attention! All project code, configurations, and technical documentation will be maintained in GitHub to ensure version control, reproducibility, and traceability.

### Data Processing Architecture

> The data pipeline follows a layered architecture based on three main transformation stages (dbt Core):

- **Staging**: Source data standardization, column selection, renaming, type casting, and basic cleaning.
- **Intermediate**: Business logic implementation, data integration, and preparation of datasets for dimensional modeling.
- **Marts**: Business-ready fact and dimension tables designed to support analytical queries, reporting, and BI dashboards.

### Data Ingestion (EL)

> The data ingestion process from PostgreSQL to Databricks has been successfully completed, following the [Indicium AI – Databricks Data Sources](https://bitbucket.org/indiciumtech/databricks-datasources/src/main/) implementation guide.

> A total of 68 tables were ingested from the `adventure_works` source schema and made available in Databricks.

**Source system:** PostgreSQL

**Target platform:** Databricks

**Unity Catalog:**
- Catalog: `fea_academy`
- Source schema: `adventure_works`
- Ingested tables: 68

> The ingested tables serve as the source layer for subsequent data exploration, transformation, and dimensional modeling. Only the `adventure_works` schema is considered within the scope of this project.

### Source Data Exploration - Key Findings

> The initial source data exploration covered the 68 tables ingested into the `fea_academy.adventure_works` schema, focusing on data structure, quality, referential integrity, and sales metrics.

#### Data Quality

- 8 out of 9 candidate primary keys presented no NULL or duplicate values.
- One NULL `countryregioncode` was identified for Namibia in `person_countryregion`.
- All analyzed foreign key relationships passed referential integrity checks, with no unmatched records.
- Customer records were classified into three categories:
  - Person Only: 18,484
  - Store Only: 701
  - Person and Store: 635
- All 31,465 sales orders have status code 5.
- Some identifier columns were ingested as DOUBLE and date columns as STRING. Data types will be standardized in the staging layer.

#### Sales Overview

> The source dataset contains:

- 31,465 sales orders.
- 121,317 order details.
- 274,914 units sold.
- Sales period from May 2011 to June 2014.

> Financial metrics were defined as follows:

| Metric | Definition |
|---|---|
| Gross Sales | UnitPrice * OrderQty |
| Total Discounts | UnitPrice * OrderQty * UnitPriceDiscount |
| Net Sales | UnitPrice * OrderQty * (1 - UnitPriceDiscount) |
| Header Subtotal | Net value recorded in the sales order header |
| Total Due | Subtotal + Tax + Freight |

#### Financial Reconciliation

> The annual financial analysis confirmed that 2011 gross sales totaled USD 12,646,112.16, exactly matching the required accounting reconciliation reference.

> The order detail calculations also showed consistency with the header subtotal, with only minor decimal precision differences.

#### Modeling Considerations

> The exploration identified important requirements for the analytical model:

- Preserve the many-to-many relationship between sales orders and sales reasons through a bridge table.
- Keep billing and shipping addresses as separate geographic roles.
- Preserve customers associated with both individuals and stores.
- Handle missing credit card information without excluding valid orders.
- Standardize source data types in the staging layer.
- Keep gross sales, discounts, net sales, taxes, freight, and total due as separate measures.
- Investigate the unusual sales reduction observed in June 2014 during the analytical architecture development.

> These findings will guide the dimensional modeling, dbt transformations, and data quality tests.

### Pipeline Architecture

```text
                     PostgreSQL
       (Transactional source: adventure_works)
                         |
                         v
                    Ingestion
             (Extraction and loading)
                         |
                         v
              Databricks / Delta Lake
               (Data storage layer)
                         |
                         v
                     dbt Core
          +---------------------------+
          |         Staging           |
          |       Intermediate        |
          |           Marts           |
          +---------------------------+
                         |
                         v
                     Power BI
             (Analytics and Reporting)
```

### Project Architecture

```text
Project_AdventureWorksAnalytics/
│
├── docs
│   ├── architecture
│   ├── data_model
│   └── project_planning
│       └── Anexo B - Modelo de Planejamento de Projeto.docx
│
├── exploration/
│   └── sql/
│       ├── 01_source_inventory.sql
│       ├── 02_source_profiling.sql
│       └── 03_relationship_analysis.sql
│
├── ingestion/
│   └── postgres/
│
├── models
│   ├── intermediate
│   ├── marts
│   │   ├── core
│   │   └── reporting
│   └── staging
│       └── adventure_works
│
├── analyses/
├── macros/
├── seeds/
├── snapshots/
├── tests/
│
├── dbt_project.yml
├── requirements.txt
├── README.md
└── .gitignore
```

### Prerequisites & Softwares

- WSL Linux/Ubuntu for Windows 11 System
- Python version 3.12.3
- PostgreSQL version 18.6
- Power BI version 2.157.879
- Databricks Free Edition
- Delta Lake
- dbt Core 1.12.5
- dbt Databricks 1.12.8

> Attention! Consult the requirements.txt file for more information about python libraries used.

### Collaborators

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/luiz-ed-ferreira" title="Luiz Eduardo">
        <img src="https://avatars3.githubusercontent.com/u/145693602" width="100px;" alt="Foto do Iuri Silva no GitHub"/><br>
        <sub>
          <b>Luiz Eduardo</b>
        </sub>
      </a>
    </td>
</table>