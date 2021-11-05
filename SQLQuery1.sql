--TEMP TABLE	
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent
, dea.location
, dea.date
, dea.population
, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over 
		 (partition by dea.location)
		 as RollingPeopleVaccinated
from [Portfolio Projects]..covid_deaths dea
join [Portfolio Projects]..covid_vacinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	and dea.continent is not null
order by 2,3

select *
, (RollingPeopleVaccinated / Population) *100 as
From #PercentPopulationVaccinated


--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as 
select dea.continent
, dea.location
, dea.date
, dea.population
, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over 
		 (partition by dea.location 
		 order by dea.location, dea.date)
		 as RollingPeopleVaccinated
from [Portfolio Projects]..covid_deaths dea
join [Portfolio Projects]..covid_vacinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	and dea.continent is not null

	select * 
	from PercentPopulationVaccinated