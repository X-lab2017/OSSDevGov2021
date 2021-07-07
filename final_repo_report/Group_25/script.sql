select concat('2021/', toString(Month)), Count from (
SELECT COUNT(id) AS Count, toMonth(created_at) AS Month
  FROM year2021
 WHERE repo_name= 'kubernetes/kubernetes'
   AND type= 'PullRequestEvent'
 GROUP BY toMonth(created_at))


select distinct(created_date), repo_stargazers_count
from year2021 where repo_name = 'kubernetes/kubernetes' and repo_stargazers_count != 0 order by created_date;


select concat('2021/', toString(toMonth(created_date))),
       max(repo_stargazers_count)  from year2021
 where repo_name= 'kubernetes/kubernetes'
   and repo_stargazers_count!= 0
   and created_date in(
select min(created_date)  from year2021
 group by toMonth(created_date))  group by created_date;
