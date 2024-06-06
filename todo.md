# todo



## limit repo sizes

https://github.com/nix-community/NUR/issues/133  
Size limits on repos?

> I suppose we would need a history rewrite to undo this.

anyway, the history of nur-combined should be truncated regularly

similar to  
https://github.com/rust-lang/crates-io-cargo-teams/issues/47  
When should we next squash the index?

repo sizes...

```
$ du -sh nur-combined/
106M    nur-combined/

$ du -sh nur-combined/repos/* | sort -h | tail -n10
1.3M    nur-combined/repos/linyinfeng
1.8M    nur-combined/repos/arc
2.7M    nur-combined/repos/crazazy
2.9M    nur-combined/repos/xddxdd
3.7M    nur-combined/repos/lucasew
4.0M    nur-combined/repos/sikmir
6.9M    nur-combined/repos/mipmip
7.6M    nur-combined/repos/milahu
8.0M    nur-combined/repos/colinsane
11M     nur-combined/repos/oluceps
```

the removed Ma27/nixexprs repo had 34 MB

i would suggest a hard limit of 100 MB per repo  
like github's maximum file size  
github repos: soft limit 5 GB, hard limit 10 GB  

... or we limit the total size of nur-combined  
to something like 1 GB  
and the largest repo is removed first

in my repo, by far the largest files are lockfiles  
package-lock.json  
mvn2nix-lock.json  
now it makes sense why npmlock2nix is not used in nixpkgs...

repo size of nixpkgs

```
$ git -C nixpkgs rev-parse HEAD
5672bc9dbf9d88246ddab5ac454e82318d094bb8/

$ du -sh nixpkgs
377M    nixpkgs
```



## write source date to nur-repos-lock/repos.json.lock

this was working before...

authoredDate is fetched from github graphQL

should be set as repo.new_version.date

ci/nur/prefetch.py

```
        commit = item["defaultBranchRef"]["target"]["oid"]
        commit_date = item["defaultBranchRef"]["target"]["authoredDate"]
        repo.new_version = LockedVersion(repo.url.geturl(), commit, None, repo.submodules, commit_date)
```



## further reduce CI time

noop time is 30 seconds

noop = no updates, no evals, all repos are up to date

with DeterminateSystems/magic-nix-cache-action

- 3 seconds for cachix/install-nix-action
- 8 seconds for DeterminateSystems/magic-nix-cache-action
- 2 seconds to fetch git branches
- 6 seconds for github graphql query

without DeterminateSystems/magic-nix-cache-action

- 3 seconds for cachix/install-nix-action
- 2 seconds for python
- 5 seconds for pip install
- 12 seconds for ci/update-nur.sh
  - 2 seconds to fetch git branches
  - 7 seconds for github graphql query



## add NUR to repology.org

https://repology.org/repositories/statistics/total

to compare, number of packages on 2024-04-17

- nixpkgs unstable: 91857
- AUR: 73494
- Debian Unstable: 37106
- GNU Guix: 27194
- PyPI: 18697
- Gentoo: 17790
- Homebrew: 6814
- NUR: 4806
- Chocolatey: 3132

https://libraries.io/platforms

http://www.modulecounts.com/

- NPM: 4M packages
- Maven: 600K packages
- Go: 500K packages
- PyPi: 500K packages
- Cargo: 150K packages



## remove nur-eval-results

pro: reduce disk space

con: increase CPU time

nur-eval-results is useful for caching the eval results

without nur-eval-results we would have to eval every repo in every CI run  
or we would need a smarter update (incremental update) for gh-pages/index.html  
for example by grouping packages by repo, and by only updating the changed parts

```html
<table>
  <tbody id="repo-user1">
    <tr>...</tr>
    <tr>...</tr>
  </tbody>
  <tbody id="repo-user2">
    <tr>...</tr>
    <tr>...</tr>
  </tbody>
</table>
```



## use sqlite for the packages index

instead of a large html `<table>` in gh-pages/index.html
which takes 20 seconds to load,
use a dynamic single page app to render a sqlite table,
allowing to search, sort, filter, paginate.

dynamic single page app, based on sqlite and solidjs

- https://github.com/sql-js/sql.js
  - https://www.npmjs.com/browse/depended/sql.js
    - https://www.npmjs.com/package/jeep-sqlite
    - https://www.npmjs.com/package/gist-sqlite
    - https://www.npmjs.com/package/rosbag_next
    - https://www.npmjs.com/package/@squill/sqlite3-browser
- https://sqlite.org/wasm/doc/trunk/demo-123.md
  - https://sqlite.org/wasm/doc/trunk/demo-123.html
- https://github.com/jepiqueau/capacitor-solid-sqlite
  - https://www.npmjs.com/package/@capacitor-community/sqlite
  - https://capacitorjs.com/docs
- https://github.com/fimbres/astro-chat
- https://riffle.systems/essays/prelude/
  - A research project aiming to simplify app development by using databases for client-side state management.

also add a command-line client for offline use,
because html and javascript is slow.

example:

```
$ nur-search cowsay
nur.repos.someuser.cowsay  cowsay-3.7.0  A program which generates ASCII pictures of a cow with a message
```



# done



<details>



- cache eval errors
- cache eval timeout errors
- use graphql to batch-update versions of github repos: 10 instead of 200 seconds
- make NUR more forking-friendly: in CI, use dynamic repo urls
- make CI logs much less verbose: use `nix --quiet` to hide output of git



### make update more efficient

https://github.com/nix-community/NUR/issues/351

running bin/nur update is too expensive



### merge tasks update/eval/index to use maximum caching

fixed issue:

https://github.com/nix-community/NUR/issues/240  
[nur-search] repo does evaluate when generating nur-combined but does not evaluate on nur-search update

nur-update and nur-index used different arguments to call nix-env  
fixed by joining nur-index into nur-update



### move all code to NUR, remove "automatic update" commits from git history

move all data to nur-combined (also nur-search)

#### move repos.json.lock to a separate branch: nur-repos-lock

```
# create backup of master branch
git branch --copy master master-bak-with-nur-repos-lock

# create nur-repos-lock branch
git branch --copy master nur-repos-lock
# remove repos.json.lock from master branch history
git filter-repo --invert-paths --path repos.json.lock --refs master --force

# keep only repos.json.lock in nur-repos-lock branch history
git filter-repo --path repos.json.lock --refs nur-repos-lock --force
```

#### move repos.json to a separate branch: nur-repos

```
# create backup of master branch
git branch --copy master master-bak-with-nur-repos

# create nur-repos branch
git branch --copy master nur-repos

# remove repos.json from master branch history
git filter-repo --invert-paths --path repos.json --refs master --force

# keep only repos.json in nur-repos branch history
git filter-repo --path repos.json --refs nur-repos --force
```

#### move eval-errors/ to a separate branch: nur-eval-errors

```sh
# create backup of master branch
git branch --copy master master-bak-with-nur-eval-errors

# create nur-eval-errors branch
git branch --copy master nur-eval-errors

# remove eval-errors/ from master branch history
git filter-repo --invert-paths --path eval-errors/ --refs master --force

# keep only eval-errors/ in nur-eval-errors branch history
git filter-repo --path eval-errors/ --refs nur-eval-errors --force
```

#### remove moved files from branches based on master branch

```sh
for branch in parallel-fetch python37 quiet-builds; do
  # create backup branch
  git branch --copy $branch $branch-with-removed-files

  # remove files
  git filter-repo --invert-paths --path repos.json.lock --refs $branch --force
  git filter-repo --invert-paths --path repos.json --refs $branch --force
  git filter-repo --invert-paths --path eval-errors/ --refs $branch --force
done
```



#### nur-search: move data/ to a separate branch: nur-search-data

```sh
# this will take some time...
git fetch https://github.com/nix-community/nur-search master:upstream-nur-search

# create nur-search-data branch
git branch --copy upstream-nur-search nur-search-data

# keep only data/ in nur-search-data branch history
git filter-repo --path data/ --refs nur-search-data --force

# create nur-search branch
git branch --move nur-search nur-search-bak
git branch --copy upstream-nur-search nur-search

# remove data/ from nur-search branch history
git filter-repo --invert-paths --path data/ --refs nur-search --force
```

```
# TODO keep only the data folder
# TODO remove the data folder

# TODO future: delete old history of the nur-search-data branch

# TODO future: delete old history of the nur-repos-lock branch

# "delete old history" but keep commit hashes (dont rewrite git history, add graft commit?)
```



### move everything to one repo

is there a hard requirement for nur-combined? (TODO "nur-combined repo" or "nur-combined branch"?)

move the other repos (nur-combined, nur-search)
to branches of the main repo? -> monorepo

in the main repo:

```
git remote add nur-search-repo https://github.com/milahu/nur-search
git fetch nur-search-repo master:nur-search
git fetch nur-search-repo gh-pages:gh-pages

git remote add nur-combined-repo https://github.com/milahu/nur-combined
git fetch nur-combined-repo master:nur-combined

git remote add nur-update-repo https://github.com/nix-community/nur-update
git fetch nur-update-repo master:nur-update

git remote add nur-packages-template-repo https://github.com/nix-community/nur-packages-template
git fetch nur-packages-template-repo master:nur-packages-template
```

also move the repo `nur-packages-template` to a branch of the `NUR` repo.
but then, people cannot use the github webinterface to create a fork of `nur-packages-template`.
instead, people have to manually clone the `nur-packages-template` branch
to the `master` branch of their `nur-packages` repo.
we cannot push a shallow clone to a new repo on github, so we create a new repo:

```
git clone https://github.com/milahu/NUR --branch nur-packages-template --depth=1 nur-packages
cd nur-packages
h=$(git rev-parse HEAD)
rm -rf .git
git init
git add .
git commit -m $'init\n\nfrom:\n\nrepo: https://github.com/milahu/NUR\nbranch: nur-packages-template\ncommit: '$h
git remote add github https://github.com/$USER/nur-packages
git push github -u main
```

see also [scripts/init-nur-packages.sh](scripts/init-nur-packages.sh)



### use relative links in generated html, so it also works with github pages



### show a recursive list of packages

recursive listing does not work in my repo:

- https://github.com/milahu/nur-packages/blob/master/default.nix
   - `python3Packages = pkgs.recurseIntoAttrs`
- http://nur.nix-community.org/repos/milahu/
   - no recursion, only top-level attributes are listed

but it works in other repos:

- https://github.com/nagy/nur-packages/blob/master/default.nix
   - `python3Packages = pkgs.recurseIntoAttrs`
   - `lispPackages = pkgs.recurseIntoAttrs`
   - http://nur.nix-community.org/repos/nagy/
      - recursion, also nested attributes are listed
         - `nur.repos.nagy.python3Packages.asyncer`
         - `nur.repos.nagy.lispPackages.cl-opengl`



## fork NUR



### 1. fork these repos

- https://github.com/nix-community/NUR
- https://github.com/nix-community/nur-combined
- https://github.com/nix-community/nur-search



### 1a. also clone the "gh-pages" branch of the nur-search repo

```
cd nur-search
git fetch https://github.com/nix-community/nur-search gh-pages:gh-pages-src --depth=1
git checkout --orphan gh-pages gh-pages-src
git commit -m "init orphan branch"
git push $your_name gh-pages -u
```



### 2. enable github actions in the NUR repo



### 3. enable scheduled github actions in the NUR repo



### 4. wait for the next CI run



### 5. visit nur-search on github pages

https://your_name.github.io/nur-search/



## git push error: RPC failed; HTTP 408 curl 18 HTTP/2 stream 7 was reset

```
$ git push milahu gh-pages
Enumerating objects: 828, done.
Counting objects: 100% (828/828), done.
Delta compression using up to 4 threads
Compressing objects: 100% (266/266), done.
Writing objects: 100% (828/828), 4.80 MiB | 2.38 MiB/s, done.
Total 828 (delta 301), reused 793 (delta 286), pack-reused 0
error: RPC failed; HTTP 408 curl 18 HTTP/2 stream 7 was reset
send-pack: unexpected disconnect while reading sideband packet
fatal: the remote end hung up unexpectedly
Everything up-to-date
```

fix:

```
git config http.postBuffer 524288000
```

https://stackoverflow.com/questions/22369200/git-pull-push-error-rpc-failed-result-22-http-code-408



## push branches

```sh
for branch in master gh-pages nur-combined nur-eval-errors nur-repos nur-repos-lock nur-search nur-search-data nur-update nur-packages-template  parallel-fetch python37 quiet-builds; do
  git push --force milahu $branch
done
```



## remove empty commits

these were used to trigger github workflow runs

```
# remove empty commits in all branches
git filter-repo --prune-empty always
```



### manually run a github workflow

solved: nur-update/nur_update/__init__.py

https://github.com/nix-community/nur-update

nur-update was hosted on herokuapp.com, but heroku stopped their free plans

currently, nur-update is hosted on nix-community.org

alternatives to heroku:

- https://www.makeuseof.com/heroku-alternatives-free-full-stack-hosting/
   - https://render.com/ is a unified cloud to build and run all your apps and websites. It has free TLS certificates, a global CDN, DDoS protection, private networks, and auto deploys from Git. Render’s free plan for services supports web services with HTTP/2 and full TLS. Render supports custom docker containers and background workers. You can use it to host web apps in Node.js, the server-side JavaScript environment. It also has support for other languages, including Python, Golang, Rust, Ruby, and Elixir. Using Render’s free plans, you can spin up web services and databases at zero cost. However, these plans have certain usage limits and are designed to help build personal projects and explore new tech.
   - https://www.cyclic.sh/ is a good alternative to Heroku due to its modern cloud architecture with serverless hosting, an easy onboarding experience, and an existing free tier. Cyclic is ideal for hosting full-stack MERN apps. Its free tier features up to 100,000 API requests with fast builds and 1GB runtime memory. Using Cyclic’s free tier gives you an edge over competitors when it comes to inactivity delay. Platforms like Heroku and Render take approximately 30 seconds to restart a service after a period of inactivity. In contrast, this service takes approximately 200ms according to Cyclic’s benchmarks.
   - https://railway.app/ also offers a free tier like Heroku, which features 512 MB RAM, a shared CPU/container, and 1GB of disk space. It also offers unlimited inbound network bandwidth, multiple custom domains with SSL, and $5 or 500 hours of usage.
   - https://deta.space/ is a personal cloud platform for hosting web applications. Deta Space offers fully managed servers, data, and security to each app deployed on the platform, similar to other cloud service providers. Deta Space currently does not have a paid tier. Their platform is free by default and currently has no limits to their wide range of use cases.
   - https://fly.io/ is a platform that allows you to host and run small applications for free. Unlike other alternatives to Heroku, Fly.io doesn't have a "free tier". However, they offer free resource allowances.
- https://codeless.co/heroku-alternatives/

... but its simpler to avoid such a public nur-update service.
users should be happy, when the update workflow runs every 60 minutes

alternative to nur-update:
eval-test.sh for local development of user repos.
FIXME eval-test.sh still gives different results than the update workflow

alternative to nur-update:
add another workflow with higher frequency (example: every 20 minutes),
which checks some condition, and then runs the update workflow

alternative to nur-update:
make the update workflow more efficient,
so we can run it more often, for example every 20 minutes

<blockquote>

## Example

```
$ curl -XPOST https://nur-update.herokuapp.com/update?repo=mic92
```

</blockquote>

deprecated: scripts/run-update-workflow-manually.sh

https://github.com/nix-community/NUR#update-nurs-lock-file-after-updating-your-repository

<blockquote>

### Update NUR's lock file after updating your repository

By default we only check for repository updates once a day with an automatic
github action to update our lock file `repos.json.lock`.
To update NUR faster, you can use our service at https://nur-update.nix-community.org/
after you have pushed an update to your repository, e.g.:

```console
curl -XPOST https://nur-update.nix-community.org/update?repo=mic92
```

Check out the [github page](https://github.com/nix-community/nur-update#nur-update-endpoint) for further details

</blockquote>



#### website

- https://github.com/milahu/NUR/actions/workflows/update.yml
- run workflow
- run workflow



#### api

https://stackoverflow.com/questions/60419257/is-it-possible-to-manually-run-a-github-workflow

https://docs.github.com/en/free-pro-team@latest/rest/actions/workflows?apiVersion=2022-11-28#create-a-workflow-dispatch-event

```
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer <YOUR-TOKEN>" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/actions/workflows/WORKFLOW_ID/dispatches \
  -d '{"ref":"topic-branch","inputs":{"name":"Mona the Octocat","home":"San Francisco, CA"}}'
```

> workflow_id (Required): The ID of the workflow. You can also pass the workflow file name as a string.

for rate-limiting, we also need a list of the latest workflow runs:

https://docs.github.com/en/free-pro-team@latest/rest/actions/workflow-runs?apiVersion=2022-11-28#list-workflow-runs-for-a-workflow

```
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer <YOUR-TOKEN>" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/actions/workflows/WORKFLOW_ID/runs
```



### avoid nix commands

because nix commands are slow, generally.

ci/update-nur.sh runs for 7 seconds, nix-shell takes 27 seconds to install dependencies

install python deps with actions/setup-python@v5 and "pip install"

use nix-prefetch-git from scripts/nix-prefetch-git.sh from nixpkgs/pkgs/build-support/fetchgit/nix-prefetch-git

remove nix-shell shebang from ci/update-nur.sh

```
#!/usr/bin/env nix-shell
#!nix-shell --quiet -p git -p nix -p bash -p hugo -p python3 -p python3.pkgs.requests -i bash
```



#### avoid 'nix build'

we will run python code directly, so no need to create a nix package

```diff
-nix build --quiet "$NUR_REPO_PATH/ci#"
```



#### avoid 'nix run'



#### install dependencies in the nix shell of ci/update-nur.sh

```diff
 #!/usr/bin/env nix-shell
-#!nix-shell --quiet -p git -p nix -p bash -p hugo -i bash
+#!nix-shell --quiet -p git -p nix -p bash -p hugo -p python3 -p python3.pkgs.requests -i bash
```



#### fix python code

maybe the old python code would work with `python3 -m ci.nur.__init__:main` but meh, lets fix it

```diff
--- a/ci/nur/__init__.py
+++ b/ci/nur/__init__.py
@@ -56,3 +56,7 @@ def main() -> None:
     logging.basicConfig(level=LOG_LEVELS[args.log_level])
 
     args.func(args)
+
+
+if __name__ == "__main__":
+    main()
```



#### run python code directly in ci/update-nur.sh

```diff
-nix run --quiet "$NUR_REPO_PATH/ci#" -- update
+python3 -m ci.nur.__init__ update
```

```diff
-nix run --quiet "$NUR_REPO_PATH/ci#" -- combine nur-combined
+python3 -m ci.nur.__init__ combine nur-combined
```

```diff
-nix run --quiet "$NUR_REPO_PATH/ci#" -- index nur-combined > nur-search/data/packages.json
+python3 -m ci.nur.__init__ index nur-combined > nur-search/data/packages.json
```



### fix the PR workflow

currently, the PR workflow fails if a repo gives eval errors

but the PR workflow should not care about these eval errors

example: https://github.com/nix-community/NUR/pull/592
there, the eval fails because of timeout



### use same filesystem layout as nixpkgs

move packages from default.nix to pkgs/top-level/all-packages.nix

this should be the default filesystem layout in https://github.com/nix-community/nur-packages-template
to make nur-packages compatible with nixpkgs

examples in https://github.com/nix-community/nur-combined

```
$ find . -name all-packages.nix
./repos/xeals/pkgs/top-level/all-packages.nix
./repos/bb010g/pkgs/top-level/all-packages.nix
./repos/nexromancers/pkgs/top-level/all-packages.nix
```



### on eval error, keep previous version

this seems to be implemented, but only partially

in [my nur-packages](https://github.com/milahu/nur-packages)
repo, i had some eval error
which caused my repo to be unlisted from the
[nur website](http://nur.nix-community.org/)

im afraid i did overwrite the error-causing version
with a git force-push, so cannot reproduce for now



### generate a better website

current website: http://nur.nix-community.org/

currently, the search function sucks

either use a proper javascript search engine

or render a simple html page with all repos and all packages
so i can search that page with Control-F



### disable push protection

some repos contain secerts (GitHub Personal Access Token)

by default, github blocks "git push" with secrets

```
error: GH013: Repository rule violations found for refs/heads/nur-combined.
```

but i dont care, not my problem

https://github.com/settings/security_analysis -> Push protection for yourself -> disable

https://docs.github.com/en/code-security/secret-scanning/pushing-a-branch-blocked-by-push-protection

https://docs.github.com/en/code-security/secret-scanning/about-secret-scanning

https://docs.github.com/en/code-security/secret-scanning/push-protection-for-users



### remove deleted repos

these repos are either deleted or private

anyway, they dont belong in NUR

```
0d9c25226 remove thilobillerbeck
e5c5dbbe3 remove smolsnail
a370969f5 remove procyon
c66e97c72 remove pamplemousse
485730456 remove nodeselector
654ea0916 remove joshuafern
41b161558 remove infinitivewitch
6cb04d737 remove imsofi
d5b745457 remove andersontorres
```



## limit eval result sizes

the dguibert/nur-packages repo had this in /default.nix

```nix
{
 pkgs ? import <nixpkgs> { }
}:
# problem: all packages from nixpkgs are copied
# fix: remove "pkgs //"
pkgs // {
 some-package = callPackage ./pkgs/some-package { };
}
```

... which either resulted in an eval timeout  
or created an eval result json of 110 MB  
(github files: hard limit 100 MB)

so in update.py i added

```
max_eval_result_size = 5 * 1024 * 1024 # 5MiB
```

currently the largest eval_result (repo rycee) has 1MB

```
$ du -sh nur-eval-results/* | sort -h | tail -n10
96K     nur-eval-results/colinsane.json
100K    nur-eval-results/arc.json
104K    nur-eval-results/foolnotion.json
120K    nur-eval-results/drewrisinger.json
296K    nur-eval-results/milahu.json
420K    nur-eval-results/xddxdd.json
436K    nur-eval-results/sigprof.json
596K    nur-eval-results/izorkin.json
608K    nur-eval-results/sikmir.json
916K    nur-eval-results/rycee.json
```



## add first class support for nix flakes

currently some nur repos are based on nix flakes  
but currently, nur update treats all repos as based on default.nix

this leads to eval errors in nur-update

```
$ grep "error: access to URI" nur-eval-errors/*
nur-eval-errors/bandithedoge.txt:error: access to URI 'https://github.com/lastquestion/explain-pause-mode/archive/2356c8c3639cbeeb9751744dbe737267849b4b51.tar.gz' is forbidden in restricted mode
nur-eval-errors/darkkirb.txt:error: access to URI 'https://github.com/edolstra/flake-compat/archive/4f910c9827911b1ec2bf26b5a062cd09f8d89f85.tar.gz' is forbidden in restricted mode
nur-eval-errors/geonix.txt:error: access to URI 'https://github.com/edolstra/flake-compat/archive/0f9255e01c2351cc7d116c072cb317785dd33b33.tar.gz' is forbidden in restricted mode
nur-eval-errors/kreisys.txt:error: access to URI 'https://github.com/NixOS/nixpkgs-channels/archive/b47873026c7e356a340d0e1de7789d4e8428ac66.tar.gz' is forbidden in restricted mode
nur-eval-errors/pschuprikov.txt:error: access to URI 'https://github.com/fzakaria/mvn2nix/archive/master.tar.gz' is forbidden in restricted mode
nur-eval-errors/shamilton.txt:error: access to URI 'https://github.com/NixOS/NixPkgs/archive/cd0fa6156f486c583988d334202946ffa4b9ebe8.tar.gz' is forbidden in restricted mode
nur-eval-errors/some-pkgs.txt:error: access to URI 'https://api.github.com/repos/NixOS/nixpkgs/tarball/2c92367fc6afb7df4700782bccae881d81e02de9' is forbidden in restricted mode
nur-eval-errors/vroad.txt:error: access to URI 'https://github.com/edolstra/flake-compat/archive/35bb57c0c8d8b62bbfd284272c928ceb64ddbde9.tar.gz' is forbidden in restricted mode
nur-eval-errors/yellowonion.txt:error: access to URI 'https://github.com/edolstra/flake-compat/archive/35bb57c0c8d8b62bbfd284272c928ceb64ddbde9.tar.gz' is forbidden in restricted mode
```

upstream issues

- https://github.com/nix-community/NUR/issues/571
- https://github.com/nix-community/NUR/issues/174
- https://github.com/nix-community/NUR/issues/331

personally, i dont use flakes  
because pinning everything is a waste of disk space



## normalize nix store paths

the actual nix store paths change with every update  
which creates lots of diff noise in nur-eval-results and nur-eval-errors

fix:

- normalize the repo path to `.`
  - example: replace `/nix/store/xxx-nur-packages/default.nix` with `./default.nix`
- normalize the nixpkgs path to `<nixpkgs>`
  - example: replace `/nix/store/xxx-source/default.nix` with `<nixpkgs>/default.nix`

nur-eval-errors also contains source positions (line and column number) like `default.nix:12:34`
which still create diff noise, but less noise than from nix store paths



## update nur-packages-template

- add by-name path format
- add python3Packages scope
- add nodePackages scope



</details>
