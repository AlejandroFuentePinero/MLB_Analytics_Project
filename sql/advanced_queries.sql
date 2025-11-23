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