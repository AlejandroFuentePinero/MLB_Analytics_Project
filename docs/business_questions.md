# Business Questions

This document defines the analytical questions addressed in the MLB Analytics Project.  

- Questions marked **(C)** come directly from the Udemy course project.  
- Questions marked **(advance query)** are additional portfolio-focused questions intended primarily for `advanced_queries.sql`.

---

# Part I — School / Talent Pipeline Analysis

**Q1.1 (C)** — Data Coverage  
How many MLB players in the database have at least one recorded college, and how many distinct schools appear in the data?

Using the `people` table, there are **24,023** distinct MLB players in the database. Of these, **6,869 players** have at least one recorded college in the `collegeplaying` data (via the `v_player_school` view), meaning roughly **28–29%** of players have an associated college record, while the remaining **17,154** do not. Across all players with recorded college data, there are **1,122 distinct schools** that have produced at least one MLB player, giving us a reasonably broad—but far from complete—coverage of the historical college-to-MLB pipeline.

**Q1.2 (C)** — Schools by Debut Decade  
For each **debut decade**, how many schools produced at least one MLB player?

Linking each player’s MLB debut year with all colleges they attended shows how the breadth of the college-to-MLB pipeline has changed over time. The number of schools represented rises steadily from just **11 schools** in the 1870s to a peak of around **470 schools** for players debuting in the **1990s**, reflecting the expansion and diversification of collegiate baseball. The counts decline slightly in the 2000s and more sharply in the 2010s, largely because modern MLB rosters include more international players, high-school draftees, and athletes from non-collegiate development pathways, resulting in fewer players with recorded college data in recent decades.

**Q1.3 (C)** — Top Producer Schools (All-Time)  
Which are the **top 5 schools** by total number of MLB players produced?

Counting how many distinct MLB players attended each college shows a clear hierarchy of powerhouse programs. The top five schools by total MLB players produced are **Texas**, **USC**, **Arizona State**, **Stanford**, and **Michigan**, with Texas alone sending just over a hundred players to the majors. These programs stand out as long-term talent pipelines, consistently contributing a large share of MLB-calibre players across eras.

**Q1.4 (C)** — Top Schools per Decade  
For each debut decade, which **top 3 schools** produced the most players?

Ranking schools within each MLB debut decade shows how a small group of collegiate programs consistently sit at the top of the talent pipeline. Across most decades from the mid-20th century onward, schools like **Texas**, **USC**, and **Arizona State** regularly appear among the top three producers of MLB players, often joined by other major Division I programs in specific eras. Earlier decades feature fewer and more regionally concentrated schools, whereas later decades show a broader mix of institutions reaching the top ranks. This pattern highlights both the long-term dominance of a handful of powerhouse programs and the gradual diversification of the college systems contributing players to MLB.

**Q1.5 (advance query)** — High-Impact Schools Since 1980  
Since 1980, which schools have produced the most players whose careers lasted **5+ seasons**?

Focusing on players who debuted from 1980 onwards and went on to play at least **five MLB seasons** highlights a smaller set of truly high-impact college programs. The leading schools by this measure are **Arizona State** (38 such players), **UCLA** (35), **USC** (33), **LSU** (32), and **Texas** (28). Compared with all-time counts, this filters out short or marginal careers and shows which programs have most consistently produced players who not only reach the majors but also stay there long enough to establish substantial MLB careers.

**Q1.6 (advance query)** — Consistent Talent Pipelines  
Across all debut decades, which schools have produced MLB players in **at least 5 different decades**, and how many players did they produce in each of those decades?

Restricting attention to schools that have produced MLB players in **five or more different debut decades** reveals two broad patterns. First, a cluster of historically rooted programs show **very long continuity**: schools such as **Michigan**, **Brown**, **Holy Cross**, **Fordham**, **Princeton**, and **Penn State** appear from the late 19th or early 20th century and continue to send players to the majors well into the 2000s. Their decade-by-decade counts fluctuate, but they rarely disappear entirely, indicating deep, enduring baseball traditions.

Second, a group of **modern powerhouse programs** emerge strongly from the 1960s onward, with sustained or growing output across recent decades. Examples include **Arizona**, **Arizona State**, **LSU**, **Miami (FL)**, **Florida**, **Florida State**, **Oklahoma**, **Oklahoma State**, **Georgia Tech**, **Clemson**, **Long Beach State**, **Rice**, and **South Carolina**. These schools typically have modest representation in early decades (or none at all), followed by large spikes in the 1980s–2010s, reflecting the rise of major Division I programs as primary feeders into MLB. Together, these patterns highlight how the college-to-MLB pipeline has shifted from a small number of early historically established universities to a broad landscape dominated by modern baseball-focused institutions, while a handful of legacy schools have remained consistently present across more than a century of professional baseball.

**Q1.7 (advance query)** — Regional Talent Concentration  
Using school state/region, which states have the highest **per-decade growth** in MLB player production since 1950?

Using school locations, we tracked how many MLB players each U.S. state produced per debut decade from 1950 onward and then fitted a linear trend to quantify “per-decade growth” in player output. The strongest growth is concentrated in **California**, **Texas**, and **Florida**, with California adding on average about **17 more MLB players per decade**, and Texas and Florida each adding roughly **13**. A second tier of fast-growing states includes **South Carolina**, **Louisiana**, **North Carolina**, **Georgia**, and **Oklahoma**, all with clearly positive slopes. In contrast, several historically important baseball states in the Northeast and Midwest—such as **New York**, **Michigan**, and **Minnesota**—show flat or even negative trends, indicating that relative talent production has shifted toward the Sun Belt and West over the post-1950 era.

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


