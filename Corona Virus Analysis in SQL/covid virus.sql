--USE [covid project]

SELECT * 
FROM [dbo].[Corona Virus Dataset]
WHERE [Province] = 'Afghanistan'


--Change the datatypes from nvarchar to int
SELECT CONVERT(INT, [Confirmed]) CONFIRMED
FROM [dbo].[Corona Virus Dataset]

ALTER TABLE[dbo].[Corona Virus Dataset]
ADD CONFIRMED_1 INT


UPDATE [dbo].[Corona Virus Dataset]
SET CONFIRMED_1 = [Confirmed]


SELECT CONVERT(INT,[Deaths]) DEATHS_1
FROM [dbo].[Corona Virus Dataset]

ALTER TABLE[dbo].[Corona Virus Dataset]
ADD DEATHS_1 INT

UPDATE [dbo].[Corona Virus Dataset]
SET DEATHS_1 = Deaths

SELECT CONVERT(INT,[Recovered]) RECOVERED_1
FROM [dbo].[Corona Virus Dataset]

ALTER TABLE[dbo].[Corona Virus Dataset]
ADD RECOVERED_1 INT

UPDATE [dbo].[Corona Virus Dataset]
SET RECOVERED_1 = [Recovered]


ALTER TABLE[dbo].[Corona Virus Dataset]
DROP COLUMN [Recovered]


-- To avoid any errors, check missing value / null value 
-- Q1. Write a code to check NULL values

SELECT * 
FROM [dbo].[Corona Virus Dataset]
WHERE Province IS NULL
	OR Country_Region IS NULL
	OR Latitude IS NULL
	OR Longitude IS NULL
	OR Dates IS NULL
	OR Confirmed_1 IS NULL 
	OR DEATHS_1 IS NULL
	OR RECOVERED_1 IS NULL

--If NULL values are present, update them with zeros for all columns.
UPDATE [dbo].[Corona Virus Dataset]
SET Confirmed = 0
WHERE Confirmed IS NULL


 --check total number of rows
SELECT COUNT (*)
FROM [dbo].[Corona Virus Dataset]

 --Check what is start_date and end_date
SELECT MIN([Dates]) AS earliest_start_date, MAX([Dates]) AS latest_end_date
FROM[dbo].[Corona Virus Dataset]


--Number of month present in dataset
SELECT COUNT(DISTINCT MONTH([Dates])) AS Number_Months
FROM [dbo].[Corona Virus Dataset]

-- Find monthly average for confirmed, deaths, recovered
SELECT MONTH([Dates]) AS MONTHS,
		AVG([Confirmed_1]) AS AVG_Confirmed,
		AVG([Deaths_1]) AS AVG_Death,
		AVG([Recovered_1]) AS AVG_Recovered
FROM [dbo].[Corona Virus Dataset]
GROUP BY MONTH([Dates])
ORDER BY MONTHS



-- Find minimum values for confirmed, deaths, recovered per year
SELECT YEAR([Dates]) Yearly,
		MIN(Confirmed_1),
		MIN(Deaths_1),
		MIN(Recovered_1)
FROM [dbo].[Corona Virus Dataset]
WHERE Confirmed_1 != 0 AND
	  Deaths_1 != 0 AND
	  Recovered_1 != 0
GROUP BY YEAR([Dates])
ORDER BY Yearly

---Find maximum values of confirmed, deaths, recovered per year
SELECT YEAR([Dates]) Yearly,
		MAX(Confirmed_1) Max_Confirmed,
		MAX(Deaths_1) Max_Deaths,
		MAX(Recovered_1) Max_Recovered
FROM [dbo].[Corona Virus Dataset]
GROUP BY YEAR([Dates])
ORDER BY Yearly


---The total number of case of confirmed, deaths, recovered each month
SELECT MONTH(DATES) MONTHLY,
		SUM(CONFIRMED_1) Total_confirmed,
		SUM(Deaths_1) Total_deaths,
		SUM(Recovered_1) Total_Recovered
FROM [dbo].[Corona Virus Dataset]
GROUP BY MONTH(DATES)
ORDER BY MONTH(DATES)


--Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )


-- Total confirmed cases
SELECT 
    SUM(Confirmed_1) AS Total_Confirmed_Cases
FROM 
    [dbo].[Corona Virus Dataset];

-- Average confirmed cases
SELECT 
    AVG(Confirmed_1) AS Average_Confirmed_Cases
FROM 
    [dbo].[Corona Virus Dataset];


-- Standard deviation of confirmed cases
SELECT 
    ROUND(STDEV(Confirmed_1), 2) AS StdDev_Confirmed_Cases
FROM 
    [dbo].[Corona Virus Dataset];



--Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average & STDEV )

-- Total death cases per month
SELECT 
    MONTH([Dates]) AS Month,
    SUM(Deaths_1) AS Total_Death_Cases
FROM 
    [dbo].[Corona Virus Dataset]
GROUP BY 
    MONTH([Dates])
ORDER BY 
	Total_Death_Cases DESC


-- Average death cases per month
SELECT 
    AVG(Deaths_1) AS Average_Death_Cases
FROM 
    [dbo].[Corona Virus Dataset];


-- Standard deviation of death cases per month
SELECT 
   ROUND(STDEV(Deaths_1), 2)  AS StdDev_Death_Cases
FROM 
    [dbo].[Corona Virus Dataset];


-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

-- Total recovered cases per month
SELECT 
    MONTH([Dates]) AS Month,
    SUM(recovered_1) AS Total_Recovered_Cases
FROM 
    [dbo].[Corona Virus Dataset]
GROUP BY 
    MONTH([Dates])
ORDER BY 
	Total_Recovered_Cases DESC


-- Average revered cases per month
SELECT 
    AVG(Recovered_1) AS Average_Death_Cases
FROM 
    [dbo].[Corona Virus Dataset];


-- Standard deviation of death cases per month
SELECT ROUND(STDEV(Recovered_1), 2)  AS StdDev_Death_Cases
FROM [dbo].[Corona Virus Dataset];

--Find Country having highest number of the Confirmed case
SELECT [Country_Region], MAX([CONFIRMED_1]) AS Highest_confirmed, COUNT(*)
FROM [dbo].[Corona Virus Dataset]
GROUP BY [Country_Region]
ORDER BY Highest_confirmed DESC

SELECT Country_Region
FROM[dbo].[Corona Virus Dataset]
WHERE Confirmed_1 = (SELECT MAX(Confirmed_1) FROM [dbo].[Corona Virus Dataset]);


--Find Country having lowest number of the death case
SELECT [Country_Region], COUNT(*) AS COUNTRY_PROVINCE, DEATHS_1
FROM [dbo].[Corona Virus Dataset]
WHERE Deaths_1 = (SELECT MIN(Deaths_1) FROM [dbo].[Corona Virus Dataset])
GROUP BY [Country_Region], DEATHS_1
ORDER BY COUNTRY_PROVINCE DESC


--Find top 5 countries having highest recovered case
SELECT Country_Region,
    SUM(Recovered_1) AS Total_Recovered_Cases
FROM 
    [dbo].[Corona Virus Dataset]
GROUP BY 
    Country_Region
ORDER BY 
    Total_Recovered_Cases DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY;
