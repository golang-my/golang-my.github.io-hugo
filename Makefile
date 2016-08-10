all: merge build
	git add -A
	git commit -S -m "rebuilding site `date`"
	git push
build:
	git submodule update
	hugo -t academic
	hugo --buildDrafts
	hugo
deps:
	git clone https://github.com/gcushen/hugo-academic.git themes/academic
merge:
	git fetch origin
	git merge -S origin/master
# for rebuild, ignore this
prepare: deps
	git submodule add -b master git@github.com:golang-my/golang-my.github.io.git public
