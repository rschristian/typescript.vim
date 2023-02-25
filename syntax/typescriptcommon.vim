" Vim syntax file
" Language:     TypeScript and TypeScriptReact
" Maintainer:   Ryan Christian
" Last Change:	2022 Aug 26

if &cpo =~ 'C'
  let s:cpo_save = &cpo
  set cpo&vim
endif

source $VIMRUNTIME/syntax/javascript.vim
source $HOME/.vim/plugged/vim-javascript/syntax/javascript.vim

" This makes no sense but is required
syntax keyword jsFunction             function
  \ nextgroup=jsGenerator,jsFuncName,jsFuncArgs,jsFlowFunctionGroup
  \ skipwhite skipempty

" ADD TS-specific contstructs to existing JS syntax
syntax keyword jsImport               import
  \ nextgroup=jsModuleAsterisk,jsModuleKeyword,jsModuleGroup,jsFlowImportType,tsImportType
  \ skipwhite skipempty

syntax keyword jsExport               export
  \ nextgroup=@jsAll,jsModuleGroup,jsExportDefault,jsModuleAsterisk,jsModuleKeyword,jsFlowTypeStatement,tsInterfaceKeyword,tsImportType
  \ skipwhite skipempty

syntax match  jsVariableDef           /\<\K\k*/
  \ nextgroup=jsFlowDefinition,tsTypeAnnotation
  \ contained skipwhite skipempty

syntax region jsFuncArgs           matchgroup=jsFuncParens
  \ start=/(/  end=/)/
  \ contains=jsFuncArgCommas,jsComment,jsFuncArgExpression,jsDestructuringBlock,jsDestructuringArray,jsRestExpression,jsFlowArgumentDef,tsTypeAnnotation
  \ nextgroup=jsCommentFunction,jsFuncBlock,jsFlowReturn,tsTypeAnnotation
  \ contained extend fold skipwhite skipempty

syntax region jsDestructuringBlock matchgroup=jsDestructuringBraces
  \ start=/{/  end=/}/
  \ contains=jsDestructuringProperty,jsDestructuringAssignment,jsDestructuringNoise,jsDestructuringPropertyComputed,jsSpreadExpression,jsComment
  \ nextgroup=jsFlowDefinition,tsTypeAnnotation
  \ contained extend fold

syntax region jsDestructuringArray matchgroup=jsDestructuringBraces
  \ start=/\[/ end=/\]/
  \ contains=jsDestructuringPropertyValue,jsDestructuringNoise,jsDestructuringProperty,jsSpreadExpression,jsDestructuringBlock,jsDestructuringArray,jsComment
  \ nextgroup=jsFlowDefinition,tsTypeAnnotation
  \ contained extend fold

syntax region jsBlock matchgroup=jsBraces
  \ start=/{/  end=/}/
  \ contains=@jsAll,jsSpreadExpression,@tsStatement
  \ extend fold

" Used to support nested items in a .d.ts, basically. import, export, etc.,
" would otherwise only ever work top-level
syntax cluster jsAll
  \ contains=@jsExpression,jsStorageClass,jsConditional,jsWhile,jsFor,jsReturn,jsException,jsTry,jsNoise,jsBlockLabel,jsBlock,jsImport,jsFrom,jsExport,jsComment



syntax keyword tsImportType  type
  \ contained

syntax keyword tsCastKeyword as
  \ nextgroup=@tsType
  \ skipwhite

syntax keyword tsModule namespace module

syntax keyword tsAmbientDeclaration declare
  \ nextgroup=@tsAmbients
  \ skipwhite skipempty

syntax cluster tsAmbients contains=
  \ tsInterfaceKeyword,
  \ tsFuncKeyword,
  \ tsClassKeyword,
  \ tsAbstract,
  \ tsEnumKeyword,tsEnum,
  \ tsModule


" Types
syntax match tsOptionalMark /?/ contained

syntax cluster tsTypeParameterCluster contains=
  \ tsTypeParameter,
  \ tsGenericDefault

syntax region tsTypeParameters matchgroup=tsTypeBrackets
  \ start=/</ end=/>/
  \ contains=@tsTypeParameterCluster
  \ contained

syntax match tsTypeParameter /\K\k*/
  \ nextgroup=tsConstraint
  \ contained skipwhite skipnl

syntax keyword tsConstraint extends
  \ nextgroup=@tsType
  \ contained skipwhite skipnl

syntax match tsGenericDefault /=/
  \ nextgroup=@tsType
  \ contained skipwhite

"><
" class A extend B<T> {} // ClassBlock
" func<T>() // FuncCallArg
syntax region tsTypeArguments matchgroup=tsTypeBrackets
  \ start=/\></ end=/>/
  \ contains=@tsType
  \ nextgroup=tsFuncCallArg,@tsTypeOperator
  \ contained skipwhite


syntax cluster tsType contains=
  \ @tsPrimaryType,
  \ tsUnion,
  \ @tsFunctionType,
  \ tsConstructorType

" array type: A[]
" type indexing A['key']
syntax region tsTypeBracket contained
  \ start=/\[/ end=/\]/
  \ contains=tsString,tsNumber
  \ nextgroup=@tsTypeOperator
  \ skipwhite skipempty

syntax cluster tsPrimaryType contains=
  \ tsParenthesizedType,
  \ tsPredefinedType,
  \ tsTypeReference,
  \ tsObjectType,
  \ tsTupleType,
  \ tsTypeQuery,
  \ tsStringLiteralType,
  \ tsTemplateLiteralType,
  \ tsReadonlyArrayKeyword,
  \ tsAssertType

syntax region  tsStringLiteralType contained
  \ start=/\z(["']\)/  skip=/\\\\\|\\\z1\|\\\n/  end=/\z1\|$/
  \ nextgroup=tsUnion
  \ skipwhite skipempty

syntax region  tsTemplateLiteralType contained
  \ start=/`/  skip=/\\\\\|\\`\|\n/  end=/`\|$/
  \ contains=tsTemplateSubstitutionType
  \ nextgroup=tsTypeOperator
  \ skipwhite skipempty

syntax region  tsTemplateSubstitutionType matchgroup=tsTemplateSB
  \ start=/\${/ end=/}/
  \ contains=@tsType
  \ contained

syntax region tsParenthesizedType matchgroup=tsParens
  \ start=/(/ end=/)/
  \ contains=@tsType
  \ nextgroup=@tsTypeOperator
  \ contained skipwhite skipempty fold

syntax match tsTypeReference /\K\k*\(\.\K\k*\)*/
  \ nextgroup=tsTypeArguments,@tsTypeOperator,tsUserDefinedType
  \ skipwhite contained skipempty

syntax keyword tsPredefinedType any number boolean string void never undefined null object unknown
  \ nextgroup=@tsTypeOperator
  \ contained skipwhite skipempty

syntax match tsPredefinedType /unique symbol/
  \ nextgroup=@tsTypeOperator
  \ contained skipwhite skipempty

syntax region tsObjectType matchgroup=tsBraces
  \ start=/{/ end=/}/
  \ contains=jsComment,@tsTypeMember,tsEndColons,tsAccessibilityModifier,tsReadonlyModifier
  \ nextgroup=@tsTypeOperator
  \ contained skipwhite skipnl fold

syntax cluster tsTypeMember contains=
  \ @tsCallSignature,
  \ tsConstructSignature,
  \ tsIndexSignature,
  \ @tsMembers

syntax match tsTupleLable /\K\k*?\?:/
    \ contained

syntax region tsTupleType matchgroup=tsBraces
  \ start=/\[/ end=/\]/
  \ contains=@tsType,@tsComments,tsRestOrSpread,tsTupleLable
  \ contained skipwhite

syntax cluster tsTypeOperator
  \ contains=tsUnion,tsTypeBracket,tsConstraint,tsConditionalType

syntax match tsUnion /|\|&/ contained nextgroup=@tsPrimaryType skipwhite skipempty

syntax match tsConditionalType /?\|:/ contained nextgroup=@tsPrimaryType skipwhite skipempty

syntax cluster tsFunctionType contains=tsGenericFunc,tsFuncType
syntax region tsGenericFunc matchgroup=tsTypeBrackets
  \ start=/</ end=/>/
  \ contains=tsTypeParameter
  \ nextgroup=tsFuncType
  \ containedin=tsFunctionType
  \ contained skipwhite skipnl

syntax region tsFuncType matchgroup=tsParens
  \ start=/(/ end=/)\s*=>/me=e-2
  \ contains=@tsParameterList
  \ nextgroup=tsFuncTypeArrow
  \ contained skipwhite skipnl oneline

syntax match tsFuncTypeArrow /=>/
  \ nextgroup=@tsType
  \ containedin=tsFuncType
  \ contained skipwhite skipnl


syntax keyword tsConstructorType new
  \ nextgroup=@tsFunctionType
  \ contained skipwhite skipnl

syntax keyword tsUserDefinedType is
  \ contained nextgroup=@tsType skipwhite skipempty

syntax keyword tsTypeQuery typeof keyof
  \ nextgroup=tsTypeReference
  \ contained skipwhite skipnl

syntax keyword tsAssertType asserts
  \ nextgroup=tsTypeReference
  \ contained skipwhite skipnl

syntax cluster tsCallSignature contains=tsGenericCall,tsCall
syntax region tsGenericCall matchgroup=tsTypeBrackets
  \ start=/</ end=/>/
  \ contains=tsTypeParameter
  \ nextgroup=tsCall
  \ contained skipwhite skipnl
syntax region tsCall matchgroup=tsParens
  \ start=/(/ end=/)/
  \ contains=tsDecorator,@tsParameterList,@tsComments
  \ nextgroup=tsTypeAnnotation,tsBlock
  \ contained skipwhite skipnl

syntax match tsTypeAnnotation /:/
  \ nextgroup=@tsType
  \ contained skipwhite skipnl

syntax cluster tsParameterList contains=
  \ tsTypeAnnotation,
  \ tsAccessibilityModifier,
  \ tsReadonlyModifier,
  \ tsOptionalMark,
  \ tsRestOrSpread,
  \ tsFuncComma,
  \ tsDefaultParam

syntax match tsFuncComma /,/ contained

syntax match tsDefaultParam /=/
  \ nextgroup=@tsValue
  \ contained skipwhite

syntax keyword tsConstructSignature new
  \ nextgroup=@tsCallSignature
  \ contained skipwhite

syntax region tsIndexSignature matchgroup=tsBraces
  \ start=/\[/ end=/\]/
  \ contains=tsPredefinedType,tsMappedIn,tsString
  \ nextgroup=tsTypeAnnotation
  \ contained skipwhite oneline

syntax keyword tsMappedIn in
  \ nextgroup=@tsType
  \ contained skipwhite skipnl skipempty

syntax keyword tsAliasKeyword type
  \ nextgroup=tsAliasDeclaration
  \ skipwhite skipnl skipempty

syntax region tsAliasDeclaration matchgroup=tsUnion
  \ start=/ / end=/=/
  \ nextgroup=@tsType
  \ contains=tsConstraint,tsTypeParameters
  \ contained skipwhite skipempty

syntax keyword tsReadonlyArrayKeyword readonly
  \ nextgroup=@tsPrimaryType
  \ skipwhite


" patch
" patch for generated code
syntax keyword tsGlobal Promise
  \ nextgroup=tsGlobalPromiseDot,tsFuncCallArg,tsTypeArguments oneline
syntax keyword tsGlobal Map WeakMap
  \ nextgroup=tsGlobalPromiseDot,tsFuncCallArg,tsTypeArguments oneline

syntax keyword tsConstructor           contained constructor
  \ nextgroup=@tsCallSignature
  \ skipwhite skipempty

syntax cluster memberNextGroup contains=tsMemberOptionality,tsTypeAnnotation,@tsCallSignature

syntax match tsMember /#\?\K\k*/
  \ nextgroup=@memberNextGroup
  \ contained skipwhite

syntax match tsMethodAccessor contained /\v(get|set)\s\K/me=e-1
  \ nextgroup=@tsMembers

syntax cluster tsPropertyMemberDeclaration contains=
  \ tsClassStatic,
  \ tsAccessibilityModifier,
  \ tsReadonlyModifier,
  \ tsMethodAccessor,
  \ @tsMembers
  " \ tsMemberVariableDeclaration

syntax match tsMemberOptionality /?\|!/ contained
  \ nextgroup=tsTypeAnnotation,@tsCallSignature
  \ skipwhite skipempty

syntax cluster tsMembers contains=tsMember,tsStringMember,tsComputedMember

syntax keyword tsClassStatic static
  \ nextgroup=@tsMembers,tsAsyncFuncKeyword,tsReadonlyModifier
  \ skipwhite contained

syntax keyword tsAccessibilityModifier public private protected contained

syntax keyword tsReadonlyModifier readonly contained

syntax region  tsStringMember   contained
  \ start=/\z(["']\)/  skip=/\\\\\|\\\z1\|\\\n/  end=/\z1/
  \ nextgroup=@memberNextGroup
  \ skipwhite skipempty

syntax region  tsComputedMember   contained matchgroup=tsProperty
  \ start=/\[/rs=s+1 end=/]/
  \ contains=@tsValue,tsMember,tsMappedIn
  \ nextgroup=@memberNextGroup
  \ skipwhite skipempty

"don't add tsMembers to nextgroup, let outer scope match it
" so we won't match abstract method outside abstract class
syntax keyword tsAbstract              abstract
  \ nextgroup=tsClassKeyword
  \ skipwhite skipnl
syntax keyword tsClassKeyword          class
  \ nextgroup=tsClassName,tsClassExtends,tsClassBlock
  \ skipwhite

syntax match   tsClassName             contained /\K\k*/
  \ nextgroup=tsClassBlock,tsClassExtends,tsClassTypeParameter
  \ skipwhite skipnl

syntax region tsClassTypeParameter
  \ start=/</ end=/>/
  \ contains=@tsTypeParameterCluster
  \ nextgroup=tsClassBlock,tsClassExtends
  \ contained skipwhite skipnl

syntax keyword tsClassExtends          contained extends implements nextgroup=tsClassHeritage skipwhite skipnl

syntax match   tsClassHeritage         contained /\v(\k|\.|\(|\))+/
  \ nextgroup=tsClassBlock,tsClassExtends,tsMixinComma,tsClassTypeArguments
  \ contains=@tsValue
  \ skipwhite skipnl
  \ contained

syntax region tsClassTypeArguments matchgroup=tsTypeBrackets
  \ start=/</ end=/>/
  \ contains=@tsType
  \ nextgroup=tsClassExtends,tsClassBlock,tsMixinComma
  \ contained skipwhite skipnl

syntax match tsMixinComma /,/ contained nextgroup=tsClassHeritage skipwhite skipnl

" we need add arrowFunc to class block for high order arrow func
" see test case
syntax region  tsClassBlock matchgroup=tsBraces start=/{/ end=/}/
  \ contains=@tsPropertyMemberDeclaration,tsAbstract,@tsComments,tsBlock,tsAssign,tsDecorator,tsAsyncFuncKeyword,tsArrowFunc
  \ contained fold

syntax keyword tsInterfaceKeyword          interface nextgroup=tsInterfaceName skipwhite
syntax match   tsInterfaceName             contained /\k\+/
  \ nextgroup=tsObjectType,tsInterfaceExtends,tsInterfaceTypeParameter
  \ skipwhite skipnl
syntax region tsInterfaceTypeParameter
  \ start=/</ end=/>/
  \ contains=@tsTypeParameterCluster
  \ nextgroup=tsObjectType,tsInterfaceExtends
  \ contained
  \ skipwhite skipnl

syntax keyword tsInterfaceExtends          contained extends nextgroup=tsInterfaceHeritage skipwhite skipnl

syntax match tsInterfaceHeritage contained /\v(\k|\.)+/
  \ nextgroup=tsObjectType,tsInterfaceComma,tsInterfaceTypeArguments
  \ skipwhite

syntax region tsInterfaceTypeArguments matchgroup=tsTypeBrackets
  \ start=/</ end=/>/ skip=/\s*,\s*/
  \ contains=@tsType
  \ nextgroup=tsObjectType,tsInterfaceComma
  \ contained skipwhite

syntax match tsInterfaceComma /,/ contained nextgroup=tsInterfaceHeritage skipwhite skipnl

"Block VariableStatement EmptyStatement ExpressionStatement IfStatement IterationStatement ContinueStatement BreakStatement ReturnStatement WithStatement LabelledStatement SwitchStatement ThrowStatement TryStatement DebuggerStatement
syntax cluster tsStatement
  \ contains=tsBlock,
  \ @tsTopExpression,tsAssign,
  \ tsConditional,tsRepeat,tsBranch,
  \ tsLabel,tsStatementKeyword,
  \ tsTry,tsExceptions,tsDebugger,
  \ tsExport,tsInterfaceKeyword,tsEnum,
  \ tsModule,tsAliasKeyword,tsImport

syntax cluster tsPrimitive  contains=tsString,tsTemplate,tsRegexpString,tsNumber,tsBoolean,tsNull,tsArray

syntax cluster tsEventTypes            contains=tsEventString,tsTemplate,tsNumber,tsBoolean,tsNull

" top level expression: no arrow func
" also no func keyword. funcKeyword is contained in statement
" funcKeyword allows overloading (func without body)
" funcImpl requires body
syntax cluster tsTopExpression
  \ contains=@tsPrimitive,
  \ tsIdentifier,tsIdentifierName,
  \ tsOperator,tsUnaryOp,
  \ tsParenExp,tsRegexpString,
  \ tsGlobal,tsAsyncFuncKeyword,
  \ tsClassKeyword,tsTypeCast

" no object literal, used in type cast and arrow func
" TODO: change func keyword to funcImpl
syntax cluster tsExpression
  \ contains=@tsTopExpression,
  \ tsArrowFuncDef,
  \ tsFuncImpl

syntax cluster tsValue
  \ contains=@tsExpression,tsObjectLiteral

syntax cluster tsEventExpression       contains=tsArrowFuncDef,tsParenExp,@tsValue,tsRegexpString,@tsEventTypes,tsOperator,tsGlobal,jsxRegion

syntax keyword tsAsyncFuncKeyword      async
  \ nextgroup=tsArrowFuncDef
  \ skipwhite

syntax keyword tsAsyncFuncKeyword      await
  \ nextgroup=@tsValue
  \ skipwhite

syntax match   tsAsyncFunc             contained /*/
  \ nextgroup=tsFuncName,@tsCallSignature
  \ skipwhite skipempty

syntax match   tsFuncName              contained /\K\k*/
  \ nextgroup=@tsCallSignature
  \ skipwhite

" destructuring ({ a: ee }) =>
syntax match   tsArrowFuncDef          contained /(\(\s*\({\_[^}]*}\|\k\+\)\(:\_[^)]\)\?,\?\)\+)\s*=>/
  \ contains=tsArrowFuncArg,tsArrowFunc
  \ nextgroup=@tsExpression,tsBlock
  \ skipwhite skipempty

" matches `(a) =>` or `([a]) =>` or
" `(
"  a) =>`
syntax match   tsArrowFuncDef          contained /(\(\_s*[a-zA-Z\$_\[.]\_[^)]*\)*)\s*=>/
  \ contains=tsArrowFuncArg,tsArrowFunc
  \ nextgroup=@tsExpression,tsBlock
  \ skipwhite skipempty

syntax match   tsArrowFuncDef          contained /\K\k*\s*=>/
  \ contains=tsArrowFuncArg,tsArrowFunc
  \ nextgroup=@tsExpression,tsBlock
  \ skipwhite skipempty

" TODO: optimize this pattern
syntax region   tsArrowFuncDef          contained start=/(\_[^(^)]*):/ end=/=>/
  \ contains=tsArrowFuncArg,tsArrowFunc,tsTypeAnnotation
  \ nextgroup=@tsExpression,tsBlock
  \ skipwhite skipempty keepend

syntax match   tsArrowFunc             /=>/
syntax match   tsArrowFuncArg          contained /\K\k*/
syntax region  tsArrowFuncArg          contained start=/<\|(/ end=/\ze=>/ contains=@tsCallSignature

syntax region tsReturnAnnotation contained start=/:/ end=/{/me=e-1 contains=@tsType nextgroup=tsBlock


syntax cluster tsCallImpl contains=tsGenericImpl,tsParamImpl
syntax region tsGenericImpl matchgroup=tsTypeBrackets
  \ start=/</ end=/>/ skip=/\s*,\s*/
  \ contains=tsTypeParameter
  \ nextgroup=tsParamImpl
  \ contained skipwhite
syntax region tsParamImpl matchgroup=tsParens
  \ start=/(/ end=/)/
  \ contains=tsDecorator,@tsParameterList,@tsComments
  \ nextgroup=tsReturnAnnotation,tsBlock
  \ contained skipwhite skipnl

syntax match tsDecorator /@\([_$a-zA-Z][_$a-zA-Z0-9]*\.\)*[_$a-zA-Z][_$a-zA-Z0-9]*\>/
  \ nextgroup=tsFuncCallArg,tsTypeArguments
  \ contains=@_semantic,tsDotNotation



hi def link tsPredefinedType Type

hi def link tsImportType          Keyword
hi def link tsAliasKeyword        Keyword
hi def link tsAmbientDeclaration  Keyword
hi def link tsModule              Keyword
hi def link tsInterfaceKeyword    Keyword
hi def link tsInterfaceExtends    Keyword
hi def link tsCastKeyword         Keyword
hi def link tsStringLiteralType   Keyword

hi def link tsTypeAnnotation      jsObjectColon
hi def link tsTypeBrackets        jsObjectColon

if exists('s:cpo_save')
  let &cpo = s:cpo_save
  unlet s:cpo_save
endif
