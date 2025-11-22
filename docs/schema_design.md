# Schema Design

This document describes the data structures used in the MLB Analytics Project, including:  
(1) the tables imported from the Lahman Database (1871–2024), and  
(2) the project-owned logical layer under the `mlb_analytics` schema.

The goal is to provide a clear understanding of the underlying raw data model and the analytical views used throughout the project.

---

## Base Schema: Lahman Database (1871–2024)

The raw Lahman dataset is loaded directly into PostgreSQL with **no restructuring** of tables.  
The project uses **10 core tables** corresponding exactly to the CSV files imported into the database.

---

## Core Tables Used (10 Total)

### **1. People**
Biographical and career information for every MLB player.
- `playerID` (PK)  
- Name fields (first, last)  
- Birth details  
- Debut / finalGame  
- Physical attributes (height, weight)  
- Bats / throws  
- Used to anchor all player-level joins.

---

### **2. Appearances**
Player participation by team + season + position.
- Composite PK: (`yearID`, `teamID`, `playerID`)  
- Games played at each position  
- Used to determine player roles and primary team per year.

---

### **3. Pitching**
Season-level pitcher statistics.
- Composite PK: (`playerID`, `yearID`, `stint`)  
- ERA, IPouts, SO, BB, HR allowed, etc.  
- Used for pitcher performance and career trajectory analysis.

---

### **4. Salaries**
Annual player salary records.
- Composite PK: (`yearID`, `teamID`, `playerID`)  
- Salary (USD)  
- Used for payroll time series, league comparisons, and postseason–payroll correlations.

---

### **5. Teams**
Season-level team metadata.
- Composite PK: (`yearID`, `teamID`)  
- Wins, losses, attendance  
- Ballpark, league, franchise  
- Park factor data (`BPF`, `PPF`)  
- Used to contextualize salaries, player performance, and postseason results.

---

### **6. TeamsFranchises**
Franchise-level historical information.
- `franchID` (PK)  
- Franchise name/history  
- Used for long-term team identity analysis (e.g., defunct or relocated franchises).

---

### **7. Schools**
Metadata for each school.
- `schoolID` (PK)  
- School name  
- City, state, country  
- Used in geographic talent pipeline analysis.

---

### **8. CollegePlaying**
Links players to schools they attended.
- Composite PK: (`playerID`, `schoolID`)  
- Used for school → MLB progression and pipeline evaluations.

---

### **9. HallOfFame**
Hall of Fame voting and induction data.
- Composite PK: (`playerID`, `yearID`, `votedBy`)  
- Ballots, votes, induction status  
- Used for comparing inducted vs. non-inducted player careers.

---

### **10. SeriesPost**
Postseason series outcomes.
- Composite PK: (`yearID`, `round`, `teamIDwinner`, `teamIDloser`)  
- Series winners, losers, and games won  
- Used for postseason performance and payroll correlation analyses.

---

## Project Schema: `mlb_analytics`

This schema contains all project-owned analytical objects:

```sql
CREATE SCHEMA IF NOT EXISTS mlb_analytics;
