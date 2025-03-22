Create Database TitanicDB;

USE TitanicDB
--Step 1: Data Exploration with SQL
-- 1.1. Check the data
SELECT TOP 10 * FROM dbo.titanic;

-- 1.2. Count Total Passengers
SELECT COUNT(*) AS Total_Passengers FROM Titanic;

--1.3. Check Missing Values
SELECT 
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Missing_Age,
    SUM(CASE WHEN Cabin IS NULL THEN 1 ELSE 0 END) AS Missing_Cabin,
    SUM(CASE WHEN Embarked IS NULL THEN 1 ELSE 0 END) AS Missing_Embarked
FROM Titanic;

-- Step 2: Survival Analysis 
-- 2.1. Survival Rate
SELECT 
    Survived, COUNT(*) AS Count, 
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Titanic) AS Percentage
FROM Titanic
GROUP BY Survived;


--2.2. Survival by Passenger Class
SELECT 
    Pclass, 
    COUNT(*) AS Total_Passengers,
    SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) AS Survived_Count,
    SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Survival_Rate
FROM Titanic
GROUP BY Pclass
ORDER BY Survival_Rate DESC;

--2.3. Survival by Gender
SELECT 
    Sex, 
    COUNT(*) AS Total_Passengers,
    SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) AS Survived_Count,
    SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Survival_Rate
FROM Titanic
GROUP BY Sex;


--2.4. Survival by Age Group
SELECT 
    CASE 
        WHEN Age < 10 THEN '0-9'
        WHEN Age BETWEEN 10 AND 19 THEN '10-19'
        WHEN Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+' 
    END AS Age_Group,
    COUNT(*) AS Total_Passengers,
    SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) AS Survived_Count,
    SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Survival_Rate
FROM Titanic
WHERE Age IS NOT NULL
GROUP BY 
    CASE 
        WHEN Age < 10 THEN '0-9'
        WHEN Age BETWEEN 10 AND 19 THEN '10-19'
        WHEN Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+' 
    END
ORDER BY Age_Group;

-- Step 3: Advanced SQL Analysis
--3.1. Fare Analysis
SELECT 
    Pclass, 
    AVG(Fare) AS Avg_Fare,
    MIN(Fare) AS Min_Fare,
    MAX(Fare) AS Max_Fare
FROM Titanic
GROUP BY Pclass
ORDER BY Pclass;


--3.2. Correlation Between Family Size and Survival
SELECT 
    (SibSp + Parch) AS Family_Size,
    COUNT(*) AS Total_Passengers,
    SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) AS Survived_Count,
    SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Survival_Rate
FROM Titanic
GROUP BY (SibSp + Parch)
ORDER BY Family_Size;


-- Step 4: Feature Engineering Enhancements
--4.1. Add a Family_Size Column
ALTER TABLE Titanic ADD Family_Size INT;
UPDATE Titanic 
SET Family_Size = SibSp + Parch + 1;


--4.2. Extract Title from Name
ALTER TABLE Titanic ADD Title NVARCHAR(20);

UPDATE Titanic
SET Title = 
    CASE 
        WHEN Name LIKE '%Mr.%' THEN 'Mr'
        WHEN Name LIKE '%Mrs.%' THEN 'Mrs'
        WHEN Name LIKE '%Miss.%' THEN 'Miss'
        WHEN Name LIKE '%Master.%' THEN 'Master'
        WHEN Name LIKE '%Dr.%' THEN 'Dr'
        ELSE 'Other'
    END;


--4.3. Categorize Fare into Ranges
ALTER TABLE Titanic ADD Fare_Category NVARCHAR(20);

UPDATE Titanic
SET Fare_Category = 
    CASE 
        WHEN Fare < 10 THEN 'Low'
        WHEN Fare BETWEEN 10 AND 30 THEN 'Mid'
        WHEN Fare BETWEEN 30 AND 60 THEN 'High'
        ELSE 'Very High'
    END;

-- step 5: Additional Advanced Analysis
-- 5.1. Survival by Title
SELECT 
    Title,
    COUNT(*) AS Total_Passengers,
    SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) AS Survived_Count,
    SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Survival_Rate
FROM Titanic
GROUP BY Title
ORDER BY Survival_Rate DESC;



-- 5.2.Relationship Between Fare & Survival
SELECT 
    Fare_Category, 
    COUNT(*) AS Total_Passengers,
    SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) AS Survived_Count,
    SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Survival_Rate
FROM Titanic
GROUP BY Fare_Category
ORDER BY Fare_Category;


-- 5.3.Survival Rate for Families vs. Solo Travelers

SELECT 
    CASE 
        WHEN Family_Size = 1 THEN 'Alone'
        WHEN Family_Size BETWEEN 2 AND 4 THEN 'Small Family'
        ELSE 'Large Family'
    END AS Family_Type,
    COUNT(*) AS Total_Passengers,
    SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) AS Survived_Count,
    SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Survival_Rate
FROM Titanic
GROUP BY 
    CASE 
        WHEN Family_Size = 1 THEN 'Alone'
        WHEN Family_Size BETWEEN 2 AND 4 THEN 'Small Family'
        ELSE 'Large Family'
    END
ORDER BY Survival_Rate DESC;


