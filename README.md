# `columnize`

Takes newline-separated items on stdin and prints them in columns on stdout.

`columnize` divides the items into the largest number of columns such that
none of the rows exceed a maximum text width (120). Each row item has a
minimum of 2 spaces padding between adjacent items.

`columnize` lays out text containing
[ANSI color codes](https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#colors--graphics-mode)
as if the escape codes were invisible, so it's suitable for columnizing colored
outputs, such as from `ls --color=always`.
