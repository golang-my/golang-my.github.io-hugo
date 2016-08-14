+++
date = "2016-08-12T11:05:39+08:00"
image = ""
draft = false
math = false
tags = ["howto", "tutorial", "hugo"]
title = "How to contribute"
+++

By [Chee Leong](https://github.com/klrkdekira)

## Installation

1. Install [Hugo](https://gohugo.io/overview/installing/) or if you have Golang setup,

        go get -u -v github.com/spf13/hugo

2. Clone the project repository.

    If you've obtained permission to write to the repository.

        git clone --recursive git@github.com:golang-my/golang-my.github.io-hugo.git

    Else you'll have to fork the repository, remember to add `--recursive` when checkout.

    I prefer the fork method. :)

3. You can start this to preview the site. Any changes you made will be reflected.

        hugo server

4. The directory structure, for most the time, you only need to deal with `content/post` and `static` (if images are involved).

    Here's an output of `tree`.

        $ tree -L 2
        .
        ├── config.toml
        ├── content
        │   ├── home
        │   ├── post
        │   └── project
        ├── deploy.sh
        ├── LICENSE
        ├── Makefile
        ├── public
        ├── README.md
        ├── static
        │   └── img
        └── themes

5. To create a new post, we'll be using `Hugo`'s scaffolder.

        hugo new post/<title>.md

    Hugo supports [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) and also the current theme we're using supports [LaTeX](https://en.wikibooks.org/wiki/LaTeX/Mathematics).

    To know more, check [Resources](#resources).

6. After you did all the editing and is satisfied with the results. Commit your changes, push and send us a pull request.
   We'll do the moderation, merge and site generation.

    To check for changes

        git status

    Add files to be committed

        git add  <path>

    Commit and push your changes

        git commit
        git push

    Thank you for your contribution.

## Resources

To know more about the toolset and markups.

* [Hugo](https://gohugo.io/overview/introduction/)

* [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)

* [LaTeX](https://en.wikibooks.org/wiki/LaTeX/Mathematics)

## Contributing

Please use the [issue tracker](https://github.com/golang-my/golang-my.github.io-hugo/issues) to let me know about any bugs or feature requests, or alternatively make a pull request.

## Reference

This blog post is referenced from https://github.com/gcushen/hugo-academic/blob/master/exampleSite/content/post/getting-started.md
