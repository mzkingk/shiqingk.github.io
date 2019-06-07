echo "--->部署"
hexo g

echo "--->提交到hexo分支"
git checkout hexo
git pull
git add .
git commit -m "update hexo"
git push origin hexo

#echo "--->clone master分支"
#git clone -b master git://github.com/shiqingk/shiqingk.github.io.git
#sudo cp -R shiqingk.github.io/.git/ public/.git/
#rm -rf shiqingk.github.io

echo "--->提交到master分支"
cd public
git checkout master
git pull
git add .
git commit -m "update master"
git push origin master

echo "--->完成"
