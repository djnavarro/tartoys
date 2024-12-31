# painfully hacky deploy script: needs cleaning
cd /home/danielle/GitHub/djnavarro/tartoys

# if you're initialising the branch
# git subtree push --prefix liteblog/site origin gh-pages

# otherwise
git push origin :gh-pages && git subtree push --prefix liteblog/site origin gh-pages

cd /home/danielle/GitHub/djnavarro/tartoys/liteblog
