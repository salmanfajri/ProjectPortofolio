select * from COVIDDeath
ORDER BY location, date;

--select * from COVIDVaccination
--ORDER BY location, date;

-- Select the data that we'll be using

select location, date, total_cases, total_deaths, population 
from COVIDDeath
ORDER BY location, date;

-- Looking at total cases vs total death
-- show the likelihood of dying
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from COVIDDeath
Where location LIKE '%states%'
ORDER BY location, date;

-- to alter the column data type from varchar to float
ALTER TABLE COVIDDeath
ALTER COLUMN total_deaths float;
ALTER TABLE COVIDDeath
ALTER COLUMN total_cases float;
ALTER TABLE COVIDDeath
ALTER COLUMN total_cases float;



-- looking at total cases VS population
select location, date, total_cases, population, (total_cases/population)*100 as Case_per_Population
from COVIDDeath
--Where location LIKE '%states%'
ORDER BY location, date;

-- looking at coutry with higherst infection rate compare to population
select location, MAX(total_cases) as Higest_Infection_Count, population, MAX((total_cases/population))*100 as Case_per_Population
from COVIDDeath
--Where location LIKE '%states%'
GROUP BY population, location
ORDER BY Case_per_Population desc;

-- BREAK THINGS INTO CONTINENT
select location, MAX(total_deaths) as TotalDeathCount
from COVIDDeath
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount desc;


-- looking at how many people died, country highest death count per population
select location, MAX(total_deaths) as TotalDeathCount
from COVIDDeath
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount desc;


-- SHOWING THE CONTINENT WITH HIGHEST DEATH COUNT
select continent, MAX(total_deaths) as TotalDeathCount
from COVIDDeath
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc;

-- GLOBAL NUMBER
select date, SUM(cast(new_cases as float)) as TotalCases, SUM(cast(new_deaths as float)) as TotalDeaths,  SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100 as DeathPercentage
from COVIDDeath
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;

SELECT * from COVIDVaccination;

-- Join the two table together
-- looking at Total Population VS Vaccination

with PopVSVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(float, vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From COVIDDeath AS dea 
JOIN COVIDVaccination AS vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY continent, location
)
SELECT *, (RollingPeopleVaccinated/population)*100 from PopVSVac;

-- TEMP TABLE

DROP TABLE IF EXISTS #PercentagePopulationVaccinated
CREATE TABLE #PercentagePopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentagePopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(float, vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From COVIDDeath AS dea 
JOIN COVIDVaccination AS vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3
SELECT *, (RollingPeopleVaccinated/population)*100 from #PercentagePopulationVaccinated;


-- Creating view for store data 
CREATE view PercentagePopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(float, vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From COVIDDeath AS dea 
JOIN COVIDVaccination AS vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3