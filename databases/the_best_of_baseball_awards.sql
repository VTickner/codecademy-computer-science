-- Heaviest Hitters - This award goes to the team with the highest average weight of its batters on a given year
SELECT
	ROUND(AVG(people.weight), 2) AS "Average Weight",
  teams.name AS "Team Name",
  batting.yearid AS "Year"
FROM people
JOIN batting
	ON people.playerid = batting.playerid
JOIN teams
	ON batting.teamid = teams.teamid
GROUP BY
	teams.name, 
  batting.yearid
ORDER BY 1 DESC;
-- Answer = Chicago White Sox, 2009, 221.33 average weight

-- Shortest Sluggers - This award goes to the team with the smallest average height of its batters on a given year
SELECT
	ROUND(AVG(people.height), 2) AS "Average Height",
  teams.name AS "Team Name",
  batting.yearid AS "Year"
FROM people
JOIN batting
	ON people.playerid = batting.playerid
JOIN teams
	ON batting.teamid = teams.teamid
GROUP BY
	teams.name, 
  batting.yearid
ORDER BY 1;
-- Answer = Middletown Mansfields, 1872, 66.57 average height

-- Biggest Spenders - This award goes to the team with the largest total salary of all players in a given year
SELECT
	SUM(salaries.salary) AS "Total Salary",
  teams.name AS "Team Name",
  salaries.yearid AS "Year"
FROM salaries
JOIN teams
	ON salaries.teamid = teams.teamid
GROUP BY
	teams.name, 
  salaries.yearid
ORDER BY 1 DESC;
-- Answer = New York Yankees, 2013, $231,978,886

-- Most Bang For Their Buck in 2010 - This award goes to the team that had the smallest "cost per win" in 2010
SELECT
	ROUND(SUM(salaries.salary) / teams.w) AS "Cost Per Win",
  teams.w AS "Team Wins",
  teams.name AS "Team Name",
  salaries.yearid AS "Year"
FROM salaries
JOIN teams
	ON salaries.teamid = teams.teamid
  AND salaries.yearid = teams.yearid
WHERE salaries.yearid = 2010
GROUP BY
	teams.name, 
  salaries.yearid,
  teams.w
ORDER BY 1;
-- Answer = San Diego Padres, 90 team wins in 2010, $419,992 cost per win

-- Priciest Starter - This award goes to the pitcher who, in a given year, cost the most money per game in which they were the starting pitcher. Note that many pitchers only started a single game, so to be eligible for this award, you had to start at least 10 games.
SELECT
	people.namefirst AS "First Name",
  people.namelast AS "Last Name",
  ROUND(SUM(salaries.salary) / SUM(pitching.gs)) AS "Cost Per Game",
  salaries.yearid AS "Year",
  pitching.gs AS "# of Games Started"
FROM salaries
JOIN pitching
	ON salaries.teamid = pitching.teamid
  AND salaries.yearid = pitching.yearid
  AND salaries.playerid = pitching.playerid
JOIN people
	ON salaries.playerid = people.playerid
WHERE pitching.gs > 10
GROUP BY
    people.namefirst,
    people.namelast,
    salaries.yearid,
    pitching.gs
ORDER BY 3 DESC;
-- Answer = Cliff Lee, 2014, 13 games started, $1,923,077 cost per game

-- Worst Bang For Their Buck - This award goes to the team that has the largest "cost per win" in any given year
SELECT
	ROUND(SUM(salaries.salary) / teams.w) AS "Cost Per Win",
  teams.w AS "Team Wins",
  teams.name AS "Team Name",
  salaries.yearid AS "Year"
FROM salaries
JOIN teams
	ON salaries.teamid = teams.teamid
  AND salaries.yearid = teams.yearid
GROUP BY
	teams.name, 
  salaries.yearid,
  teams.w
ORDER BY 1 DESC;
-- Answer = New York Yankees, 85 team wins in 2013, $2,729,163 cost per win