select * from
project1..coviddeaths$

select * from
project1..covidvaccinations$
order by 3,4;

--selecting location,date,total cases,new cases,total death,population from covid death table
select location,date,total_cases,new_cases,total_deaths,population
from
project1..coviddeaths$

--selecting date,location and new cases in the range 3000 to 6000 where location is equal to Israel
select date,location, new_cases from
project1..coviddeaths$
where location = 'Israel' and (new_cases between 3000 and 6000);


--selectig  total death is equal to 1 and by date, locations 
select location,date,total_deaths
from
project1..coviddeaths$
where total_deaths=1
order by location asc;



--looking at toal cases and total deaths in all locations
--likelihood of dying when you attack by covid
 select location,date,total_cases,total_deaths,(cast([total_deaths] as float) / cast([total_cases] as float)) * 100 as death_percentage
 from
 project1..coviddeaths$
 where location='India'
 order by date desc

 --Joining of two tables
 select cd.continent,cd.date,cv.people_vaccinated
 from
project1..coviddeaths$   as cd
 inner join covidvaccinations$ as cv
 on
 cd.continent=cv.continent
 order by people_vaccinated desc,date desc;

 --looking at total cases and populations
 --by what percentage of people atacked by covid
 select location,total_cases,population,(cast([total_cases] as float) / cast([population] as float)) * 100 as covid_case_attack
 from
project1..coviddeaths$
order by 1 desc,2 asc
 

 --looking at the lowest infectious rate cases in each locaction
 select location,min(total_cases) as low_cases
 from
 project1..coviddeaths$
 group by location
 order by location asc

 --looking at the highest infectious rate cases in each location

  select location,population,max(total_cases) as high_cases, (max(total_cases)/population) * 100 as highest_affected_rate
 from
 project1..coviddeaths$
 group by location,population
 order by  highest_affected_rate desc

 -- Total Number of population in each location

 select location,max(population) as totalpeople
 from
 project1..coviddeaths$
 group by location,population
 order by 1 desc;
 
 --highest death count due to covid
 select continent,location,max(total_deaths) as diedpeople from
project1..coviddeaths$
group by location,continent
having continent is not null
order by location,continent

--highest death count in each continent
select continent,max(cast(total_deaths as float))
from
project1..coviddeaths$
group by continent
having continent is not null
order by continent

--Find total death percentage in each location
select location, sum(cast(total_cases as bigint)) as sum_totalcases,sum(cast(total_deaths as float)) as sum_totaldeath, sum(cast(total_deaths as float))/sum(cast(total_cases as bigint)) as totaldeathpercent
from
project1..coviddeaths$
group by location
order by 4 desc

--overall total cases and total death cases and death percentage

select sum(cast(total_cases as bigint)) as sum_totalcases,sum(cast(total_deaths as float)) as sum_totaldeath, sum(cast(total_deaths as float))/sum(cast(total_cases as bigint)) as totaldeathpercent
from
project1..coviddeaths$

--looing at total population vs total vaccinations
select cv.continent,cv.location,cd.population ,max(cv.people_fully_vaccinated) as vaccinatedpeople, 
from
project1..covidvaccinations$ cv
join coviddeaths$ cd
on
cv.location=cd.location
group by cv.continent,cv.location,cd.population
having cv.continent is not null

--vacinated percentage peple
select cv.continent,cv.location, (max(cast(cv.people_fully_vaccinated as float))/max(cast(cd.population as float))) * 100 as vac_peop_percent
from
project1..covidvaccinations$ cv
join coviddeaths$ cd
on
cv.location=cd.location
group by cv.continent,cv.location

--number of new vaccinated people at each location
select continent,location,max(new_vaccinations) as nv
from
project1..covidvaccinations$
group by continent,location
having continent is not null
order by continent asc,location asc, nv desc

--new vaccinated people

select continent,location,
sum(cast(new_vaccinations as bigint)) as nv
from
project1..covidvaccinations$
group by continent,location
having continent is not null

--using partition for newly vaccinated people

select continent,location,
sum(cast(new_vaccinations as float)) over (partition by location) 
from
project1..covidvaccinations$


--creating a view for vaccinated percentage people
create view  vac_perc_peop as
select cv.continent,cv.location, (max(cast(cv.people_fully_vaccinated as float))/max(cast(cd.population as float))) * 100 as vac_peop_percent
from
project1..covidvaccinations$ cv
join coviddeaths$ cd
on
cv.location=cd.location
group by cv.continent,cv.location









