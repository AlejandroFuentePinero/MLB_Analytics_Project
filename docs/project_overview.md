# MLB Analytics Project — Overview (1871–2024)

This document provides a concise, high‑level overview of the MLB Analytics Project.  
Unlike the README—which serves as a full public-facing introduction—this overview explains the **purpose, structure, analytical flow, and design philosophy** of the project so that each SQL file, view, and notebook integrates cleanly without redundancy.

---

# 1. Project Purpose

The goal of this project is to build a **professional, modular SQL analytics workflow** using the Lahman Baseball Database (1871–2024).  
The project demonstrates:

- Clean relational schema construction  
- Analytical view design  
- Multi-step CTE pipelines  
- Window functions and advanced SQL logic  
- Reusable transformations (views → optimised queries)  
- Clear separation of core vs extended business questions  
- Optional Python visualisation for narrative clarity  

The project is a **guided analytics system** designed to model real database workflows.

---

# 2. Analytical Architecture

The project follows a structured pipeline:

1. **Schema Layer**  
   - Custom schema (`sql/schema.sql`) defines all base Lahman tables.  
   - Ensures consistent types, primary keys, and reproducible joins.

2. **Data Import Layer**  
   - Raw CSVs are loaded into the schema from `data/core/`.

3. **View Layer**  
   - Analytical views (`sql/views.sql`) create reusable components  
     for debut logic, salary logic, team payroll, physical profiles, and park regions.  
   - Views remove duplication across analysis files.

4. **Analysis Layer**  
   - Core questions (`sql/analysis_queries.sql`)  
     follow a step-by-step pedagogical structure.  
   - Answers each business question in a direct, transparent manner.

5. **Advanced Layer**  
   - Extended analyses (`sql/advanced_queries.sql`)  
     introduce more sophisticated logic, deeper insights, or multi-step pipelines.

6. **Optimised Layer**  
   - Performance‑oriented rewrites (`sql/optimised_queries.sql`)  
     rebuild key queries using the analytical views.  
   - Ensures modular, readable, production-grade SQL.

7. **EDA + Visualisation Layer**  
   - Optional Python notebook (`notebooks/exploration.ipynb`)  
     creates figures and interprets trends.

This layered design mirrors real analytics workflows in professional settings.

---

# 3. Relationship Between Project Files

This overview clarifies how all SQL files interact without overlapping:

## schema.sql  
Defines all base tables. Required before any data import or analysis.

## views.sql  
Defines reusable analytical transformations:
- Debut decade computation  
- Salary aggregation  
- Postseason team identification  
- Player career mappings  
- Physical profile views  
- Park region classification  

All optimised queries rely on these views.

## analysis_queries.sql  
Contains **core business questions**.  
Each query is self-contained and written from first principles  
(no reliance on analytical views).

## advanced_queries.sql  
Builds on the core analysis:  
- More complex logic  
- Multi-step CTEs  
- Additional business insights  
- Cross-sectional or longitudinal comparisons

These queries also avoid heavy view usage  
to maintain transparency.

## optimised_queries.sql  
Rewrites major queries using views.  
This file contains:
- Shorter  
- Cleaner  
- More efficient  
- Production-ready  

versions of queries from both analysis layers.

## business_questions.md  
Holds the written business narratives.  
Keeps SQL files code-focused.

## notebooks/exploration.ipynb  
Translates selected SQL outputs into figures and explanatory text.

---

# 4. Analytical Themes

The project is organised around four major analytical domains:

### Part I — Schools & Talent Pipelines  
Identifies which schools produce MLB players, how pipelines evolve, and where regional shifts occur.

### Part II — Salary & Payroll Dynamics  
Explores financial inequality, cumulative payroll milestones, and the link between spending and postseason outcomes.

### Part III — Career Trajectories  
Analyses debut ages, retirement patterns, career longevity, team loyalty, and Hall-of-Fame differences.

### Part IV — Physical Profiles & Comparative Analytics  
Examines how height, weight, handedness, league, position, and park geography relate to debut characteristics.

---

# 5. Design Philosophy

This project follows four core principles:

### 1. Modularity  
Views are used to avoid repeated logic and to support clean optimised queries.

### 2. Reproducibility  
A custom schema ensures consistent types and reliable joins for all analyses.

### 3. Transparency  
Core and advanced queries intentionally show the full, explicit logic  
so that readers can understand each analytical step.

### 4. Narrative Clarity  
The SQL outputs are complemented by a written business narrative  
and optional Python visualisations to tie analytical results together.

---

# 6. Intended Use

This overview allows contributors, reviewers, or future users to understand:

- How all project components fit together  
- Where each type of query belongs  
- How logic flows from raw data → views → analysis → visualisation  
- How to extend the project without breaking its modular structure

It also provides a clean high-level summary that complements the README without duplicating its detailed content.

---

# 7. Summary

The **Project Overview** is the architectural map of the MLB Analytics Project.  
It explains *how* the project works, *how* files relate to one another,  
and *why* it is organised in a layered, professional structure.

For full narratives and results, see `docs/business_questions.md`.  
For technical implementation, refer to the SQL files in `sql/`.  
For visuals and interpretation, use the notebook in `notebooks/`.