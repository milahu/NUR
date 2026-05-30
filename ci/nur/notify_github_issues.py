import json
import logging
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Optional
from urllib.parse import urlparse

import requests

logger = logging.getLogger(__name__)

GITHUB_API = "https://api.github.com"

# NOTE envs are set in .github/workflows/update.yml

# TODO refactor envs, similar to paths

repo_owner = os.getenv("GITHUB_REPOSITORY_OWNER") or "nix-community"
nur_repo_name = os.getenv("NUR_REPO_NAME") or "NUR"
nur_github_owner_repo = f"{repo_owner}/{nur_repo_name}"

# username and apikey of the github issues bot
github_issues_bot_username = os.getenv("API_USERNAME_GITHUB_ISSUES")
api_token_github_issues = os.getenv("API_TOKEN_GITHUB_ISSUES")


def github_api_request(
    method: str,
    path: str,
    *,
    json_data=None,
    params=None,
):
    url = f"{GITHUB_API}{path}"

    headers = {
        "Authorization": f"Bearer {api_token_github_issues}",
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
    }

    response = requests.request(
        method,
        url,
        headers=headers,
        json=json_data,
        params=params,
        timeout=30,
    )

    if response.status_code >= 400:
        raise RuntimeError(
            f"github api error {response.status_code}: "
            f"{response.text}"
        )

    if response.text:
        return response.json()

    return None


def load_json(path: Path) -> Dict:
    with open(path, "r") as f:
        return json.load(f)


def get_existing_issues(
    repo: "Repo",
) -> List[Dict]:
    """
    Return open github issues matching:
        "{repo.name}: eval error"
    """

    jobs = []
    if repo._is_github_repo:
        jobs.append(dict(
            owner_repo = repo._github_owner_repo,
            title_prefix = "eval error",
            is_user_repo = True,
        ))
    jobs.append(dict(
        owner_repo = nur_github_owner_repo,
        title_prefix = f"{repo.name}: eval error",
        is_user_repo = False,
    ))

    title_prefix = None
    for job in jobs:
        # FIXME use a graphQL query to batch multiple requests
        owner_repo = job["owner_repo"]
        title_prefix = job["title_prefix"]
        try:
            # TODO does this throw when user repo issues are disabled
            issues = github_api_request(
                "GET",
                f"/repos/{owner_repo}/issues",
                params={
                    "state": "open",
                    "creator": github_issues_bot_username,
                    "per_page": 100,
                },
            )
            break
        except Exception as exc:
            logger.error(f"{repo.name}: failed to get issues: {type(exc).__name__}: {exc}")
            if job["is_user_repo"]:
                # user repo issues are disabled
                # dont try to use user repo issues in future requests
                repo._is_github_repo = False

    matching_issues = []
    for issue in issues:
        # skip pull requests
        if "pull_request" in issue:
            continue
        if issue["title"].startswith(title_prefix):
            matching_issues.append(issue)

    return matching_issues


def create_issue(
    repo: "Repo",
) -> None:
    time_str = datetime.now(timezone.utc).strftime("%FT%T%z")

    github_contact = getattr(repo, "github_contact", None)
    if not github_contact:
        raise Exception(f"{repo.name}: no github-contact for notify-on-eval-errors=github-issues")

    body_parts = []

    rev = repo.eval_error_version.rev
    rev_url = f"{repo.url.geturl()}/commit/{rev}"

    if github_contact:
        # body_parts.append(f"ping @{github_contact}")
        body_parts += [
            f"@{github_contact}",
            "your `nur-packages` repo failed to eval",
            f"at version {rev_url} on `{time_str}`",
        ]
    # else: ???
    # how does this work without github_contact?

    if body_parts:
        body_parts.append("")
    body_parts.append("<details>")
    body_parts.append("<summary>eval error</summary>")
    body_parts.append("")
    if "\n```\n" in ("\n" + repo.eval_error_text + "\n"):
        # we cannot use markdown code fence
        body_parts.append("<pre>")
        body_parts.append(
            repo.eval_error_text.strip()
            .replace("&", "&amp;")
            .replace("<", "&lt;")
        )
        body_parts.append("</pre>")
    else:
        body_parts.append("```")
        body_parts.append(repo.eval_error_text.strip())
        body_parts.append("```")
    body_parts.append("")
    body_parts.append("</details>")

    body_parts.append("")
    # TODO set notify-on-eval-errors in upstream repos.json
    repos_json_url = "https://github.com/nix-community/NUR/blob/main/repos.json"
    repos_json_url = "https://github.com/milahu/NUR/blob/nur-repos-notify-on-eval-errors/repos-notify-on-eval-errors.json"
    body_parts += [
        'you are receiving this notification because you have set',
        '`notify-on-eval-errors="github-issues"`',
        f'for your repo in in [NUR/repos.json]({repos_json_url})',
        '',
        'i will close this issue when eval of your repo works again',
    ]

    issue_body = "\n".join(body_parts)

    # _is_github_repo has been checked by get_existing_issues
    rev = repo.eval_error_version.rev[0:7] # short revision
    if repo._is_github_repo:
        owner_repo = repo._github_owner_repo
        # issue_title = f"eval error {time_str} {rev}"
        issue_title = f"eval error {rev}"
    else:
        owner_repo = nur_github_owner_repo
        # issue_title = f"{repo.name}: eval error {time_str} {rev}"
        issue_title = f"{repo.name}: eval error {rev}"

    logger.info(f"Creating issue {issue_title!r} in https://github.com/{owner_repo}/issues")

    # FIXME use a graphQL query to batch multiple requests
    github_api_request(
        "POST",
        f"/repos/{owner_repo}/issues",
        json_data={
            "title": issue_title,
            "body": issue_body,
        },
    )


def close_issue(
    repo: "Repo",
    issue_number: int,
) -> None:
    # _is_github_repo has been checked by get_existing_issues
    if repo._is_github_repo:
        owner_repo = repo._github_owner_repo
    else:
        owner_repo = nur_github_owner_repo

    logger.info(f"Closing issue https://github.com/{owner_repo}/issues/{issue_number}")

    # FIXME use a graphQL query to batch multiple requests
    github_api_request(
        "PATCH",
        f"/repos/{owner_repo}/issues/{issue_number}",
        json_data={
            "state": "closed",
        },
    )


def update_eval_error_github_issues(
    repos: List["Repo"],
) -> None:

    if not api_token_github_issues:
        raise Exception(f"API_TOKEN_GITHUB_ISSUES is empty")

    if not github_issues_bot_username:
        raise Exception(f"API_USERNAME_GITHUB_ISSUES is empty")

    notify_repos = []

    for repo in repos:
        # repo_notify_config = notify_repos.get(repo.name, {})
        # notify_mode = repo_notify_config.get("notify-on-eval-errors")
        notify_mode = getattr(repo, "notify_on_eval_errors", None)
        if notify_mode != "github-issues":
            # logger.debug(f"{repo.name}: notify_on_eval_errors!='github-issues'")
            continue

        github_contact = getattr(repo, "github_contact", None)
        if not github_contact:
            logger.error(f"{repo.name}: no github_contact for notify_on_eval_errors=='github-issues'")
            continue

        notify_repos.append(repo)

    if not notify_repos:
        logger.info(f"no repos to notify")
        return

    logger.info(f"trying to notify {len(notify_repos)} repos")

    for repo in notify_repos:

        if repo.url.hostname == "github.com":
            # try to create an issue in the user's nur-packages repo
            # to avoid spamming the main NUR repo
            # this can fail if the repo's issues are disabled
            # TODO try to use gitea issues
            repo._is_github_repo = True
            repo._github_owner, repo._github_repo = repo.url.path.split("/", 3)[1:3]
            repo._github_owner_repo = f"{repo._github_owner}/{repo._github_repo}"
        else:
            # create an issue in the main NUR repo
            # TODO add issue tag: eval-error
            repo._is_github_repo = False

        try:
            existing_issues = get_existing_issues(repo)

            if repo.eval_error_text:

                if existing_issues:
                    existing_issue_numbers = [issue["number"] for issue in existing_issues]
                    existing_issue_numbers.sort()
                    logger.info(f"{repo.name}: has open issues: {existing_issue_numbers}")

                    # for issue in existing_issues:
                    #     ensure_rev_comment(repo, issue)

                    # comment only on the last issue
                    issue = existing_issues[-1]
                    ensure_rev_comment(repo, issue)

                    continue

                create_issue(repo)

            else:
                # repo evals successfully now -> close old issues
                for issue in existing_issues:
                    close_issue(repo, issue["number"])

        except Exception as exc:
            logger.error(f"{repo.name}: {type(exc).__name__}: {exc}\n{''.join(traceback.format_exception(exc))}")


def get_issue_comments(
    owner_repo: str,
    issue_number: int,
) -> List[Dict]:
    return github_api_request(
        "GET",
        f"/repos/{owner_repo}/issues/{issue_number}/comments",
        params={"per_page": 100},
    )


def add_issue_comment(
    owner_repo: str,
    issue_number: int,
    body: str,
) -> None:
    logger.info(f"Adding comment to https://github.com/{owner_repo}/issues/{issue_number}")
    github_api_request(
        "POST",
        f"/repos/{owner_repo}/issues/{issue_number}/comments",
        json_data={"body": body},
    )


def ensure_rev_comment(
    repo: "Repo",
    issue: Dict,
) -> None:
    rev = repo.eval_error_version.rev

    if repo._is_github_repo:
        owner_repo = repo._github_owner_repo
    else:
        owner_repo = nur_github_owner_repo

    # check issue body first
    if rev in issue.get("body", ""):
        return

    # check all comments
    comments = get_issue_comments(owner_repo, issue["number"])
    for comment in comments:
        if rev in comment.get("body", ""):
            return

    # add comment
    rev_url = f"{repo.url.geturl()}/commit/{rev}"
    comment_body = f"still fails to eval at {rev_url}"
    add_issue_comment(owner_repo, issue["number"], comment_body)
