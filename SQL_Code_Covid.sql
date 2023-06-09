/*
Covid 19 Data Exploration
*/


-- Display entire Data from CovidDeaths table for all continents, starting from 2020 in alphabetical order

Select Location
	, date
	, total_cases
	, new_cases
	, total_deaths
	, population
From 
	Covid_data_analysis..CovidDeaths
Where 
	continent IS NOT NULL 
order by 
	1, 2;


-- What is the count of Total Cases vs Total Deaths in India - will show the likelihood of death percentage in case of contracting the virus

Select Location
	, date
	, total_cases
	, total_deaths
	, (total_deaths/total_cases)*100 as DeathPercentage
From 
	Covid_data_analysis..CovidDeaths
Where 
	location LIKE '%India%'
	and continent IS NOT NULL 
order by 
	1,2;


-- What is the count of Total Cases vs Population in India - Shows what percentage of population got infected with Covid virus

Select Location
	, date
	, Population
	, total_cases
	, (total_cases/population)*100 as PercentPopulationInfected
From Covid_data_analysis..CovidDeaths
WHERE 
	location LIKE '%India%'
	and continent IS NOT NULL 
order by 
	1,2;


-- Display the top 50 countries which had the Highest Infection Rate as compared to its Population?

Select TOP 50 Location
	, Population
	, MAX(total_cases) as HighestInfectionCount
	, MAX(total_cases/population)*100 as PercentPopulationInfected
From 
	Covid_data_analysis..CovidDeaths
Group by 
	Location
	, Population
order by 
	PercentPopulationInfected desc;


-- Display the countries with Highest Death Count per Population

Select Location
	, MAX(cast(Total_deaths as int)) as TotalDeathCount
From 
	Covid_data_analysis..CovidDeaths
Where 
	continent IS NOT NULL 
Group by 
	Location
order by 
	TotalDeathCount desc;


-- Display contintents with the highest death count per population

Select continent
	, MAX(cast(Total_deaths as int)) as TotalDeathCount
From 
	Covid_data_analysis..CovidDeaths
Where 
	continent IS NOT NULL 
Group by 
	continent
order by 
	TotalDeathCount desc;


-- Display countries with the highest availabilty rate of hospital beds

Select location
	, MAX(hospital_beds_per_thousand) as HospitalBedAvailability
From 
	Covid_data_analysis..CovidVaccinations
Where 
	continent IS NOT NULL 
Group by 
	location
order by 
	HospitalBedAvailability desc;
	

-- What Percentage of Population has recieved at least one Covid Vaccine?

Select d.continent
	, d.location
	, d.date
	, d.population
	, v.new_vaccinations
	, SUM(CAST(v.new_vaccinations AS int)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
FROM 
	Covid_data_analysis..CovidDeaths d
	Join Covid_data_analysis..CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
WHERE 
	d.continent IS NOT NULL 
ORDER BY
	2 ,3;


-- What Percentage of Population is fully vaccinated?

Select d.continent
	, d.location
	, d.date
	, d.population
	, v.people_fully_vaccinated
	, SUM(CAST(v.people_fully_vaccinated AS int)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleFullyVaccinated
FROM 
	Covid_data_analysis..CovidDeaths d
	Join Covid_data_analysis..CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
WHERE 
	d.continent IS NOT NULL 
ORDER BY
	2 ,3;
