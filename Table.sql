
-- Table Names for Top 5 League Soccer Analysis

CREATE DATABASE Soccer_Analysis;


CREATE TABLE Player (Player_ID SERIAL PRIMARY KEY,
					Full_Name VARCHAR (100),
					Birthdate DATE,
					Nationality VARCHAR (50),
					Nation_ID INT,
					FOREIGN KEY (Nation_ID) REFERENCES Geography (Nation_ID),
					Position VARCHAR (50),
					Jersey_Number INT,
					Team_ID INT,
					FOREIGN KEY (Team_ID) REFERENCES Team (Team_ID),
					Year_Joined_Club INT ,
					Debut_Career INT,
					Market_Value_In_Millions DECIMAL(20,2)
					);


CREATE TABLE Team ( Team_ID SERIAL PRIMARY KEY,
					Team_Name VARCHAR (100),
					Founded_Year INT,
					Stadium_Name VARCHAR (100),
					City VARCHAR (100),
					Country VARCHAR (50),
					League_ID INT,
					FOREIGN KEY (League_ID) REFERENCES League (League_ID)
					);


CREATE TABLE League (League_ID INT Primary Key,
					League_Name VARCHAR (50) 
						);


CREATE TABLE Geography (Nation_ID SERIAL Primary Key,
				Country VARCHAR (100),
				Continent_ID INT
					);


CREATE Table Career_Stats (Stats_ID SERIAL Primary Key,
					Player_ID INT,
					FOREIGN KEY (Player_ID) REFERENCES Player (Player_ID),
					Games INT,
					Goals INT,
					Assists INT,
					Yellow_Cards INT,
					Red_Cards INT
							);


	
	
