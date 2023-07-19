import requests
from github import Github

g = Github("org_admin_github_token")
for member in g.get_organization("bizongo").get_members():
    print(member.login, member.name, member.email)
