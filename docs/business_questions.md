# Business Questions

This document defines the analytical questions addressed in the MLB Analytics Project.  

- Questions marked **(C)** come directly from the Udemy course project.  
- Questions marked **(advance query)** are additional portfolio-focused questions intended to expand on more advanced query techniques.

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

Using school locations, I tracked how many MLB players each U.S. state produced per debut decade from 1950 onward and then fitted a linear trend to quantify “per-decade growth” in player output. The strongest growth is concentrated in **California**, **Texas**, and **Florida**, with California adding on average about **17 more MLB players per decade**, and Texas and Florida each adding roughly **13**. A second tier of fast-growing states includes **South Carolina**, **Louisiana**, **North Carolina**, **Georgia**, and **Oklahoma**, all with clearly positive slopes. In contrast, several historically important baseball states in the Northeast and Midwest—such as **New York**, **Michigan**, and **Minnesota**—show flat or even negative trends, indicating that relative talent production has shifted toward the Sun Belt and West over the post-1950 era.

---

# Part II — Salary & Payroll Analysis

**Q2.1 (C)** — Salary Table Overview  
What is the year range and total record count in the `Salaries` table?

The `Salaries` table contains **26,428 total records** covering the years **1985 to 2016**.  
This provides a 30+ year window of modern MLB salary data, giving enough temporal depth to analyze payroll evolution, compare spending patterns across eras, and ground later salary-related insights in a well-defined historical range.

**Q2.2 (C)** — Top Spending Teams (20% Threshold)  
Which teams fall into the **top 20%** of average annual payroll spending?

To identify the league’s highest-spending organizations, I calculated each franchise’s average annual payroll across all seasons and ranked teams into five equal-sized groups. The top 20% includes clubs such as the Angels, Yankees, Red Sox, Nationals, and Dodgers—organizations that consistently invest far more in player salaries than the rest of the league. These teams anchor the financial upper tier of MLB and typically operate with significantly greater payroll capacity year after year.

**Q2.3 (C)** — Cumulative Payroll Over Time  
For each team, what is the **cumulative sum of payroll** across all available seasons?

I first calculated each franchise’s total historical payroll by summing all recorded salaries across the entire dataset. This provides a consolidated view of long-term financial investment by each team, independent of how payroll fluctuated year to year.

The results show a steep hierarchy in total spending. The New York Yankees lead by a wide margin with more than **$3.7 billion** in total recorded payroll, followed by the Boston Red Sox (**$2.8B**), Los Angeles Dodgers (**$2.67B**), New York Mets (**$2.25B**), San Francisco Giants (**$2.18B**), and Philadelphia Phillies (**$2.15B**). At the other end of the spectrum, historically lower-spending clubs such as the Montreal Expos (**$408M**), Miami Marlins (**$339M**), California Angels (pre-rebranding, **$272M**), and Milwaukee Brewers’ early franchise code ML4 (**$234M**) show total outlays an order of magnitude smaller. 

This simple cumulative view highlights long-term structural differences between large-market and small-market organizations.

In the advanced analysis, I also computed cumulative payroll **over time** using a window function, allowing us to track how quickly each franchise accumulated spending and to identify milestones such as the first $1 billion season for each club. The core answer above uses the simpler “total across all seasons” interpretation, while the advanced version adds temporal insight into each team’s spending trajectory.

**Q2.4 (C)** — First Billion-Dollar Year  
For each team, in which year did cumulative payroll first surpass **$1 billion**?

By tracking cumulative payroll spending over time, I identified the first season in which each franchise exceeded the $1 billion milestone. Large-market and historically high-spending teams reached this threshold earlier, with the Yankees surpassing $1B as early as 2003 and the Red Sox in 2004. Mid-market teams generally crossed the line between 2007 and 2012, while lower-spending franchises did so even later. This pattern highlights long-term financial disparities across MLB and how resources have accumulated unevenly over the modern era.

**Q2.5 (advance query)** — Payroll Stratification  
What is the ratio between the median team’s payroll and the average payroll of the top 20% teams?

Across all franchises, the median team’s average annual payroll is approximately **$60.3 million**, compared with **$90.5 million** for the top 20% of highest-spending teams. This yields a ratio of **0.67**, meaning the typical MLB team operates with only about **two-thirds of the financial resources** available to the league’s biggest spenders. This reveals a pronounced stratification in payroll capacity, where a small group of large-market teams maintain a significant financial advantage over the league median.

**Q2.6 (advance query)** — Payroll vs Postseason Success  
From the start of the wildcard era (e.g. 1995) onward, how does a team’s **payroll rank** in a given year relate to whether they reached the **postseason**?  
- For each year, rank teams by payroll (1 = highest).  
- Compare the distribution of ranks for postseason vs non-postseason teams.

To evaluate how financial strength translates into postseason success, I focused on the wildcard era (1995–2016). First, I identified the highest-payroll team in each season and checked whether it reached the postseason. Across 22 seasons, the top-payroll team qualified for October baseball in **17 seasons** and missed in **5**, meaning the #1 payroll club reached the postseason about **77% of the time**. This confirms that extreme payroll levels greatly increase a team’s likelihood of playing in the postseason, though they do not guarantee a playoff spot.

I then examined the full distribution of payroll ranks among postseason teams. Using team-level payroll rank within each year (1 = highest), I counted how many postseason team-seasons came from each rank. The results show a strong skew toward higher payrolls: the top **5** ranks together accounted for **56** postseason team-seasons (around **30%** of all postseason slots), and the top **10** ranks produced **104** postseason team-seasons (roughly **56%**). In contrast, the bottom third of the payroll table (ranks 21–30) produced only **28** postseason team-seasons (about **15%**), and no team ranked 30th in payroll reached the postseason during this period. Overall, postseason baseball is dominated by higher-spending teams, but there is still meaningful room for lower-payroll clubs to reach October, highlighting both the power and the limits of financial advantage.

**Q2.7 (advance query)** — Overperformers: Small Payroll, Big Results  
Identify seasons where a team’s payroll is in the **bottom third** of the league, but the team still reached the **League Championship Series or World Series**. List those teams and seasons.

To identify cases where a team significantly outperformed its financial resources, I flagged teams in the bottom third of league payroll each season and checked whether they reached the League Championship Series (ALCS/NLCS) or the World Series. This produced a focused list of genuine “small-payroll overperformers.”

Across the full dataset, only a small set of low-payroll clubs reached the LCS or beyond. Examples include the 1985 Blue Jays, 1986 Astros, 1987 Giants and Twins, 1989 Cubs, 1990 Reds, 1991 Braves, 2002 Twins, 2003 Marlins, 2006 Athletics, 2007 Guardians/Indians, Rockies, and Diamondbacks, 2008 Rays, 2010 Rangers, 2014 Royals, 2015 Mets, and 2016 Guardians/Indians. These seasons stand out as clear outliers where modest payrolls were converted into deep postseason runs, highlighting that while money strongly shapes outcomes, it does not fully determine them.

---

# Part III — Player Career Analysis

**Q3.1 (C)** — Player Count  
How many players exist in the `People` table?

The database contains 24,023 unique MLB players.

**Q3.2 (C)** — Career Timelines  
For each player with complete data, calculate:  
- Age at first game  
- Age at last game  
- Career length (in years)  
Sort from longest to shortest career.

For players with complete birth and game dates, this query builds a per-player profile of **career timing** in MLB. It calculates each player’s age at debut, age at their final MLB appearance, and the total length of their MLB career, then orders everyone by career length. The top of the result set highlights a small group of players with **exceptionally long careers spanning multiple decades**, while further down I see the far more common pattern of careers lasting only a few seasons. This contrast between multi-decade veterans and short-tenure players gives immediate intuition about how skewed MLB career longevity is. The resulting table is a reusable foundation for later analyses on how debut age relates to longevity, how retirement ages are distributed, and which players stand out as outliers in terms of career duration.

**Q3.3 (C)** — Starting & Ending Teams  
Which team did each player play for in their **debut season** and in their **final season**?

This query identifies the team or teams each MLB player appeared for in their debut season and in their final season. Using the `People` table, I extract each player’s debut and final game years, then join these to the season-level `Appearances` data to find the corresponding team IDs. The result shows, for every player with both a debut and final game recorded, where they first entered the league and where they played their last MLB season. Players who switched teams within their debut or final season appear multiple times, reflecting all teams they played for in those years rather than forcing a single “primary” team. This output provides a foundation for later questions on franchise loyalty, player mobility, and how careers begin and end across different teams.

**Q3.4 (C)** — Loyal Long-Career Players  
How many players both:  
1. Played **10+ years**, and  
2. Started and ended their career on the **same team**?

To identify long-tenured, highly loyal players, I combined career duration with franchise consistency. A player qualifies if they played at least 10 years (based on debut and final season) and if the team they debuted with matches the team they ended their career on. Using the season-level `Appearances` data to determine each player’s debut and final-season teams, I found **422 players** who meet both criteria. These players represent a small but notable subset of MLB history: individuals who achieved long careers while remaining tied to the same franchise from start to finish. This group forms an interesting counterpoint to the more common pattern of frequent trades and late-career team changes.

**Q3.5 (advance query)** — Top Career Lengths  
List the **top 20 longest careers** with debut year, final year, starting team, and ending team.

Using the unified career timeline view, I identified the 20 longest MLB careers by calendar-year span. The longest careers extend more than three decades, led by players like Al Orth (35 years) and Jim O’Rourke (32 years), with others such as Minnie Miñoso and Nolan Ryan illustrating how both early-era and modern players can produce exceptionally long tenures. The output also shows how often these players changed franchises over such extended periods, with only a handful beginning and ending on the same team. This result highlights the extreme right tail of MLB career longevity and provides context for evaluating typical vs. exceptional career arcs in later analyses.

**Q3.6 (advance query)** — Hall of Fame vs Non–Hall of Fame Careers  
Compare **career length** and **age at debut** between players who are inducted into the Hall of Fame (`inducted = 'Y'`) and those who are not.  
Summarise median values and distribution differences.

Using complete biographical and career-timeline data, I compared age at debut and total career length between Hall of Fame inductees and all non-inducted players. Hall-of-Famers debut significantly earlier, with a median age of around 21.6 years, compared to 23.8 years for non-HOF players. Career length differences are even more pronounced: the median Hall-of-Fame career spans roughly 17.2 years, while non-HOF players average only about 5.3 years. Both groups include extreme long-career outliers (30+ years), showing that longevity alone does not guarantee induction, but the overall distribution confirms that early entry into MLB and sustained career duration strongly correlate with HOF membership. This analysis highlights the structural differences between elite careers and typical MLB trajectories.

**Q3.7 (advance query)** — Primary Franchise of Hall of Famers  
For each Hall of Fame player, identify the team for which they played the **most games** over their career (primary franchise).  
Which franchises have the most Hall of Famers primarily associated with them?

To identify the primary franchise of each Hall of Famer, I summed every type of appearance recorded in the `Appearances` table to estimate total games played for each team across a player’s career. I then ranked teams per player and selected the franchise for which they accumulated the most games. After filtering to Hall-of-Fame inductees, I counted how many players were primarily associated with each franchise. The results show a clear hierarchy: the New York Yankees (NYA) lead all franchises with 24 Hall of Famers whose longest tenures occurred with the team. They are followed by the St. Louis Cardinals (SLN), Chicago White Sox (CHA), Chicago Cubs (CHN), and Pittsburgh Pirates (PIT). This pattern reflects both historical success and the long-standing ability of these franchises to attract and retain elite players.

---

# Part IV — Player Comparison & Physical Profiles

**Q4.1 (C)** — Data Completeness  
How complete are height, weight, and handedness (`bats`) data across the player population?

The physical-profile fields in the Lahman database are highly complete. Height data is recorded for roughly **92%** of players, weight for **91%**, and batting handedness for **about 88%**. This strong level of coverage provides confidence in the analyses that follow, especially comparisons across positions, leagues, and eras. Because missing values are limited and broadly distributed across MLB history, the dataset offers a reliable foundation for understanding player body characteristics and batted-hand tendencies without major bias introduced by data gaps.

**Q4.2 (C)** — Shared Birthdays  
Which players share the same birthday, and which birthday is most common?

Many MLB players share birthdays with at least one other player. Using all players with complete birth dates, there are **5,271 unique unordered pairs** of players who were born on the same calendar day. When summarising birthdays by date, the most common birthdays are each shared by **six players**, with several different dates tied at this level rather than a single dominant “MLB birthday.” Overall, shared birthdays are fairly evenly dispersed across the calendar, suggesting no meaningful clustering in player birth dates beyond what we would expect by chance.

**Q4.3 (C)** — Team Handedness Composition  
For each team, what percentage of players bat **right**, **left**, or **both**?

Across MLB teams, right-handed hitters clearly dominate roster construction. Averaging across all franchises, roughly **68%** of players bat right-handed, around **26%** bat left-handed, and only **6%** are switch hitters. At the team level, most clubs fall within this same range, typically featuring **60–75% right-handed hitters**, **25–35% left-handers**, and **5–10% switch hitters**. These patterns reflect the long-standing tendency for MLB lineups to be right-heavy, with left-handed and switch hitters forming a consistent but much smaller portion of the talent pool.

**Q4.4 (C)** — Physical Traits at Debut  
How have **average height** and **average weight at debut** changed over time?

Average debut height and weight have both increased across MLB history, but at different rates. Players in the 1870s–early 1900s debuted at roughly **5'8"–5'10"** and **155–175 lbs**, reflecting the smaller physical profiles of early professional baseball. Heights rose steadily into the early 20th century and stabilised around **6'0"–6'1"** by the 1930s, remaining remarkably consistent thereafter. Weight, however, continued rising: from **~180 lbs** in the 1940s to **190–200 lbs** in the 1970s, and exceeding **200 lbs** from the 1990s onward. Modern debuting players average around **73.5 inches (6'1")** and **205–212 lbs**, making them significantly heavier—but not much taller—than players from earlier eras. These patterns indicate that MLB’s physical evolution has been driven far more by increases in strength and mass than by changes in height.

**Q4.5 (C)** — Decade-over-Decade Change  
For each debut decade, what is the Δ (change) in average height and weight relative to the previous decade?

Looking at debut physical traits by decade confirms that MLB players have grown heavier much more than they have grown taller. From the 1870s to the early 1900s, average debut weight typically increases by **1–6 lbs per decade**, with occasional flat or slightly negative decades such as the 1910s. A clear step change occurs in the 1930s, followed by another strong jump between the 1980s and 1990s, and an especially large increase from the 1990s to the 2000s (over **+10 lbs** in one decade). In contrast, average debut height changes only by **0.1–0.7 inches** per decade, with the largest gains early in the 20th century and very small changes after the 1950s as heights stabilise around **6'1"–6'2"**. Overall, the decade-over-decade pattern shows that the modern MLB player has become progressively heavier across eras, while height has largely plateaued since the mid-20th century.

**Q4.6 (advance query)** — Pitchers vs Non-Pitchers  
How do debut physical profiles (height and weight) compare between pitchers and non-pitchers?

Comparing debut physiques between pitchers and non-pitchers shows a clear physical specialization for the pitching role. Players who ever appear as pitchers debut at an average of roughly **73.1 inches (6'1")** and **192 lbs**, while non-pitchers average about **71.4 inches (just under 5'11½")** and **183 lbs**. In other words, pitchers are around **1.5–2 inches taller** and almost **10 lbs heavier** at debut than position players. This gap suggests that MLB teams consistently favour larger, more physically imposing bodies on the mound, even before any major-league performance data are available.

**Q4.7 (advance query)** — Debut Profiles by Era and League  
Compare average debut height and weight between leagues (AL vs NL) across eras (e.g. pre-1960, 1960–1989, 1990–present).
 
To compare how player physiques differed between the American League (AL) and National League (NL), we matched each player to the team and league they debuted with and grouped their debut height and weight into three broad eras (pre-1960, 1960–1989, 1990–present). The results show that AL and NL players are physically almost indistinguishable in every era. Both leagues experience the same long-term trend: modest increases in height and substantial increases in weight across the century. The modern era (1990–present) shows the largest jump, with debuting players averaging over **205 lbs** and **73.6 inches**, much larger than their pre-1960 counterparts.

**Q4.8 (Advanced) — Home Ballpark & Player Profile**  
Do debut physical profiles vary depending on the geographic region of a player’s first MLB home ballpark?
Compare average debut height and weight for players whose first team belongs to each region to see if any systematic differences emerge.

To evaluate whether debut player physiques vary with the geographic region of a team’s home ballpark, each park was assigned to a broad region (Northeast, Midwest, South, West, or International) based on its city and state. We then matched players to the park used by their debut team in their debut season and compared average debut height and weight across these regions.

The results show modest but consistent regional differences. Players debuting in the **West** and in **International** parks (e.g., Toronto, Montreal) are the largest on average, typically around **73.2–73.3 inches** and **197+ lbs**. The **South** also produces relatively large debuting players (≈72.9 inches, 194.5 lbs). In contrast, debut players in the **Northeast** and **Midwest** tend to be smaller, averaging **71.6–72.2 inches** and **≈181–186 lbs**. These differences are not dramatic, but they suggest that regional scouting and developmental pipelines may shape slight variations in the physical profiles of players entering MLB.

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


