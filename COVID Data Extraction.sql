Select *
From CovidDeaths
Where continuent IS NOT NULL
order by 3,4

Select * 
From CovidVaccine	
Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
Order by 1,2
--Looking at the total_caes vs total_deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
from CovidDeaths
Order by 1,2
--Looking at the deathpercentage in States 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
from CovidDeaths
Where location like '%states%'
Order by 1,2

--Looking at the total_cases vs population
Select Location, date, total_cases, population, (total_cases/population)*100 AS DeathPercentage
from CovidDeaths
Where location like'%states%'
Order by 1,2
--Looking at countris wiht Highest Infection Rate
Select Location, Max(total_cases) As HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopoulationInfected
from CovidDeaths
Group By Location, population
Order by PercentPopoulationInfected Desc

--showing countires Highest Death Count per population
Select continent, Max(total_deaths) AS TotalDeathCount
from CovidDeaths
Where continent IS NOT NULL
Group By continent
Order by TotalDeathCount desc
 --Showing the continuent with Highest death count 

Select continent, Max(total_deaths) AS TotalDeathCount
from CovidDeaths
Where continent IS NOT NULL
Group By continent
Order by TotalDeathCount desc








--GLOBAL NUMBERS
SELECT SUM(new_cases) as total_cases, SUM (cast(new_deaths as int)) as total_deaths, SUM (CAST(new_deaths as int))/SUM(NEW_CASES)*100 as DeathPercentage
From CovidDeaths
where continent IS NOT NULL
ORDER BY 1,2
--Looking at total Pouplation vs Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) Over (Partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
From CovidDeaths dea
Join CovidVaccine vac
  ON DEA.LOCATION = VAC.LOCATION
  AND DEA.DATE = VAC.DATE
WHERE DEA.CONTINENT IS NOT NULL
Order by 2,3

--USE CTE
With PopvsVac (continent,location,date,population,new_vaccination,rollingpeoplevaccinated) 
as
(
SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) Over (Partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
From CovidDeaths dea
Join CovidVaccine vac
  ON DEA.LOCATION = VAC.LOCATION
  AND DEA.DATE = VAC.DATE
WHERE DEA.CONTINENT IS NOT NULL
--Order by 2,3
)
Select*, (rollingpeoplevaccinated/population)*100
From PopVSVac

--Temp table
DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
rollingpeoplevaccinated numeric
)

Insert Into #percentpopulationvaccinated
SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) Over (Partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
From CovidDeaths dea
Join CovidVaccine vac
  ON DEA.LOCATION = VAC.LOCATION
  AND DEA.DATE = VAC.DATE
--WHERE DEA.CONTINENT IS NOT NULL
--Order by 2,3

Select*, (rollingpeoplevaccinated/population)*100
From  #percentpopulationvaccinated


--creating view to store data for later visulaization

Create View PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) Over (Partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
From CovidDeaths dea
Join CovidVaccine vac
  ON DEA.LOCATION = VAC.LOCATION
  AND DEA.DATE = VAC.DATE
WHERE DEA.CONTINENT IS NOT NULL
--Order by 2,3

Select *
From PercentPopulationVaccinated