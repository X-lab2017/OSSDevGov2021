SELECT anyHeavy(actor_login)  AS ah_actor_login,
    SUM( issue_comment) AS ic, 
	SUM( open_issue) AS oi, 
	SUM( open_pull) AS op, 
	SUM( pull_review_comment) AS prc, 
	SUM( merge_pull) AS mp, 
	SUM( star) AS st, 
	SUM( fork) AS fo, 
    SUM(daily_score) AS actor_activity 
	FROM daily_score
WHERE toYear(date_time)=2020 AND repo_name = 'tensorflow/tensorflow' AND actor_login NOT LIKE '%bot%'
GROUP BY actor_id
ORDER BY actor_activity DESC 
LIMIT 20