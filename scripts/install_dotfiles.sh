#!/bin/bash
set -e

./sanity_checks.sh

DOTFILE_BACKUP=~/.dotfiles-backup
if [ -d ${DOTFILE_BACKUP} ]; then
  echo "You already have a dotfiles backup at ${DOTFILE_BACKUP}"
  echo "Refusing to continue."
  exit 1
fi

echo "Backing up your dotfiles to ${DOTFILE_BACKUP}..."
mkdir ~/.dotfiles-backup
pushd ../dotfiles
for f in $(find -type f | sed 's/^..//'); do
  # Check if it's inside a dir or not
  dirpath=${f%/*}
  if [ "$dirpath" == "$f" ]; then
    dirpath=""
  fi

  dotfilename=".${f}"
  orig="$HOME/.${f}"
  echo $orig
  if [ -f "$orig" ]; then
    echo "backing up .${f}..."
    mkdir -p ${DOTFILE_BACKUP}/${dirpath}
    cp -r ${orig} ${DOTFILE_BACKUP}/$f
  fi
  # copy in new
  echo "copying in ${f}..."
  cp -r ${f} $orig
done
popd

echo "Done! You probably want to set up Janus and compile relevant completers. Use ./setup_janus.sh to do that."