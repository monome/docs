---
layout: default
nav_exclude: true
permalink: /aleph/forking/
---

# Aleph: Forking

This is an example of how to fork the Aleph repo, change something, and submit a request for your changes to be pulled upstream to monome/aleph. Some naming and workflow conventions are to taste, and `user` is your own github username.

Create a fork of monome/aleph on github by clicking the “fork” button on the upper right of the repo page. There should now be a new repo on your github page called user/aleph.

Now, the terminal commands go something like this:

### 1: Clone a local copy of your new repo and go into it

~~~
git clone https://github.com/user/aleph.git aleph_user
cd aleph_user
~~~

### 2: Create a local dev branch tracking your remote dev branch

~~~
git checkout -b dev origin/dev
~~~

### 3: Add another remote pointed at the upstream repo

~~~
git remote add upstream https://github.com/monome/aleph.git
~~~

### 4: Fetch and merge any upstream changes

~~~
git fetch upstream dev
git merge upstream/dev
~~~

### 5: Do some work…

It's optional, but prudent, to make a new local branch for your work in progress:

~~~
git checkout -b newstuff
echo what > newthing.txt
git add newthing.txt
~~~

### 6: Commit your work locally and merge it back to into dev

~~~
git commit -m “added newthing”
git checkout dev
git merge newstuff
~~~

### 7: Push changes to your forked repo

~~~
git push origin dev
~~~

Here it's a good idea to check again for upstream changes by performing `step 4` again, and preemptively fix any merge conflicts.

## Now submit a pull request

- visit the page for your fork
- select your dev branch from the dropdown menu
- click the big green button that says “compare and pull request”
- enter your comments and verify that the basis for comparison is monome:dev … user:dev (it should be)

Click `send` and you are done!
