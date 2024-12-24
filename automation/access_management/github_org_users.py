import requests
from github import Github

g = Github("org_admin_github_token")
for member in g.get_organization("orgname").get_members(): #replace org name
    print(member.login, member.name, member.email)
