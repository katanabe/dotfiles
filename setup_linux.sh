echo "install dotfiles..."

# defines
DOT_FILES="${HOME}/dotfiles"
DEPS_DIR="${DOT_FILES}/deps"

echo "[1/5] rm .vim* .zsh* files"
for f in "${HOME}"/.vim* "${HOME}"/.gvim* "${HOME}"/.zsh* "${HOME}"/.zl* "${HOME}"/.zpr*
do
  echo "rm: -rf $f"
  rm -rf $f
done

echo "[2/5] symlink: vim...(${DOT_FILES}/vim/*)"
echo "ln: vimrc"
ln -s ${DOT_FILES}/vim/vimrc ${HOME}/.vimrc

echo "ln: gvimrc"
ln -s ${DOT_FILES}/vim/gvimrc ${HOME}/.gvimrc

# for f in "${DOT_FILES}"/vim/*
# do
#   echo "ln: `basename $f`"
#   ln -s $f ${HOME}/.`basename $f`
# done

echo "[3/5] symlink: zsh...(${DOT_FILES}/zsh/*)"
echo "ln: zshrc"
ln -s ${DOT_FILES}/zsh/zshrc ${HOME}/.zshrc

# for f in "${DOT_FILES}"/zsh/*
# do
#   echo "ln: `basename $f`"
#   ln -s ${f} ${HOME}/.`basename $f`
# done

echo "[4/5] symlink: git submodules...(${DEPS_DIR}/*)"
for f in "${DEPS_DIR}"/neobundle.vim
do
  echo "ln: `basename $f`"
  ln -s "${DEPS_DIR}/`basename $f`" ${HOME}/.`basename $f`
done

# install autojump
if [ -d "${DEPS_DIR}/autojump" ]; then
  echo "install autojump"
  sh "python ${DEPS_DIR}/autojump/install.py"
fi

if [ ! -d "${HOME}/.vim/bundle" ]; then
  echo "mkdir: .vim/bundle"
  mkdir -p ${HOME}/.vim/bundle
fi

#echo "mv: .neobundle.vim -> .vim/bundle/neobundle.vim"
mv -f ${HOME}/.neobundle.vim ${HOME}/.vim/bundle/
mv -f ${HOME}/.vim/bundle/.neobundle.vim ${HOME}/.vim/bundle/neobundle.vim

# echo "[5/5] symlink: prezto...(${DOT_FILES}/prezto/*)"
# for f in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/*
# do
#   case "$f" in
#     *\.md) ;;
# 	*rc) ;;
#     *)
# 	echo "ln: `basename $f`"
#   	ln -s "$f" ${HOME}/.`basename $f` ;;
#   esac
# done

echo "completed."
