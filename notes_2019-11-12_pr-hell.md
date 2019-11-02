
## Questions/Answers from last meetup

  - What’s nicer about PR from forks than branches from source repo?
      - pr vs branches: pr are branches, with additional, desirable
        features.
      - from fork betther than from source repo:
          - leads to better branch hygiene because the pr branch lives
            in the contributor’s fork, so it does not contamine the
            source repo.
  - contributors can work with no privileges over the repo

## Challenging scenarios

TODAY

  - Problem: While the contributor works on a PR, the maintainer adds a
    conflicting commit to the source repo.

  - Solution: The contributor must synchronize the PR with
    upstream/master and fix conflicts.

## Challenging scenarios

NEXT TIME

  - Problem: After the contributor submitted a first pull request
    (`pr1`), and before the maintainer merges it into the source
    repository, the contributor starts a second pull request (`pr2`)
    that depends on the first one.

  - Solution: Avoid interdependent pull requests. If you can’t, start
    `pr2` off the tip of `pr1` and assume `pr1` will be merged “as is”
    but don’t expect it – be (emotionally) prepared to fix merge
    conflicts before `pr2` can be merged.

# Sync `[pr]` with `[upstream/master]`

## 1\. Maintainer

Create new repo Clone locally Add README Commit and push to source repo

    * 7ad3e62 (HEAD -> master, origin/master) M Add README.md

## 2\. Contrubutor

  - Fork source repo
  - Clone locally
  - Checkout new branch
  - Edit README
  - Commit and push to fork repo

<!-- end list -->

    * 9fd9ae5 (HEAD -> pr, origin/pr) C Edit README.md
    * 7ad3e62 (origin/master, origin/HEAD, master) M Add README.md

## 2\. Contrubutor

  - Create PR

<img src="https://i.imgur.com/lmGJD6F.png" width=760>

## 3\. Maintainer

  - Edit README
  - Commit and push

<!-- end list -->

    * 7d8b91b (HEAD -> master, origin/master) M Edit README.md
    * 7ad3e62 M Add README.md

## 4\. Maintainer and Contributor

Notice conflict

<img src="https://i.imgur.com/BTxqGlC.png" width=760>

## 5\. Contrubutor

  - Add connection to source repo, then view all connections

<!-- end list -->

    Contributor@Laptop  ~/abc (pr)
    $ git remote add upstream git@github.com:an-org/abc.git
    
    Contributor@Laptop  ~/abc (pr)
    $ git remote -v
    origin  git@github.com:maurolepore/abc.git (fetch)
    origin  git@github.com:maurolepore/abc.git (push)
    upstream        git@github.com:an-org/abc.git (fetch)
    upstream        git@github.com:an-org/abc.git (push)

## 5\. Contrubutor

  - Bring metadata from source repo

<!-- end list -->

    Contributor@Laptop  ~/abc (pr)
    $ git fetch upstream
    remote: Enumerating objects: 5, done.
    remote: Counting objects: 100% (5/5), done.
    remote: Compressing objects: 100% (2/2), done.
    remote: Total 3 (delta 0), reused 3 (delta 0), pack-reused 0
    Unpacking objects: 100% (3/3), done.
    From github.com:an-org/abc
    * [new branch]      master     -> upstream/master

## 5\. Contributor

  - The history of the local repo remains the same

<!-- end list -->

    * 9fd9ae5 (HEAD -> pr, origin/pr) C Edit README.md
    * 7ad3e62 (origin/master, origin/HEAD, master) M Add README.md

## 5\. Contrubutor

  - Sync the local history (contributor) with updated history of source
    repo:

<!-- end list -->

    Contributor@Laptop  ~/abc (pr)
    $ git merge upstream/master
    Auto-merging README.md
    CONFLICT (content): Merge conflict in README.md
    Recorded preimage for 'README.md'
    Automatic merge failed; fix conflicts and then commit the result.

## 5\. Contrubutor

  - Fix merge conflicts, then push with `git push`

<img src="https://i.imgur.com/kNwo4of.png" width=760>

## 5\. Contrubutor

  - The history of the local repo has now changed to reflect the merge

<!-- end list -->

    *   56b721c (HEAD -> pr, origin/pr) C Fix merge conflicts (combining edits by C/M)
    |\
    | * 7d8b91b (upstream/master) M Edit README.md
    * | 9fd9ae5 C Edit README.md
    |/
      * 7ad3e62 (origin/master, origin/HEAD, master) M Add README.md

## 6\. Contributor and maintainer

  - Notice that the PR is now again ready to merge

<img src="https://i.imgur.com/kY4TC4W.png" width=760>

## 6\. Contributor and maintainer

  - After merging, the source repo stays clean (no `[pr]` branch)

<div class="columns-2">

<img src="https://i.imgur.com/jVbBgOk.png" height=400>

<img src="https://i.imgur.com/NwQSOzU.png" height=400>

</div>

## 7\. Maintainer

    Maintainer@Laptop  ~/abc (master)
    $ git pull
    remote: Enumerating objects: 5, done.
    remote: Counting objects: 100% (5/5), done.
    remote: Compressing objects: 100% (2/2), done.
    Unpacking objects: 100% (3/3), done.
    remote: Total 3 (delta 0), reused 2 (delta 0), pack-reused 0
    From github.com:an-org/abc
       7d8b91b..bb2b83e  master     -> origin/master
    Updating 7d8b91b..bb2b83e
    Fast-forward
     README.md | 3 ++-
     1 file changed, 2 insertions(+), 1 deletion(-)

## 7\. Maintainer

  - The commit history now has an additional commit

<!-- end list -->

    * bb2b83e (HEAD -> master, origin/master) C Edit README.md (#1)
    * 7d8b91b M Edit README.md
    * 7ad3e62 M Add README.md
