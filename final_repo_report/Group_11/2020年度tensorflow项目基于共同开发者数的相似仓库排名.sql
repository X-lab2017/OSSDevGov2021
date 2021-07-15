SELECT repo_name, COUNT(*) AS cnt_joint_parti FROM 
(
  SELECT t_g_year2020.actor_login AS actor_login, t_g_year2020.repo_name AS repo_name
  FROM
    (
      SELECT anyHeavy(actor_login) AS ah_actor_login, COUNT(*) AS cnt_tf
      FROM year2020
      WHERE repo_name= 'tensorflow/tensorflow' AND actor_login NOT LIKE '%bot%'
      GROUP BY actor_login
      ORDER BY cnt_tf DESC
      LIMIT 30
    ) t_alcnt 
    INNER JOIN
    (
    SELECT actor_login, repo_name, COUNT(*) AS cnt1
    FROM year2020 
    WHERE actor_login NOT LIKE '%bot%' AND repo_name != 'tensorflow/tensorflow'
    GROUP BY actor_login, repo_name
    ) t_g_year2020
    ON t_g_year2020.actor_login = t_alcnt.ah_actor_login
  WHERE t_g_year2020.cnt1 > 30
) t_joint_parti
GROUP BY repo_name
ORDER BY cnt_joint_parti DESC
LIMIT 15;