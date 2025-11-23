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
