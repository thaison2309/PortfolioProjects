use PortfolioProject
go



-- Looking at total cases vs total deaths
-- Likelihood of dying if being contracted with COVID-19 in the US
select location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as death_percentage
from CovidDeaths
where location = 'United States'
order by 1,2

-- Looking at total cases vs population
-- Showing what percentage of population got COVID
select location, date, total_cases,  population, (total_cases/population)*100 as Infection_rate
from CovidDeaths
where location = 'United States'
order by 1,2

-- Looking at countries with highest infection rate compared to population
select location,population,  max(total_cases) as highest_infection_count, max(total_cases)/population*100 as Infection_rate
from CovidDeaths
group by location, population
order by 4 desc

-- Looking at countries with highest death
select location,population,  max(total_deaths) as total_death
from CovidDeaths
group by location, population
order by 3 desc

-- Looking at countries with highest death percentage
select location,population,  max(total_deaths) as total_death, max(total_deaths)/population*100 as death_percentage
from CovidDeaths
group by location, population
order by 4 desc

-- Looking at continent with highest death
select  continent,  max(total_deaths) as total_death
from CovidDeaths
group by continent
order by 2 desc


-- Global numbers
select  sum(new_cases) Total_cases, SUM(new_deaths) Total_deaths, sum(new_deaths)/SUM(new_cases)*100 Death_percentage
from CovidDeaths
where continent is not null


select * from CovidVaccinations
where location = 'Albania'
--
with popvsvac (Location, Date, Population, new_vaccinations, vaccinated_people)
as 
(
-- Looking at total population vs total vaccination
select dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as vaccinated_people
from CovidDeaths dea join
CovidVaccinations vac
on dea .location = vac.location and dea.date = vac.date
where dea.continent is not null 
)
select *, vaccinated_people/Population*100 
from popvsvac

-- Creating view to store data for later visualization 
create view PercentPopulationVaccinated as 
select dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as vaccinated_people
from CovidDeaths as  dea join
CovidVaccinations as vac
on dea .location = vac.location and dea.date = vac.date
where dea.continent is not null




