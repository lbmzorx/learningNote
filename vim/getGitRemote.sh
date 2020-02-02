#!/usr/bin/bash
#


function read_dir(){
    log=""
    for file in `ls $1` #注意此处这是两个反引号，表示运行系统命令
    do
        if [ -d $1"/"$file ] #注意此处之间一定要加上空格，否则会报错
        then
            cd $1"/"$file
            gitinfo=`git remote get-url origin`
            if [[ "$gitinfo" =~ ^http ]]; then
                echo $gitinfo
            fi
        fi
    done
}

read_dir ~/.vim/bundle  > vim_plugin_remote.conf
