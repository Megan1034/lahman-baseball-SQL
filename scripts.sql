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
SELECT g
FROM teams;

SELECT DISTINCT yearid 
FROM TEAMS 
ORDER BY YEARID;
--2016-1871

SELECT ROUND(AVG(SO/g),2) AS SO_per_game,
ROUND(AVG(hr/g),2) AS HR_per_game,
(CASE 
	 WHEN yearid BETWEEN 1920 AND 1929 THEN '1920s'
	 WHEN yearid BETWEEN 1930 AND 1939 THEN '1930s'
	 WHEN yearid BETWEEN 1940 AND 1949 THEN '1940s'
 	 WHEN yearid BETWEEN 1950 AND 1959 THEN '1950s'
	 WHEN yearid BETWEEN 1960 AND 1969 THEN '1960s'
	 WHEN yearid BETWEEN 1970 AND 1979 THEN '1970s'
	 WHEN yearid BETWEEN 1980 AND 1989 THEN '1980s'
	 WHEN yearid BETWEEN 1990 AND 1999 THEN '1990s'
	 WHEN yearid BETWEEN 2000 AND 2009 THEN '2000s'
	 WHEN yearid BETWEEN 2010 AND 2019 THEN '2010s'
END) AS DECADE
FROM TEAMS
WHERE yearid >=1920
GROUP BY DECADE
ORDER BY decade;
-- SO_per_game  HR_per_game  DECADE
--	 2.32		 0.01		"1920s"
-- 	 2.83		 0.05		"1930s"
-- 	 3.05		 0.03		"1940s"
-- 	 3.84		 0.27		"1950s"
-- 	 5.19		 0.22		"1960s"
-- 	 4.67		 0.11		"1970s"
-- 	 4.88		 0.16		"1980s"
-- 	 5.65		 0.41		"1990s"
-- 	 6.07		 0.62		"2000s"
-- 	 7.03		 0.44		"2010s"

--Q 6 Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted at least 20 stolen bases.

SELECT *
FROM people;

SELECT * 
FROM batting;

-- SELECT namefirst, namelast
-- FROM people
-- WHERE teamid IN 
--    (SELECT playerid
--     FROM batting
--     WHERE yearid = '2016'
-- 	AND sb+cs >= 20
-- 	INTERSECT
--     SELECT playerid
--     FROM people
--     GROUP BY playerid);
	
SELECT p.namefirst, 
	p.namelast,
	ROUND(SUM(b.sb) * 100.0 / SUM(b.sb + b.cs), 2) AS sb_success
FROM people as p
INNER JOIN batting as b
ON p.playerid = b.playerid
WHERE b.yearid = 2016
	AND (sb+cs) >= 20
	AND SB IS NOT NULL
	AND CS IS NOT NULL
GROUP BY p.namefirst, p.namelast
ORDER BY sb_success desc;
--"Chris"	"Owings"	91.30

-- Q 7
-- 7a From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? 
-- 7b What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. 
-- 7c Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? 
-- 7d What percentage of the time?

SELECT MAX(w)
FROM teams;

SELECT wswin
FROM teams;

select* from teams;

SELECT yearid,
teamid,
name,
w,
wswin
FROM teams
WHERE wswin IS NOT NULL
AND yearid BETWEEN 1970 AND 2016
AND wswin <> 'Y'
ORDER BY w desc, yearid desc;
--7a 2001	"SEA"	"Seattle Mariners"	116	"N"

SELECT yearid,
teamid,
name,
w,
wswin
FROM teams
WHERE wswin IS NOT NULL
AND yearid BETWEEN 1970 AND 2016
AND wswin = 'Y'
ORDER BY w, yearid desc;
--7b 1981	"LAN"	"Los Angeles Dodgers"	63	"Y"

-- WITH S as (SELECT yearid,
-- 	teamid,
-- 	name,
-- 	max(w) AS wins_per_year,
-- 	wswin
-- 	FROM teams
-- 	WHERE wswin IS NOT NULL
-- 	AND yearid BETWEEN 1970 AND 2016
-- 	and yearid <> 1981
-- 	GROUP BY yearid, teamid, name, wswin)
-- SELECT t.teamid, 
-- COUNT(wins_per_year) as winningest,
-- s.wswin
-- FROM TEAMS as t
--  INNER JOIN s
--  ON s.teamid = t.teamid
-- GROUP BY t.teamid, wins_per_year, s.wswin
-- order by winningest desc;

SELECT teamid,
count(*) as WSWIN_
FROM teams
WHERE wswin = 'Y'
GROUP BY teamid;

SELECT teamid,
w,
wswin,
yearid,
(CASE 
	 WHEN yearid BETWEEN 1920 AND 1929 AND wswin = 'Y' THEN '1920s champ'
	 WHEN yearid BETWEEN 1930 AND 1939 AND wswin = 'Y' THEN '1930s champ'
	 WHEN yearid BETWEEN 1940 AND 1949 AND wswin = 'Y' THEN '1940s champ'
 	 WHEN yearid BETWEEN 1950 AND 1959 AND wswin = 'Y' THEN '1950s champ'
	 WHEN yearid BETWEEN 1960 AND 1969 AND wswin = 'Y' THEN '1960s champ'
	 WHEN yearid BETWEEN 1970 AND 1979 AND wswin = 'Y' THEN '1970s champ'
	 WHEN yearid BETWEEN 1980 AND 1989 AND wswin = 'Y' THEN '1980s champ'
	 WHEN yearid BETWEEN 1990 AND 1999 AND wswin = 'Y' THEN '1990s champ'
	 WHEN yearid BETWEEN 2000 AND 2009 AND wswin = 'Y' THEN '2000s champ'
	 WHEN yearid BETWEEN 2010 AND 2019 AND wswin = 'Y' THEN '2010s champ'
END) AS DECADE_winner
FROM teams
WHERE wswin IS NOT null
AND wswin <> 'N'
AND yearid BETWEEN 1920 AND 2016
GROUP BY teamid, yearid, wswin, w
ORDER BY yearid, decade_winner;

-- COME BACK TO THIS ONE

-- 8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.

SELECT * 
FROM homegames;

SELECT *
FROM parks;

SELECT attendance
FROM homegames;

SELECT year,
team,
park_name,
(attendance/games) as avg_attend
FROM homegames as h
INNER JOIN parks as p
ON p.park = h.park
WHERE h.games > 10
AND year = 2016
ORDER BY avg_attend desc
LIMIT 5;

-- 8 a  TOP 5
-- 2016	"LAN"	"Dodger Stadium"	45719
-- 2016	"SLN"	"Busch Stadium III"	42524
-- 2016	"TOR"	"Rogers Centre"	41877
-- 2016	"SFN"	"AT&T Park"	41546
-- 2016	"CHN"	"Wrigley Field"	39906

SELECT year,
team,
park_name,
(attendance/games) as avg_attend
FROM homegames as h
INNER JOIN parks as p
ON p.park = h.park
WHERE h.games > 10
AND year = 2016
ORDER BY avg_attend
LIMIT 5;

-- 8 a BOTTOM 5
-- 2016	"TBA"	"Tropicana Field"	15878
-- 2016	"OAK"	"Oakland-Alameda County Coliseum"	18784
-- 2016	"CLE"	"Progressive Field"	19650
-- 2016	"MIA"	"Marlins Park"	21405
-- 2016	"CHA"	"U.S. Cellular Field"	21559

-- 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.
SELECT * 
FROM awardsmanagers;
-- playerid
SELECT *
FROM people;
-- playerid
SELECT *
FROM teams;
-- teamid
SELECT *
FROM managers;
-- teamid
-- playerid

WITH a AS (
	SELECT namefirst as first,
	namelast as last,
	am.yearid,
	awardid,
	p.playerid,
	lgid
	FROM awardsmanagers as am
	FULL join people as p
	ON am.playerid = p.playerid
	WHERE lgid = 'AL'
	AND awardid = 'TSN Manager of the Year'
	order by namelast, yearid),
b AS (
	SELECT namefirst as first,
	namelast as last,
	am.yearid,
	awardid,
	p.playerid,
	lgid
	FROM awardsmanagers as am
	FULL join people as p
	ON am.playerid = p.playerid
	WHERE lgid = 'NL'
	AND awardid = 'TSN Manager of the Year'
	order by namelast, yearid)
SELECT a.first,
	a.last,
	a.yearid AS AL_year,
	a.lgid AS AL_award,
	b.yearid AS NL_year,
	b.lgid AS NL_award,
	t.name
FROM a
INNER JOIN b 
ON a.playerid = b.playerid
JOIN managers as m
ON m.playerid = a.playerid
JOIN teams as t
ON t.teamid = m.teamid
GROUP BY CUBE (a.first, a.last, a.yearid, AL_award, NL_year, NL_award, t.name)
ORDER BY nl_year
