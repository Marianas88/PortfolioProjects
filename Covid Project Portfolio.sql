SELECT *
FROM covidDeaths
where CONTINENT is not NULL 
order by 3, 4


--SELECT *
--FROM covidvaccinations
--order by 3,4

SELECT Location, date, total_cases_per_million, new_cases, total_deaths, population
FROM covidDeaths
order by 1,2

--LOOKING AT ToTal cases per million vs. Total Deaths
--Shows likelyhood of dying if you have COVID 19 in your country
SELECT Location, date, total_cases_per_million, total_deaths, (total_cases_per_million/Total_deaths) *100 as Deathpercentage
FROM covidDeaths
WHERE location like '%States%'
order by 1,2

--LOOKING AT TOTAL CASES PER MILLION VS. POPULATION
--SHOWS WHAT PERCENTAGE OF POPULATION GOT COVID
SELECT Location, date, population, total_cases_per_million, (total_cases_per_million/POPULATION) *100 as PercentpopulationInfected
FROM covidDeaths
WHERE location like '%States%'
order by 1,2

--LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION
SELECT Location, population, MAX(total_cases_per_million) as HighestInfectioncount, (MAX(total_cases_per_million/POPULATION)) *100 as PercentpopulationInfected
FROM CovidDeaths
WHERE location like '%States%'
GROUP BY Location, population
order by PercentpopulationInfected desc


--LET'S BREAK EVERYTHING BY CONTINENT 

--SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION
SELECT location, MAX (cast (Total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
--WHERE location like '%States%'
WHERE CONTINENT is NULL
GROUP BY location 
order by TotalDeathCount desc

--LET'S BREAK EVERYTHING DOWN BY CONTINENT
-- SHOWING CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION

SELECT CONTINENT, MAX (cast (Total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
--WHERE location like '%States%'
WHERE CONTINENT is not NULL
GROUP BY CONTINENT 
order by TotalDeathCount desc

--GLOBAL NUMBERS

SELECT date, SUM(New_cases) as total_cases, SUM(cast(New_deaths as int)), SUM(cast(new_deaths as int)) as total_deaths, SUM(New_Cases)*100 as DeathPercentage
FROM CovidDeaths
--WHERE location like '%states%'
where continent is not null
Group by date
order by 1, 2

--LOOKING AT TOTAL POPULATION VS. VACCINATION
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER By dea.location, dea.date)
FROM CovidDeaths dea
JOIN CovidVaccinations Vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE
WITH POPvsVAC (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
, SUM (CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER by dea.location,
dea.date) As Rollingpeoplevaccinated
--, (Rollingpeoplevaccincated/population) *100
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
	and dea.date= vac.date
where dea.continent is not null
--order by 2,3
)

---CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	SUM(CONVERT( int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
	dea.Date) as RollingPeopleVaccinated
	--, (rollingpeoplevaccinated/population) *100
	From covidDeaths dea
	JOIN Covidvaccinations vac
		On dea.location = vac.location
		and dea.date = vac.date
	Where dea.continent is not null
	--order by 2,3

	SELECT *
	FROM Percentpopulationvaccinated




