#!/usr/bin/env python3

import sys
import os
import subprocess
import shlex
import time
import datetime



def exec(*args, **kwargs):
  #if type(args) == str:
  if len(args) == 0:
    raise ValueError
  if len(args) == 1:
    args = shlex.split(args[0])
  else:
    args = list(map(str, args))
  print("> " + shlex.join(args))
  #proc = subprocess.Popen(
  try:
    proc = subprocess.run(
      args,
      capture_output=True,
      encoding="utf8",
      #check=True,
      #timeout=None,
      **kwargs,
    )
  except subprocess.CalledProcessError as proc:
    print(proc.stderr)
    raise
  #proc.wait()
  rc, out, err = proc.returncode, proc.stdout, proc.stderr
  return rc, out, err

#print(repr(exec("bash -c 'echo hello'")))



git_remote_dict = {
  "upstream-nur": {
    "url": "https://github.com/nix-community/NUR",
    "main-branch": "master",
  },
  "upstream-nur-combined": {
    "url": "https://github.com/nix-community/nur-combined",
    "main-branch": "master",
  },
  # no. this git history is not relevant
  # it is derived from nur-combined
  # also, we create a different nur-search based on qwik (nur-search-qwik)
  #"upstream-nur-search": "https://github.com/nix-community/nur-search",
}

# ignore
del git_remote_dict["upstream-nur-combined"]



# split the main branch: code, data, lockfile
git_branch_dict = {
  "main": {
    "remote": "upstream-nur",
    "remove-files": [
      "repos.json",
      "repos.json.lock",
    ],
  },
  "nur-repos": {
    "remote": "upstream-nur",
    "files": ["repos.json"],
  },
  "nur-repos-lock": {
    "remote": "upstream-nur",
    "files": ["repos.json.lock"],
  },
}

# dont modify the main branch
# todo? git rebase
del git_branch_dict["main"]



def get_datetime_str():
    # https://stackoverflow.com/questions/2150739/iso-time-iso-8601-in-python#28147286
    #return datetime.datetime.utcnow().strftime("%Y%m%dT%H%M%S.%fZ")
    return datetime.datetime.utcnow().strftime("%Y%m%dT%H%M%SZ")

date_str = get_datetime_str()



# fetch from remotes
for remote_name in git_remote_dict:
  remote_url = git_remote_dict[remote_name]["url"]
  # check if remote exists
  rc, out, err = exec("git", "remote", "get-url", remote_name)
  if rc != 0:
    # add remote
    exec("git", "remote", "add", remote_name, remote_url, check=True)
  else:
    old_remote_url = out.strip()
    if old_remote_url != remote_url:
      # update remote
      exec("git", "remote", "set-url", remote_name, remote_url, check=True)

  branch_name_list = [
    git_remote_dict[remote_name]["main-branch"],
    *git_remote_dict[remote_name].get("branches", []),
  ]

  # fetch into "upstream-nur/master" etc
  # this fails if the branch is mounted via "git worktree"
  # todo: parse output of "git worktree list"
  exec("git", "fetch", remote_name, *branch_name_list, check=True)



# split the main branch: code, data, lockfile
for branch_name in git_branch_dict:

  branch = git_branch_dict[branch_name]

  if "files" in branch and "remove-files" in branch:
    raise ValueError

  if type(branch["remote"]) == str:
    remote_name = branch["remote"]
    remote_branch = git_remote_dict[remote_name]["main-branch"]
  else:
    remote_name, remote_branch = branch["remote"]

  # example: upstream-nur/master
  src_ref_name = remote_name + "/" + remote_branch

  # check if update is necessry
  if "files" in branch:
    # compare author times of files
    time_list = []
    for ref in [src_ref_name, branch_name]:
      rc, out, err = exec("git", "log", ref, "-n", "1", "--format=%at", "--", *branch["files"], check=True)
      time_list.append(int(out))
    src_time, dst_time = time_list
    if src_time == dst_time:
      print(f"already up to date: {branch_name}")
      continue

  if os.path.isdir(branch_name):
    # this fails if there is no worktree mounted at (branch_name)
    # this fails if the worktree is dirty
    exec("git", "worktree", "remove", branch_name, check=True)

  branch_name_bak = f"{branch_name}_{date_str}_bak"
  branch_name_tmp = f"{branch_name}_{date_str}_tmp"

  exec("git", "branch", branch_name_tmp, src_ref_name, check=True)

  # filter files
  if "files" in branch or "remove-files" in branch:
    args = ["git", "filter-repo", "--force", "--refs", branch_name_tmp]
    if "remove-files" in branch:
      args += ["--invert-path"]
    for path in branch["files"]:
      args += ["--path", path]
    exec(*args, check=True)

  exec("git", "branch", "--move", branch_name, branch_name_bak, check=True)
  exec("git", "branch", "--move", branch_name_tmp, branch_name, check=True)

  exec("git", "branch", "--delete", "--force", branch_name_bak, check=True)

  exec("git", "worktree", "add", branch_name, branch_name, check=True)
