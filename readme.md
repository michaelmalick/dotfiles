# dotfiles


Install dotfiles as symlinks:
```
git clone https://github.com/michaelmalick/dotfiles ~/.dotfiles
~/.dotfiles/make.sh
```

Cleanup after install:
```
~/.dotfiles/clean.sh
```

The `make.sh` script will prompt for a git email address.
To avoid the prompt, set the `GIT_EMAIL` variable:
```
GIT_EMAIL=me@email.com ~/.dotfiles/make.sh
```
