SELECT * FROM
(
    SELECT actor_login,repo_name,COUNT(*)as css FROM year2020
WHERE actor_login IN
(
SELECT actor_login
  FROM(
SELECT actor_login, COUNT(*)  as cs
  FROM year2020
 WHERE repo_name= 'kubernetes/kubernetes'
 GROUP BY actor_login
 ORDER BY cs DESC) as ba
WHERE cs> 200 
)
GROUP BY actor_login,repo_name
)
WHERE css >200 and actor_login <> 'k8s-ci-robot' and actor_login <> 'fejta-bot'
;
SELECT actor_login 
  FROM(
SELECT actor_login, COUNT(*)  as cs
  FROM year2020
 WHERE repo_name= 'kubernetes/kubernetes'
 GROUP BY actor_login
 ORDER BY cs DESC) 
WHERE cs> 200 