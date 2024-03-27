
Select * from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

Select * from PortfolioProject..CovidVaccinations
where continent is not null
order by 3,4

--Select data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Looking at Total Cases Vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (Convert(float,total_deaths)/ NULLIF(Convert(float,total_cases),0))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%' 
and continent is not null
order by 1,2


--Looking at total cases Vs Population
-- Shows what percentage of population got covid

Select Location, date, total_cases, Population, (Convert(float,total_cases)/ NULLIF(Convert(float,Population),0))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
where location like '%India%'
and continent is not null
order by 1,2

--Looking at country with highest infection rate compared to population

Select Location, Population, max(total_cases) as HighestInfectionCount, Max(Convert(float,total_cases)/ NULLIF(Convert(float,Population),0))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
group by population, location
order by PercentPopulationInfected desc


--Showing countries with the Highest Death Count per Population

Select Location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc

--LETS BREAK THINGS DOWN BY CONTINENT

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc


-- Showing continents with Highest Death Counts

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select sum(new_cases) as totAL_CASES, sum(cast(new_deaths as int)) AS TOTAL_DEATHS, Sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage --, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%' 
where continent is not null
--group by date
order by 1,2


--Looking at Total Population Vs Vaccination


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(float,vac.new_vaccinations)) over (partition by  dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/Population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
   on dea.location=vac.location
   and dea.date=vac.date
where dea.continent is not null
order by 2,3









