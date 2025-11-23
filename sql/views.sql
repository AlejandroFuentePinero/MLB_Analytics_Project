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
