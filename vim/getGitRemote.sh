#!/usr/bin/bash
#


function read_dir(){
    log=""
    for file in `ls $1` #ע��˴��������������ţ���ʾ����ϵͳ����
    do
        if [ -d $1"/"$file ] #ע��˴�֮��һ��Ҫ���Ͽո񣬷���ᱨ��
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
