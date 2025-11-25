-- Table: appearances
-- Source: Appearances.csv (Lahman dataset)
-- Purpose: Records the number of games played by each player per year and position.
-- Primary key uniquely identifies a player’s appearances in a given season and team.

CREATE TABLE appearances (
    yearid      SMALLINT,
    teamid      VARCHAR(3),
    lgid        VARCHAR(3),
    playerid    VARCHAR(10),

    g_all       SMALLINT,
    gs          SMALLINT,
    g_batting   SMALLINT,
    g_defense   SMALLINT,
    g_p         SMALLINT,
    g_c         SMALLINT,
    g_1b        SMALLINT,
    g_2b        SMALLINT,
    g_3b        SMALLINT,
    g_ss        SMALLINT,
    g_lf        SMALLINT,
    g_cf        SMALLINT,
    g_rf        SMALLINT,
    g_of        SMALLINT,
    g_dh        SMALLINT,
    g_ph        SMALLINT,
    g_pr        SMALLINT,

    PRIMARY KEY (yearid, teamid, playerid)
);


-- Table: collegeplaying
-- Source: CollegePlaying.csv (Lahman dataset)
-- Purpose: Links players to colleges; one row per player–school–year.
-- Notes:
--   Some records have unknown year (yearid is NULL), so we use a surrogate
--   primary key instead of (playerid, schoolid, yearid). We still keep a
--   unique index on that triplet for data integrity.

CREATE TABLE collegeplaying (
    collegeplaying_id SERIAL PRIMARY KEY,  -- surrogate key

    playerid   VARCHAR(10)  NOT NULL,
    schoolid   VARCHAR(50)  NOT NULL,
    yearid     SMALLINT                 -- may be NULL when year is unknown
);

-- Enforce uniqueness of the logical key while allowing NULL yearid
CREATE UNIQUE INDEX collegeplaying_player_school_year_uidx
    ON collegeplaying (playerid, schoolid, yearid);



-- Table: halloffame
-- Source: HallOfFame.csv (Lahman dataset)
-- Purpose: Hall of Fame voting results by player, year, and voting body.
-- Notes:
--   - Some records have NULL values for 'inducted', ballots, needed, votes, etc.
--   - needed_note contains free-text notes, so TEXT is used.
--   - Composite PK matches Lahman's logical key.

CREATE TABLE halloffame (
    playerid     VARCHAR(10)  NOT NULL,
    yearid       SMALLINT     NOT NULL,
    votedby      VARCHAR(64)  NOT NULL,
    ballots      SMALLINT,
    needed       SMALLINT,
    votes        SMALLINT,
    inducted     CHAR(1),         -- WAS NOT NULL — NOW nullable because Lahman has blank entries
    category     VARCHAR(32),
    needed_note  TEXT,

    PRIMARY KEY (playerid, yearid, votedby)
);


-- Table: parks
-- Source: Parks.csv (Lahman dataset)
-- Purpose: List of ballparks, aliases, and location information.
-- Notes:
--   - 'state' can contain long names ('New South Wales'), not just abbreviations.
--   - TEXT is used for flexible-length fields.
--   - 'id' is the primary key from the dataset.

CREATE TABLE parks (
    id         INTEGER PRIMARY KEY,  -- park ID from dataset
    parkalias  TEXT,                 -- alternate / historical names
    parkkey    VARCHAR(20),          -- short identifier (e.g. 'ALB01')
    parkname   TEXT,                 -- official full name of park
    city       TEXT,                 -- city name
    state      TEXT,                 -- full state/province name or abbreviation
    country    TEXT                  -- full country name
);


-- Table: people
-- Source: People.csv (Lahman dataset)
-- Purpose: Master list of players with biographical info and identifiers.
-- Notes:
--   - playerid is the main key used to link to all other tables.
--   - Many text fields are TEXT to avoid length problems (cities, names, etc.).
--   - Dates may be NULL for players without known debut/finalGame.

CREATE TABLE people (
    id           INTEGER,        -- row ID from dataset (not primary key)
    playerid     VARCHAR(10) PRIMARY KEY,  -- Lahman player ID, e.g. 'aaronha01'

    birthyear    SMALLINT,
    birthmonth   SMALLINT,
    birthday     SMALLINT,
    birthcity    TEXT,
    birthcountry TEXT,
    birthstate   TEXT,

    deathyear    SMALLINT,
    deathmonth   SMALLINT,
    deathday     SMALLINT,
    deathcountry TEXT,
    deathstate   TEXT,
    deathcity    TEXT,

    namefirst    TEXT,
    namelast     TEXT,
    namegiven    TEXT,

    weight       SMALLINT,
    height       SMALLINT,
    bats         CHAR(1),        -- 'R', 'L', 'B', or NULL
    throws       CHAR(1),        -- 'R', 'L', or NULL

    debut        DATE,
    bbrefid      TEXT,
    finalgame    DATE,
    retroid      TEXT
);


-- Table: pitching
-- Source: Pitching.csv (Lahman dataset)
-- Purpose: Season-level pitching statistics for each player and team.
-- Notes:
--   - Many numeric stats can be NULL in earlier eras.
--   - VARCHAR sizes are generous to avoid import failures.
--   - Composite primary key matches Lahman's logical key.
--   - IPouts, BFP, and many stats are integers and may contain NULL.

CREATE TABLE pitching (
    playerid   VARCHAR(10)  NOT NULL,
    yearid     SMALLINT     NOT NULL,
    stint      SMALLINT     NOT NULL,
    teamid     VARCHAR(10),
    lgid       VARCHAR(10),    -- allow up to 10 chars; Lahman includes 'EAS', etc.

    w          SMALLINT,
    l          SMALLINT,
    g          SMALLINT,
    gs         SMALLINT,
    cg         SMALLINT,
    sho        SMALLINT,
    sv         SMALLINT,
    ipouts     INTEGER,

    h          INTEGER,
    er         INTEGER,
    hr         INTEGER,
    bb         INTEGER,
    so         INTEGER,

    baopp      DECIMAL(5,3),
    era        DECIMAL(6,3),

    ibb        INTEGER,
    wp         INTEGER,
    hbp        INTEGER,
    bk         INTEGER,
    bfp        INTEGER,

    gf         INTEGER,
    r          INTEGER,
    sh         INTEGER,
    sf         INTEGER,
    gidp       INTEGER,

    PRIMARY KEY (playerid, yearid, stint)
);


-- Table: salaries
-- Source: Salaries.csv (Lahman dataset)
-- Purpose: Player salary by year, team, and league.
-- Notes:
--   - lgid and teamid are widened to handle non-standard codes.
--   - salary stored as BIGINT to cover historical + modern values.
--   - Composite PK matches Lahman's logical key.

CREATE TABLE salaries (
    yearid    SMALLINT     NOT NULL,
    teamid    VARCHAR(10)  NOT NULL,
    lgid      VARCHAR(10)  NOT NULL,
    playerid  VARCHAR(10)  NOT NULL,
    salary    BIGINT,          -- annual salary in dollars (can be NULL)

    PRIMARY KEY (yearid, teamid, lgid, playerid)
);



-- Table: schools
-- Source: Schools.csv (Lahman dataset)
-- Purpose: Master list of colleges/universities with identifiers and location.
-- Notes:
--   - schoolid is the primary key; values vary widely in length.
--   - All text fields use TEXT to avoid truncation and import errors.

CREATE TABLE schools (
    schoolid   TEXT PRIMARY KEY,   -- e.g., 'akron', 'abilchrist', 'albanyst1878'
    name_full  TEXT,               -- full school name
    city       TEXT,               -- city where school is located
    state      TEXT,               -- state / province (varies in length)
    country    TEXT                -- e.g., 'USA', 'Canada', etc.
);



-- Table: seriespost
-- Source: SeriesPost.csv (Lahman dataset)
-- Purpose: Postseason series results (WS, LCS, DS, etc.).
-- Notes:
--   - Round codes vary by era ('WS', 'ALCS', 'NLDS', etc.), so we allow longer text.
--   - League and team IDs are widened to handle non-standard codes.
--   - Composite PK uniquely identifies each series.

CREATE TABLE seriespost (
    yearid       SMALLINT     NOT NULL,
    round        VARCHAR(20)  NOT NULL,   -- e.g. 'WS', 'ALCS', 'NLDS', 'CS'
    teamidwinner VARCHAR(10)  NOT NULL,
    lgidwinner   VARCHAR(10),
    teamidloser  VARCHAR(10)  NOT NULL,
    lgidloser    VARCHAR(10),
    wins         SMALLINT,
    losses       SMALLINT,
    ties         SMALLINT,

    PRIMARY KEY (yearid, round, teamidwinner, teamidloser)
);


-- Table: teams
-- Source: Teams.csv (Lahman dataset)
-- Purpose: Season-level team statistics and identifiers.
-- Notes:
--   - 48 columns, including identifiers, standings, batting/pitching totals,
--     defensive stats, attendance, and various team codes.
--   - Many identifier columns vary in length across leagues and eras, so TEXT is safest.
--   - All numeric fields may contain NULL for certain seasons.
--   - Composite primary key (yearid, teamid) is standard for Lahman.

CREATE TABLE teams (
    yearid              SMALLINT     NOT NULL,
    lgid                TEXT,
    teamid              TEXT         NOT NULL,
    franchid            TEXT,
    divid               TEXT,
    rank                SMALLINT,
    g                   SMALLINT,
    ghome               SMALLINT,
    w                   SMALLINT,
    l                   SMALLINT,
    divwin              TEXT,
    wcwin               TEXT,
    lgwin               TEXT,
    wswin               TEXT,
    r                   INTEGER,
    ab                  INTEGER,
    h                   INTEGER,
    "2b"                INTEGER,
    "3b"                INTEGER,
    hr                  INTEGER,
    bb                  INTEGER,
    so                  INTEGER,
    sb                  INTEGER,
    cs                  INTEGER,
    hbp                 INTEGER,
    sf                  INTEGER,
    ra                  INTEGER,
    er                  INTEGER,
    era                 DECIMAL(6,3),
    cg                  SMALLINT,
    sho                 SMALLINT,
    sv                  SMALLINT,
    ipouts              INTEGER,
    ha                  INTEGER,
    hra                 INTEGER,
    bba                 INTEGER,
    soa                 INTEGER,
    e                   INTEGER,
    dp                  INTEGER,
    fp                  DECIMAL(5,4),
    name                TEXT,
    park                TEXT,
    attendance          INTEGER,
    bpf                 SMALLINT,
    ppf                 SMALLINT,
    teamidbr            TEXT,
    teamidlahman45      TEXT,
    teamidretro         TEXT,

    PRIMARY KEY (yearid, teamid)
);


-- Table: teamsfranchises
-- Source: TeamsFranchises.csv (Lahman dataset)
-- Purpose: Franchise-level info (long-lived clubs across different team IDs).
-- Notes:
--   - franchid is the primary key used to link with Teams.franchid.
--   - active is usually 'Y', 'N', or 'NA'.
--   - All text fields are TEXT to avoid length issues.

CREATE TABLE teamsfranchises (
    franchid    TEXT PRIMARY KEY,  -- e.g. 'ATL', 'BOS', 'NYA'
    franchname  TEXT,              -- franchise name, e.g. 'Atlanta Braves'
    active      TEXT,              -- 'Y', 'N', 'NA'
    naassoc     TEXT               -- historical association (e.g. 'NA', 'PNA', 'BNA'), nullable
);


-- ------------------
-- End of SCHEMA Code
-- ------------------