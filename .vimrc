set ignorecase
set cursorline
set autoindent
autocmd BufNewFile *.sh exec ":call SetTitle()"
func SetTitle()
 if expand("%:e") == 'sh'
 call setline(1,"#!/bin/bash")
 call setline(2,"#")
 call setline(3,"#********************************************************************")
 call setline(4,"#Author:               一只刚刚开始吃猫粮的运维狗")
 call setline(5,"#Mail：                1393121612@qq")
 call setline(6,"#Date：                ".strftime("%Y-%m-%d"))
 call setline(7,"#FileName：            ".expand("%"))
 call setline(8,"#URL：                 https://github.com/wdxqg")
 call setline(9,"#Description：         The test script")
 call setline(10,"#Copyright (C)：      ".strftime("%Y")." All rights reserved")
 call setline(11,"#********************************************************************")
 call setline(12,"#")
 call setline(13,"")
endif
endfunc
autocmd BufNewFile * normal G  
