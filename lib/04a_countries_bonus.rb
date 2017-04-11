# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

# BONUS QUESTIONS: These problems require knowledge of aggregate
# functions. Attempt them after completing section 05.

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
  SELECT
    name
  FROM
    countries
  WHERE
    gdp > (
      SELECT
      MAX(gdp)
      FROM
      countries
      WHERE
      continent = 'Europe'
    )
  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
  Select
  max_area.continent,
  countries.name,
  max_area.max
  FROM
  (SELECT
    continent,
    MAX(area)
  FROM
    countries
  GROUP BY
    continent
  ) AS max_area
  JOIN
    countries ON (max_area.max = countries.area)
  SQL

end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
  SELECT
  c1.name,
  c1.continent
  FROM
    countries c1
  WHERE
    c1.population > (
      SELECT
      MAX(c2.population)*3
      FROM
      countries c2
      WHERE
        (c1.name != c2.name
        and c1.continent = c2.continent)
    )

  SQL
end
