# todo

## done

- cache eval errors
- cache eval timeout errors
- use graphql to batch-update versions of github repos: 10 instead of 200 seconds
- make NUR more forking-friendly: in CI, use dynamic repo urls
- make CI logs much less verbose: use `nix --quiet` to hide output of git

## todo

### make update more efficient

https://github.com/nix-community/NUR/issues/351

running bin/nur update is too expensive

### merge tasks update/eval/index to use maximum caching

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

## how to fork NUR

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

## avoid nix commands

because nix commands are slow, generally.

### avoid 'nix build'

we will run python code directly, so no need to create a nix package

```diff
-nix build --quiet "$NUR_REPO_PATH/ci#"
```

### avoid 'nix run'

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

## fix the PR workflow

currently, the PR workflow fails if a repo gives eval errors

but the PR workflow should not care about these eval errors

example: https://github.com/nix-community/NUR/pull/592
there, the eval fails because of timeout

## use same filesystem layout as nixpkgs

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

### generate a better website

current website: http://nur.nix-community.org/

currently, the search function sucks

either use a proper javascript search engine

or render a simple html page with all repos and all packages
so i can search that page with Control-F
