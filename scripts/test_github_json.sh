#!/usr/bin/env sh

PORT=${GACHETTE_PORT:-3000}

http localhost:${PORT} User-Agent:GitHub-Hookshot/hashsah X-Github-Event:push X-Hub-Signature:"sha1=4e81b0757a6a6100a0ba2b1f184f5c9a01fb5632" Content-Type:application/json <<< '{
  "ref": "refs/heads/master",
  "before": "31304113108556f646c4c2805e8a4567bb9cebac",
  "after": "cec4ef461a0ec631a7d118634ee3c1afd68537ce",
  "created": false,
  "deleted": false,
  "forced": false,
  "base_ref": null,
  "compare": "https://github.com/blankoworld/gachette/compare/313041131085...cec4ef461a0e",
  "commits": [
    {
      "id": "cec4ef461a0ec631a7d118634ee3c1afd68537ce",
      "tree_id": "1b9ef641405b070b0b67fb1aa4bcc451c5f762be",
      "distinct": true,
      "message": "[IMP] Check secretkey for each kind of payload",
      "timestamp": "2019-08-12T00:26:47+02:00",
      "url": "https://github.com/blankoworld/gachette/commit/cec4ef461a0ec631a7d118634ee3c1afd68537ce",
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
        "TODO",
        "src/gachette.cr",
        "src/gitea.cr",
        "src/kemal.cr"
      ]
    }
  ],
  "head_commit": {
    "id": "cec4ef461a0ec631a7d118634ee3c1afd68537ce",
    "tree_id": "1b9ef641405b070b0b67fb1aa4bcc451c5f762be",
    "distinct": true,
    "message": "[IMP] Check secretkey for each kind of payload",
    "timestamp": "2019-08-12T00:26:47+02:00",
    "url": "https://github.com/blankoworld/gachette/commit/cec4ef461a0ec631a7d118634ee3c1afd68537ce",
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
      "TODO",
      "src/gachette.cr",
      "src/gitea.cr",
      "src/kemal.cr"
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
    "updated_at": "2019-08-09T21:53:36Z",
    "pushed_at": 1565562430,
    "git_url": "git://github.com/blankoworld/gachette.git",
    "ssh_url": "git@github.com:blankoworld/gachette.git",
    "clone_url": "https://github.com/blankoworld/gachette.git",
    "svn_url": "https://github.com/blankoworld/gachette",
    "homepage": null,
    "size": 39,
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
}'

