# Schema Design

This document describes the data structures used in the MLB Analytics Project, including  
(1) the relevant tables from the Lahman Database (1871–2024), and  
(2) the project-owned logical layer under the `mlb_analytics` schema.

The goal is to provide a clear understanding of the underlying data model and the analytical views used throughout the project.

---

## Base Schema: Lahman Database (1871–2024)

The project works directly with the raw Lahman dataset, without restructuring or altering any base tables.  
Only a subset of tables is used, focused on players, salaries, schools, careers, teams, and gameplay events.

### **Core Tables Used**

#### **1. People**
Biographical and key career information for every MLB player.
- `playerID` — unique identifier  
- `nameFirst`, `nameLast`  
- `birthYear`, `birthMonth`, `birthDay`  
- `debut`, `finalGame`  
- `height`, `weight`  
- `bats` (R/L/B), `throws`

#### **2. Appearances**
Player participation by team and season.
- `playerID`  
- `teamID`, `yearID`  
- Games by position  
- Used to determine:  
  - primary team per year,  
  - player-team relationships,  
  - pitcher vs non-pitcher roles.

#### **3. Salaries**
Annual salary data.
- `playerID`, `teamID`, `yearID`  
- `salary`  
- Used for spending, payroll ranks, cumulative totals, and postseason comparisons.

#### **4. Teams**
Team-level metadata.
- `teamID`, `yearID`, `lgID`  
- Team names, franchise identifiers  
- Used to connect salaries, appearances, postseason results, and league analyses.

#### **5. CollegePlaying**
Mapping of players to colleges played for.
- `playerID`  
- `schoolID`  
- Used to evaluate talent pipelines.

#### **6. Schools**
Metadata for each school.
- `schoolID`  
- `schoolName`, `schoolCity`, `schoolState`  
- Used for geographic and cross-decade school analysis.

#### **7. HallOfFame**
Induction results for eligible players.
- `playerID`  
- `yearID`  
- `inducted`  
- Used for Hall-of-Fame vs non-Hall comparison analyses.

#### **8. SeriesPost**
Postseason series results for each year.
- `yearID`, `round`, `teamIDwinner`, `teamIDloser`  
- Used to examine payroll vs postseason success.

#### **9. Parks**
Park metadata (historical and modern).
- `park`, `city`, `state`  
- Used for ballpark-based physical profile comparisons.

#### **10. HomeGames**
Team-level home game counts by park and season.
- `teamID`, `yearID`, `park`  
- Used to link players to ballpark characteristics in debut analyses.

---

## Project Schema: `mlb_analytics`

All project-owned objects (views, optional summary tables) live in the dedicated schema:

```sql
CREATE SCHEMA IF NOT EXISTS mlb_analytics;
