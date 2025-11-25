-- ------------------------------------------
-- Part I — School / Talent Pipeline Analysis
-- ------------------------------------------

-- Q1.5
-- Since 1980, which schools have produced the most players whose MLB careers
-- lasted at least 5 seasons?
-- Uses v_player_seasons (career seasons) and v_player_school (school mapping)

WITH players_5plus AS (
    SELECT
        ps.playerid,
        ps.num_seasons
    FROM v_player_seasons AS ps
    WHERE ps.num_seasons >= 5
),
players_5plus_schools AS (
    SELECT
        p5.playerid,
        vps.schoolid
    FROM players_5plus AS p5
    INNER JOIN v_player_school AS vps
        ON p5.playerid = vps.playerid
),
players_5plus_since_1980 AS (
    SELECT
        p5s.playerid,
        p5s.schoolid
    FROM players_5plus_schools AS p5s
    INNER JOIN people AS p
        ON p5s.playerid = p.playerid
    WHERE EXTRACT(YEAR FROM p.debut) >= 1980
)
SELECT
    schoolid,
    COUNT(DISTINCT playerid) AS num_players
FROM players_5plus_since_1980
GROUP BY schoolid
ORDER BY num_players DESC;

-- Answer:
-- Since 1980, the leading producers of 5+ season MLB players are Arizona State,
-- UCLA, USC, LSU, and Texas, with Arizona State producing the highest total.


-- Q1.6
-- Across all debut decades, which schools have produced MLB players in at
-- least 5 different decades, and how many players did they produce in each
-- of those decades?

WITH decade_debut AS (
    SELECT
        vps.playerid,
        vps.schoolid,
        FLOOR(EXTRACT(YEAR FROM p.debut) / 10) * 10 AS debut_decade
    FROM v_player_school AS vps
    INNER JOIN people AS p
        ON vps.playerid = p.playerid
    WHERE p.debut IS NOT NULL
),
distinct_school_decade AS (
    SELECT DISTINCT
        schoolid,
        debut_decade
    FROM decade_debut
),
schools_5plus_decades AS (
    SELECT
        schoolid,
        COUNT(DISTINCT debut_decade) AS num_diff_decades
    FROM distinct_school_decade
    GROUP BY schoolid
    HAVING COUNT(DISTINCT debut_decade) >= 5
),
filtered_decade_debut AS (
    SELECT
        dd.playerid,
        dd.schoolid,
        dd.debut_decade
    FROM decade_debut AS dd
    INNER JOIN schools_5plus_decades AS s5
        ON dd.schoolid = s5.schoolid
)
SELECT
    schoolid,
    debut_decade,
    COUNT(DISTINCT playerid) AS num_players
FROM filtered_decade_debut
GROUP BY
    schoolid,
    debut_decade
ORDER BY
    schoolid,
    debut_decade;

-- Answer:
-- This query lists schools that have produced MLB players in at least 5
-- different debut decades and shows, for each such decade, how many players
-- they produced. Longstanding programs like Alabama and Amherst span many
-- decades with varying but persistent MLB output.

-- Q1.7
-- Using school state/region, which states have the highest per-decade growth
-- in MLB player production since 1950?
-- Growth is defined as the linear trend (slope) of players-per-decade
-- for each state, using decades from 1950 onward.
-- Due to the potential constraints of having few datapoints to calculate the slope,
-- I filtered out states with representation in fewer than 5 decades.

WITH decade_debut AS (
    SELECT
        vps.playerid,
        vps.schoolid,
        FLOOR(EXTRACT(YEAR FROM p.debut) / 10) * 10 AS debut_decade
    FROM v_player_school AS vps
    INNER JOIN people AS p
        ON vps.playerid = p.playerid
    WHERE p.debut IS NOT NULL
),
dd_state AS (
    SELECT
        dd.playerid,
        dd.debut_decade,
        dd.schoolid,
        s.state
    FROM decade_debut AS dd
    LEFT JOIN schools AS s
        ON dd.schoolid = s.schoolid
    WHERE s.state IS NOT NULL
),
state_decade_players AS (
    SELECT
        state,
        debut_decade,
        COUNT(DISTINCT playerid) AS num_players
    FROM dd_state
    WHERE debut_decade >= 1950
    GROUP BY
        state,
        debut_decade
),
decade_index_cte AS (
    SELECT
        state,
        debut_decade,
        num_players,
        (debut_decade - 1950) / 10 AS decade_index
    FROM state_decade_players
),
state_growth AS (
    SELECT
        state,
        COVAR_POP(num_players, decade_index) / VAR_POP(decade_index) AS raw_slope
    FROM decade_index_cte
    GROUP BY state
    HAVING COUNT(DISTINCT decade_index) >= 5   -- require ≥5 decades for a stable slope
)
SELECT
    state,
    ROUND(raw_slope::numeric, 2) AS slope_growth
FROM state_growth
ORDER BY
    slope_growth DESC;

-- Answer:
-- Since 1950, the steepest growth in MLB player production comes from
-- California, Texas, and Florida. California leads with an average increase
-- of ~17 extra MLB players per decade, followed by Texas (~13) and Florida (~13),
-- while several Midwestern and Northeastern states (e.g., Michigan, Minnesota, New York)
-- show flat or negative trends.


-- -----------------------------------
-- Part II — Salary & Payroll Analysis
-- -----------------------------------

-- Q2.3 (Advanced)
-- For each team and season, show annual payroll and cumulative payroll over time.

WITH year_team_payroll AS (
    SELECT
        yearID,
        teamID,
        SUM(salary) AS annual_payroll
    FROM salaries
    GROUP BY yearID, teamID
)
SELECT
    teamID,
    yearID,
    annual_payroll,
    SUM(annual_payroll) OVER (
        PARTITION BY teamID
        ORDER BY yearID
    ) AS cumulative_payroll
FROM year_team_payroll
ORDER BY teamID, yearID;

-- Answer: This shows how each team's total spending accumulates year by year across the dataset.

-- Q2.5 (Advanced)
-- What is the ratio between the median team’s payroll and the average payroll of the top 20% teams?

WITH avg_team_spending AS (
    -- Average annual payroll per franchise across all seasons
    SELECT
        teamID,
        SUM(salary) AS total_salary,
        COUNT(DISTINCT yearID) AS n_years,
        ROUND(SUM(salary) / COUNT(DISTINCT yearID), 2) AS avg_annual_payroll
    FROM salaries
    GROUP BY teamID
),
ranked AS (
    -- Rank teams into quintiles by average annual payroll
    SELECT
        teamID,
        avg_annual_payroll,
        NTILE(5) OVER (ORDER BY avg_annual_payroll DESC) AS payroll_percentile
    FROM avg_team_spending
),
top20_teams AS (
    -- Keep only the top 20% highest-spending teams
    SELECT
        teamID,
        avg_annual_payroll
    FROM ranked
    WHERE payroll_percentile = 1
),
median_payroll AS (
    -- Median team payroll across all franchises
    SELECT
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY avg_annual_payroll)
            AS median_team_payroll
    FROM avg_team_spending
),
top20_avg AS (
    -- Average payroll of the top 20% teams
    SELECT
        ROUND(AVG(avg_annual_payroll), 2) AS top20_avg_payroll
    FROM top20_teams
)
SELECT
    m.median_team_payroll,
    t.top20_avg_payroll,
    m.median_team_payroll / t.top20_avg_payroll AS payroll_ratio
FROM median_payroll m
CROSS JOIN top20_avg t;

-- Answer:
-- The median team's average annual payroll is $60.3M, while the top 20% of teams 
-- spend an average of $90.5M per year. This means the median franchise operates 
-- at roughly 66.6% of the spending level of the top-spending teams. 
-- In other words, a typical MLB team has about two-thirds the payroll capacity 
-- of the elite big-market franchises.

-- Q2.6 (Advanced, part 1)
-- From 1995 onward, how often does the top-payroll team reach the postseason?

WITH teams_yearly_spent AS (
    SELECT
        yearID,
        teamID,
        SUM(salary) AS total_spent
    FROM salaries
    WHERE yearID >= 1995
    GROUP BY yearID, teamID
),
yearly_rank AS (
    SELECT
        yearID,
        teamID,
        total_spent,
        RANK() OVER (
            PARTITION BY yearID
            ORDER BY total_spent DESC
        ) AS payroll_rank
    FROM teams_yearly_spent
),
postseason_teams AS (
    -- All teams that appeared in any postseason series (winner or loser)
    SELECT DISTINCT
        yearID,
        teamIDwinner AS teamID
    FROM seriespost
    WHERE yearID >= 1995

    UNION

    SELECT DISTINCT
        yearID,
        teamIDloser AS teamID
    FROM seriespost
    WHERE yearID >= 1995
),
payroll_with_post AS (
    -- All teams with their payroll rank and a postseason flag
    SELECT
        yr.yearID,
        yr.teamID,
        yr.total_spent,
        yr.payroll_rank,
        CASE
            WHEN p.teamID IS NULL THEN 0
            ELSE 1
        END AS made_postseason
    FROM yearly_rank AS yr
    LEFT JOIN postseason_teams AS p
      ON  yr.yearID = p.yearID
     AND yr.teamID = p.teamID
)

-- Year-by-year view: top-payroll team and postseason flag
SELECT
    yearID,
    teamID,
    total_spent,
    made_postseason
FROM payroll_with_post
WHERE payroll_rank = 1
ORDER BY yearID;

-- Summary: how often did the top-payroll team make the postseason?
WITH teams_yearly_spent AS (
    SELECT
        yearID,
        teamID,
        SUM(salary) AS total_spent
    FROM salaries
    WHERE yearID >= 1995
    GROUP BY yearID, teamID
),
yearly_rank AS (
    SELECT
        yearID,
        teamID,
        total_spent,
        RANK() OVER (
            PARTITION BY yearID
            ORDER BY total_spent DESC
        ) AS payroll_rank
    FROM teams_yearly_spent
),
postseason_teams AS (
    SELECT DISTINCT
        yearID,
        teamIDwinner AS teamID
    FROM seriespost
    WHERE yearID >= 1995

    UNION

    SELECT DISTINCT
        yearID,
        teamIDloser AS teamID
    FROM seriespost
    WHERE yearID >= 1995
),
payroll_with_post AS (
    SELECT
        yr.yearID,
        yr.teamID,
        yr.total_spent,
        yr.payroll_rank,
        CASE
            WHEN p.teamID IS NULL THEN 0
            ELSE 1
        END AS made_postseason
    FROM yearly_rank AS yr
    LEFT JOIN postseason_teams AS p
      ON  yr.yearID = p.yearID
     AND yr.teamID = p.teamID
)
SELECT
    COUNT(*) AS seasons_considered,
    SUM(CASE WHEN payroll_rank = 1 AND made_postseason = 1 THEN 1 ELSE 0 END)
        AS seasons_top_payroll_reached_postseason,
    ROUND(
        100.0 * SUM(CASE WHEN payroll_rank = 1 AND made_postseason = 1 THEN 1 ELSE 0 END)::numeric
        / COUNT(*),
        2
    ) AS pct_top_payroll_reached_postseason
FROM payroll_with_post
WHERE payroll_rank = 1;

-- Answer:
-- Between 1995 and 2016 (22 seasons), the top-payroll team reached the postseason
-- in 17 seasons and missed in 5, which corresponds to about 77.27% of the time.
-- This shows that having the #1 payroll greatly improves postseason odds,
-- but does not guarantee a playoff berth.

-- Q2.6 (Advanced, part 2)
-- Compare the distribution of payroll ranks for postseason vs non-postseason teams (1995+).

WITH teams_yearly_spent AS (
    SELECT
        yearID,
        teamID,
        SUM(salary) AS total_spent
    FROM salaries
    WHERE yearID >= 1995
    GROUP BY yearID, teamID
),
yearly_rank AS (
    SELECT
        yearID,
        teamID,
        total_spent,
        RANK() OVER (
            PARTITION BY yearID
            ORDER BY total_spent DESC
        ) AS payroll_rank
    FROM teams_yearly_spent
),
postseason_teams AS (
    SELECT DISTINCT
        yearID,
        teamIDwinner AS teamID
    FROM seriespost
    WHERE yearID >= 1995

    UNION

    SELECT DISTINCT
        yearID,
        teamIDloser AS teamID
    FROM seriespost
    WHERE yearID >= 1995
),
payroll_with_post AS (
    SELECT
        yr.yearID,
        yr.teamID,
        yr.total_spent,
        yr.payroll_rank,
        CASE
            WHEN p.teamID IS NULL THEN 0
            ELSE 1
        END AS made_postseason
    FROM yearly_rank AS yr
    LEFT JOIN postseason_teams AS p
      ON  yr.yearID = p.yearID
     AND yr.teamID = p.teamID
)

SELECT
    payroll_rank,
    SUM(made_postseason) AS postseason_team_seasons,
    COUNT(*) - SUM(made_postseason) AS non_postseason_team_seasons
FROM payroll_with_post
GROUP BY payroll_rank
ORDER BY payroll_rank;

-- Answer / Interpretation:
-- The output shows, for each payroll rank (1 = highest), how many team-seasons
-- at that rank reached the postseason vs did not.
-- Based on your results:
--   - Rank 1 produced 17 postseason team-seasons.
--   - Ranks 1–5 together produced 56 postseason team-seasons (~30% of all postseason slots).
--   - Ranks 1–10 produced 104 postseason team-seasons (~56% of all postseason slots).
--   - The bottom third (ranks 21–30) produced only 28 postseason team-seasons (~15%).
-- No team ranked 30th in payroll reached the postseason in this period.
-- This indicates that postseason teams are heavily skewed toward higher payroll ranks,
-- but lower-payroll clubs still occasionally break through.

-- Q2.7 (Advanced)
-- Overperformers: teams in the bottom payroll third that reached ALCS, NLCS, or WS

WITH year_team_sal AS (
    SELECT
        yearID,
        teamID,
        SUM(salary) AS sum_salaries
    FROM salaries
    GROUP BY yearID, teamID
),

segreg_yearly_teams AS (
    SELECT
        yearID,
        teamID,
        sum_salaries,
        NTILE(3) OVER (
            PARTITION BY yearID
            ORDER BY sum_salaries DESC
        ) AS payroll_tercile
    FROM year_team_sal
),

teams_bottom_third AS (
    SELECT
        yearID,
        teamID
    FROM segreg_yearly_teams
    WHERE payroll_tercile = 3
),

lcs_or_ws_teams AS (
    SELECT DISTINCT
        yearID,
        teamIDwinner AS teamID
    FROM seriespost
    WHERE round IN ('ALCS', 'NLCS', 'WS')

    UNION

    SELECT DISTINCT
        yearID,
        teamIDloser AS teamID
    FROM seriespost
    WHERE round IN ('ALCS', 'NLCS', 'WS')
)

SELECT
    b.yearID,
    b.teamID
FROM teams_bottom_third AS b
JOIN lcs_or_ws_teams AS p
  ON  b.yearID = p.yearID
 AND b.teamID = p.teamID
ORDER BY yearID;

-- These seasons had bottom-third payroll teams reach ALCS/NLCS/WS:
-- 1985 TOR
-- 1986 HOU
-- 1987 SFN, MIN
-- 1989 CHN
-- 1990 CIN
-- 1991 ATL
-- 2002 MIN
-- 2003 FLO
-- 2006 OAK
-- 2007 CLE, COL, ARI
-- 2008 TBA
-- 2010 TEX
-- 2014 KCA
-- 2015 NYN
-- 2016 CLE

-- ---------------------------------
-- Part III — Player Career Analysis
-- ---------------------------------

-- Q3.5 (Advanced) — Top 20 Longest Careers
-- Using the v_player_debut_final_teams view, identify the 20 longest
-- MLB careers by calendar-year career length, returning debut year,
-- final year, starting team, and ending team.

SELECT
    playerid,
    debut_year,
    final_year,
    debut_team,
    final_team,
    career_length
FROM v_player_debut_final_teams
ORDER BY career_length DESC, playerid
LIMIT 20;

-- Answer: Returns the top 20 longest MLB careers (calendar-year difference),
-- including debut/final teams and career lengths up to 35 years.

-- Q3.6 (Advanced) — Hall of Fame vs Non–Hall of Fame Careers
-- Compare age at debut and career length between HOF inductees and
-- non-inducted players using median, min, and max summaries.

WITH player_birthdates AS (
    SELECT
        playerid,
        debut,
        finalgame,
        MAKE_DATE(birthyear, birthmonth, birthday) AS birth_date
    FROM people
    WHERE birthyear IS NOT NULL
      AND birthmonth IS NOT NULL
      AND birthday IS NOT NULL
      AND debut IS NOT NULL
      AND finalgame IS NOT NULL
),

debut_career AS (
    SELECT
        playerid,
        AGE(debut, birth_date) AS age_debut,
        AGE(finalgame, debut)  AS career_length
    FROM player_birthdates
),

hof_flag AS (
    SELECT
        d.playerid,
        d.age_debut,
        d.career_length,
        COALESCE(h.inducted, 'N') AS hof
    FROM debut_career d
    LEFT JOIN halloffame h
      ON d.playerid = h.playerid
)

SELECT
    hof,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY age_debut)      AS median_age_debut,
    MIN(age_debut)                                              AS min_age_debut,
    MAX(age_debut)                                              AS max_age_debut,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY career_length)  AS median_career_length,
    MIN(career_length)                                          AS min_career_length,
    MAX(career_length)                                          AS max_career_length
FROM hof_flag
GROUP BY hof
ORDER BY hof DESC;

-- Answer: Compares debut age and career length distributions between
-- Hall of Fame inductees and all non-inducted players.

-- Q3.7 (Advanced) — Primary Franchise of Hall of Famers
-- Identify each HOF player's primary franchise (team with the most
-- career games played) and count how many inductees are primarily
-- associated with each franchise.

WITH games AS (
    SELECT
        teamid,
        playerid,
        COALESCE(g_all,0) + COALESCE(gs,0) + COALESCE(g_batting,0) +
        COALESCE(g_defense,0) + COALESCE(g_p,0) + COALESCE(g_c,0) +
        COALESCE(g_1b,0) + COALESCE(g_2b,0) + COALESCE(g_3b,0) +
        COALESCE(g_ss,0) + COALESCE(g_lf,0) + COALESCE(g_cf,0) +
        COALESCE(g_rf,0) + COALESCE(g_of,0) + COALESCE(g_dh,0) +
        COALESCE(g_ph,0) + COALESCE(g_pr,0) AS sum_games
    FROM appearances
    WHERE teamid IS NOT NULL
      AND playerid IS NOT NULL
),

total_games AS (
    SELECT
        teamid,
        playerid,
        SUM(sum_games) AS total_games
    FROM games
    GROUP BY teamid, playerid
),

ranked AS (
    SELECT
        playerid,
        teamid,
        total_games,
        RANK() OVER (PARTITION BY playerid ORDER BY total_games DESC) AS rnk
    FROM total_games
),

primary_franchise AS (
    SELECT playerid, teamid, total_games
    FROM ranked
    WHERE rnk = 1
),

hof_players AS (
    SELECT playerid
    FROM halloffame
    WHERE inducted = 'Y'
),

hof_primary AS (
    SELECT
        pf.playerid,
        pf.teamid,
        pf.total_games
    FROM primary_franchise pf
    INNER JOIN hof_players h
        ON pf.playerid = h.playerid
)

SELECT
    teamid,
    COUNT(DISTINCT playerid) AS hof_count
FROM hof_primary
GROUP BY teamid
ORDER BY hof_count DESC;

-- Answer: YANKEES (NYA) have the most HOF players primarily associated
-- with their franchise, followed by the Cardinals (SLN), White Sox (CHA),
-- and Cubs (CHN).

-- -----------------------------------------------
-- Part IV — Player Comparison & Physical Profiles
-- -----------------------------------------------

-- Q4.6 (Advanced)
-- Pitchers vs Non-Pitchers
-- How do debut physical profiles (height and weight) compare between pitchers and non-pitchers?

WITH player_pitching_role AS (
    SELECT
        playerid,
        CASE WHEN SUM(g_p) > 0 THEN 1 ELSE 0 END AS pitching_flag
    FROM appearances
    GROUP BY playerid
),
pitching_morpho AS (
    SELECT
        p.playerid,
        p.height,
        p.weight,
        pr.pitching_flag
    FROM people AS p
    INNER JOIN player_pitching_role AS pr
        ON p.playerid = pr.playerid
    WHERE p.height IS NOT NULL
      AND p.weight IS NOT NULL
)

SELECT
    CASE WHEN pitching_flag = 1 THEN 'Pitcher' ELSE 'Non-pitcher' END AS role,
    ROUND(AVG(height), 2) AS avg_height,
    ROUND(AVG(weight), 2) AS avg_weight
FROM pitching_morpho
GROUP BY pitching_flag
ORDER BY pitching_flag;

-- Answer: Pitchers debut on average ~1.7 inches taller and ~9.5 pounds heavier than non-pitchers,
-- indicating a clear physical specialization for the pitching role.

-- Q4.7 (Advanced)
-- Debut Profiles by Era and League
-- Compare average debut height and weight between leagues (AL vs NL)
-- across eras (pre-1960, 1960–1989, 1990–present).

WITH player_debut AS (
    SELECT
        playerid,
        MIN(yearid) AS debut_year
    FROM appearances
    GROUP BY playerid
),

player_debut_team AS (
    SELECT DISTINCT
        pd.playerid,
        pd.debut_year,
        a.teamid
    FROM player_debut AS pd
    INNER JOIN appearances AS a
        ON pd.playerid = a.playerid
       AND pd.debut_year = a.yearid
),

player_debut_league AS (
    SELECT
        pdt.playerid,
        pdt.debut_year,
        t.lgid AS league
    FROM player_debut_team AS pdt
    INNER JOIN teams AS t
        ON pdt.debut_year = t.yearid
       AND pdt.teamid     = t.teamid
    WHERE t.lgid IN ('AL', 'NL')
),

morpho_by_era AS (
    SELECT
        pdl.playerid,
        pdl.league,
        CASE
            WHEN pdl.debut_year < 1960 THEN 'a_pre-1960'
            WHEN pdl.debut_year < 1990 THEN 'b_1960-1989'
            ELSE 'c_1990-present'
        END AS era,
        ppl.height,
        ppl.weight
    FROM player_debut_league AS pdl
    INNER JOIN people AS ppl
        ON pdl.playerid = ppl.playerid
    WHERE ppl.height IS NOT NULL
      AND ppl.weight IS NOT NULL
)

SELECT
    era,
    league,
    ROUND(AVG(weight), 2) AS avg_weight,
    ROUND(AVG(height), 2) AS avg_height
FROM morpho_by_era
GROUP BY era, league
ORDER BY era, league;

-- Answer: AL and NL debut physiques are nearly identical in every era.
-- Both leagues show large increases in weight (and modest height rises)
-- from pre-1960 → 1960–1989 → 1990–present.

-- Q4.8 (Advanced)
-- Home Ballpark & Player Profile
-- Do debut physical profiles vary depending on the geographic region
-- of a player's first MLB home ballpark?

WITH park_region AS (
    SELECT
        parkname,
        parkalias,
        CASE 
            WHEN state IN ('MA','NY','PA','NJ','CT','RI','VT','NH','ME') THEN 'Northeast'
            WHEN state IN ('IL','OH','MI','WI','IN','MN','IA','MO','KS','NE','SD','ND') THEN 'Midwest'
            WHEN state IN ('TX','FL','GA','AL','MS','LA','SC','NC','VA','WV','KY','TN','OK','AR','MD','DC') THEN 'South'
            WHEN state IN ('CA','WA','OR','CO','AZ','NV','NM','UT','ID','MT','WY') THEN 'West'
            ELSE 'International'
        END AS region
    FROM parks
),

player_debut AS (
    SELECT
        playerid,
        EXTRACT(YEAR FROM debut)::INT AS debut_year,
        height,
        weight
    FROM people
    WHERE debut IS NOT NULL
      AND height IS NOT NULL
      AND weight IS NOT NULL
),

player_debut_team AS (
    SELECT DISTINCT
        pd.playerid,
        pd.debut_year,
        a.teamid,
        pd.height,
        pd.weight
    FROM player_debut AS pd
    INNER JOIN appearances AS a
        ON pd.playerid = a.playerid
       AND pd.debut_year = a.yearid
),

team_parks AS (
    SELECT
        pdt.playerid,
        pdt.height,
        pdt.weight,
        t.park
    FROM player_debut_team AS pdt
    INNER JOIN teams AS t
        ON pdt.debut_year = t.yearid
       AND pdt.teamid     = t.teamid
),

people_park_region AS (
    SELECT
        tp.playerid,
        tp.height,
        tp.weight,
        COALESCE(pr.region, 'Unknown') AS region
    FROM team_parks AS tp
    LEFT JOIN park_region AS pr
        ON tp.park = pr.parkname
        OR tp.park = pr.parkalias
)

SELECT
    region,
    ROUND(AVG(weight), 2) AS avg_weight,
    ROUND(AVG(height), 2) AS avg_height
FROM people_park_region
GROUP BY region
ORDER BY region;

-- Answer: Debut physiques vary modestly by region: players debuting in Western, Southern,
-- and International parks tend to be taller/heavier, while Northeast/Midwest regions
-- show slightly smaller debut profiles.

-- ---------------------------------------
-- End of Advanced Analytical Queries Code
-- ---------------------------------------
-- See analysis_queries.sql for initial analyses
-- and optimised_queries.sql for refactored query versions.
