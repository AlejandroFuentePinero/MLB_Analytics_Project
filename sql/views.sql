-- View: v_player_school
-- Purpose: Provide a distinct mapping of players to schools for use across
--          school- and pipeline-related analyses.
-- Notes:   Deduplicates the raw collegeplaying table (which may contain
--          multiple rows per player–school pair).

CREATE OR REPLACE VIEW v_player_school AS
SELECT DISTINCT
    playerid,
    schoolid
FROM collegeplaying;


-- View: v_player_seasons
-- Purpose: total MLB seasons played per player, based on Appearances.

CREATE OR REPLACE VIEW v_player_seasons AS
SELECT
    playerid,
    COUNT(DISTINCT yearid) AS num_seasons
FROM appearances
GROUP BY playerid;

-- View: v_player_debut_decade
-- Purpose: link each player–school pair to their MLB debut year and debut decade.

CREATE OR REPLACE VIEW v_player_debut_decade AS
SELECT
    vps.playerid,
    vps.schoolid,
    p.debut,
    EXTRACT(YEAR FROM p.debut) AS debut_year,
    FLOOR(EXTRACT(YEAR FROM p.debut) / 10) * 10 AS debut_decade
FROM v_player_school AS vps
INNER JOIN people AS p
    ON vps.playerid = p.playerid
WHERE p.debut IS NOT NULL;


-- View: annual payroll per team and season
CREATE OR REPLACE VIEW v_team_year_payroll AS
SELECT
    yearID,
    teamID,
    SUM(salary) AS annual_payroll
FROM salaries
GROUP BY
    yearID,
    teamID;


-- View: average annual payroll per franchise across all seasons
CREATE OR REPLACE VIEW v_team_avg_annual_payroll AS
SELECT
    teamID,
    SUM(salary) AS total_salary,
    COUNT(DISTINCT yearID) AS n_years,
    ROUND(SUM(salary) / COUNT(DISTINCT yearID), 2) AS avg_annual_payroll
FROM salaries
GROUP BY
    teamID;

-- View: all teams that appeared in any postseason series (winner or loser)
CREATE OR REPLACE VIEW v_postseason_teams AS
SELECT DISTINCT
    yearID,
    teamIDwinner AS teamID
FROM seriespost

UNION

SELECT DISTINCT
    yearID,
    teamIDloser AS teamID
FROM seriespost;


-- View: teams that reached ALCS, NLCS, or World Series (winner or loser)
CREATE OR REPLACE VIEW v_lcs_ws_teams AS
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
WHERE round IN ('ALCS', 'NLCS', 'WS');

-- View: v_player_debut_final_teams
-- Purpose: Link each player to their debut and final MLB seasons, along with
--          the team(s) they appeared for in those seasons and a simple
--          year-based career length.
-- Notes:   Keeps one row per player–debut-team–final-team combination.
--          Players who appeared for multiple teams in their debut or final
--          season will have multiple rows. Career length is computed as
--          final_year - debut_year (calendar-year difference).

CREATE OR REPLACE VIEW v_player_debut_final_teams AS
SELECT
    py.playerid,
    py.debut_year,
    py.final_year,
    ad.teamid AS debut_team,
    af.teamid AS final_team,
    (py.final_year - py.debut_year) AS career_length
FROM (
    SELECT
        playerid,
        EXTRACT(YEAR FROM debut)     AS debut_year,
        EXTRACT(YEAR FROM finalgame) AS final_year
    FROM people
    WHERE debut IS NOT NULL
      AND finalgame IS NOT NULL
) AS py
LEFT JOIN appearances AS ad
  ON py.playerid = ad.playerid
 AND py.debut_year = ad.yearid
LEFT JOIN appearances AS af
  ON py.playerid = af.playerid
 AND py.final_year = af.yearid;

