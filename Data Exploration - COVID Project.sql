Select *
From PortfolioProject..CovidDeaths
Where continent is not Null
Order By 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--Order By 3,4


--Looking at Total Cases vs Total Deaths
--Shows the likelihood of dying if you contract Covid in Ghana

Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like 'Ghana' 
Order By 1, 2


--Looking at the Total Cases vs Population
--Shows what percentage of the population got Covid

Select location, date, total_cases, population, (total_cases/population) * 100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like 'Ghana'
Order By 1, 2


--Looking at Countries with highest infection rate compared to Population

Select location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)) * 100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like 'Ghana'
Where continent is not null
Group By location, population
Order By PercentPopulationInfected DESC


--Countries with the Highest Death Count Per Population

Select location, MAX(cast(total_deaths as int)) AS HighestDeathCount
From PortfolioProject..CovidDeaths
--Where location like 'Ghana' 
Where continent is not Null
Group By location
Order By HighestDeathCount desc



--LET'S BREAK THINGS DOWN BY CONTINENT


Select continent, MAX(cast(total_deaths as int)) AS HighestDeathCount
From PortfolioProject..CovidDeaths
--Where location like 'Ghana'
Where continent is not Null
Group By continent
Order By HighestDeathCount DESC


--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/(SUM(new_cases)) * 100 AS DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like 'Ghana'
Where continent is not null
--Group By date
Order By 1, 2


--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location ,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order By 2, 3


--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location ,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order By 2, 3
)
Select *, (RollingPeopleVaccinated/Population) * 100 
From PopvsVac



--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location ,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order By 2, 3

Select *, (RollingPeopleVaccinated/Population) * 100 
From #PercentPopulationVaccinated


--Creating View to store data for later Visualization

Create View PercentPeopleVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location ,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order By 2, 3

Select * 
From PercentPeopleVaccinated

