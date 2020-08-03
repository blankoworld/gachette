require "spec"

# spec_helper adds method to manipulate data easily in tests

# Just open a file and give its content
def open_json_file(name) : String
  file = File.new(name)
  content = file.gets_to_end || ""
  file.close
  content
end

# Headers for GITEA payload tests
GITEA_HEADERS = HTTP::Headers{
  "User-Agent"        => "GiteaServer",
  "Content-Type"      => "application/json",
  "X-GitHub-Delivery" => "e905e09b-6b35-46b4-bba5-c6599d21ab33",
  "X-GitHub-Event"    => "push",
  "X-Gitea-Delivery"  => "e905e09b-6b35-46b4-bba5-c6599d21ab33",
  "X-Gitea-Event"     => "push",
  "X-Gogs-Delivery"   => "e905e09b-6b35-46b4-bba5-c6599d21ab33",
  "X-Gogs-Event"      => "push",
}

# Headers for GITLAB payload tests
GITLAB_HEADERS = HTTP::Headers{
  "Content-Type"   => "application/json",
  "X-Gitlab-Event" => "Push Hook",
  "X-Gitlab-Token" => "mot2passe",
}

# Headers from an existing GITHUB webhook
GITHUB_HEADERS = HTTP::Headers{
  "content-type"      => "application/json",
  "Expect"            => "",
  "User-Agent"        => "GitHub-Hookshot/hashsah",
  "X-GitHub-Delivery" => "691df212-bdb7-11e9-8119-fa2f1de358a6",
  "X-GitHub-Event"    => "push",
  "X-Hub-Signature"   => "sha1=8cfbbbf7a0b7b8322519ac7fbf346ad9a9475236",
}

# Body content from an existing Github webhook
GITHUB_PAYLOAD = <<-'TEXT'
{
  "ref": "refs/heads/master",
  "before": "0e11d9b0c51417ffde29f21d5b753a06a6fe1147",
  "after": "7a5369b2c6513577d3a10ccd3c2324dd99838b8e",
  "created": false,
  "deleted": false,
  "forced": false,
  "base_ref": null,
  "compare": "https://github.com/blankoworld/gachette/compare/0e11d9b0c514...7a5369b2c651",
  "commits": [
    {
      "id": "7a5369b2c6513577d3a10ccd3c2324dd99838b8e",
      "tree_id": "435c4dcdf9d8d32da8d76d56df012fa9dfb1dfda",
      "distinct": true,
      "message": "[IMP] Get github webhooks working!",
      "timestamp": "2019-08-13T12:42:56+02:00",
      "url": "https://github.com/blankoworld/gachette/commit/7a5369b2c6513577d3a10ccd3c2324dd99838b8e",
      "author": {
        "name": "Olivier DOSSMANN",
        "email": "git@dossmann.net",
        "username": "blankoworld"
      },
      "committer": {
        "name": "Olivier DOSSMANN",
        "email": "git@dossmann.net",
        "username": "blankoworld"
      },
      "added": [

      ],
      "removed": [

      ],
      "modified": [
        "src/gachette.cr"
      ]
    }
  ],
  "head_commit": {
    "id": "7a5369b2c6513577d3a10ccd3c2324dd99838b8e",
    "tree_id": "435c4dcdf9d8d32da8d76d56df012fa9dfb1dfda",
    "distinct": true,
    "message": "[IMP] Get github webhooks working!",
    "timestamp": "2019-08-13T12:42:56+02:00",
    "url": "https://github.com/blankoworld/gachette/commit/7a5369b2c6513577d3a10ccd3c2324dd99838b8e",
    "author": {
      "name": "Olivier DOSSMANN",
      "email": "git@dossmann.net",
      "username": "blankoworld"
    },
    "committer": {
      "name": "Olivier DOSSMANN",
      "email": "git@dossmann.net",
      "username": "blankoworld"
    },
    "added": [

    ],
    "removed": [

    ],
    "modified": [
      "src/gachette.cr"
    ]
  },
  "repository": {
    "id": 173622896,
    "node_id": "MDEwOlJlcG9zaXRvcnkxNzM2MjI4OTY=",
    "name": "gachette",
    "full_name": "blankoworld/gachette",
    "private": false,
    "owner": {
      "name": "blankoworld",
      "email": "git@dossmann.net",
      "login": "blankoworld",
      "id": 147417,
      "node_id": "MDQ6VXNlcjE0NzQxNw==",
      "avatar_url": "https://avatars2.githubusercontent.com/u/147417?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/blankoworld",
      "html_url": "https://github.com/blankoworld",
      "followers_url": "https://api.github.com/users/blankoworld/followers",
      "following_url": "https://api.github.com/users/blankoworld/following{/other_user}",
      "gists_url": "https://api.github.com/users/blankoworld/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/blankoworld/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/blankoworld/subscriptions",
      "organizations_url": "https://api.github.com/users/blankoworld/orgs",
      "repos_url": "https://api.github.com/users/blankoworld/repos",
      "events_url": "https://api.github.com/users/blankoworld/events{/privacy}",
      "received_events_url": "https://api.github.com/users/blankoworld/received_events",
      "type": "User",
      "site_admin": false
    },
    "html_url": "https://github.com/blankoworld/gachette",
    "description": "Webhook server for Gitlab, Github and Gitea to run arbitrary commands",
    "fork": false,
    "url": "https://github.com/blankoworld/gachette",
    "forks_url": "https://api.github.com/repos/blankoworld/gachette/forks",
    "keys_url": "https://api.github.com/repos/blankoworld/gachette/keys{/key_id}",
    "collaborators_url": "https://api.github.com/repos/blankoworld/gachette/collaborators{/collaborator}",
    "teams_url": "https://api.github.com/repos/blankoworld/gachette/teams",
    "hooks_url": "https://api.github.com/repos/blankoworld/gachette/hooks",
    "issue_events_url": "https://api.github.com/repos/blankoworld/gachette/issues/events{/number}",
    "events_url": "https://api.github.com/repos/blankoworld/gachette/events",
    "assignees_url": "https://api.github.com/repos/blankoworld/gachette/assignees{/user}",
    "branches_url": "https://api.github.com/repos/blankoworld/gachette/branches{/branch}",
    "tags_url": "https://api.github.com/repos/blankoworld/gachette/tags",
    "blobs_url": "https://api.github.com/repos/blankoworld/gachette/git/blobs{/sha}",
    "git_tags_url": "https://api.github.com/repos/blankoworld/gachette/git/tags{/sha}",
    "git_refs_url": "https://api.github.com/repos/blankoworld/gachette/git/refs{/sha}",
    "trees_url": "https://api.github.com/repos/blankoworld/gachette/git/trees{/sha}",
    "statuses_url": "https://api.github.com/repos/blankoworld/gachette/statuses/{sha}",
    "languages_url": "https://api.github.com/repos/blankoworld/gachette/languages",
    "stargazers_url": "https://api.github.com/repos/blankoworld/gachette/stargazers",
    "contributors_url": "https://api.github.com/repos/blankoworld/gachette/contributors",
    "subscribers_url": "https://api.github.com/repos/blankoworld/gachette/subscribers",
    "subscription_url": "https://api.github.com/repos/blankoworld/gachette/subscription",
    "commits_url": "https://api.github.com/repos/blankoworld/gachette/commits{/sha}",
    "git_commits_url": "https://api.github.com/repos/blankoworld/gachette/git/commits{/sha}",
    "comments_url": "https://api.github.com/repos/blankoworld/gachette/comments{/number}",
    "issue_comment_url": "https://api.github.com/repos/blankoworld/gachette/issues/comments{/number}",
    "contents_url": "https://api.github.com/repos/blankoworld/gachette/contents/{+path}",
    "compare_url": "https://api.github.com/repos/blankoworld/gachette/compare/{base}...{head}",
    "merges_url": "https://api.github.com/repos/blankoworld/gachette/merges",
    "archive_url": "https://api.github.com/repos/blankoworld/gachette/{archive_format}{/ref}",
    "downloads_url": "https://api.github.com/repos/blankoworld/gachette/downloads",
    "issues_url": "https://api.github.com/repos/blankoworld/gachette/issues{/number}",
    "pulls_url": "https://api.github.com/repos/blankoworld/gachette/pulls{/number}",
    "milestones_url": "https://api.github.com/repos/blankoworld/gachette/milestones{/number}",
    "notifications_url": "https://api.github.com/repos/blankoworld/gachette/notifications{?since,all,participating}",
    "labels_url": "https://api.github.com/repos/blankoworld/gachette/labels{/name}",
    "releases_url": "https://api.github.com/repos/blankoworld/gachette/releases{/id}",
    "deployments_url": "https://api.github.com/repos/blankoworld/gachette/deployments",
    "created_at": 1551642965,
    "updated_at": "2019-08-12T13:58:05Z",
    "pushed_at": 1565693104,
    "git_url": "git://github.com/blankoworld/gachette.git",
    "ssh_url": "git@github.com:blankoworld/gachette.git",
    "clone_url": "https://github.com/blankoworld/gachette.git",
    "svn_url": "https://github.com/blankoworld/gachette",
    "homepage": null,
    "size": 42,
    "stargazers_count": 2,
    "watchers_count": 2,
    "language": "Crystal",
    "has_issues": true,
    "has_projects": true,
    "has_downloads": true,
    "has_wiki": true,
    "has_pages": false,
    "forks_count": 0,
    "mirror_url": null,
    "archived": false,
    "disabled": false,
    "open_issues_count": 0,
    "license": {
      "key": "mit",
      "name": "MIT License",
      "spdx_id": "MIT",
      "url": "https://api.github.com/licenses/mit",
      "node_id": "MDc6TGljZW5zZTEz"
    },
    "forks": 0,
    "open_issues": 0,
    "watchers": 2,
    "default_branch": "master",
    "stargazers": 2,
    "master_branch": "master"
  },
  "pusher": {
    "name": "blankoworld",
    "email": "git@dossmann.net"
  },
  "sender": {
    "login": "blankoworld",
    "id": 147417,
    "node_id": "MDQ6VXNlcjE0NzQxNw==",
    "avatar_url": "https://avatars2.githubusercontent.com/u/147417?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/blankoworld",
    "html_url": "https://github.com/blankoworld",
    "followers_url": "https://api.github.com/users/blankoworld/followers",
    "following_url": "https://api.github.com/users/blankoworld/following{/other_user}",
    "gists_url": "https://api.github.com/users/blankoworld/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/blankoworld/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/blankoworld/subscriptions",
    "organizations_url": "https://api.github.com/users/blankoworld/orgs",
    "repos_url": "https://api.github.com/users/blankoworld/repos",
    "events_url": "https://api.github.com/users/blankoworld/events{/privacy}",
    "received_events_url": "https://api.github.com/users/blankoworld/received_events",
    "type": "User",
    "site_admin": false
  }
}
TEXT
