
Select*
From CovidDeaths
Order BY 3,4

--Select*
--From CovidVaccinations
--Order BY 3,4

-- Select data that will be using

Select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
Order By 1,2

-- Looking at Total Cases VS Total Death
-- It shows the likelihood of dying of Covid in Nigeria

Select location,date,total_cases,total_deaths,(cast (total_deaths as decimal)/cast(total_cases as decimal)*100) as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%Nigeria%'
Order by 1,2

-- Looking at Total cases Vs Population
--Shows the Percentage of Population got Covid
Select location,date,population,total_cases,(cast (total_cases as decimal)/cast(population as decimal)*100) as PercentOfPopulationInFected
From PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
Order by 1,2

--Looking at country with highest Infection rate compare population
Select location,population,max(total_cases) as HighestInfectionCount,Max((cast (total_cases as decimal)/cast(population as decimal))*100) as PercentOfPopulationInFected
From PortfolioProject..CovidDeaths
--Where location like '%Nigeria%'
Group by location,population
Order by PercentOfPopulationInFected desc

-- Showing countries with Highest Count per Population

Select location,MAX(total_deaths) as HighestDeathCount
From PortfolioProject..CovidDeaths
Where continent is not NUll
Group by location
Order by HighestDeathCount desc


-- Let Break Things down By Continent
-- Showing continent with the highest death count 

Select continent,MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not NUll
Group by continent
Order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select date,sum(cast(new_cases as int)) as TotalCases,sum(new_deaths)as TotalDeaths,
sum(CONVERT(decimal, new_deaths))/sum(cast(new_cases as decimal))*100 as DeathPercentage
From  PortfolioProject.. CovidDeaths
Where(continent is not null and  new_cases <>0)
Group by date
Order by 1,2

--GLOBAL COVID FIGURE

Select sum(cast(new_cases as int)) as TotalCases,sum(new_deaths)as TotalDeaths,
sum(CONVERT(decimal, new_deaths))/sum(cast(new_cases as decimal))*100 as DeathPercentage
From  PortfolioProject.. CovidDeaths
Where(continent is not null and  new_cases <>0)



--Look Total Population Vs Vaccination
Select Dea.continent,Dea.location,Dea.date,dea.population,vac.new_vaccinations,
SUM(convert(bigint,Vac.new_vaccinations )) OVER(Partition by Dea.location Order by dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
	On Dea.location=Vac.location
	and Dea.date=Vac.date
Where( Dea.continent is not  null )
Order By 2,3


-- CTE 

with PopvsVac(continent, Location,Date,Population, New_Vaccination,RollingPeopleVaccinated)
as(
Select Dea.continent,Dea.location,Dea.date,dea.population,vac.new_vaccinations,
SUM(convert(bigint,Vac.new_vaccinations )) OVER(Partition by Dea.location Order by dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
	On Dea.location=Vac.location
	and Dea.date=Vac.date
Where( Dea.continent is not  null )
--Order By 2,3
)
Select *, (cast(RollingPeopleVaccinated as decimal)/cast(Population as decimal))*100 as PercentRollingVaccinatedofPopulation
From PopvsVac

	

--TEMP TABLE
DROP TABLE If EXISTS #PercentOfPopulationVaccinated
CREATE TABLE #PercentOfPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date Date,
Population Numeric,
New_Vaccination Numeric,
RollingPeopleVaccinated Numeric
)

Insert Into #PercentOfPopulationVaccinated

Select Dea.continent,Dea.location,Dea.date,dea.population,vac.new_vaccinations,
SUM(convert(bigint,Vac.new_vaccinations )) OVER(Partition by Dea.location Order by dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
	On Dea.location=Vac.location
	and Dea.date=Vac.date
Where( Dea.continent is not  null )
Order By 2,3

Select *,(cast(RollingPeopleVaccinated as decimal)/cast(Population as decimal))*100 as PercentRollingVaccinatedofPopulation
From #PercentOfPopulationVaccinated

--CREATE A VIEW FOR LATER VISUALISATION

CREATE VIEW PercentOfPopulationVaccinated AS
Select Dea.continent,Dea.location,Dea.date,dea.population,vac.new_vaccinations,
SUM(convert(bigint,Vac.new_vaccinations )) OVER(Partition by Dea.location Order by dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
	On Dea.location=Vac.location
	and Dea.date=Vac.date
Where( Dea.continent is not  null )
--Order By 2,3









