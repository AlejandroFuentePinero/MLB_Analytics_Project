# MLB Analytics Project — Lahman Database (1871–2024)

This project explores long-term patterns in MLB player development, careers, salaries, talent pipelines, and postseason performance using the Lahman Baseball Database (1871–2024).  
It is designed as a **portfolio-ready SQL analytics project**, showcasing advanced SQL skills, modular analysis design, and optional Python-based EDA.

---

## 1. Overview

Using the Lahman Database (1871–2024), this project investigates four major themes:

- **Talent Pipelines** — Which colleges produce MLB players and how these patterns vary across decades.
- **Team Salary & Payroll Dynamics** — How payroll evolves, which teams spend the most, and how spending relates to postseason outcomes.
- **Career Trajectories** — Debut age, retirement age, career length distributions, and player loyalty to their first team.
- **Player Physical & Comparative Profiles** — How height, weight, and handedness vary across eras, teams, positions, and leagues.

Advanced analysis includes Hall of Fame comparisons, ballpark-factor effects, multi-era splits, and multi-step SQL models using window functions and chained CTEs.

---

## 2. Data Source

- **Dataset:** Lahman Baseball Database  
- **Version:** 2024 release (covering seasons 1871–2024)  
- **Website:** https://sabr.org/lahman-database/  
- **Repository Data Layout:**
  - `data/core/` — The core Lahman tables used in this project  
  - `data/extra/` — Additional Lahman tables not used in this project  
  - `readme2024u.txt` — Official Lahman dataset documentation

### PostgreSQL Import

All tables are imported into the **default `public` schema** of a PostgreSQL database.  
Raw tables are not modified or renamed.

Analytical objects (views) may optionally reside in a separate schema:

```sql
CREATE SCHEMA IF NOT EXISTS mlb_analytics;
```

Raw data remains in `public`.

---

## 3. Repository Structure

```
MLB_Analytics_Project/
│
├── data/
│   ├── core/                    # Core Lahman tables used in the project
│   ├── extra/                   # Additional Lahman tables not used in schema
│   └── readme2024u.txt          # Official Lahman dataset documentation
│
├── sql/
│   ├── schema.sql              # Project schema + optional summary objects
│   ├── views.sql               # Reusable analytic views
│   ├── analysis_queries.sql    # Core solutions to business questions
│   ├── advanced_queries.sql    # Extended/portfolio-level queries
│   └── optimised_queries.sql   # Performance-tuned versions of key queries
│
├── notebooks/
│   └── exploration.ipynb        # Optional Python EDA notebook
│
├── docs/
│   ├── project_overview.md      # Narrative overview of the project
│   ├── business_questions.md    # Core + advanced analytical questions
│   └── schema_design.md         # Documentation of schema and tables used
│
└── README.md                    # This file
```

---

## 4. Business Questions

The complete set of analytical questions is in:

```
docs/business_questions.md
```

Topics include:

- Player counts and debut patterns  
- Retirement age and career length analyses  
- College → MLB talent production rankings  
- Payroll evolution and cumulative spending milestones  
- Postseason performance vs payroll  
- Hall-of-Fame vs non-HOF comparisons  
- Height, weight, and handedness trends across eras  
- Team-level physical and handedness profiles  

Each question is labeled either:

- **(C)** — Core question  
- **(advanced query)** — Extended portfolio-level analytical question  

---

## 5. How to Run the Project

### A. Import Data into PostgreSQL

1. Create a PostgreSQL database (e.g., `lahman_2024` or `mlb_project`).
2. Import all CSVs from `data/core/` into the **public** schema.
3. (Optional) Create a schema for analysis views:
   ```sql
   CREATE SCHEMA mlb_analytics;
   ```
4. Load supporting objects:
   ```sql
   \i sql/schema.sql;
   \i sql/views.sql;
   ```

### B. Execute Analysis Queries

Use the SQL files in the `sql/` directory:

- `analysis_queries.sql` — Core business questions  
- `advanced_queries.sql` — Extended analyses  
- `optimised_queries.sql` — Performance-tuned versions  

These can be run using pgAdmin, DBeaver, Azure Data Studio, or psql.

### C. Optional Python EDA

Open:

```
notebooks/exploration.ipynb
```

Includes:

- SQL-to-pandas workflows  
- Visualisations of long-term MLB trends  
- Additional exploratory analysis  

---

## 6. Tools & Techniques Demonstrated

- Relational modelling and schema design  
- Multi-table joins  
- Window functions (RANK, LAG/LEAD, percentiles, running totals)  
- Chained CTEs for multi-stage analytical logic  
- Dedicated analytics schema design  
- Career and salary modelling  
- Cross-era and cross-league comparative analysis  
- SQL + Python integration  
- Performance optimisation (EXPLAIN/ANALYZE)  

---

## 7. Key Findings  
(*To be completed after analysis*)  

Examples of expected insights include:

- How college talent pipelines shift across decades  
- Payroll inequality and spending dynamics  
- Changes in debut age and career length over time  
- Hall-of-Fame vs non-HOF career differences  
- Height and weight trends across eras  
- Ballpark characteristics shaping player profiles  
- Team-level physical and handedness patterns  

---

## 8. Purpose

This repository is both:

1. A **portfolio-grade SQL project**, demonstrating end-to-end mastery of data ingestion, modelling, querying, and interpretation.  
2. A **deep analytical exploration** of 150+ years of MLB history across salaries, careers, talent pipelines, physical profiles, and postseason outcomes.

The project architecture mirrors professional analytics workflows using a layered structure (raw data → views → analysis queries → optional EDA).

---

## 9. License / Attribution

The Lahman Baseball Database is distributed under the **Creative Commons Attribution–ShareAlike 3.0 Unported License**.  
License details: https://creativecommons.org/licenses/by-sa/3.0/
