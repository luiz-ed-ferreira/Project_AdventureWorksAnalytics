# Project Adventure Works e-commerce - Indicium AI's Analytics Engineer Certification

### Project Overview

> A project developed as part of the final assessment process for Indicium AI's Analytics Engineer training program, based on a fictional e-commerce case for Adventure Works. The project integrates PostgreSQL, Databricks, and dbt to implement data ingestion (EL), data transformation, dimensional modeling, automated data quality testing, and a cloud-based Data Warehouse. The final solution aims to support strategic decision-making through interactive BI dashboards, providing actionable insights into sales performance, customers, products, and geographic trends.

> Attention! Please note that this notebook is partially written in Brazilian Portuguese, as it was developed as a test project to evaluate my skills as part of the Indicium AI's Data Analytics certification.

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

- [ ] Environment and infrastructure setup.
- [ ] Data ingestion from PostgreSQL into Databricks.
- [ ] Source data exploration and profiling.
- [ ] Conceptual and dimensional data modeling.
- [ ] Data transformations using dbt.
- [ ] Automated data quality testing and financial reconciliation.
- [ ] Interactive dashboard development.
- [ ] Final validation, documentation, and delivery.

> Attention! All project code, configurations, and technical documentation will be maintained in GitHub to ensure version control, reproducibility, and traceability.

### Data Processing Layers

> The data pipeline is organized into three main transformation layers:

- **Staging**: Initial data standardization, column selection, renaming, and basic cleaning.
- **Intermediate**: Business logic, data integration, and preparation for dimensional modeling.
- **Marts**: Business-ready fact and dimension tables designed to support analytical queries and BI dashboards.

### Data Quality & Governance

> Data quality and reliability are essential requirements throughout the pipeline.

> The project will implement:

- Source-level validation and data quality tests.
- Primary key and relationship integrity tests.
- Null and duplicate record checks.
- Business rule validations.
- Financial reconciliation against the accounting audit reference.

> Attention! A mandatory reconciliation test will validate the 2011 gross sales amount against the accounting audit reference of $12,646,112.16.

### Project Architecture

```text

Project_AdventureWorksAnalytics/
│
├── docs/
│   ├── architecture/
│   ├── data_model/
│   └── project_planning/
│
├── ingestion/
│   └── README.md
│
├── databricks/
│   ├── ingestion/
│   └── exploration/
│
├── dbt/
│   ├── dbt_project.yml
│   ├── models/
│   │   ├── staging/
│   │   ├── intermediate/
│   │   └── marts/
│   ├── tests/
│   ├── macros/
│   └── seeds/
│
├── scripts/
│
├── .gitignore
├── README.md
└── requirements.txt

```

### Prerequisites & Softwares

- WSL Linux/Ubuntu for Windows 11 System
- Python version 3.12.3
- PostgreSQL version 18.6
- Power BI version 2.157.879
- Databricks Free Edition
- Delta Lake
- dbt Core 1.12.6
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