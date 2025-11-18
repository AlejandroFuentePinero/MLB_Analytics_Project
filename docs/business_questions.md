# Business Questions

This document defines the analytical questions addressed in the MLB Analytics Project.  

- Questions marked **(C)** come directly from the Udemy course project.  
- Questions marked **(advance query)** are additional portfolio-focused questions intended primarily for `advanced_queries.sql`.

---

# Part I — School / Talent Pipeline Analysis

**Q1.1 (C)** — Data Coverage  
How many MLB players in the database have at least one recorded college, and how many distinct schools appear in the data?

**Q1.2 (C)** — Schools by Debut Decade  
For each **debut decade**, how many schools produced at least one MLB player?

**Q1.3 (C)** — Top Producer Schools (All-Time)  
Which are the **top 5 schools** by total number of MLB players produced?

**Q1.4 (C)** — Top Schools per Decade  
For each debut decade, which **top 3 schools** produced the most players?

**Q1.5 (advance query)** — High-Impact Schools Since 1980  
Since 1980, which schools have produced the most players whose careers lasted **5+ seasons**?

**Q1.6 (advance query)** — Consistent Talent Pipelines  
Across all debut decades, which schools have produced MLB players in **at least 5 different decades**, and how many players did they produce in each of those decades?

**Q1.7 (advance query)** — Regional Talent Concentration  
Using school state/region, which states have the highest **per-decade growth** in MLB player production since 1950?

---

# Part II — Salary & Payroll Analysis

**Q2.1 (C)** — Salary Table Overview  
What is the year range and total record count in the `Salaries` table?

**Q2.2 (C)** — Top Spending Teams (20% Threshold)  
Which teams fall into the **top 20%** of average annual payroll spending?

**Q2.3 (C)** — Cumulative Payroll Over Time  
For each team, what is the **cumulative sum of payroll** across all available seasons?

**Q2.4 (C)** — First Billion-Dollar Year  
For each team, in which year did cumulative payroll first surpass **$1 billion**?

**Q2.5 (advance query)** — Payroll Stratification  
What is the ratio between the median team’s payroll and the average payroll of the top 20% teams?

**Q2.6 (advance query)** — Payroll vs Postseason Success  
From the start of the wildcard era (e.g. 1995) onward, how does a team’s **payroll rank** in a given year relate to whether they reached the **postseason**?  
- For each year, rank teams by payroll (1 = highest).  
- Compare the distribution of ranks for postseason vs non-postseason teams.

**Q2.7 (advance query)** — Overperformers: Small Payroll, Big Results  
Identify seasons where a team’s payroll is in the **bottom third** of the league, but the team still reached the **League Championship Series or World Series**. List those teams and seasons.

---

# Part III — Player Career Analysis

**Q3.1 (C)** — Player Count  
How many players exist in the `People` table?

**Q3.2 (C)** — Career Timelines  
For each player with complete data, calculate:  
- Age at first game  
- Age at last game  
- Career length (in years)  
Sort from longest to shortest career.

**Q3.3 (C)** — Starting & Ending Teams  
Which team did each player play for in their **debut season** and in their **final season**?

**Q3.4 (C)** — Loyal Long-Career Players  
How many players both:  
1. Played **10+ years**, and  
2. Started and ended their career on the **same team**?

**Q3.5 (advance query)** — Top Career Lengths  
List the **top 20 longest careers** with debut year, final year, starting team, and ending team.

**Q3.6 (advance query)** — Hall of Fame vs Non–Hall of Fame Careers  
Compare **career length** and **age at debut** between players who are inducted into the Hall of Fame (`inducted = 'Y'`) and those who are not.  
Summarise median values and distribution differences.

**Q3.7 (advance query)** — Primary Franchise of Hall of Famers  
For each Hall of Fame player, identify the team for which they played the **most games** over their career (primary franchise).  
Which franchises have the most Hall of Famers primarily associated with them?

---

# Part IV — Player Comparison & Physical Profiles

**Q4.1 (C)** — Data Completeness  
How complete are height, weight, and handedness (`bats`) data across the player population?

**Q4.2 (C)** — Shared Birthdays  
Which players share the same birthday, and which birthday is most common?

**Q4.3 (C)** — Team Handedness Composition  
For each team, what percentage of players bat **right**, **left**, or **both**?

**Q4.4 (C)** — Physical Traits at Debut  
How have **average height** and **average weight at debut** changed over time?

**Q4.5 (C)** — Decade-over-Decade Change  
For each debut decade, what is the Δ (change) in average height and weight relative to the previous decade?

**Q4.6 (advance query)** — Pitchers vs Non-Pitchers  
How do debut physical profiles (height and weight) compare between pitchers and non-pitchers?

**Q4.7 (advance query)** — Debut Profiles by Era and League  
Compare average debut height and weight between leagues (AL vs NL) across eras (e.g. pre-1960, 1960–1989, 1990–present).

**Q4.8 (advance query)** — Home Ballpark & Player Profile  
Using home ballpark information, classify parks into simple categories (e.g. high-altitude vs sea-level or by park characteristic).  
Do players debuting for teams in certain park categories differ systematically in average height or weight?

---

# Mapping to SQL Files

- Core (C) questions → implemented in `sql/analysis_queries.sql`  
- Questions marked **(advance query)** → implemented primarily in `sql/advanced_queries.sql`  
- Performance-tuned versions of any query → `sql/optimised_queries.sql`  
- Reusable logical components (views) → `sql/views.sql`

---

# Purpose of This Document

This list is the **source of truth** for the project’s analytical scope.  
Each question is traceable to a concrete SQL implementation and, where relevant, to supporting visualisations or narrative interpretation.


