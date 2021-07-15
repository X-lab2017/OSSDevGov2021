import csv
import random

def get_id(name,arr):
    for a in arr:
        if a['name'] == name:
            return a['id']

with open('data.csv', 'r') as f:
    reader = csv.reader(f)
    
    users=set()
    repos=set()
    links=[]
    nodes=[]
    idx=0
    for row in reader:
        if row[0] not in users:
            nodes.append({
                "id":str(idx),
                "name":row[0],
                "category":0,
                "value":1,
                "x":random.uniform(-500.0,500.0),
                "y":random.uniform(-500.0,500.0),
                "symbolSize":0
            })
            idx+=1
        if row[1] not in repos:
            nodes.append({
                "id":str(idx),
                "name":row[1],
                "category":1,
                "value":1,
                "x":random.uniform(-500.0,500.0),
                "y":random.uniform(-500.0,500.0),
                "symbolSize":0
            })
            idx+=1
        user_id=get_id(row[0],nodes)
        repo_id=get_id(row[1],nodes)
        users.add(row[0])
        repos.add(row[1])
        nodes[int(user_id)]['symbolSize']+=int(row[2])
        nodes[int(user_id)]['value']+=int(row[2])
        nodes[int(repo_id)]['symbolSize']+=int(row[2])
        nodes[int(repo_id)]['value']+=int(row[2])
        links.append({
            "source":str(user_id),
            "target":str(repo_id)
        })
    # for user in users:
    #     print(user)
    # for repo in repos:
    #     print(repo)
    for node in nodes:
        node['symbolSize']/=100
        print(str(node)+',')
    # for link in links:
    #     print(str(link)+',')