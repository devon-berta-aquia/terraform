resource "github_repository" "repository" {
  name = var.repo
}

resource "github_branch_protection" "repository-main-protection" {
  repository_id = github_repository.repository.node_id
  pattern          = "main"
  enforce_admins   = true
  allows_deletions = true
  //required_status_checks {
  //  strict   = false
  //  contexts = ["ci/travis"]
  //}

  required_pull_request_reviews {
    dismiss_stale_reviews  = true
    restrict_dismissals    = true
    dismissal_restrictions = [
      data.github_user.example.node_id,
      github_team.example.node_id,
      "/exampleuser",
      "exampleorganization/exampleteam",
    ]
  }

  restrict_pushes {
    push_allowances = [
      data.github_user.example.node_id,
      "/exampleuser",
      "exampleorganization/exampleteam",
      # you can have more than one type of restriction (teams + users). If you use
      # more than one type, you must use node_ids of each user and each team.
      # github_team.example.node_id
      # github_user.example-2.node_id
    ]
  }

  force_push_bypassers = [
    data.github_user.example.node_id,
    "/exampleuser",
    "exampleorganization/exampleteam",
    # you can have more than one type of restriction (teams + users)
    # github_team.example.node_id
    # github_team.example-2.node_id
  ]

}

resource "github_team" "admins-team" {
  name = "${var.repo}-admins"
}

resource "github_team" "contributors-team" {
  name = "${var.repo}-contributors"
}
// making admins maintianers of the contributors team to be able to add people to the team to give repo access
resource "github_team_membership" "contributors-team" {
  for_each = toset(var.admins)
  team_id  = github_team.contributors-team.id
  username = each.key
  role     = "maintainer"
}
// admins are members of admin team so that they can have admin access to the repo, terraform should be used to modify admin group
resource "github_team_membership" "admins-team" {
  for_each = toset(var.admins)
  team_id  = github_team.admins-team.id
  username = each.key
  role     = "members"
}

resource "github_team_repository" "admins-team-mapping" {
  team_id    = github_team.admins-team.id
  repository = github_repository.repository.name
  permission = "admin"
}

resource "github_team_repository" "contributors-team-mapping" {
  team_id    = github_team.contributors-team.id
  repository = github_repository.repository.name
  permission = "write"
}

