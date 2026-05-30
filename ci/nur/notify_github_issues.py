import json
import logging
import os
import re
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
        "eval error"
        "repo {repo.name}: eval error"

    Set repo._is_github_repo:
        if we succeed fetching issues from the user repo
        then set: repo._is_github_repo = True
        if we fail fetching issues from the user repo
        then set: repo._is_github_repo = False
    """

    jobs = []
    # None = maybe True, maybe False
    if repo._is_github_repo in (True, None):
        jobs.append(dict(
            owner_repo = repo._github_owner_repo,
            title_prefix = "eval error",
            is_user_repo = True,
        ))
    jobs.append(dict(
        owner_repo = nur_github_owner_repo,
        title_prefix = f"repo {repo.name}: eval error",
        is_user_repo = False,
    ))

    title_prefix = None
    for job in jobs:
        # FIXME use a graphQL query to batch multiple requests
        owner_repo = job["owner_repo"]
        title_prefix = job["title_prefix"]
        try:
            # TODO does this throw when user repo issues are disabled
            # https://docs.github.com/en/rest/issues/issues?apiVersion=2026-03-10#list-repository-issues
            # List repository issues
            issues = github_api_request(
                "GET",
                f"/repos/{owner_repo}/issues",
                params={
                    "state": "open",
                    "creator": github_issues_bot_username,
                    "per_page": 100,
                    # "sort": "created", # default
                    # "sort": "updated",
                    # "direction": "desc", # default
                    # "direction": "asc",
                },
            )
            if job["is_user_repo"]:
                # user repo issues are enabled
                # use user repo issues in future requests
                repo._is_github_repo = True
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


def get_details_tag(rev):
    return f'<details class="eval-error" id="eval-error-{rev}">'


def create_issue(
    repo: "Repo",
) -> None:
    time_str = datetime.now(timezone.utc).strftime("%FT%T%z")
    # date_str = datetime.now(timezone.utc).strftime("%F")

    github_contact = (
        getattr(repo, "github_contact", None) or
        repo._github_owner
    )

    body_parts = []

    rev = repo.eval_error_version.rev
    rev_url = f"{repo.url.geturl()}/commit/{rev}"

    body_parts += [
        f"your repo fails to eval at {rev_url}",
    ]

    if body_parts:
        body_parts.append("")
    body_parts.append(get_details_tag(rev))
    if repo.eval_error_message:
        # FIXME re-use issue title
        body_parts.append(f"<summary>eval error: {repo.eval_error_message}</summary>")
    else:
        body_parts.append(f"<summary>eval error</summary>")
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

    issue_title = issue_title_of_repo(repo)

    # repo._is_github_repo has been verified by get_existing_issues
    if repo._is_github_repo:
        # create an issue in the user repo
        owner_repo = repo._github_owner_repo
    else:
        # create an issue in the NUR repo
        owner_repo = nur_github_owner_repo
        # mention the repo owner so he gets a notification
        issue_body = f"@{github_contact}" + "\n" + issue_body
        # TODO add issue label: eval-error
        # color: #d93f0b = lightred = same color as the default "bug" label
        # https://github.com/milahu/NUR/issues/labels

    logger.info(f"Creating issue {issue_title!r} in https://github.com/{owner_repo}/issues")

    # https://docs.github.com/en/rest/issues/issues?apiVersion=2026-03-10#create-an-issue
    # Create an issue

    # FIXME use a graphQL query to batch multiple requests
    github_api_request(
        "POST",
        f"/repos/{owner_repo}/issues",
        json_data={
            "title": issue_title,
            "body": issue_body,
            # NOTE: Only users with push access can set labels for new issues.
            # Labels are silently dropped otherwise.
            "labels": ["eval-error"],
            # NOTE: Only users with push access can set assignees for new issues.
            # Assignees are silently dropped otherwise.
            "assignees": [github_contact],
        },
    )


def close_issue(
    issue: "Issue",
) -> None:
    logger.info(f"Closing issue {issue['html_url']}")

    # TODO close with comment?
    # f"works to eval at {rev_url} &rarr; closing"
    # f"working eval at {rev_url} &rarr; closing"
    # f"successful eval at {rev_url} &rarr; closing"
    # f"passing eval at {rev_url} &rarr; closing"

    # TODO lock issue?
    # https://docs.github.com/en/rest/issues/issues?apiVersion=2026-03-10#lock-an-issue

    return update_issue(issue, {"state": "closed"})


def set_issue_title(
    issue: "Issue",
    issue_title: str,
) -> None:
    return update_issue(issue, {"title": issue_title})


def issue_title_of_repo(repo):
    issue_title = "eval error"
    if repo.eval_error_message:
        issue_title += f": {repo.eval_error_message}"
    # same format as in the subject of github emails
    # [milahu/NUR] Run failed: Update - master (15b8d9f)
    rev_short = repo.eval_error_version.rev[0:7]
    issue_title += f" ({rev_short})"
    # repo._is_github_repo has been verified by get_existing_issues
    if not repo._is_github_repo:
        # create an issue in the NUR repo
        # add prefix to the issue title
        issue_title = f"repo {repo.name}: {issue_title}"
    return issue_title


def owner_repo_of_issue(issue):
    'get "OWNER/REPO" of issue'
    return "/".join(issue["repository_url"].split("/")[-2:])


def rev_short_of_issue(issue):
    "parse rev_short from issue title"
    match = re.search(r" \(([0-9a-f]+)\)$", issue["title"])
    if not match: return
    return match.group(1)


def update_issue(
    issue: "Issue",
    data: dict,
) -> None:
    owner_repo = owner_repo_of_issue(issue)
    issue_number = issue["number"]
    logger.info(f"Updating issue {issue['html_url']} with data {data}")
    # https://docs.github.com/en/rest/issues/issues?apiVersion=2026-03-10#update-an-issue
    # FIXME use a graphQL query to batch multiple requests
    github_api_request(
        "PATCH",
        f"/repos/{owner_repo}/issues/{issue_number}",
        json_data=data,
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
            # try to create an issue in the user repo
            # to avoid spamming the NUR repo
            # this can fail if the user repo's issues are disabled
            # so we fallback to the NUR repo
            # TODO try to use gitea issues
            # we will set repo._is_github_repo later in get_existing_issues
            repo._is_github_repo = None # maybe True, maybe False
            repo._github_owner, repo._github_repo = repo.url.path.split("/", 3)[1:3]
            repo._github_owner_repo = f"{repo._github_owner}/{repo._github_repo}"
        else:
            # create an issue in the NUR repo
            repo._is_github_repo = False

        try:
            existing_issues = get_existing_issues(repo)

            if repo.eval_error_text:

                # simple:
                # check github API if an issue exists for repo.eval_error_version

                # check if we have already reported this eval error
                # check by proxy:
                # when have we found this eval error?
                # in this CI run or in a previous CI run?
                # eval error found in this CI run -> report error
                # eval error found in previous CI run -> dont report error

                # NOTE we dont maintain an extra lockfile for notifications
                # instead, we rely on repo.eval_error_version
                # which is stored in EVAL_ERRORS_LOCK_PATH = "nur-eval-errors/repos.json.lock"
                #
                # if an eval error is stored there
                # then we assume a notification has been sent
                # but sending notifications can fail...

                # if repo.eval_error_version == repo.old_eval_error_version:
                #     # reachable only with force_eval=True

                if existing_issues:
                    existing_issue_numbers = [issue["number"] for issue in existing_issues]
                    existing_issue_numbers.sort()
                    logger.info(f"{repo.name}: has open issues: {existing_issue_numbers}")

                    # for issue in existing_issues:
                    #     ensure_rev_comment(repo, issue)

                    # update only on the last issue
                    issue = existing_issues[-1]
                    if 1:

                        rev_short = rev_short_of_issue(issue)
                        if rev_short == repo.eval_error_version[:7]:
                            # issue exists for this eval error
                            continue

                        new_title = issue_title_of_repo(repo)
                        logger.info(f"{repo.name}: updating issue title: {issue['title']} -> {new_title}")
                        set_issue_title(issue, new_title)

                        ensure_rev_comment(repo, issue)

                    continue

                create_issue(repo)

            else:
                # repo evals successfully now -> close old issues
                for issue in existing_issues:
                    close_issue(issue)

        except Exception as exc:
            logger.error(f"{repo.name}: {type(exc).__name__}: {exc}\n{''.join(traceback.format_exception(exc))}")


def get_issue_comments(
    issue: "Issue",
) -> List[Dict]:
    owner_repo = owner_repo_of_issue(issue)
    issue_number = issue["number"]
    # https://docs.github.com/en/rest/issues/issues?apiVersion=2026-03-10#get-an-issue
    # Get an issue
    return github_api_request(
        "GET",
        f"/repos/{owner_repo}/issues/{issue_number}/comments",
        params={"per_page": 100},
    )


def add_issue_comment(
    issue: "Issue",
    body: str,
) -> None:
    owner_repo = owner_repo_of_issue(issue)
    issue_number = issue["number"]
    logger.info(f"Adding comment to {issue['html_url']}")
    github_api_request(
        "POST",
        f"/repos/{owner_repo}/issues/{issue_number}/comments",
        json_data={"body": body},
    )


def ensure_rev_comment(
    repo: "Repo",
    issue: "Issue",
) -> None:
    rev = repo.eval_error_version.rev

    # check issue body first
    if rev in issue.get("body", ""):
        return

    # check all comments
    comments = get_issue_comments(issue)
    details_tag = get_details_tag(rev)
    for comment in comments:
        if comment["user"]["login"] != github_issues_bot_username:
            continue
        if details_tag in comment.get("body", ""):
            return

    # add comment
    rev_url = f"{repo.url.geturl()}/commit/{rev}"
    comment_body = f"still fails to eval at {rev_url}"
    add_issue_comment(issue, comment_body)
