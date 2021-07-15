SELECT COUNT(*) AS count, toDayOfWeek(created_at) AS dayOfWeek, toHour(created_at)  AS hour FROM year2020
WHERE actor_login NOT LIKE '%[bot]' AND repo_name = 'tensorflow/tensorflow'
GROUP BY hour, dayOfWeek