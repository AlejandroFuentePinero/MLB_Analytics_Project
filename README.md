# MLB Analytics Project — Lahman Database (1871–2024)

This project explores long-term patterns in MLB player development, salaries, careers, and physical characteristics using the Lahman Baseball Database (1871–2024).  
It demonstrates relational modelling, analytical views, window functions, multi-step CTE pipelines, and Python-based EDA.

---

# 1. Overview

The project investigates four major analytical themes:

- Talent Pipelines — Which colleges produce MLB players, and how this has changed over time and geography.  
- Team Salary & Payroll Dynamics — How payroll evolves, which teams invest most heavily, and how spending relates to postseason performance.  
- Career Trajectories — Debut age, retirement age, career longevity, and the degree of team loyalty.  
- Player Physical & Comparative Profiles — How height, weight, and handedness vary across eras, positions, leagues, and regions.

Advanced components include Hall of Fame comparisons, debut-to-final-team mapping, salary inequality metrics, era splits, and geography-linked physical analyses.

---

# 2. Data Source

Dataset: Lahman Baseball Database  
Version: 2024 release (1871–2024)  
Website: https://sabr.org/lahman-database/

Repository data layout:

- data/core/ — Core Lahman CSV tables used in this project  
- data/extra/ — Supplementary tables (not used) 
- data/output/ - SQL outputs used for visualisation in the notebook. 
- readme2024u.txt — Official data documentation  

PostgreSQL setup:  
Tables are created manually using sql/schema.sql.  
Run this before loading data:

```
sql/schema.sql;
```

Analytical views may be stored in an optional schema:

```
CREATE SCHEMA IF NOT EXISTS mlb_analytics;
```

---

# 3. Repository Structure

```
MLB_Analytics_Project/
│
├── data/
│   ├── core/                    # Core CSV tables
│   ├── extra/                   # Unused additional tables
│   ├── output/                  # SQL output tables
│   └── readme2024u.txt          # Official documentation
│
├── sql/
│   ├── schema.sql               # Table creation
│   ├── views.sql                # Analytical views
│   ├── analysis_queries.sql     # Core business queries
│   ├── advanced_queries.sql     # Extended analysis
│   └── optimised_queries.sql    # View-based refined versions
│
├── docs/
│   ├── project_overview.md      
│   ├── business_questions.md    
│   └── schema_design.md         
│
├── notebooks/
│   └── mlb_visual_analysis.ipynb # EDA notebook
│
└── README.md                    # This file
```

---

# 4. Business Questions

All questions analysed are documented in:

```
docs/business_questions.md
```

Topics include:

- College-to-MLB pipelines  
- Debut & retirement age distributions  
- Career length modelling  
- Salary trends & payroll inequality  
- Postseason success vs financial investment  
- Hall of Fame vs non-HOF comparisons  
- Physical traits across eras, leagues, and positions  
- Ballpark geography and debut profiles  

Questions follow the convention:

- (C) — Core question  
- (advance query) — Extended portfolio analysis  

---

# 5. How to Run the Project

### A. Create All Tables

Build an empty PostgreSQL database, then:

```
sql/schema.sql;
```

### B. Import CSV Data

Load each CSV in data/core/ into its corresponding table.  
Ensure header rows and delimiter settings are correct.

### C. Create Analytical Views

```
sql/views.sql;
```

This generates reusable analytical views.

### D. Run Queries

Execute:

- sql/analysis_queries.sql
- sql/advanced_queries.sql
- sql/optimised_queries.sql

### E. Python EDA

Open:

```
notebooks/mlb_visual_analysis.ipynb
```

Includes pandas–SQL integration and long-term visualisations.

---

# 6. Tools & Techniques Demonstrated

- Manual relational schema creation  
- Analytical view design  
- Window functions (RANK, PERCENTILE, LAG/LEAD)  
- Multi-step CTE pipelines  
- Joining multi-table baseball records  
- SQL performance tuning  
- SQL + Python EDA workflows  

---

# 7. Integrated Project Summary & Key Findings

This project builds a multi-layered, data-driven narrative of MLB’s evolution, spanning origins, economics, career outcomes, and physical traits. Although split into four sections, the analysis forms a continuous story about talent, opportunity, and athletic change.

---

## Part I — Schools and MLB Talent Pipelines

Part I examines where MLB players come from and how the collegiate pipeline has changed across time.

### Key Findings
- Around 28 percent of MLB players have a documented college affiliation, spread across 1,100+ schools, indicating a large and decentralised talent system.  
- School representation increases sharply after 1950, driven by the growth of collegiate baseball and improved scouting.  
- Geographic patterns shift: early talent comes primarily from the Northeast and Midwest, while modern pipelines favour the South and West.  
- Schools with established baseball programs tend to produce more players and longer MLB careers.

<p align="center">
  <img src="images/q1_7.png" width="600">
</p>

---

## Part II — Salary, Payroll Evolution, and Competitive Dynamics

Part II examines the financial landscape players enter as professionals.

### Key Findings
- The salary dataset (1985–2016) captures the modern era of escalating team budgets.  
- The New York Yankees maintain a historic lead in cumulative payroll spending.  
- Other high-spending teams (Red Sox, Dodgers, Mets) invest heavily but do not match the Yankees' multi-decade consistency.  
- The median payroll is roughly two-thirds of the top-tier payrolls, indicating structural financial inequality.  
- Postseason success is closely associated with higher payrolls.

<p align="center">
  <img src="images/q2_6.png" width="600">
</p>


---

## Part III — Career Trajectories, Longevity, and Team Loyalty

Part III explores what happens after players reach MLB.

### Key Findings
- MLB careers are typically short, with only a minority sustaining decade-long tenures.  
- Hall of Fame players debut younger, play longer, and accumulate more games than non-inductees.  
- Team mobility is common; relatively few players spend their entire career with one franchise.  
- Historically stable franchises anchor many long-tenured players.

<p align="center">
  <img src="images/q3_2.png" width="600">
</p>

---

## Part IV — Player Comparison and Physical Profiles

Part IV focuses on athletic traits and debut context.

### Key Findings
- Height and weight data are over 90 percent complete.  
- Average debut height has risen from about 5 ft 8 in to more than 6 ft 1 in, with weight increases even larger.  
- Pitchers debut slightly taller and heavier than non-pitchers.  
- AL and NL players show nearly identical physical profiles in each era.  
- Geographic patterns show players debuting in western or international parks tend to be slightly larger on average.

<p align="center">
  <img src="images/q4_4.png" width="600">
</p>


---

# Integrated Narrative

Across all sections, a coherent picture emerges:

1. The MLB talent pipeline has broadened geographically and institutionally.  
2. Team financial capacity strongly shapes opportunity and competitive landscapes.  
3. Career outcomes depend on early debut age, longevity, mobility, and organisational context.  
4. Physical traits have evolved alongside strategic, developmental, and economic changes.

Together, these insights provide a comprehensive view of MLB’s evolution, from origins to opportunity, from financial investment to career trajectory, and from physical development to long-term outcomes.

---

# 8. Purpose

This repository serves as both:

1. A portfolio-grade SQL project demonstrating professional relational modelling, advanced query design, analytical view architecture, and performance optimisation.  
2. A substantive exploration of MLB history, spanning salaries, careers, development systems, physical traits, and postseason dynamics.

---

# 9. License / Attribution

The Lahman Baseball Database is distributed under the  
Creative Commons Attribution–ShareAlike 3.0 Unported License:  
https://creativecommons.org/licenses/by-sa/3.0/
