# MLB Analytics Project — Lahman Database (1871–2024)

A comprehensive SQL analytics project exploring long-term patterns in MLB player development, career trajectories, team spending, and player attributes using the Lahman Baseball Database.  
This project is designed as a **standalone, portfolio-ready demonstration of SQL proficiency**, supported by modular views, well-structured query files, and optional Python-based EDA.

---

## 1. Overview

This project uses the **Lahman Baseball Database (1871–2024)** to answer a wide range of analytical questions across four major themes:

- **School / Talent Pipelines** — Which colleges produce MLB talent, and how has this changed over time?
- **Team Salary & Payroll Dynamics** — Which teams are high spenders, when do teams cross major cumulative payroll milestones, and how does spending relate to postseason outcomes?
- **Player Career Patterns** — At what ages do players debut/retire, how long do careers last, and how loyal are players to their first team?
- **Player Physical & Comparative Profiles** — How do height, weight, and handedness vary by team, era, or position?

The project extends beyond basic SQL tasks and incorporates advanced analytics, including Hall of Fame comparisons, league/era splits, park-based effects, and postseason-performance modelling.

---

## 2. Data Source

- **Dataset:** Lahman Baseball Database  
- **Version:** 2024 update (1871–2024 seasons)  
- **Website:** https://sabr.org/lahman-database/  
- **Format:** CSV tables imported into PostgreSQL  
- **Coverage:** MLB players, teams, salaries, colleges, parks, managers, postseason results, Hall of Fame voting, awards, appearances, and more.

All project-owned transformations are implemented as **views** under the schema:

```sql
CREATE SCHEMA IF NOT EXISTS mlb_analytics;
```

No base tables are modified.

---

## 3. Repository Structure

```
mlb-analytics/
│
├── sql/
│   ├── schema.sql              # Project schema + optional summary objects
│   ├── views.sql               # Reusable analytic views
│   ├── analysis_queries.sql    # Core solutions to business questions
│   ├── advanced_queries.sql    # Extended/portfolio-level queries
│   └── optimised_queries.sql   # Performance-tuned versions of key queries
│
├── notebooks/
│   └── exploration.ipynb       # Python EDA, charts, tables
│
├── docs/
│   ├── project_overview.md     # Narrative overview of the project
│   ├── business_questions.md   # Full question set (core + advanced)
│   └── schema_design.md        # Documentation of base + analytic schema
│
└── README.md                   # This file
```

---

## 4. Business Questions

All core and advanced analytical questions are documented in:

```
docs/business_questions.md
```

These include:

- Player counts, debut/retirement ages, career length  
- School production patterns  
- Payroll rankings, cumulative spending, postseason relevance  
- Hall of Fame vs non–Hall of Fame comparisons  
- Player physical traits and how they've changed by era  
- Ballpark and league effects  
- Team-level handedness composition  
- And more

Each question is labeled:

- **(C)** — core question  
- **(advance query)** — extended portfolio question  

---

## 5. How to Run the Project

### A. Import the Dataset into PostgreSQL

1. Create a new PostgreSQL database (e.g., `lahman_db`).
2. Import all Lahman 2024 CSV files into their corresponding tables.
3. Run:

```sql
\i sql/schema.sql;
\i sql/views.sql;
```

This creates the `mlb_analytics` schema and the analytical views.

---

### B. Running SQL Analyses

Use the SQL files in the `sql/` directory:

- **analysis_queries.sql** → Core business-question solutions  
- **advanced_queries.sql** → Extended, deeper analyses  
- **optimised_queries.sql** → Performance-tuned versions (optional)

These can be run section by section in pgAdmin, DBeaver, Azure Data Studio, or any SQL client.

---

### C. Python EDA (Optional)

Open:

```
notebooks/exploration.ipynb
```

This notebook includes:

- SQL-to-pandas queries  
- Visualisations of long-term trends  
- Exploratory and supplementary analyses  

---

## 6. Tools & Techniques

This project demonstrates:

- Relational modelling  
- Multi-table joins  
- CTEs for multi-stage logic  
- Window functions (ranking, percentiles, running totals, lag/lead)  
- Analytical view design  
- Cross-era and cross-league comparisons  
- Postseason/payroll modelling  
- SQL + Python integration for EDA  
- Query performance optimisation strategies  

---

## 7. Key Findings  
*(To be completed after analysis)*

Example insights that will be summarised:

- Decade-level evolution of school talent pipelines  
- Payroll inequality between large-market and small-market teams  
- Patterns in debut age and career longevity  
- Hall of Fame vs non-HOF career differences  
- Decade-over-decade changes in height and weight  
- Ballpark/altitude effects on debut physical profiles  
- Handedness distributions across franchises  

---

## 8. Purpose

This repository serves as both:

1. A **portfolio-grade SQL analytics project** demonstrating end-to-end analytical capability (data ingestion → modelling → querying → interpretation → visualisation).  
2. A deep exploratory study of over 150 years of MLB data, spanning schools, salaries, careers, teams, parks, postseason results, and physical attributes.

It is structured to mirror real-world analytical workflows through modular views, layered queries, and clear documentation.

---

## 9. License / Attribution

The Lahman Database is published under the **Creative Commons Attribution-ShareAlike 3.0 Unported License**.  
Details: https://creativecommons.org/licenses/by-sa/3.0/
