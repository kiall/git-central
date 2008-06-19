#!/bin/bash

export LD_LIBRARY_PATH=/home/BIPFS/shaberman/local/lib
TRAC_ENV=/srv/trac/cbas

while read oldrev newrev refname ; do
    if expr "$oldrev" : '0*$' >/dev/null
    then
        # git-rev-list "$newrev"
        git rev-parse --not --branches | grep -v $(git rev-parse $refname) | git rev-list --stdin $newrev
    else
        # git-rev-list "$newrev" "^$oldrev"
		git rev-parse --not --branches | grep -v $(git rev-parse $refname) | git rev-list --stdin $oldrev..$newrev
    fi | while read com ; do
        /home/BIPFS/shaberman/local/bin/python /srv/git/hooks/trac-post-commit-hook.py -p "$TRAC_ENV" -r "$com" 
    done
done

exit 0