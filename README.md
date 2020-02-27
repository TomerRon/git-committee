# git-committee

:octocat: git-committee is a little script that lets you make bulk backdated git commits.

## Usecases

### Leaving an organization

Many developers use their work email when making commits to their work repositories. However, when they leave their organization (and unlink their work email), they lose their entire commit history!

I was facing the same issue when I was leaving one of my previous companies and realized I was about to lose more than 2,000 commits from the last 2 years. I didn't want my contribution graph to become mostly empty, so I created this script!

Run this script before you leave your organization on Github, and then push the generated repo after you leave the organization.

### Copying another account's commit history

You can use the script to copy the contribution history of another account (whether your own, or someone else's).

## Usage

- Clone this repo and make the script executable

```
$ git clone https://github.com/TomerRon/git-committee
$ cd git-committee
$ chmod +x committee.sh
```

- Run the script (refer to examples)

```
$ ./committee.sh -u torvalds -s 2020-02-01 -e 2020-02-29
```

- Sanity checks - make sure everything is in order before we push it

```
$ cd repos/<the generated folder>
$ git log
$ git config -l
```

- [Create a new (private) repository](https://github.com/new) on Github

- Add the origin

```
$ git remote add origin <my remote>.git
```

- Push it!

```
$ git push -u origin master
```

## Options and examples

You can also read this by running `./committee.sh --help`

```
git-committee usage:
---

-u | --username   Choose GitHub username to use as input
-f | --file       Choose JSON file to use as input

-s | --start      Set the start date
-e | --end        Set the end date

-h | --help       Show this help screen

---

Examples:

Use a GitHub user as the input, with start date and end date:
./committee.sh -u torvalds -s 2020-02-01 -e 2020-02-29

Use a JSON file as the input:
./committee.sh -f ~/Downloads/data.json

---
```
