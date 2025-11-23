-- ------------------------------------------
-- Part I — School / Talent Pipeline Analysis
-- ------------------------------------------

-- Q1.1 (C)
-- How many MLB players in the database have at least one recorded college?
-- How many distinct schools appear in the college-playing data?
--
-- Note:
--   This query uses the view v_player_school (defined in views.sql) as a
--   reusable mapping between players and schools:
--      CREATE OR REPLACE VIEW v_player_school AS
--      SELECT DISTINCT playerid, schoolid FROM collegeplaying;

-- 1) Total number of players in the database
SELECT COUNT(DISTINCT playerid) AS total_players
FROM people;
-- Result: 24,023 players in the people table.

-- 2) Players with at least one recorded college
SELECT COUNT(DISTINCT playerid) AS players_with_college
FROM v_player_school;
-- Result: 6,869 players have at least one recorded college.
--         Therefore, 24,023 - 6,869 = 17,154 players do not have a recorded college.

-- 3) Distinct schools that appear in the college-playing data
SELECT COUNT(DISTINCT schoolid) AS schools_with_mlb_players
FROM v_player_school;
-- Result: 1,122 distinct schools are associated with at least one MLB player.


-- Q1.2 (C)
-- For each MLB debut decade, how many schools produced at least one MLB player?
-- Uses v_player_school (player–school mapping) + people (MLB debut dates).

WITH decade_debut AS (
    SELECT
        vps.playerid,
        vps.schoolid,
        EXTRACT(YEAR FROM p.debut) AS debut_year,
        FLOOR(EXTRACT(YEAR FROM p.debut) / 10) * 10 AS debut_decade
    FROM v_player_school AS vps
    INNER JOIN people AS p
        ON vps.playerid = p.playerid
    WHERE p.debut IS NOT NULL
)
SELECT
    debut_decade,
    COUNT(DISTINCT schoolid) AS num_schools
FROM decade_debut
GROUP BY debut_decade
ORDER BY debut_decade;

-- Answer:
-- The number of schools producing at least one MLB player rises from 11 in the 1870s
-- to a peak of ~470 schools for players debuting in the 1990s, before dipping slightly
-- in the 2000s and more sharply in the (incomplete) 2010s.


-- Q1.3 (C)
-- Which are the top 5 schools by total number of MLB players produced?

SELECT
    schoolid,
    COUNT(DISTINCT playerid) AS num_players
FROM v_player_school
GROUP BY schoolid
ORDER BY num_players DESC
LIMIT 5;

-- Answer:
-- The top 5 MLB-producing schools are Texas, USC, Arizona State, Stanford,
-- and Michigan, with Texas leading at just over 100 MLB players.

-- Q1.4 (C)
-- For each MLB debut decade, which are the top 3 schools by number of MLB players produced?
-- Ties are included using RANK(), so some decades may have more than 3 schools listed.

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
school_decade_counts AS (
    SELECT
        schoolid,
        debut_decade,
        COUNT(DISTINCT playerid) AS num_players
    FROM decade_debut
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

-- Answer:
-- For each debut decade, this query returns the top 3 schools (including ties)
-- by the number of MLB players they produced, showing recurring powerhouses
-- like Texas, USC, and Arizona State across multiple decades alongside more
-- era-specific schools.

-- -----------------------------------
-- Part II — Salary & Payroll Analysis
-- -----------------------------------