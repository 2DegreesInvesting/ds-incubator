[Googledoc](https://docs.google.com/document/d/1FWiGmwTsr3YuZeQ7NLtTQ42WIm9D5RLxuFuPK4M6FzQ/edit?usp=sharing)

# 2019-10-15, setup GitHub, R, RStudio, Git



### Pre-meetup setup

* Move .gitconfig and .ssh out of ~/

* Comment out relevant code in .Rprofile

* Remove git credentials:

_Control Panel > user accounts > credential manager > Windows credentials > Generic credentials_



### Introduction

* Welcome to [ds-incubator](https://github.com/2DegreesInvesting/ds-incubator): Why, who, what, when, how

* Troubleshoot, ask, discuss: [Open a new issue](https://github.com/2DegreesInvesting/ds-incubator/issues/new)

* I'll focus on Windows



### Register a free GitHub account

* Your GitHub username, and definiterly your profile, should have your name.

* Your ssername should be timeless, so you accumulate credit (exclude your employer; add your work email to your personal account).



### Install or update R and RStudio AND Install Git

> If it hurts so it more often

How to think about upgrading software?:

* [happy git with r](https://happygitwithr.com/install-r-rstudio.html#install-r-rstudio).

* [rscommunity](https://community.rstudio.com/t/should-i-update-all-my-r-packages-frequently-yes-no-why/5856/4?u=mauro_lepore).

* The [installr package](https://cran.r-project.org/web/packages/installr/index.html).


![](https://i.imgur.com/X30oCE1.png)

> If you have this kind of exponential relationship, then if you do it more frequently, you can drastically reduce the pain.
> -- Martin Fowler in [FrequencyReducesDifficulty](https://martinfowler.com/bliki/FrequencyReducesDifficulty.html)



### Introduce yourself to Git (TODO)

```
# My ~/.gitconfig at the start
git config --global --list

#Email associated with GitHub
git config --global user.email "maurolepore@gmail.com"
git config --global user.name "Mauro Lepore"

# Other very useful configurations
git config --global push.default "current"
git config --global core.editor "notepad"
git config --global credential.helper "manager"

# My ~/.gitconfig at the end
git config --global --list
```



### Prove local Git can talk to GitHub (SKIP)

Login to http://github.com/

On GitHub: 

* Create a repo
* Add description.
* Add README.md
* Copy https clone link

On Git Bash:

```
# Clone new repo and move to it
git clone <URL>
cd <new repo>

# Edit README
## Before
cat README.md
echo "A line from local computer" >> README.md
## After
cat README.md

# Commit and push
git add .
git commit -m "Edit README from local computer"
git push
```

* Check if credentials are managed correctly: Repeat edit, commit and push (you should no longer be challenged for a username and password).



### Cache your username and password or set up SSH keys (DONE)

We should be done:

* We already added 

```
git config —global credential.helper manager 
```

If we need to remove credentials, here they are:
    Control Panel > user accounts > credential manager > Windows credentials > Generic credentials

SSH: Skip.



### Prove RStudio can find local Git (TODO)

Login to http://github.com/

On GitHub: 

* Create a repo
* Add description.
* Add README.md
* Copy https clone link
 
On RStudio:

File > New Project ... > Version Control > Git

Edit README, commit and push.

Do it twice to confirm that the credential manager works as expected.



### Contemplate if you’d like to install an optional Git client

I recommend GitKraken: https://www.gitkraken.com/download


















# 2019-10-15, setup GitHub, R, RStudio, Git

Demo from Introduce yourself to git until the end. Focus on windows because most people use it and they are the most likely to struggle.

### GitHub

* Best if your usenamame has your name.

* Ensure your profile in 2DegreesInvesting has actual name.

![](https://i.imgur.com/thyv7ax.png)

This makes it easy for people to search your name and find your username. People need your username to `@mention` you (e.g. in GitHub issues, pull requests, commits, and to thank you in NEWS.md).

![](https://i.imgur.com/BMcaky9.png)

### R, RStudio, Git

Upgrading software:

* How to think about upgrading R, RStudio, and R packages:
    * [happy git with r](https://happygitwithr.com/install-r-rstudio.html#install-r-rstudio).
    * [rscommunity](https://community.rstudio.com/t/should-i-update-all-my-r-packages-frequently-yes-no-why/5856/4?u=mauro_lepore).
    * The [installr package](https://cran.r-project.org/web/packages/installr/index.html).

* Recommended versions:

    * R >= 3.6
    * RStudio >= 1.2.5
    * Git >= 1.7.10

### Git

* Terminal: RStudio terminal or git bash
* Git clients: None or GitKraken
* Editor: nano or notepad
* Credential manager: 
    * HTTPS should just work or `git config --global credential.helper manager`
    * SSH
* Aliases
* Useful git config

```
[user]
	name = Mauro Lepore
	email = maurolepore@gmail.com
[push]
	default = current
[core]
	editor = nano
[credential]
	helper = manager
```

### RStudio

* preview (try the tarball installer)


