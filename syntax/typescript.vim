" Vim syntax file
" Language:     TypeScript
" Maintainer:   Ryan Christian
" Last Change:	2022 Aug 26

if !exists("main_syntax")
  if exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'typescript'
endif

let s:cpo_save = &cpo
set cpo&vim

" this region is NOT used in TypeScriptReact
" nextgroup doesn't contain objectLiteral, let outer region contains it
syntax region typescriptTypeCast matchgroup=typescriptTypeBrackets
  \ start=/< \@!/ end=/>/
  \ contains=@typescriptType
  \ nextgroup=@typescriptExpression
  \ contained skipwhite oneline

source <sfile>:h/typescriptcommon.vim

let b:current_syntax = "typescript"
if main_syntax == 'typescript'
  unlet main_syntax
endif

let &cpo = s:cpo_save
unlet s:cpo_save
