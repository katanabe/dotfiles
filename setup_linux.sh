echo "install dotfiles..."

# DEFINES
DOT_FILES="${HOME}/dotfiles"
SRC_DIR="${DOT_FILES}/src"
DEPS_DIR="${DOT_FILES}/deps"

echo "[1/5] rm .vim* .zsh* files"
for f in "${HOME}"/.vim* "${HOME}"/.zsh* "${HOME}"/.zl* "${HOME}"/.zprezto*
do
  echo "rm: -rf $f"
  rm -rf $f
done

echo "[2/5] symlink: vim...(${SRC_DIR}/vim/*)"
for f in "${SRC_DIR}"/vim/*
do
  echo "ln: `basename $f`"
  ln -s $f ${HOME}/.`basename $f`
done

echo "[3/5] symlink: zsh...(${SRC_DIR}/zsh/*)"
for f in "${SRC_DIR}"/zsh/*
do
  echo "ln: `basename $f`"
  ln -s ${f} ${HOME}/.`basename $f`
done

echo "[4/5] symlink: prezto...(${SRC_DIR}/prezto/*)"
for f in "${SRC_DIR}"/prezto/*
do
  echo "ln: `basename $f`"
  ln -s ${f} ${HOME}/.`basename $f`
done

echo "[5/5] symlink: git submodules...(${DEPS_DIR}/*)"
for f in "${DEPS_DIR}"/*
do
  echo "ln: `basename $f`"
  ln -s "${DEPS_DIR}/`basename $f`" ${HOME}/.`basename $f`
done

if [ ! -d "${HOME}/.vim/bundle" ]; then
  echo "mkdir: .vim/bundle"
  mkdir -p ${HOME}/.vim/bundle
fi
echo "mv: .neobundle.vim -> .vim/bundle/neobundle.vim"
mv -f ${HOME}/.neobundle.vim ${HOME}/.vim/bundle/
mv -f ${HOME}/.vim/bundle/.neobundle.vim ${HOME}/.vim/bundle/neobundle.vim

echo "completed!!"