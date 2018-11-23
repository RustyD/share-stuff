# This README is WIP

# Multi-repository Git Scripts

These scripts are design to make it easier/quicker to work with multiple git repositores.
You can add this folder to your path and execute them from anywhere. But unless you modify the scripts yourself, all your repositories will be acted upon at a fixed relative location.

## Default folder layout

These scripts expect the '_repos parent dir_' folder to be the parent folder of where they themselves are cloned, e.g.

```
C:\dev
   |- work
      |- git-scripts             <= clone this 'scripts' repo here
      |- project-repo-1          <= other work/project repos
      |- project-repo-2
      |- project-repo-3
      |- project-repo-4
```
So in the above, `work` would be the '_repos parent dir_' folder, and the `git-scripts` repository is a direct sibling of all your other repositories.

## repos.txt

This file contains a list of all the git repositories you are interested in. Blank lines are skipped, as are lines that are commented out (using `#`).
You can also append a comment to the end of a line, if required. The format of each line is:

```
<repo-name>,<origin-index>,<merge-branch>
```

Where:
* _repo-name_ The name of your repository, e.g.) `project-repo-1`. This is used in all the scripts.
* _origin-index_ The line in the `origins.txt` file to use as the _base-url_ for cloning the repository. Used only in the _clone_ script.
* _merge-branch_ The 'main' branch that you normally branch from, e.g. `develop`. Used only in the _merge_ script. If not specified, `master` is assumed.

You can also create your own alternate copies of the `repos.txt` for maybe subsets or alternate sets of repositories. In order for the scripts to
use your custom file, it must be in the same folder as your scripts and then simply provide that file name on the command line, e.g.)

```
$ ./cloneRepos.sh alt-repos.txt
$ ./statusRepos.sh fav-repos.txt
```

## origins.txt

This file contains a list of _base-urls_ that are used in the _clone_ script to determine where to clone your repository from. The _base-url_ to use for each
repository is determined by the value set for _origin-index_ on each line in the `repos.txt` file. The default is `zero` and so the first entry in `origins.txt` gets used.
The processing of this file does __not__ allow for comments or account for blank lines, unlike the `repos.txt` file - so treat it with care! The _clone_ operation basically
gets performed on a url constructed thus:

```
<base-url><repo-name>.git
```

## git merge defaults

For the `mergeRepos.sh` script to work, you may need to set:

`git config --global merge.defaultToUpstream true`

The merge that is performed is a `ff-only` (fast forward only) merge that only executes when there are __no__ outstanding changes, merge conflicts, etc.

## Usage

In order to keep your local repositories up to date, you may want to (daily?):

```
 $ ./fetchRepos.sh
 $ ./mergeRepos.sh
```

If you are actually developing in several repositories at once, a

```
 $ ./statusRepos.sh
```

Will show you where you have outstanding changes that you haven't yet commited.
