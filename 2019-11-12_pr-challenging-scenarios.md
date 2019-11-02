## Challenging scenario 1

* Problem: While the contributor works  on a PR, the maintainer adds a
conflicting commit to the source repo.

* Solution: The contributor must synchronize the PR with upstream/master and
fix conflicts.

## Challenging scenario 2

* Problem: After the contributor submitted a first pull request (`pr1`), and
before the maintainer merges it into the source repository, the contributor
starts a second pull request (`pr2`) that depends on the first one.

* Solution: Avoid interdependent pull requests. If you can't, start `pr2` off
  the tip of `pr1` and assume `pr1` will be merged "as is" but don't expect it
  -- be (emotionally) prepared to fix merge conflicts before `pr2` can be
  merged.

