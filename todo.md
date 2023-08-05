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
for branch in master gh-pages nur-combined nur-eval-errors nur-repos nur-repos-lock nur-search parallel-fetch python37 quiet-builds; do
  git push --force milahu $branch
done
```

## remove empty commits

these were used to trigger CI runs

TODO use a better way to trigger CI runs

```
# remove empty commits in all branches
git filter-repo --prune-empty always
```
