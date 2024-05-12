
Select *
from PortifolioProject..[population-and-demography]
order by YEAR asc

Select *
from PortifolioProject..[divorces-per-1000-people]

Select [Country name], YEAR,[population], [population at age 1], [population under the age of 25], [population older than 18 years], [population aged 30 to 39 years] 
from PortifolioProject..[population-and-demography]
order by 1,2



Select [Country name], YEAR,[population], [population at age 1], [population under the age of 25], ([population under the age of 25]/[population at age 1]) as [how many 25 years old per baby]
from PortifolioProject..[population-and-demography]
--where [country name] like '%kistan'
order by 1,2



Select [Country name], YEAR,[population], [population aged 30 to 39 years], ([population aged 30 to 39 years]/[population])*100 as [percentage of 30 to 39 aged people in population]
from PortifolioProject..[population-and-demography]
where year = 2021
order by 1,2



Select [Country name], Year, [population], [population at age 1] as [number of babies], MAX(([population at age 1]/[population]))*100 as [rate in percetage of babies in population]
from PortifolioProject..[population-and-demography]
group by [country name], [population], year, [population at age 1]
order by 1,2

Select [Country name], max([population at age 1]/[population])*100 as [highest rate in percetage of babies in population] 
from PortifolioProject..[population-and-demography]
where [Country name] = 'World'
group by [Country name]



Select year, sum([population]) as [total number of people per year]
from PortifolioProject..[population-and-demography]
where [Country name] <> 'world'
group by year
order by 1,2
;


With SigaretPerOdam (Entity, year, population, Cigaret, [Rolling cigarette])
as
(Select a.[Country name], a.year, a.Population, b.[Cigarette consumption per smoker per day (IHME, GHDx (2012))],
sum(b.[Cigarette consumption per smoker per day (IHME, GHDx (2012))]) over (partition by a.[Country name] order by a.[Country name], a.year) as [rolling cigarette]
from PortifolioProject..[population-and-demography] a
	join PortifolioProject..[consumption-per-smoker-per-day] b
	on a.[Country name]=b.Entity
	and a.Year=b.Year
--order by 1,2,3
)
Select *, ([Rolling cigarette]/population)*100
from SigaretPerOdam


Drop table if exists #SigaretOdam
Create table #SigaretOdam
(
Country nvarchar (1000),
year numeric,
population numeric,
sigaret nvarchar (1000),
RollingCigaret nvarchar (1000)
)

Insert into #SigaretOdam
Select a.[Country name], a.year, a.Population, b.[Cigarette consumption per smoker per day (IHME, GHDx (2012))],
sum(b.[Cigarette consumption per smoker per day (IHME, GHDx (2012))]) over (partition by a.[Country name] order by a.[Country name], a.year) as [rolling cigarette]
from PortifolioProject..[population-and-demography] a
	join PortifolioProject..[consumption-per-smoker-per-day] b
	on a.[Country name]=b.Entity
	and a.Year=b.Year

Select *, ([RollingCigaret]/population)*100
from #SigaretOdam


Create view Sigaret_Odam as 
Select a.[Country name], a.year, a.Population, b.[Cigarette consumption per smoker per day (IHME, GHDx (2012))],
sum(b.[Cigarette consumption per smoker per day (IHME, GHDx (2012))]) over (partition by a.[Country name] order by a.[Country name], a.year) as [rolling cigarette]
from PortifolioProject..[population-and-demography] a
	join PortifolioProject..[consumption-per-smoker-per-day] b
	on a.[Country name]=b.Entity
	and a.Year=b.Year
--order by 2,3

Select *
from Sigaret_Odam
order by 2,3
