-- Optimised Queries (Part I)
-- ------------------------------------------------------------
-- During review of the analysis and advanced SQL solutions
-- for Part I, it became clear that many questions relied
-- on the same recurring transformation: joining players to
-- their debut year and computing their debut decade.
--
-- Although the original goal was to keep views minimal and
-- general, introducing a dedicated view (v_player_debut_decade)
-- significantly streamlined the logic for several queries.
-- This view removes repeated CTEs, reduces complexity, and
-- ensures consistent behaviour across the project.
--
-- The optimised versions of the relevant Part I queries are
-- presented below, using this view. The original longer-form
-- versions (without the view) remain available in the
-- analysis_queries.sql and advanced_queries.sql files.
-- ------------------------------------------------------------

-- Q1.2 (optimised)
-- For each MLB debut decade, how many schools produced at least one MLB player?

SELECT
    debut_decade,
    COUNT(DISTINCT schoolid) AS num_schools
FROM v_player_debut_decade
GROUP BY debut_decade
ORDER BY debut_decade;


-- Q1.4 (optimised)
-- For each MLB debut decade, which are the top 3 schools (including ties)
-- by number of MLB players produced?

WITH school_decade_counts AS (
    SELECT
        schoolid,
        debut_decade,
        COUNT(DISTINCT playerid) AS num_players
    FROM v_player_debut_decade
    GROUP BY
        schoolid,
        debut_decade
),
ranked_schools AS (
    SELECT
        schoolid,
        debut_decade,
        num_players,
        RANK() OVER (
            PARTITION BY debut_decade
            ORDER BY num_players DESC
        ) AS school_rank
    FROM school_decade_counts
)
SELECT
    debut_decade,
    schoolid,
    num_players
FROM ranked_schools
WHERE school_rank <= 3
ORDER BY
    debut_decade,
    num_players DESC,
    schoolid;


-- Q1.6 (optimised)
-- Which schools have produced MLB players in at least 5 different debut decades,
-- and how many players did they produce in each of those decades?

WITH schools_5plus_decades AS (
    SELECT
        schoolid,
        COUNT(DISTINCT debut_decade) AS num_diff_decades
    FROM v_player_debut_decade
    GROUP BY schoolid
    HAVING COUNT(DISTINCT debut_decade) >= 5
),
filtered_debut AS (
    SELECT
        d.playerid,
        d.schoolid,
        d.debut_decade
    FROM v_player_debut_decade AS d
    INNER JOIN schools_5plus_decades AS s5
        ON d.schoolid = s5.schoolid
)
SELECT
    schoolid,
    debut_decade,
    COUNT(DISTINCT playerid) AS num_players
FROM filtered_debut
GROUP BY
    schoolid,
    debut_decade
ORDER BY
    schoolid,
    debut_decade;


-- Q1.7 (optimised)
-- Using school state, which states have the highest per-decade growth in
-- MLB player production since 1950?
-- Growth is defined as the linear trend (slope) of players-per-decade
-- per state, from 1950 onwards.

WITH state_decade_players AS (
    SELECT
        s.state,
        d.debut_decade,
        COUNT(DISTINCT d.playerid) AS num_players
    FROM v_player_debut_decade AS d
    LEFT JOIN schools AS s
        ON d.schoolid = s.schoolid
    WHERE
        d.debut_decade >= 1950
        AND s.state IS NOT NULL
    GROUP BY
        s.state,
        d.debut_decade
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
    HAVING COUNT(DISTINCT decade_index) >= 5   -- require ≥ 5 decades for a stable slope
)
SELECT
    state,
    ROUND(raw_slope::numeric, 2) AS slope_growth
FROM state_growth
ORDER BY
    slope_growth DESC;


-- Optimised Queries (Part II)
-- ------------------------------------------------------------
-- During review of the analysis and advanced SQL solutions
-- for Part II, it became clear that several questions depend
-- on the same recurring transformations:
--
--   • computing annual payroll per team and season,
--   • deriving average payroll per franchise,
--   • identifying postseason participants,
--   • and selecting only advanced postseason rounds (ALCS,
--     NLCS, and WS).
--
-- These patterns appeared repeatedly across Q2.2–Q2.7 and
-- were originally implemented through repeated CTE blocks.
-- While correct, this duplication increased query length,
-- obscured intent, and introduced opportunities for subtle
-- inconsistencies across questions.
--
-- To resolve this, Part II introduces four dedicated views:
--
--   • v_team_year_payroll          – annual payroll by team-year
--   • v_team_avg_annual_payroll    – franchise-level average payroll
--   • v_postseason_teams           – all postseason participants
--   • v_lcs_ws_teams              – teams reaching ALCS, NLCS, or WS
--
-- These views replace the repeated CTE boilerplate and act
-- as stable, canonical transformations for payroll and
-- postseason analytics. They simplify reasoning, improve
-- readability, and ensure consistent behavior throughout
-- Part II.
--
-- The optimised versions of the relevant Part II queries
-- are presented below, rewritten to use these views.
-- The original, fully expanded versions (without the views)
-- remain available in analysis_queries.sql and
-- advanced_queries.sql.
-- ------------------------------------------------------------

-- Q2.2 (C, optimised)
-- Which teams fall into the top 20% of average annual payroll spending?

WITH ranked AS (
    SELECT
        teamID,
        avg_annual_payroll,
        NTILE(5) OVER (ORDER BY avg_annual_payroll DESC) AS payroll_percentile
    FROM v_team_avg_annual_payroll
)
SELECT
    teamID,
    avg_annual_payroll
FROM ranked
WHERE payroll_percentile = 1
ORDER BY avg_annual_payroll DESC;

-- Same answer as analysis Q2.2: LAA, NYA, BOS, WAS, LAN, ARI, NYN.

-- Q2.3 (Advanced, optimised)
-- For each team and season, show annual payroll and cumulative payroll over time.

SELECT
    teamID,
    yearID,
    annual_payroll,
    SUM(annual_payroll) OVER (
        PARTITION BY teamID
        ORDER BY yearID
    ) AS cumulative_payroll
FROM v_team_year_payroll
ORDER BY
    teamID,
    yearID;

-- Same output as advanced Q2.3, but now built directly on v_team_year_payroll.

-- Q2.4 (C, optimised)
-- For each team, in which year did cumulative payroll first surpass $1 billion?

WITH cum_sum AS (
    SELECT
        teamID,
        yearID,
        annual_payroll,
        SUM(annual_payroll) OVER (
            PARTITION BY teamID
            ORDER BY yearID
        ) AS cumulative_payroll
    FROM v_team_year_payroll
),
billion_crossing AS (
    SELECT
        teamID,
        yearID,
        cumulative_payroll,
        ROW_NUMBER() OVER (
            PARTITION BY teamID
            ORDER BY yearID
        ) AS rn
    FROM cum_sum
    WHERE cumulative_payroll >= 1000000000
)
SELECT
    teamID,
    yearID AS first_billion_year,
    cumulative_payroll
FROM billion_crossing
WHERE rn = 1
ORDER BY teamID;

-- Same answer as analysis Q2.4: NYA 2003, BOS 2004, etc.

-- Q2.5 (Advanced, optimised)
-- What is the ratio between the median team’s payroll and the average payroll of the top 20% teams?

WITH ranked AS (
    -- Rank teams into quintiles by average annual payroll
    SELECT
        teamID,
        avg_annual_payroll,
        NTILE(5) OVER (ORDER BY avg_annual_payroll DESC) AS payroll_percentile
    FROM v_team_avg_annual_payroll
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
    FROM v_team_avg_annual_payroll
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

-- Same result as advanced Q2.5: median ≈ $60.3M, top 20% ≈ $90.5M, ratio ≈ 0.67.

-- Q2.6 (Advanced, part 1, optimised)
-- From 1995 onward, how often does the top-payroll team reach the postseason?

WITH yearly_rank AS (
    SELECT
        yearID,
        teamID,
        annual_payroll AS total_spent,
        RANK() OVER (
            PARTITION BY yearID
            ORDER BY annual_payroll DESC
        ) AS payroll_rank
    FROM v_team_year_payroll
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
    LEFT JOIN v_postseason_teams AS p
      ON  yr.yearID = p.yearID
     AND yr.teamID = p.teamID
)
SELECT
    COUNT(*) AS seasons_considered,
    SUM(CASE WHEN payroll_rank = 1 AND made_postseason = 1 THEN 1 ELSE 0 END)
        AS seasons_top_payroll_reached_postseason,
    ROUND(
        100.0
        * SUM(CASE WHEN payroll_rank = 1 AND made_postseason = 1 THEN 1 ELSE 0 END)::numeric
        / COUNT(*),
        2
    ) AS pct_top_payroll_reached_postseason
FROM payroll_with_post
WHERE payroll_rank = 1;

-- Same answer: 17 of 22 seasons (~77.27%) the #1 payroll team reached the postseason.

-- Q2.6 (Advanced, part 2, optimised)
-- Distribution of payroll ranks for postseason vs non-postseason teams (1995+).

WITH yearly_rank AS (
    SELECT
        yearID,
        teamID,
        annual_payroll AS total_spent,
        RANK() OVER (
            PARTITION BY yearID
            ORDER BY annual_payroll DESC
        ) AS payroll_rank
    FROM v_team_year_payroll
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
    LEFT JOIN v_postseason_teams AS p
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

-- Same interpretation as in advanced Q2.6: postseason slots are heavily skewed
-- toward higher payroll ranks, especially ranks 1–10.

-- Optional: year-by-year top-payroll team and whether it made the postseason

WITH yearly_rank AS (
    SELECT
        yearID,
        teamID,
        annual_payroll AS total_spent,
        RANK() OVER (
            PARTITION BY yearID
            ORDER BY annual_payroll DESC
        ) AS payroll_rank
    FROM v_team_year_payroll
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
    LEFT JOIN v_postseason_teams AS p
      ON  yr.yearID = p.yearID
     AND yr.teamID = p.teamID
)
SELECT
    yearID,
    teamID,
    total_spent,
    made_postseason
FROM payroll_with_post
WHERE payroll_rank = 1
ORDER BY yearID;


-- Q2.7 (Advanced, optimised)
-- Bottom-third payroll teams that still reached ALCS, NLCS, or WS.

WITH segreg_yearly_teams AS (
    SELECT
        yearID,
        teamID,
        annual_payroll,
        NTILE(3) OVER (
            PARTITION BY yearID
            ORDER BY annual_payroll DESC
        ) AS payroll_tercile
    FROM v_team_year_payroll
),
teams_bottom_third AS (
    SELECT
        yearID,
        teamID
    FROM segreg_yearly_teams
    WHERE payroll_tercile = 3
)
SELECT
    b.yearID,
    b.teamID
FROM teams_bottom_third AS b
JOIN v_lcs_ws_teams AS p
  ON  b.yearID = p.yearID
 AND b.teamID = p.teamID
ORDER BY b.yearID;

-- Same list of overperformers as advanced Q2.7 (1985 TOR, 1986 HOU, 1987 SFN/MIN, ... 2016 CLE).


-- Optimised Queries (Part III)
-- ------------------------------------------------------------
-- During review of the analysis solutions for Part III, it
-- became clear that several questions rely on the same
-- recurring transformation:
--
--   • extracting each player's debut and final MLB seasons, and
--   • joining those seasons to the Appearances table to recover
--     the team(s) they played for in those years.
--
-- In the original queries (Q3.3–Q3.4), this logic was implemented
-- via repeated CTEs (player_years, debut_teams, final_teams).
-- While correct, this duplication increased query length and
-- introduced opportunities for subtle inconsistencies.
--
-- To resolve this, Part III introduces a dedicated view:
--
--   • v_player_debut_final_teams – per-player mapping of debut
--     year, final year, debut team(s), final team(s), and a
--     simple year-based career length (final_year - debut_year).
--
-- This view replaces the repeated boilerplate and acts as a
-- canonical transformation for career-start / career-end team
-- analytics. It simplifies reasoning, improves readability, and
-- ensures consistent behaviour across Part III.
--
-- The optimised versions of the relevant Part III queries are
-- presented below, rewritten to use this view. The original,
-- fully expanded versions (without the view) remain available in
-- analysis_queries.sql.
-- ------------------------------------------------------------


-- Q3.3 (C, optimised)
-- Which team did each player play for in their debut season and in
-- their final season?

SELECT
    playerid,
    debut_year,
    debut_team,
    final_year,
    final_team
FROM v_player_debut_final_teams
ORDER BY
    playerid,
    debut_year;

-- Same answer as analysis Q3.3, but now built directly on
-- v_player_debut_final_teams. Players who switched teams within
-- their debut or final season appear once per player–team
-- combination.


-- Q3.4 (C, optimised)
-- How many players both:
--   1. played 10+ years (based on debut vs final season), and
--   2. started and ended their career on the same team?

SELECT
    COUNT(*) AS loyal_long_career_players
FROM v_player_debut_final_teams
WHERE career_length >= 10
  AND debut_team = final_team;

-- Same result as analysis Q3.4: 422 players meet both conditions
-- of longevity (10+ years by calendar-year difference) and team
-- loyalty (same debut and final team).


-- Optimised Queries (Part IV)
-- ------------------------------------------------------------
-- During review of the Part IV analysis and advanced solutions,
-- several questions were found to rely on repeated transformations:
--
--   • extracting debut year/decade and combining it with height,
--     weight, and handedness from the People table,
--   • determining each player's debut team and league,
--   • and mapping debut teams to ballpark regions.
--
-- The dedicated views introduced in views.sql:
--
--   • v_player_morpho
--   • v_player_debut_team
--   • v_park_region
--
-- replace this repeated CTE boilerplate and act as canonical
-- transformations for physical-profile analytics. The optimised
-- Part IV queries below are rewritten to leverage these views.
-- The original, fully expanded versions remain available in
-- analysis_queries.sql and advanced_queries.sql.
-- ------------------------------------------------------------


-- Q4.4 (C, optimised)
-- How have average height and average weight at debut changed
-- over time (by debut year)?

SELECT
    debut_year,
    ROUND(AVG(weight), 2) AS avg_weight,
    ROUND(AVG(height), 2) AS avg_height
FROM v_player_morpho
WHERE debut_year IS NOT NULL
  AND weight IS NOT NULL
  AND height IS NOT NULL
GROUP BY debut_year
ORDER BY debut_year;

-- Same answer as analysis Q4.4, but now built directly on
-- v_player_morpho.


-- Q4.5 (C, optimised)
-- For each debut decade, what is the change (Δ) in average
-- height and weight relative to the previous decade?

WITH decade_average AS (
    SELECT
        debut_decade,
        ROUND(AVG(weight), 2) AS avg_weight,
        ROUND(AVG(height), 2) AS avg_height
    FROM v_player_morpho
    WHERE debut_decade IS NOT NULL
      AND weight IS NOT NULL
      AND height IS NOT NULL
    GROUP BY debut_decade
)
SELECT
    debut_decade,
    avg_weight,
    LAG(avg_weight) OVER (ORDER BY debut_decade) AS prev_decade_weight,
    avg_weight
        - LAG(avg_weight) OVER (ORDER BY debut_decade) AS weight_change,
    avg_height,
    LAG(avg_height) OVER (ORDER BY debut_decade) AS prev_decade_height,
    avg_height
        - LAG(avg_height) OVER (ORDER BY debut_decade) AS height_change
FROM decade_average
ORDER BY debut_decade;

-- Same answer as analysis Q4.5: modest height gains and
-- substantial weight gains across debut decades, especially
-- into the modern era.


-- Q4.6 (Advanced, optimised)
-- How do debut physical profiles (height, weight) compare
-- between pitchers and non-pitchers?

WITH player_pitching_role AS (
    SELECT
        playerid,
        CASE WHEN SUM(g_p) > 0 THEN 1 ELSE 0 END AS pitching_flag
    FROM appearances
    GROUP BY playerid
)
SELECT
    pr.pitching_flag,
    ROUND(AVG(m.height), 2) AS avg_height,
    ROUND(AVG(m.weight), 2) AS avg_weight
FROM player_pitching_role AS pr
INNER JOIN v_player_morpho AS m
    ON pr.playerid = m.playerid
WHERE m.height IS NOT NULL
  AND m.weight IS NOT NULL
GROUP BY pr.pitching_flag
ORDER BY pr.pitching_flag;

-- Same result as advanced Q4.6: pitchers debut slightly taller
-- and heavier on average than non-pitchers, but the difference
-- is modest rather than dramatic.


-- Q4.7 (Advanced, optimised)
-- Debut Profiles by Era and League
-- Compare average debut height and weight between leagues
-- (AL vs NL) across eras (pre-1960, 1960–1989, 1990–present).

WITH player_debut_league AS (
    SELECT
        pdt.playerid,
        pdt.debut_year,
        t.lgid AS league
    FROM v_player_debut_team AS pdt
    INNER JOIN teams AS t
        ON pdt.debut_year = t.yearid
       AND pdt.debut_teamid = t.teamid
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
        m.height,
        m.weight
    FROM player_debut_league AS pdl
    INNER JOIN v_player_morpho AS m
        ON pdl.playerid = m.playerid
    WHERE m.height IS NOT NULL
      AND m.weight IS NOT NULL
)
SELECT
    era,
    league,
    ROUND(AVG(weight), 2) AS avg_weight,
    ROUND(AVG(height), 2) AS avg_height
FROM morpho_by_era
GROUP BY
    era,
    league
ORDER BY
    era,
    league;

-- Same interpretation as in the advanced Q4.7 analysis:
-- AL and NL debut physiques are nearly identical in each era,
-- with both leagues showing substantial weight increases and
-- modest height gains from pre-1960 → 1960–1989 → 1990–present.


-- Q4.8 (Advanced, optimised)
-- Home Ballpark & Player Profile
-- Do debut physical profiles vary depending on the geographic
-- region of a player's first MLB home ballpark?

WITH player_debut_park AS (
    SELECT
        pdt.playerid,
        pdt.debut_year,
        t.park
    FROM v_player_debut_team AS pdt
    INNER JOIN teams AS t
        ON pdt.debut_year = t.yearid
       AND pdt.debut_teamid = t.teamid
),
player_morpho_region AS (
    SELECT
        m.playerid,
        m.height,
        m.weight,
        COALESCE(pr.region, 'Unknown') AS region
    FROM player_debut_park AS pdp
    INNER JOIN v_player_morpho AS m
        ON pdp.playerid = m.playerid
    LEFT JOIN v_park_region AS pr
        ON pdp.park = pr.parkname
        OR pdp.park = pr.parkalias
    WHERE m.height IS NOT NULL
      AND m.weight IS NOT NULL
)
SELECT
    region,
    ROUND(AVG(weight), 2) AS avg_weight,
    ROUND(AVG(height), 2) AS avg_height
FROM player_morpho_region
GROUP BY region
ORDER BY region;

-- Same result as advanced Q4.8: debut physiques vary modestly
-- by park region. Players debuting in Western, Southern, and
-- International parks tend to be slightly taller and heavier,
-- while Northeast and Midwest debut profiles are somewhat
-- smaller on average.


-- ----------------------------------------
-- End of Optimised Analytical Queries Code
-- ----------------------------------------