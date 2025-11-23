# MLB Analytics Project — Lahman Database (1871–2024)

This project explores long-term patterns in MLB player development, careers, salaries, talent pipelines, and postseason performance using the Lahman Baseball Database (1871–2024).  
It is designed as a **portfolio-ready SQL analytics project**, showcasing advanced SQL skills, modular analysis design, and optional Python-based EDA.

---

## 1. Overview

Using the Lahman Database (1871–2024), this project investigates four major themes:

- **Talent Pipelines** — Which colleges produce MLB players and how these patterns vary across decades.
- **Team Salary & Payroll Dynamics** — How payroll evolves, which teams spend the most, and how spending relates to postseason outcomes.
- **Career Trajectories** — Debut age, retirement age, career longevity, and player loyalty to their first team.
- **Player Physical & Comparative Profiles** — How height, weight, and handedness vary across eras, teams, positions, and leagues.

Advanced analysis includes Hall of Fame comparisons, multi-era splits, ballpark-factor effects, and multi-step SQL models using chained CTEs and window functions.

---

## 2. Data Source

- **Dataset:** Lahman Baseball Database  
- **Version:** 2024 release (1871–2024)  
- **Website:** https://sabr.org/lahman-database/  
- **Repository Data Layout:**
  - `data/core/` — Core Lahman CSV tables used in the project  
  - `data/extra/` — Additional CSV tables not used in this project  
  - `readme2024u.txt` — Official dataset documentation  

### PostgreSQL Setup

The project uses **manually created tables**, defined in `schema.sql`.  
You **must run schema.sql before importing any CSV files**.

Analytical views may optionally reside in a separate schema:

```sql
CREATE SCHEMA IF NOT EXISTS mlb_analytics;
```

Raw tables remain in `public`.

---

## 3. Repository Structure

```
MLB_Analytics_Project/
│
├── data/
│   ├── core/                    # Core Lahman CSV tables
│   ├── extra/                   # Extra Lahman tables (not used)
│   └── readme2024u.txt          # Official dataset README
│
├── sql/
│   ├── schema.sql               # CREATES all 10 base Lahman tables
│   ├── views.sql                # Analytical views (joins, summaries)
│   ├── analysis_queries.sql     # Core business questions
│   ├── advanced_queries.sql     # Extended portfolio queries
│   └── optimised_queries.sql    # Performance-tuned versions
│
├── notebooks/
│   └── exploration.ipynb        # Optional Python EDA notebook
│
├── docs/
│   ├── project_overview.md      # Narrative overview
│   ├── business_questions.md    # Full question list (core + advanced)
│   └── schema_design.md         # Documentation of all tables + schema
│
└── README.md                    # This file
```

---

## 4. Business Questions

The full list of questions is documented in:

```
docs/business_questions.md
```

Topics include:

- Debut & retirement age distributions  
- Career length modelling  
- College-to-MLB talent pipelines  
- Team salary trends & payroll evolution  
- Postseason success vs payroll  
- Hall-of-Fame vs non-HOF career differences  
- Height, weight, handedness trends  
- Team-level physical and handedness profiles  

Questions are labeled:

- **(C)** — Core question  
- **(advanced query)** — Extended portfolio analysis  

---

## 5. How to Run the Project

### A. Create All Tables in PostgreSQL

First, create an empty PostgreSQL database (e.g., `lahman_2024` or `mlb_project`).

Then run:

```sql
\i sql/schema.sql;
```

This will create the following tables:

- appearances  
- collegeplaying  
- halloffame  
- parks  
- people  
- pitching  
- salaries  
- schools  
- seriespost  
- teams  
- teamsfranchises  

### B. Import CSV Data into These Tables

After the tables exist:

1. Open pgAdmin / DBeaver / Azure Data Studio.
2. Import each CSV from `data/core/` into its corresponding table.
3. Ensure import settings align with the schema (e.g., header = true).

This step loads the actual data into the tables created by `schema.sql`.

### C. Create Analytical Views (Optional)

After loading all data, run:

```sql
\i sql/views.sql;
```

This will create reusable analytical views under the optional schema:

```sql
CREATE SCHEMA IF NOT EXISTS mlb_analytics;
```

### D. Run Analytical Queries

Use the SQL files in:

```
sql/analysis_queries.sql
sql/advanced_queries.sql
sql/optimised_queries.sql
```

These can be executed in pgAdmin, DBeaver, Azure Data Studio, or psql.

### E. Optional Python EDA

Open:

```
notebooks/exploration.ipynb
```

Includes:

- SQL → pandas integration  
- Visualisation of long-term trends  
- Exploratory deep-dives  

---

## 6. Tools & Techniques Demonstrated

- Relational modelling  
- Manual schema creation (`schema.sql`)  
- Window functions (RANK, LAG/LEAD, percentiles, rolling stats)  
- Multi-step CTE pipelines  
- Schema and analytical view design  
- Linking multi-table baseball records  
- Advanced SQL tuning (EXPLAIN/ANALYZE)  
- SQL + Python EDA workflow  

---

## 7. Key Findings  
(*To be completed after analysis*)  

Expected insights include:

- How college talent pipelines shift across time  
- Payroll inequality and long-term spending trends  
- Career length variation among positions  
- Hall-of-Fame vs non-HOF performance  
- Height and weight evolution across MLB history  
- Ballpark effects on performance and player profiles  
- Team-level athletic and handedness compositions  

---

## 8. Purpose

This repository serves both as:

1. A **portfolio-grade SQL project** demonstrating professional relational modelling, table creation, data loading, analytical view design, and advanced querying.  
2. A **deep exploration of MLB history**, covering salaries, careers, talent pipelines, physical traits, and postseason dynamics.

The layered design (schema → data import → analytic views → queries → EDA) reflects real-world analytics workflows.

---

## 9. License / Attribution

The Lahman Baseball Database is distributed under the  
**Creative Commons Attribution–ShareAlike 3.0 Unported License**.  
Details: https://creativecommons.org/licenses/by-sa/3.0/
