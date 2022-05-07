----------------------------------------- select data that we are going to use ----------------------------------------- 

select [location], date, population, [total_cases], [new_cases], [total_deaths]
from Death
where [continent] is not null
order by 1,2

----------------------------------------- Total Cases VS Total Deaths (Egypt) ----------------------------------------- 

select [location], date, [total_cases], [total_deaths], (total_deaths / total_cases)*100 as DeathPercentage 
from [dbo].[Death]
where [location] = 'Egypt'
order by 1,2

----------------------------------------- Total Cases VS Population (Egypt) ----------------------------------------- 

select [location], date, [total_cases], population, (total_cases / population)*100 as CasesPercentage 
from [dbo].[Death]
where [location] = 'Egypt'
order by 1,2

----------------------------------------- Countries With Heighst Infection Rate ----------------------------------------- 

select [location], max([total_cases]) as Cases, population, max(total_cases / population)*100 as CasesPercentage 
from [dbo].[Death]
where [continent] is not null
group by [location], population
order by Cases desc

----------------------------------------- Countries With Heighst Death Count -----------------------------------------

select [location], max([total_deaths]) as Deaths_Cases, max([total_deaths] / [total_cases])*100 as DeathPercentage 
from [dbo].[Death]
where [continent] is not null
group by [location]
order by Deaths_Cases desc

----------------------------------------- Countries With Heighst Death Count -----------------------------------------

select [continent], max([total_deaths]) as Deaths_Cases, max([total_deaths] / [total_cases])*100 as DeathPercentage 
from [dbo].[Death]
where [continent] is not null --[continent] is not null
group by [continent]
order by Deaths_Cases desc

select [location], max([total_deaths]) as Deaths_Cases, max([total_deaths] / [total_cases])*100 as DeathPercentage 
from [dbo].[Death]
where [continent] is null --[continent] is null
group by [location]
order by Deaths_Cases desc

----------------------------------------- Global Numbers -----------------------------------------

select date, Sum([new_cases]) as Total_Cases, Sum([new_deaths]) as Total_Deaths , Sum([new_deaths])/Sum([new_cases]) as DeathPercentage
from Death
where [continent] is not null
Group by date
order by 1,2

----------------------------------------- Total Cases -----------------------------------------

select Sum([new_cases]) as Total_Cases, Sum([new_deaths]) as Total_Deaths , (Sum([new_deaths])/Sum([new_cases])) as DeathPercentage
from Death
where [continent] is not null

----------------------------------------- New Cases, Deaths Per Day ----------------------------------------- 

select date, sum(population) As Totale_Population, sum([new_cases]) As Totale_Cases, sum([new_deaths]) As Total_Death from Death group by date order by 1

----------------------------------------- New Cases, Deaths Per Day ----------------------------------------- 

select date, sum([new_tests]) As Total_Tests, sum([new_vaccinations]) As Total_Vaccination from [dbo].[Vaccination] group by date order by 1

----------------------------------------- Join -----------------------------------------

select * from [dbo].[Death] dea, [dbo].[Vaccination] vac where  dea.[location] = vac.[location] and dea.[date]  = vac.[date] 

----------------------------------------- Total Population VS Vaccination -----------------------------------------

With popVSvac (continent, location, date, population, new_vaccinations, Total_Vac) As(
select dea.[continent], dea.[location], dea.[date], dea.[population], vac.[new_vaccinations], 
sum(vac.[new_vaccinations]) over (partition by dea.[location] order by dea.[location], dea.[date]) as Total_Vac
from [dbo].[Death] dea, [dbo].[Vaccination] vac 
where  dea.[location] = vac.[location] and dea.[date]  = vac.[date] and dea.[continent] is not null
)

select *, (Total_Vac/[population])*100 as  VacPercentage from popVSvac

----------------------------------------- View To Be Used Later -----------------------------------------

create view PercentPopVac as
select dea.[continent], dea.[location], dea.[date], dea.[population], vac.[new_vaccinations], 
sum(vac.[new_vaccinations]) over (partition by dea.[location] order by dea.[location], dea.[date]) as Total_Vac
from [dbo].[Death] dea, [dbo].[Vaccination] vac 
where  dea.[location] = vac.[location] and dea.[date]  = vac.[date] and dea.[continent] is not null