all: merge build
	./deploy.sh
	git add -A
	git commit -S -m "rebuilding site `date`"
	git push
build:
	git submodule update
	hugo -t academic
	hugo --buildDrafts
	hugo
merge:
	git fetch origin
	git merge -S origin/master

# for rebuild, ignore this
prepare:
	git submodule add -b master  https://github.com/gcushen/hugo-academic.git themes/academic
	git submodule add -b master git@github.com:golang-my/golang-my.github.io.git public
