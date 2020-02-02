msyql 知识点


1、show variables 与 show status 区别

    show variables 查看的是mysql系统变量，是MySQL系统运行时的参数，如字符集设置、版本信息、默认参数等，除非手动修改，否则运行时一般不会改变；

    show  status是MySQL服务器运行统计，如打开的表数量、命令计数、qcache计数等。

    show status 是系统状态  是动态
    show variables 是系统参数  是静态
    
    系统参数可以通过set命令，或者修改mysql配置文件调整，
    系统状态则无法调整。