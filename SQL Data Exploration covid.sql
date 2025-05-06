SELECT *
FROM CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 3,4
;


SELECT *
FROM CovidVaccinations$
ORDER BY 3,4
;


SELECT location,date,total_cases,new_cases,total_deaths, population
FROM [Covid-19 Porfolio project]..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Death Percentage

SELECT location,date,total_cases,new_cases,total_deaths, population, ROUND((total_deaths/total_cases)* 100 , 2) AS Death_Percentage
FROM [Covid-19 Porfolio project]..CovidDeaths$
WHERE location = 'India' AND continent IS NOT NULL
ORDER BY 1,2
;


-- Total Cases V/S Population

SELECT location,date,total_cases,new_cases,total_deaths, population, ROUND((total_cases/population)* 100 , 2) AS Infected_Percentage
FROM [Covid-19 Porfolio project]..CovidDeaths$
WHERE location = 'India' AND continent IS NOT NULL
ORDER BY 1,2
;


-- Highly Infected Countries

SELECT location,population,MAX(total_cases) AS Highest_Infected, ROUND(MAX((total_cases/population))*100 ,2)AS Max_Infected
FROM [Covid-19 Porfolio project]..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY population,location
ORDER BY Max_Infected DESC
;

-- Death Percentage by country

SELECT location,population,MAX(CAST(total_deaths AS int)) AS deaths, ROUND(MAX((total_deaths/population))*100,2) AS death_percentage
FROM [Covid-19 Porfolio project]..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY location,population 
ORDER BY death_percentage DESC
;

-- Death Percentage by continent

SELECT continent,MAX(CAST(total_deaths AS int)) AS deaths, ROUND(MAX((total_deaths/population))*100,2) AS death_percentage
FROM [Covid-19 Porfolio project]..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY deaths DESC
;


-- Death across the world

SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths AS int)) total_deaths,
ROUND((SUM(CAST(new_deaths AS int)) / SUM(new_cases) )* 100,2) AS total_percentage 
FROM [Covid-19 Porfolio project]..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1
;

-- Total deaths accross the world

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths AS int)) total_deaths,
ROUND((SUM(CAST(new_deaths AS int)) / SUM(new_cases) )* 100,2) AS total_percentage 
FROM [Covid-19 Porfolio project]..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 1
;


-- Total Population v/s Total Vaccinated

SELECT death.continent,death.location,death.date,death.population, vaccine.new_vaccinations, 
SUM(CONVERT(int,vaccine.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location,death.date) rolling_vaccinated
FROM [Covid-19 Porfolio project]..CovidDeaths$ AS death
JOIN [Covid-19 Porfolio project]..CovidVaccinations$ AS vaccine
	ON death.location = vaccine.location
	AND death.date = vaccine.date
WHERE death.continent IS NOT NULL
ORDER BY 1,2
;


WITH popvsvac AS 
(
SELECT death.continent,death.location,death.date,death.population, vaccine.new_vaccinations, 
SUM(CONVERT(int,vaccine.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location,death.date) rolling_vaccinated
FROM [Covid-19 Porfolio project]..CovidDeaths$ AS death
JOIN [Covid-19 Porfolio project]..CovidVaccinations$ AS vaccine
	ON death.location = vaccine.location
	AND death.date = vaccine.date
WHERE death.continent IS NOT NULL
)
SELECT  *, ROUND((rolling_vaccinated/population)*100,2)		
FROM popvsvac
;



DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT death.continent,death.location,death.date,death.population, vaccine.new_vaccinations, 
SUM(CONVERT(int,vaccine.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location,death.date) rolling_vaccinated
FROM [Covid-19 Porfolio project]..CovidDeaths$ AS death
JOIN [Covid-19 Porfolio project]..CovidVaccinations$ AS vaccine
	ON death.location = vaccine.location
	AND death.date = vaccine.date
WHERE death.continent IS NOT NULL
;

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- creating views

CREATE VIEW PopulationVaccinatedPercent AS
SELECT death.continent,death.location,death.date,death.population, vaccine.new_vaccinations, 
SUM(CONVERT(int,vaccine.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location,death.date) rolling_vaccinated
FROM [Covid-19 Porfolio project]..CovidDeaths$ AS death
JOIN [Covid-19 Porfolio project]..CovidVaccinations$ AS vaccine
	ON death.location = vaccine.location
	AND death.date = vaccine.date
WHERE death.continent IS NOT NULL
;