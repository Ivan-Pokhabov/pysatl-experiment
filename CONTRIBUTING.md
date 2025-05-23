# Contributing

## Contribute to pysatl-experiment

Feel like our lib is missing a feature? We welcome your pull requests! 

Few pointers for contributions:

- Create your PR against the `main` branch, not `release`.
- New features need to contain unit tests, must conform to PEP8 (max-line-length = 100) and should be documented with the introduction PR.
- PR's can be declared as `[WIP]` - which signify Work in Progress Pull Requests (which are not finished).

## Before sending the PR

### 1. Run unit tests

All unit tests must pass. If a unit test is broken, change your code to 
make it pass. It means you have introduced a regression.

#### Test the whole project

```bash
pytest
```

#### Test only one file

```bash
pytest tests/test_<file_name>.py
```

#### Test only one method from one file

```bash
pytest tests/test_<file_name>.py::test_<method_name>
```

### 2. Test if your code is PEP8 compliant

#### Run Ruff

```bash
ruff check .
```

We receive a lot of code that fails the `ruff` checks.
To help with that, we encourage you to install the git pre-commit 
hook that will warn you when you try to commit code that fails these checks.

you can manually run pre-commit with `pre-commit run -a`.

##### Additional styles applied

* Have docstrings on all public methods
* Use double-quotes for docstrings
* Multiline docstrings should be indented to the level of the first quote
* Doc-strings should follow the reST format (`:param xxx: ...`, `:return: ...`, `:raises KeyError: ... `)

### 3. Test if all type-hints are correct

#### Run mypy

``` bash
mypy statistic-test
```

### 4. Ensure formatting is correct

#### Run ruff

``` bash
ruff format .
```

## (Core)-Committer Guide

### Process: Pull Requests

How to prioritize pull requests, from most to least important:

1. Fixes for broken tests. Broken means broken on any supported platform or Python version.
2. Extra tests to cover corner cases.
3. Minor edits to docs.
4. Bug fixes.
5. Major edits to docs.
6. Features.

Ensure that each pull request meets all requirements in the Contributing document.

### Process: Issues

If an issue is a bug that needs an urgent fix, mark it for the next patch release.
Then either fix it or mark as please-help.

For other issues: encourage friendly discussion, moderate debate, offer your thoughts.

### Process: Your own code changes

All code changes, regardless of who does them, need to be reviewed and merged by someone else.
This rule applies to all the core committers.

Exceptions:

- Minor corrections and fixes to pull requests submitted by others.
- While making a formal release, the release manager can make necessary, appropriate changes.
- Small documentation changes that reinforce existing subject matter. Most commonly being, but not limited to spelling and grammar corrections.

### Responsibilities

- Ensure cross-platform compatibility for every change that's accepted. Windows, Mac & Linux.
- Ensure no malicious code is introduced into the core code.
- Create issues for any major changes and enhancements that you wish to make. Discuss things transparently and get community feedback.
- Keep feature versions as small as possible, preferably one new feature per version.
- Be welcoming to newcomers and encourage diverse new contributors from all backgrounds. See the Python Community Code of Conduct (https://www.python.org/psf/codeofconduct/).

### Becoming a Committer

Contributors may be given commit privileges. Preference will be given to those with:

1. Past contributions to pysatl-experiment and other related open-source projects. Contributions to pysatl-experiment include both code (both accepted and pending) and friendly participation in the issue tracker and Pull request reviews. Both quantity and quality are considered.
2. Coding style that the other core committers find simple, minimal, and clean.
3. Access to resources for cross-platform development and testing.
4. Time to devote to the project regularly.

Being a Committer does not grant write permission on `main` or `release` for security reasons.

After being Committer for some time, a Committer may be named Core Committer and given full repository access.
