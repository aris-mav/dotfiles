unlet! b:current_syntax
syntax include @texMath syntax/tex.vim
let b:current_syntax = 'markdown'

syntax region mdMathInline start=/\$\(\$\|\s\|\d\)\@!/ end=/\$/ skip=/\\\$/ keepend oneline contains=@texMath
syntax region mdMathBlock start=/\$\$/ end=/\$\$/ keepend contains=@texMath
