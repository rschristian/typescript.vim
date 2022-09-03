# Typescript.Vim

If TypeScript is a superset of JavaScript, so too should its syntax files be.

Vim ships with [yats](https://github.com/HerringtonDarkholme/yats.vim) by default as the syntax highlighting for TS & TSX, and it includes the following marketing tag line:

> Exuberant Highlighting. The most elaborate or byzatine syntax highlighting for TypeScript.

While I applaud the effort, yats has completely forgotten what TS is: a superset language. It has created a situation in which there are no overlapping syntax groups between JS & TS, which is a travesty. At best, this means the user will have to manually ensure `jsFucntion` and `typescriptFuncKeyword` align in color and at worst they're stuck manually writing syntax groups because one offers a highlighting group that the other does not.

I find it incredibly frustrating to switch between files to have my syntax highlighting change, and I didn't have hours to throw at my color scheme to ensure everything matched up perfectly. The solution? Make a TS syntax plugin that remembers its roots as a superset.

## Dependencies

Depends on [pangloss/vim-javascript](https://github.com/pangloss/vim-javascript) and [maxmellon/vim-jsx-pretty](https://github.com/maxmellon/vim-jsx-pretty).

Vim's included JS syntax is a decade+ out-of-date at this point, with no real concern for supporting ES6+. As such, a third-party fix is needed. `pangloss/vim-javascript` is what I've used & I'm quite happy with it.

`maxmellon/vim-jsx-pretty` offers great (& consistent!) support for JSX & TSX, which enough to make me a happy user.

## Notes

Unsure about linking patterns or even how to properly distribute these at the moment. In addition, I'm well aware the `typescriptcommon.vim` still has many leftover junk syntax groups that will need to be culled. It's a few hundreds lines of label soup though, so it'll take time.

## Acknowledgements

Largely [yats](https://github.com/HerringtonDarkholme/yats.vim), but with a chainsaw taken to it.

## License

[MIT](https://github.com/rschristian/typescript.vim/blob/master/LICENSE)
