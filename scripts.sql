SELECT *
FROM allstarfull;

SELECT *
FROM people;

SELECT *
FROM teams;

SELECT *
FROM appearances;

SELECT DISTINCT yearID
FROM allstarfull
ORDER BY yearid;
-- 1933-2016

-- ANSWERS No. 1
SELECT DISTINCT yearID
FROM appearances
ORDER BY yearid;
-- 1871-2016

--ANSWER 2a
SELECT namegiven,
	height,
	birthyear,
	birthmonth,
	birthday
FROM people
ORDER BY height;
--"Edward Carl"	 HEIGHT:43in tall  Bday: 1925-06-08

--ANSWER 2c
SELECT namefirst,
	namelast,
	namegiven,
	height,
	birthyear,
	birthmonth,
	birthday
FROM people
WHERE namegiven = 'Edward Carl' 
AND height = '43'
ORDER BY height;

SELECT * 
FROM people 
WHERE namegiven = 'Edward Carl';

SELECT DISTINCT namefirst,
	namelast,
	namegiven,
	height,
	t.teamid,
	t.name
	FROM people AS p
INNER JOIN appearances AS a
ON a.playerid = p.playerid
INNER JOIN teams AS t
ON t.teamid = a.teamid
WHERE namegiven = 'Edward Carl' 
AND height = '43'
ORDER BY height;
--ANSWER: "St. Louis Browns"
-- TEAMID: SLA

-- ANSWER 2b
SELECT *
FROM teams
WHERE teamid = 'SLA';

select *
FROM homegames
WHERE team = 'SLA';

SELECT DISTINCT namefirst,
	namelast,
	namegiven,
	height,
	t.teamid,
	t.name,
	g_all
FROM people AS p
INNER JOIN appearances AS a
ON a.playerid = p.playerid
INNER JOIN teams AS t
ON t.teamid = a.teamid
WHERE namegiven = 'Edward Carl' 
AND height = '43';
--ANSWER: 1 game
-- "Eddie"	"Gaedel"	"Edward Carl"	43	"SLA"	"St. Louis Browns"	1

-- Q 3 - 
-- FIND: all players who played at Vanderbilt University.
-- Create a list showing
-- > each player’s first and last names
-- > total salary they earned in the major leagues. 
-- >Sort: descending 
-- >order by: total salary earned. 
-- Which Vanderbilt player earned the most money in the majors?
select playerid,
	schoolid,
	yearid
FROM collegeplaying
where schoolid like '%vand%';

SELECT DISTINCT namefirst,
	namelast,
	namegiven,
	schoolid,
	SUM(salary) as salary
FROM people AS p
INNER JOIN collegeplaying AS c
ON c.playerid = p.playerid
INNER JOIN salaries AS s
ON s.playerid = p.playerid
where schoolid like '%vand%'
GROUP BY namefirst,
	namelast,
	namegiven,
	schoolid
ORDER BY salary desc;
--ANSWER: "David"	"Price"	"David Taylor"	"vandy"	245553888

-- Q 4.
-- Using the fielding table, group players into three groups based on their position: 
-- "OF" as "Outfield"
-- "SS", "1B", "2B", and "3B" as "Infield"
-- "P" or "C" as "Battery".
-- Determine the number of putouts made by each of these three groups in 2016.

SELECT *
FROM fielding;

SELECT POS
FROM fielding
GROUP BY pos;

SELECT fieldPOS,
SUM(SUM(PO)) OVER (PARTITION BY FieldPOS)
FROM 
(SELECT playerid,
	pos,
	CASE WHEN pos = 'OF' THEN 'Outfield' 
	WHEN pos IN ('SS', '1B', '2B', '3B') THEN 'Infield'
	WHEN pos IN ('P', 'C') THEN 'Battery'
	END AS FieldPOS,
 	PO
FROM fielding
WHERE yearid = '2016'
GROUP BY playerid, pos, PO
ORDER BY POS desc) AS Subquery
GROUP BY fieldpos;

-- Q 5
-- Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?
SELECT *
FROM battingpost;

SELECT yearid,
	ROUND(AVG(SO),2)
FROM battingpost
GROUP BY yearid
ORDER BY yearid DESC
--2016
	