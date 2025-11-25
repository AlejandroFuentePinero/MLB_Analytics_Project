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

-- Q2.1 (C)
-- What is the year range and total record count in the Salaries table?

SELECT 
    COUNT(*) AS total_records,
    MIN(yearID) AS first_year,
    MAX(yearID) AS last_year
FROM salaries;

-- Answer: The Salaries table contains 26,428 records spanning 1985–2016.

-- Q2.2 (C)
-- Which teams fall into the top 20% of average annual payroll spending?

WITH avg_team_spending AS (
    SELECT
        teamID,
        SUM(salary) AS total_salary,
        COUNT(DISTINCT yearID) AS n_years,
        ROUND(SUM(salary) / COUNT(DISTINCT yearID), 2) AS avg_annual_payroll
    FROM salaries
    GROUP BY teamID
),
ranked AS (
    SELECT
        teamID,
        avg_annual_payroll,
        NTILE(5) OVER (ORDER BY avg_annual_payroll DESC) AS payroll_percentile
    FROM avg_team_spending
)
SELECT
    teamID,
    avg_annual_payroll
FROM ranked
WHERE payroll_percentile = 1
ORDER BY avg_annual_payroll DESC;

-- Answer: These teams make up the top 20% of MLB organizations by average annual payroll:
-- LAA, NYA, BOS, WAS, LAN, ARI, NYN.

-- Q2.3 (C)
-- For each team, what is the cumulative sum of payroll across all available seasons?

SELECT
    teamID,
    SUM(salary) AS total_payroll
FROM salaries
GROUP BY teamID
ORDER BY total_payroll DESC;

-- Answer: This returns each team's total historical payroll; the Yankees (NYA) lead with over 3.7B in recorded salary spend, 
-- followed by the Red Sox (BOS), Dodgers (LAN), Mets (NYN), and other large-market teams.

-- Q2.4 (C)
-- For each team, in which year did cumulative payroll first surpass $1 billion?

WITH year_team_payroll AS (
    SELECT
        yearID,
        teamID,
        SUM(salary) AS annual_payroll
    FROM salaries
    GROUP BY yearID, teamID
),
cum_sum AS (
    SELECT
        teamID,
        yearID,
        annual_payroll,
        SUM(annual_payroll) OVER (
            PARTITION BY teamID
            ORDER BY yearID
        ) AS cumulative_payroll
    FROM year_team_payroll
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

-- Answer:
-- Most large-market teams crossed $1B earliest: the Yankees (NYA) in 2003, 
-- Red Sox (BOS) in 2004, and Dodgers (LAN) and Braves (ATL) in 2005. 
-- A second wave of teams—including the Cubs (CHN), Mets (NYN), Giants (SFN), 
-- Mariners (SEA), and Cardinals (SLN)—reached $1B around 2006–2008. 
-- Many mid-market teams surpassed the milestone between 2009 and 2012 
-- (e.g., CLE, CIN, COL, MIN, ARI, KCA, OAK). 
-- Smaller-spending franchises such as PIT and MIL crossed $1B later (2014–2015), 
-- while WAS reached it in 2016. 
-- Overall, the timing clearly separates long-term high-spending organizations 
-- from those with historically lower payroll investment.

-- ---------------------------------
-- Part III — Player Career Analysis
-- ---------------------------------
-- Q3.1 (C) — Player Count
-- Count total number of players recorded in the People table.

SELECT COUNT(*) AS total_players
FROM people;

-- Answer: 24,023 players

-- Q3.2 (C) — Player age at debut, age at final game, and career length
-- For each player with a complete birthdate and game dates, calculate:
--   * age at first MLB game
--   * age at last MLB game
--   * total career length in MLB
-- Then order by longest careers first.

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
)

SELECT
    playerid,
    AGE(debut, birth_date)      AS age_first_game,
    AGE(finalgame, birth_date)  AS age_last_game,
    AGE(finalgame, debut)       AS career_length
FROM player_birthdates
ORDER BY career_length DESC, playerid;

-- Answer: Computes each player's age at debut and final game, plus total MLB career length,
-- for players with complete birth and game dates, ordered by longest careers first. The top 5 longest
-- career spanned 29-35 years!

-- Q3.3 (C) — Starting and Ending Teams
-- Identify the team(s) each player played for in their debut MLB season
-- and in their final MLB season.

WITH player_years AS (
    SELECT
        playerid,
        EXTRACT(YEAR FROM debut)     AS debut_year,
        EXTRACT(YEAR FROM finalgame) AS final_year
    FROM people
    WHERE debut IS NOT NULL
      AND finalgame IS NOT NULL
),

debut_teams AS (
    SELECT
        py.playerid,
        py.debut_year,
        a.teamid AS debut_team
    FROM player_years py
    LEFT JOIN appearances a
      ON py.playerid = a.playerid
     AND py.debut_year = a.yearid
),

final_teams AS (
    SELECT
        py.playerid,
        py.final_year,
        a.teamid AS final_team
    FROM player_years py
    LEFT JOIN appearances a
      ON py.playerid = a.playerid
     AND py.final_year = a.yearid
)

SELECT
    d.playerid,
    d.debut_year,
    d.debut_team,
    f.final_year,
    f.final_team
FROM debut_teams d
LEFT JOIN final_teams f
  ON d.playerid = f.playerid
ORDER BY d.playerid, d.debut_year;

-- Answer: Returns the team(s) each player appeared for in their debut and final MLB seasons,
-- including multiple rows for players who changed teams within those seasons.

-- Q3.4 (C) — Loyal Long-Career Players
-- Count players who played 10+ years AND started and ended their career
-- on the same team.

WITH player_years AS (
    SELECT
        playerid,
        EXTRACT(YEAR FROM debut)     AS debut_year,
        EXTRACT(YEAR FROM finalgame) AS final_year
    FROM people
    WHERE debut IS NOT NULL
      AND finalgame IS NOT NULL
),

debut_teams AS (
    SELECT
        py.playerid,
        py.debut_year,
        a.teamid AS debut_team
    FROM player_years py
    LEFT JOIN appearances a
      ON py.playerid = a.playerid
     AND py.debut_year = a.yearid
),

final_teams AS (
    SELECT
        py.playerid,
        py.final_year,
        a.teamid AS final_team
    FROM player_years py
    LEFT JOIN appearances a
      ON py.playerid = a.playerid
     AND py.final_year = a.yearid
),

merged AS (
    SELECT
        d.playerid,
        d.debut_year,
        d.debut_team,
        f.final_year,
        f.final_team,
        (f.final_year - d.debut_year) AS career_length
    FROM debut_teams d
    LEFT JOIN final_teams f
      ON d.playerid = f.playerid
)

SELECT COUNT(*) AS loyal_long_career_players
FROM merged
WHERE career_length >= 10
  AND debut_team = final_team;

-- Answer: 422 players played 10+ years and finished on the same team they debuted with.

-- -----------------------------------------------
-- Part IV — Player Comparison & Physical Profiles
-- -----------------------------------------------

-- Q4.1 (C)
-- Data Completeness
-- How complete are height, weight, and handedness (bats) data across the MLB player population?

SELECT
    ROUND((COUNT(weight)::numeric / COUNT(*)) * 100, 1) AS weight_completeness_pct,
    ROUND((COUNT(height)::numeric / COUNT(*)) * 100, 1) AS height_completeness_pct,
    ROUND((COUNT(bats)::numeric   / COUNT(*)) * 100, 1) AS handedness_completeness_pct
FROM people;

-- Answer: Height and weight fields are ~90% complete; handedness slightly lower (~88%),
-- providing sufficient coverage for physical-profile comparisons in later questions.


-- Q4.2 (C)
-- Shared Birthdays
-- Which players share the same birthday, and which birthday is most common?

WITH bday AS (
    SELECT
        playerid,
        MAKE_DATE(birthyear, birthmonth, birthday) AS birth_date
    FROM people
    WHERE birthyear IS NOT NULL
      AND birthmonth IS NOT NULL
      AND birthday IS NOT NULL
)

-- 1) All unique pairs of players who share the same birthday
SELECT
    b1.playerid AS player1,
    b1.birth_date AS birth_date,
    b2.playerid AS player2
FROM bday AS b1
INNER JOIN bday AS b2
    ON b1.birth_date = b2.birth_date
   AND b1.playerid  < b2.playerid;

-- Answer: There are 5,271 unique unordered pairs of players who share the same birthday.


-- 2) Birthday(s) shared by the most players
WITH bday AS (
    SELECT
        playerid,
        MAKE_DATE(birthyear, birthmonth, birthday) AS birth_date
    FROM people
    WHERE birthyear IS NOT NULL
      AND birthmonth IS NOT NULL
      AND birthday IS NOT NULL
),
bday_counts AS (
    SELECT
        birth_date,
        COUNT(*) AS bday_count
    FROM bday
    GROUP BY birth_date
)

SELECT
    birth_date,
    bday_count
FROM bday_counts
WHERE bday_count = (
    SELECT MAX(bday_count) FROM bday_counts
)
ORDER BY birth_date;

-- Answer: The most common birthdays in the dataset each have 6 players sharing the same date,
-- with no single standout "MLB birthday"; shared birthdays are broadly dispersed.

-- Q4.3 (C)
-- Team Handedness Composition
-- For each team, what percentage of players bat right, left, or both?

WITH team_bats AS (
    SELECT
        a.teamid,
        a.playerid,
        p.bats
    FROM appearances AS a
    LEFT JOIN people AS p
        ON a.playerid = p.playerid
    WHERE p.bats IS NOT NULL
),

total_players_cte AS (
    SELECT
        teamid,
        COUNT(DISTINCT playerid)::numeric AS total_players
    FROM team_bats
    GROUP BY teamid
),

player_bats AS (
    SELECT
        teamid,
        bats,
        COUNT(DISTINCT playerid)::numeric AS players_bats
    FROM team_bats
    GROUP BY teamid, bats
),

bats_pct_table AS (
    SELECT
        pb.teamid,
        pb.bats,
        pb.players_bats,
        t.total_players,
        ROUND((pb.players_bats / t.total_players) * 100, 2) AS bats_pct
    FROM player_bats AS pb
    LEFT JOIN total_players_cte AS t
        ON pb.teamid = t.teamid
)

SELECT
    teamid,
    MAX(CASE WHEN bats = 'R' THEN bats_pct ELSE 0 END) AS pct_r,
    MAX(CASE WHEN bats = 'L' THEN bats_pct ELSE 0 END) AS pct_l,
    MAX(CASE WHEN bats = 'B' THEN bats_pct ELSE 0 END) AS pct_b
FROM bats_pct_table
GROUP BY teamid
ORDER BY teamid;

-- Answer: Team-level compositions show that most clubs have 60–75% right-handed hitters,
-- 25–35% left-handed, and ~5–10% switch hitters.

-- Q4.4 (C)
-- Physical Traits at Debut
-- How have average height and average weight at debut changed over time?

SELECT
    EXTRACT(YEAR FROM debut) AS debut_year,
    ROUND(AVG(weight), 2) AS avg_weight,
    ROUND(AVG(height), 2) AS avg_height
FROM people
WHERE debut IS NOT NULL
GROUP BY EXTRACT(YEAR FROM debut)
ORDER BY debut_year;

-- Answer: Players debuting in the late 19th century were much smaller; heights stabilized early,
-- but weights increased substantially from the 1970s onward.

-- Q4.5 (C)
-- Decade-over-Decade Change
-- For each debut decade, what is the change in average height and weight
-- relative to the previous decade?

WITH decade_average AS (
    SELECT
        FLOOR(EXTRACT(YEAR FROM debut) / 10) * 10 AS debut_decade,
        ROUND(AVG(weight), 2) AS avg_weight,
        ROUND(AVG(height), 2) AS avg_height
    FROM people
    WHERE debut IS NOT NULL
    GROUP BY FLOOR(EXTRACT(YEAR FROM debut) / 10) * 10
),
with_lag AS (
    SELECT
        debut_decade,
        avg_weight,
        LAG(avg_weight) OVER (ORDER BY debut_decade) AS lagged_weight,
        avg_height,
        LAG(avg_height) OVER (ORDER BY debut_decade) AS lagged_height
    FROM decade_average
)

SELECT
    debut_decade,
    avg_weight,
    lagged_weight,
    ROUND(avg_weight - lagged_weight, 2) AS weight_change,
    avg_height,
    lagged_height,
    ROUND(avg_height - lagged_height, 2) AS height_change
FROM with_lag
ORDER BY debut_decade;

-- Answer: Weight shows large positive jumps in the 1930s and especially 1990s–2000s,
-- while height changes are modest and plateau by the mid-20th century.


-- ------------------------------------
-- End of Basic Analytical Queries Code
-- ------------------------------------
-- See advanced_queries.sql for extended analyses
-- and optimised_queries.sql for refactored query versions.