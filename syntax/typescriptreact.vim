" Vim syntax file
" Language:     TypeScriptReact
" Maintainer:   Ryan Christian
" Last Change:	2022 Aug 26

if !exists("main_syntax")
  if exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'typescriptreact'
endif

let s:cpo_save = &cpo
set cpo&vim

source <sfile>:h/typescriptcommon.vim
source $HOME/.vim/plugged/vim-jsx-pretty/after/syntax/javascriptreact.vim

let b:current_syntax = "typescriptreact"
if main_syntax == 'typescriptreact'
  unlet main_syntax
endif

let &cpo = s:cpo_save
unlet s:cpo_save
