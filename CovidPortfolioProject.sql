ALTER TABLE dbo.CovidVaccinations
ALTER COLUMN total_tests INT


ALTER TABLE dbo.CovidDeaths
ALTER COLUMN new_cases INT;

-- Creating view for later visualization.

Create View PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
  ON dea.location = vac.location
  AND dea.date = vac.date
  WHERE dea.continent IS NOT NULL
  
  --ORDER BY 2,3
  --GROUP BY dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations

  SELECT * 
  FROM PercentPopulationVaccinated