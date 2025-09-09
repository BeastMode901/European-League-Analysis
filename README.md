
# Europe's Top 5 League Analysis

## Table of Contents
- [Project Overview](#project-overview)
- [Datasets](#datasets)
- [Tools](#tools)
- [Skills Applied](#skills-applied)
- [Questions Explored](#questions-explored)
- [Interesting Queries](#interesting-queries)
- [Summary of Findings](#summary-of-findings)

### Project Overview
In this project, I looked at 110 player profiles from Europe’s top five football leagues to see what trends emerge in player performance and value. I explored players’ age, market value, career stats, and team affiliations, looked at how players are distributed across leagues and countries, identified the top-valued players, tracked career length, highlighted top goal scorers and assist leaders, and examined disciplinary records. The goal was to get a clear picture of how players perform and how leagues and clubs compare across Europe.

### Datasets
- **Player Profile**: Details such as name, birthdate, jersey number, and market value.  
- **Player Statistics**: Metrics including games, goals, and assists.  
- **Team Info**: Information about the team and their league affiliation.  
- **League Info**: Names of the leagues.  
- **Geographical Data**: Information on the players' countries.  

### Tools
- **PostgreSQL** - Imported the Excel data into Postgres SQL for data cleaning and analysis.  
  - [Download PostgreSQL Here](https://www.postgresql.org/download/windows/)  
- **Power BI** - Created visuals for the data.  
  - [Download Power BI Here](https://www.microsoft.com/en-us/power-platform/products/power-bi/downloads)  

### Skills Applied
- JOINs  
- Aggregations  
- CTEs  
- Window Functions  
- Case Statements  
- Date Functions  
- Grouping and Sorting  

### Questions Explored
1. How are players distributed across the five major leagues?  
2. How does player representation vary by continent?  
3. Which country contributes the most players in this dataset?  
4. How does player market value compare across the different leagues?  
5. Which clubs rank highest in terms of total and average player market value?  
6. How does average player market value vary across age groups?  
7. Which players have had the longest professional careers?  
8. What is the average career length by position?  
9. Who are the top 10 players with the most career goals?  
10. Who are the top 20 players with the most career assists?  
11. Which players have accumulated the most disciplinary cards?  
12. How many players with over 150 games have never received a red card?  
13. Which players have stayed with their current club for at least 5 years?  
14. Who are the top 5 highest-valued players?  


### Interesting Queries

Q4: How does player market value compare across the different leagues? 
```sql
WITH Leage_Market_Value AS (
    SELECT Name, League_Name, Market_Value
    FROM league L
    INNER JOIN Team T ON T.League_ID = L.League_ID
    INNER JOIN Player P ON P.Team_ID = T.Team_ID
)
SELECT 
    League_Name,
    '€' || To_CHAR(MIN(Market_Value), 'FM99,999,999,990.00') AS "Lowest Market Value", 
    '€' || To_CHAR(MAX(Market_Value), 'FM99,999,999,990.00') AS "Highest Market Value",     
    '€' || To_CHAR(SUM(Market_Value), 'FM99,999,999,990.00') AS "Sum Market Value",     
    '€' || To_CHAR(ROUND(AVG(Market_Value),2),'FM999,999,999,990.00')  AS "Average Market Value" 
FROM Leage_Market_Value 
GROUP BY League_Name;
```

Q7:  Which players have had the longest professional careers?
```sql
SELECT
    Name,
    Team_Name, 
    EXTRACT(YEAR FROM CURRENT_DATE) - Career_Debut AS Years_Playing_Professional,
    RANK () OVER (PARTITION BY T.Team_ID ORDER BY EXTRACT(YEAR FROM CURRENT_DATE) - Career_Debut DESC) AS Career_Length_Rank_Within_Team,
    RANK () OVER (ORDER BY EXTRACT(YEAR FROM CURRENT_DATE) - Career_Debut DESC) AS Overall_Ranking
FROM player P
INNER JOIN Team T ON T.Team_ID = P.Team_ID
ORDER BY Team_Name, Career_Length_Rank_Within_Team;
```

Q13: Which players have stayed with their current club for at least 5 years? 
```sql
SELECT
    Name,
    EXTRACT(YEAR FROM CURRENT_DATE) - Year_Joined_Club AS Current_Club_Duration
FROM Player 
WHERE EXTRACT(YEAR FROM CURRENT_DATE) - Year_Joined_Club >= 5
ORDER BY Current_Club_Duration DESC;
```

### Summary of Findings
- The majority of players are in the Premier League, followed by Ligue 1 and Bundesliga, while Serie A and La Liga have the fewest players represented.  
- Over 70% of players come from Europe, with France having the highest representation; North America has the fewest players. 
- The Premier League leads in both total and average market value of players, while Ligue 1 ranks lowest. Four of the highest-valued players are from the Premier League or La Liga.
- Real Madrid has the highest total and average market value among clubs, followed by Manchester City; Sevilla ranks lowest in both metrics.
- Younger players (17-24) have the highest average market value, followed by mid-age players (25-29), with seniors (30+) at the bottom.
- Defenders have the longest average career duration.
- Jesús Navas of Sevilla has the longest playing career at 21 years, while Lamine Yamal and Pau Cubarsi of Barcelona have the shortest at 1 year each. 
- Robert Lewandowski of Barcelona leads in career goals; Kevin De Bruyne of Manchester City leads in career assists; Granit Xhaka of Bayer Leverkusen has the most disciplinary cautions.  
- 25 players have played over 150 games without receiving a red card.
- 21 players have been with their current club for at least 5 years, with Dani Carvajal holding the longest tenure at 11 years with Real Madrid.
