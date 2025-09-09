-- Question Solutions:

-- 1. How are players distributed across the five major leagues?  
		WITH League_Distribution AS (
			SELECT league_name, COUNT(Player_ID) AS Player_Count  
			FROM League L
			INNER JOIN Team T ON T.League_ID = L.League_ID
			INNER JOIN Player P ON P.Team_ID = T.Team_ID
			GROUP BY League_Name
				)
		SELECT League_name,
		Player_Count,
		Round(Player_Count / 110.0 * 100,2) AS Percentage
		FROM League_Distribution
		ORDER BY Player_Count DESC;

-- 2. How does player representation vary by continent? 
		WITH Continent_Player_Distribution AS (
			SELECT  	
				CASE WHEN Continent_id = 1 THEN 'Africa'
				WHEN Continent_ID = 2 THEN 'Asia'
				WHEN Continent_ID = 3 THEN 'Europe'
				WHEN Continent_ID = 4 THEN 'North America'
				ELSE 'South America'
				END AS Continent_Name,
				COUNT(Player_ID) Player_Count
			FROM Geography G
			INNER JOIN Player P ON P.Nation_ID = G.Nation_ID
			GROUP BY Continent_Name
				)
		SELECT Continent_Name, 
				Player_Count,
				ROUND(Player_Count /110.0 * 100,2) AS Percentage
		FROM Continent_Player_Distribution
		ORDER BY Player_Count DESC;

-- 3. Which country contributes the most players in this dataset?  
		SELECT Country, COUNT(G.Nation_ID) Total_Players
		FROM Geography G
		INNER JOIN PLAYER P ON P.Nation_ID = G.Nation_ID
		GROUP BY Country
		ORDER BY Total_Players DESC LIMIT 1;

-- 4.  How does player market value compare across the different leagues?
		WITH Leage_Market_Value AS (
			SELECT Name, League_Name, Market_Value
			FROM league L
			INNER JOIN Team T ON T.League_ID = L.League_ID
			INNER JOIN Player P ON P.Team_ID = T.Team_ID
					)
 					--- Side Note: '€' || To_CHAR('FM99,999,999,990.00'):  Formats the value with a Euro symbol and two decimal places
		SELECT 
		League_Name,
		'€' || To_CHAR(MIN(Market_Value), 'FM99,999,999,990.00') AS "Lowest Market Value", 
		'€' || To_CHAR(Max(Market_Value), 'FM99,999,999,990.00') AS "Highest Market Value", 	
		'€' || To_CHAR(SUM(Market_Value), 'FM99,999,999,990.00') AS "Sum Market Value", 	
		'€' || To_CHAR(ROUND(AVG(Market_Value),2),'FM999,999,999,990.00')  AS "Average Market Value" 
		FROM Leage_Market_Value 
		GROUP BY League_Name;
	
-- 5.  Which clubs rank highest in terms of total and average player market value?  
		WITH Team_Market_Value AS (
			SELECT Name, Team_Name, Market_Value
			FROM Team T
			INNER JOIN Player P ON P.Team_ID = T.Team_ID
			ORDER BY T.Team_ID
					)
		SELECT 
			Team_Name,
			'€' || To_CHAR(ROUND(AVG(Market_Value),2),'FM999,999,999,990.00')  AS "Average Market Value" ,
			RANK () OVER(ORDER BY AVG(Market_Value)DESC) AS Average_Market_Value_Rank,
			'€' || To_CHAR(SUM(Market_Value), 'FM99,999,999,990.00') AS "Sum Market Value"	,
			RANK () OVER(ORDER BY SUM(Market_Value)DESC) AS Sum_Of_Market_Value_Rank
		FROM  Team_Market_Value
		GROUP BY Team_Name;
	
-- 6. How does average player market value vary across age groups?
		 WITH Market_Value_Via_Age_Group AS (
			SELECT 
				EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM Birthdate) AS AGE, Market_Value,
				CASE
				WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM Birthdate)  BETWEEN 17 AND 24 THEN '17-24'
				WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM Birthdate)  BETWEEN 25 AND 29 THEN '25-29'
				ELSE '30+'
				END AS AGE_GROUP
			FROM PLAYER
				)
		SELECT
			'€' || TO_CHAR(ROUND(AVG(Market_Value),2),'FM9,999,999,999.00') Average_Value,
			AGE_GROUP
		FROM Market_Value_Via_Age_Group
		GROUP BY AGE_GROUP
		ORDER BY Average_Value DESC;

	
-- 7. Which players have had the longest professional careers?  
		SELECT Name,
				Team_Name, 
				Extract(YEAR FROM CURRENT_DATE) - Career_Debut AS Years_Playing_Professional,
				RANK () OVER (PARTITION BY t.Team_ID ORDER BY Extract(YEAR FROM CURRENT_DATE) - Career_Debut DESC) AS Career_Length_Rank_Within_Team,
				RANK () OVER (ORDER BY Extract(YEAR FROM CURRENT_DATE) - Career_Debut DESC) AS Overall_Ranking
		FROM player P
		INNER JOIN Team T ON T.Team_ID = P.Team_ID
		ORDER BY Team_Name, Career_Length_Rank_Within_Team;


-- 8.  What is the average career length by position?  
		WITH Career_Length AS (
			SELECT Position, Name,
			Extract (YEAR FROM CURRENT_DATE) - Career_Debut AS Career_Length
			FROM PLAYER
				)
		SELECT Position,
				ROUND(AVG(Career_Length),2) AS Average_Career_Length_in_Years
		FROM Career_Length
		GROUP BY Position
		ORDER BY Average_Career_Length_In_Years DESC ;


-- 9.Who are the top 10 players with the most career goals?
		 SELECT 
			Name,
			SUM(Goals) Career_Goals, 
			RANK () OVER( ORDER BY SUM(Goals) DESC) AS Career_Goals_Rank
		FROM 
			Player P
		INNER JOIN 
			Career_Stats CS ON CS.Player_ID = P.Player_ID
		GROUP BY Name
        LIMIT 10;
	
-- 10. Who are the top 20 players with the most career assists?  
		 SELECT 
			Name,
			SUM(Assists) Career_Assists,
			RANK () OVER( ORDER BY SUM(Assists) DESC) AS Career_Assists_Rank
		FROM 
			Player P
		INNER JOIN 
			Career_Stats CS ON CS.Player_ID = P.Player_ID
		GROUP BY Name
        LIMIT 20;

-- 11. Which players have accumulated the most disciplinary cards?  
		SELECT
			Name,
			SUM(Yellow_Cards + Red_Cards) AS Disciplinary_Cards,
			RANK () OVER (ORDER BY SUM(Yellow_Cards + Red_Cards) DESC) AS Disciplinary_Cards_Rank
		FROM 
			Player P
		INNER JOIN 
			Career_Stats CS ON CS.Player_ID = P.Player_ID
		GROUP BY Name
        Limit 10;

-- 12. How many players with over 150 games have never received a red card? 
		SELECT COUNT(name) AS Total_Players
		FROM Player P
		INNER JOIN Career_Stats CS ON CS.Player_ID = P.Player_ID
		WHERE Red_Cards = 0 AND Games >= 150;
			
-- 13. Which players have stayed with their current club for at least 5 years?
		 SELECT Name,
				Extract(YEAR FROM CURRENT_DATE) - Year_Joined_Club AS Current_Club_Duration
		FROM Player
		Where Extract(YEAR FROM CURRENT_DATE) - Year_Joined_Club >= 5
		ORDER BY Current_Club_Duration DESC;

-- 14. Who are the top 5 highest-valued players?  
		SELECT Name, Market_Value
		FROM Player
		ORDER BY Market_Value DESC
		LIMIT 5;
	


	





