#!/usr/bin/env sh

# остановиться при ошибках
set -e

# сборка
npm run build

# переход в каталог итоговой сборки
cd dist

git init
git add -A
git commit -m 'deploy'

git push -f git@bitbucket.org:yudinmaxim/yudinmaxim.bitbucket.io.git master

cd -