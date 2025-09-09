Data Cleaning:

-- Rename Player Table COlumn names
		ALTER TABLE Player
        RENAME COLUMN Full_Name TO Name;

        ALTER TABLE Player
        RENAME COLUMN Jersey_Number TO Jersey;

        ALTER TABLE Player
        RENAME COLUMN Debut_Career TO Career_Debut;

        ALTER TABLE PLAYER
        RENAME COLUMN Market_Value_In_Millions TO Market_Value;


	

-- Update Cole Palmer's Birthdat Information
	
UPDATE Player  
SET Birthdate = '2002-05-06'
WHERE Name = 'Cole Palmer'

-- Change Ghanian to Ghana
	UPDATE Geography
      SET Country = 'Ghana'
      WHERE Country = 'Ghanian'

-- Update Player_ID 32 Stats where value is Null
	UPDATE Career_Stats
	SET Games = 483,
		Goals = 49,
		Assists = 29,
		Yellow_Cards =45,
		Red_Cards = 2
	WHERE Player_ID = 32
