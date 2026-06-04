# TODO it should be trivial to subscribe to and unsubscribe from these notifications
#
# currently the NUR repo maintainer
# has to modify the config file repos-notify-on-eval-errors.json
# by setting the config value
# notify-on-eval-errors = "github-issues"
#
# a trivial "subscribe to notifications"
# could be implemented with a magic github comment like
# @nurbot update repo config: {"notify-on-eval-errors": "github-issues"}
#
# a trivial "unsubscribe from notifications"
# could be implemented with a magic github comment like
# @nurbot update repo config: {"notify-on-eval-errors": null}

import json
import logging
import os
import re
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Optional
from urllib.parse import urlparse
import traceback

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


def get_github_repo_data(repo: "Repo") -> None:
    if not hasattr(repo, "_github_owner_repo"):
        repo._github_owner, repo._github_repo = repo.url.path.split("/", 3)[1:3]
        repo._github_owner_repo = f"{repo._github_owner}/{repo._github_repo}"
    return github_api_request(
        "GET",
        f"/repos/{repo._github_owner_repo}",
    )


def get_is_github_repo(repo: "Repo") -> None:
    """
    return True if repo is a github repo
    and we can create new issues
    """
    if repo.url.hostname != "github.com":
        return False
    if not hasattr(repo, "_github_repo_data"):
        repo._github_repo_data = get_github_repo_data(repo)
    if repo._github_repo_data.get("archived") == True:
        return False
    if repo._github_repo_data.get("has_issues") == False:
        return False
    # else: create an issue in the user repo
    return True


def get_existing_issues(
    repo: "Repo",
) -> List[Dict]:
    """
    Return open github issues matching:
        "error"
        "repo {repo.name}: error"
    """
    if repo._is_github_repo:
        # get issues from the user repo
        owner_repo = repo._github_owner_repo
        title_prefix = "error"
        is_user_repo = True
    else:
        # get issues from the NUR repo
        owner_repo = nur_github_owner_repo
        title_prefix = f"repo {repo.name}: error"
        is_user_repo = False

    # FIXME use a graphQL query to batch multiple requests
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

    matching_issues = []
    for issue in issues:
        # skip pull requests
        if "pull_request" in issue:
            continue
        if issue["title"].startswith(title_prefix):
            matching_issues.append(issue)

    return matching_issues


def get_error_details_tag(rev):
    return f'<details class="eval-error" id="eval-error-{rev}">'


def escape_html(s):
    return (
        s
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
    )


def unescape_html(s):
    return (
        s
        .replace("&gt;", ">")
        .replace("&lt;", "<")
        .replace("&amp;", "&")
    )


def eval_error_details_md_of_repo(repo):
    # workaround for github:
    # we have to add empty lines around "<pre>...</pre>"
    # otherwise "<details>\n<pre>...</pre>\n</details>" produces broken html
    # where leading whitespace (indented lines) is lost
    rev = repo.eval_error_version.rev
    body_parts = []
    # dont add rev here
    # because this only works in the user repo
    # and we already have rev_url in the body
    issue_title = issue_title_of_repo(repo, add_rev=False)
    body_parts.append(get_error_details_tag(rev)) # <details>
    body_parts.append(f"<summary>{escape_html(issue_title)}</summary>")
    body_parts.append("") # empty line before <pre>
    body_parts.append("<pre>" + escape_html(repo.eval_error_text.strip()) + "</pre>")
    body_parts.append("") # empty line after </pre>
    body_parts.append("</details>")
    return body_parts


# inverse of eval_error_details_md_of_repo
eval_error_details_regex = re.compile(
    (
        # group 1: rev
        r'<details class="eval-error" id="eval-error-([0-9a-f]+)">\n'
        # group 2: escape_html(issue_title)
        r'<summary>([^<]+)</summary>\n'
        r'\n' # empty line before <pre>
        # group 3: escape_html(repo.eval_error_text.strip())
        r'<pre>([^<]+)</pre>\n'
        r'\n' # empty line after </pre>
        r'</details>'
    ),
    re.DOTALL,
)


def extract_last_eval_error_block(issue, comments):
    for comment in reversed(comments):
        if comment["user"]["login"] != github_issues_bot_username:
            continue
        m = eval_error_re.search(comment["body"])
        if m:
            return (
                m.group(0),
                comment["html_url"],
            )
    m = eval_error_re.search(issue["body"])
    if m:
        return (
            m.group(0),
            issue["html_url"],
        )
    return (None, None)


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
    body_parts += eval_error_details_md_of_repo(repo)

    body_parts.append("")
    # TODO set notify-on-eval-errors in upstream repos.json
    repos_json_url = "https://github.com/nix-community/NUR/blob/main/repos.json"
    repos_json_url = "https://github.com/milahu/NUR/blob/nur-repos-notify-on-eval-errors/repos-notify-on-eval-errors.json"
    eval_repo_sh_url = "https://github.com/milahu/NUR/blob/nur-packages-template/scripts/eval-repo.sh"
    body_parts += [
        'you are receiving this notification because you have set',
        '`notify-on-eval-errors="github-issues"`',
        f'for your repo in in [NUR/repos.json]({repos_json_url})',
        '',
        'i will close this issue when eval of your repo works again',
        '',
        f'hint: you can eval your repo locally with [eval-repo.sh]({eval_repo_sh_url})',
    ]

    issue_body = "\n".join(body_parts)

    issue_title = issue_title_of_repo(repo)

    # github docs say:
    # NOTE: Only users with push access can set labels for new issues.
    # Labels are silently dropped otherwise.
    # ... but the github API throws HTTP status 403 forbidden
    # when we try to create an issue with new labels
    # new labels which do not yet exist in the repo
    # message: You do not have permission to create labels on this repository.
    # documentation_url: https://docs.github.com/v3/issues/labels/
    # https://github.com/orgs/community/discussions/197408

    # TODO maybe use a separate request to try to set labels
    # https://docs.github.com/en/rest/issues/labels?apiVersion=2026-03-10#set-labels-for-an-issue

    issue_labels = []

    # NOTE: Only users with push access can set assignees for new issues.
    # Assignees are silently dropped otherwise.
    issue_assignees = []

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
        issue_labels = ["eval-error"]
        # no. github api error 422
        # error: Validation Failed. assignees {github_contact} cannot be assigned to this issue
        # documentation_url: https://docs.github.com/rest/issues/issues#create-an-issue
        # issue_assignees = [github_contact]

    logger.info(f"Creating issue {issue_title!r} in https://github.com/{owner_repo}/issues")

    # https://docs.github.com/en/rest/issues/issues?apiVersion=2026-03-10#create-an-issue
    # Create an issue

    r'''
    2026-05-30T20:02:06.3439122Z notify_github_issues.py:276 create_issue Creating issue 'error: test4 (948979f)' in https://github.com/milahu/nur-packages/issues
    2026-05-30T20:02:06.3446784Z connectionpool.py:1062 _new_conn Starting new HTTPS connection (1): api.github.com:443
    2026-05-30T20:02:06.5264779Z connectionpool.py:544 _make_request https://api.github.com:443 "POST /repos/milahu/nur-packages/issues HTTP/1.1" 403 None
    2026-05-30T20:02:06.5276001Z notify_github_issues.py:462 update_eval_error_github_issues milahu: RuntimeError: github api error 403: {"message":"You do not have permission to create labels on this repository.","errors":[{"resource":"Repository","field":"label","code":"unauthorized"}],"documentation_url":"https://docs.github.com/v3/issues/labels/","status":"403"}
    2026-05-30T20:02:06.5277920Z Traceback (most recent call last):
    2026-05-30T20:02:06.5288636Z   File "/home/runner/work/NUR/NUR/ci/nur/notify_github_issues.py", line 454, in update_eval_error_github_issues
    2026-05-30T20:02:06.5289502Z     create_issue(repo)
    2026-05-30T20:02:06.5290225Z   File "/home/runner/work/NUR/NUR/ci/nur/notify_github_issues.py", line 282, in create_issue
    2026-05-30T20:02:06.5290918Z     github_api_request(
    2026-05-30T20:02:06.5291585Z   File "/home/runner/work/NUR/NUR/ci/nur/notify_github_issues.py", line 55, in github_api_request
    2026-05-30T20:02:06.5292299Z     raise RuntimeError(
    2026-05-30T20:02:06.5293969Z RuntimeError: github api error 403: {"message":"You do not have permission to create labels on this repository.","errors":[{"resource":"Repository","field":"label","code":"unauthorized"}],"documentation_url":"https://docs.github.com/v3/issues/labels/","status":"403"}
    2026-05-30T20:02:06.5295520Z 
    '''


    # FIXME use a graphQL query to batch multiple requests
    github_api_request(
        "POST",
        f"/repos/{owner_repo}/issues",
        json_data={
            "title": issue_title,
            "body": issue_body,
            "labels": issue_labels,
            "assignees": issue_assignees,
        },
    )


def close_issue(
    issue: "Issue",
) -> None:
    logger.info(f"Closing issue {issue['html_url']}")

    # no. "close with comment" sends 2 notification emails:
    # 1. comment: "..."
    # 2. close issue: "Closed #123 as completed."
    # so a less noisy alternative would be
    # to amend our last comment with something like
    # "\n\n---\n\n" + f"edit: eval is working again at {rev_url} &rarr; closing"
    #
    # TODO close with comment?
    # f"works to eval at {rev_url} &rarr; closing"
    # f"working eval at {rev_url} &rarr; closing"
    # f"successful eval at {rev_url} &rarr; closing"
    # f"passing eval at {rev_url} &rarr; closing"
    #
    # there is no atomic "close with comment" operation
    # so we have to
    # 1. add comment
    # 2. close issue
    # see also
    # https://github.com/atxtechbro/dotfiles/issues/777
    # https://github.com/cli/cli/issues/1038
    # https://github.com/terrylica/claude-code-skills-github-issues/blob/main/docs/references/github-cli-issues-comprehensive-guide.md#close-issues

    # TODO lock issue?
    # https://docs.github.com/en/rest/issues/issues?apiVersion=2026-03-10#lock-an-issue

    return update_issue(issue, {"state": "closed"})


def set_issue_title(
    issue: "Issue",
    issue_title: str,
) -> None:
    return update_issue(issue, {"title": issue_title})


# github issues limit:
# Title can not be longer than 256 characters
MAX_TITLE_LEN = 256


def issue_title_of_repo(repo, add_rev=True):
    prefix = "error"

    if not repo._is_github_repo:
        # create an issue in the NUR repo
        # add prefix to the issue title
        prefix = f"repo {repo.name}: {prefix}"

    suffix = ""
    if add_rev:
        # same format as in the subject of github emails
        # [milahu/NUR] Run failed: Update - master (15b8d9f)
        rev_short = repo.eval_error_version.rev[:7]
        suffix += f" ({rev_short})"

    message = ""
    if repo.eval_error_message:
        # f"error: {message}"
        message = f": {repo.eval_error_message}"

    issue_title = prefix + message + suffix

    if len(issue_title) <= MAX_TITLE_LEN:
        return issue_title

    logger.warning(f"{repo.name}: issue_title is too long: {issue_title!r}")

    # -1 for "…"
    max_message_len = MAX_TITLE_LEN - len(prefix) - len(suffix) - 1

    if max_message_len <= 0:
        # Extremely long prefix/suffix; keep hard limit anyway.
        issue_title = (prefix + suffix)[:MAX_TITLE_LEN]
        return issue_title

    # truncate the error message
    message = message[:max_message_len] + "…"
    issue_title = f"{prefix}{message}{suffix}"
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
            repo._github_owner, repo._github_repo = repo.url.path.split("/", 3)[1:3]
            repo._github_owner_repo = f"{repo._github_owner}/{repo._github_repo}"
            repo._is_github_repo = get_is_github_repo(repo)
        else:
            # create an issue in the NUR repo
            repo._is_github_repo = False

        try:
            existing_issues = get_existing_issues(repo)

            if repo.eval_error_text:

                # simple:
                # check github API if an issue exists for repo.eval_error_version

                # TODO maintain a lockfile for notifications
                # for notifications, we cannot rely on repo.eval_error_version
                # which is stored in EVAL_ERRORS_LOCK_PATH = "nur-eval-errors/repos.json.lock"
                # because sending notifications can fail

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
                        if rev_short == repo.eval_error_version.rev[:7]:
                            # issue exists for this error
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
    # https://docs.github.com/en/rest/issues/comments?apiVersion=2026-03-10#list-issue-comments
    # List issue comments
    comments = github_api_request(
        "GET",
        f"/repos/{owner_repo}/issues/{issue_number}/comments",
        params={"per_page": 100},
    )
    # we care only about our own comments
    # "i am the only bot in the village!"
    def filter_comment(comment):
        return comment["user"]["login"] == github_issues_bot_username
    comments = list(filter(filter_comment, comments))
    return comments


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

    # check our previous comments
    comments = get_issue_comments(issue)

    # check if we have reported this rev already
    for comment in comments:
        if rev in comment.get("body", ""):
            # dont add comment
            return

    # add comment

    # check if this error text has been reported already
    # if yes, we dont repeat the error text
    # but add a link to the previous comment
    new_error_html = escape_html(repo.eval_error_text.strip())
    old_error_url = None
    for comment in comments:
        body = comment.get("body", "")
        match = eval_error_details_regex.search(body)
        if not match:
            continue
        old_error_html = match.group(3).strip()
        if new_error_html == old_error_html:
            # found duplicate error text
            old_error_url = comment["html_url"]
            break

    if old_error_url is None:
        # also look in the issue body
        body = issue.get("body", "")
        match = eval_error_details_regex.search(body)
        if match:
            old_error_html = match.group(3).strip()
            if new_error_html == old_error_html:
                # found duplicate error text

                # github bug: this link target does not exist
                # so we cannot link to the issue body
                # https://github.com/orgs/community/discussions/197406
                # old_error_url = issue["html_url"] + "#issue-" + str(issue["id"])
                #
                # the issue body has no id
                # <div class="IssueBodyHeader-...">
                # only some buttons in the issue body have ids
                # but these ids may be unstable
                # last edited by:
                # <button ... id="_r_6l_">
                # issue body actions:
                # <button ... id="_r_24_">
                #
                # comments have ids
                # <div id="issuecomment-4584067881" data-testid="comment-header" class="ActivityHeader-...">
                #
                # issue content has an id
                # <div id="start-of-content" class="show-on-focus"></div>
                old_error_url = issue["html_url"] + "#start-of-content"

    rev_url = f"{repo.url.geturl()}/commit/{rev}"
    comment_body = f"still fails to eval at {rev_url}"

    if old_error_url:
        # add link to old error
        comment_body += f" with the same error as in {old_error_url}"
    else:
        # add new error
        comment_body += "\n\n" + "\n".join(eval_error_details_md_of_repo(repo))

    add_issue_comment(issue, comment_body)
