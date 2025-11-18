# MLB Analytics Project – Lahman Database (1871–2024)

## Overview

This project uses the **Lahman Baseball Database (1871–2024)** to explore long-term patterns in MLB player development, team spending, and player career trajectories.  
The aim is to demonstrate clean, well-structured SQL analytical workflows using joins, CTEs, window functions, and reusable views, supported by light EDA in Python.

The project is organised into four analytical themes:

- **Part I — School / Talent Pipeline Analysis:**  
  Which colleges produce the most MLB players, and how has this changed across decades?

- **Part II — Salary & Payroll Dynamics:**  
  How do teams differ in annual payroll spending, and when do teams surpass major cumulative salary milestones?

- **Part III — Player Career Analysis:**  
  How long do MLB careers last, at what ages do players debut/retire, and how loyal are players to their first team?

- **Part IV — Player Comparison & Physical Profiles:**  
  How do player attributes (handedness, height, weight) vary by team and across time?

The project focuses on building transparent, modular SQL pipelines backed by well-documented queries, views, and clear business questions.  
It includes both core analytical tasks and deeper, extended questions that leverage the full breadth of the Lahman dataset to produce portfolio-grade insights.

---

## Data Source

- **Dataset:** Lahman Baseball Database  
- **Version:** 2024 update (1871–2024 seasons)  
- **Website:** https://sabr.org/lahman-database/  
- **Contents:** Historical MLB player, team, salary, school, and gameplay data.

The project works directly on the raw Lahman schema (no restructuring), with all transformations implemented as views under the custom schema `mlb_analytics`.

---

## Project Structure

The repository follows a clean analytical structure:

- `sql/schema.sql` — Project schema and (optional) summary objects  
- `sql/views.sql` — Reusable views (career summaries, team salary aggregates, debut profiles, etc.)  
- `sql/analysis_queries.sql` — Core queries answering each business question  
- `sql/advanced_queries.sql` — Alternative or extended solutions  
- `sql/optimised_queries.sql` — Performance-tuned versions of selected queries  
- `notebooks/exploration.ipynb` — Python-based EDA and visualisations  
- `docs/` — Full documentation (business questions, schema notes, overview)

This separation mirrors professional data-analytics workflows and keeps exploratory work, final solutions, and reusable logic clearly decoupled.

---

## Analytical Themes

### Part I — School / Talent Pipeline
Explores which colleges produce professional players, tracks decade-by-decade shifts, and identifies the most prolific talent pipelines in MLB history.

### Part II — Salary & Payroll Dynamics
Analyses annual payrolls, long-term spending trends, cumulative franchise spending, and the financial stratification of MLB teams.

### Part III — Player Career Trajectories
Derives ages at debut/retirement, calculates career length, identifies starting and ending teams, and quantifies how many players maintain team loyalty across long careers.

### Part IV — Player Profiles & Comparisons
Investigates shared birthdays, team-level batting handedness distributions, and decade-level changes in player physical attributes at debut.

---

## Tools and Techniques

The project showcases:

- Multi-table joins & relational exploration  
- CTEs for multi-stage logic  
- Window functions: ranking, percentiles, running totals, decade comparisons  
- Logical view design for reusable transformations  
- Optional Python EDA (pandas + matplotlib) for communicating key findings

This combination reflects real analytical workflows: SQL for transformation + Python for visualisation.

---

## Key Findings (to be filled after analysis)

A brief summary of insights will be added here once the analysis is complete.  
Examples may include:

- Leading colleges by MLB player production since the 1980s  
- Financial disparities between top-spending and median-spending teams  
- Distribution of career lengths and typical debut/retirement ages  
- Trends in player height/weight at debut across decades  
- Team-by-team handedness profiles

---

## Purpose

This project serves as both:

1. **A portfolio-ready demonstration of SQL proficiency**, and  
2. **A genuine exploratory analysis** of MLB’s long-term evolution.

It highlights best practices in structuring analytical SQL projects, documenting business questions, and delivering interpretable results.
