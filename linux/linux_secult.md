#wget security update 

GNU Wget是GNU计划开发的一套用于在网络上进行下载的自由软件，它支持通过HTTP、HTTPS以及FTP这三个最常见的TCP/IP协议下载。

wget 1.18 版本以前的wget有漏洞

卸载原有版本，

    #yum list installed | grep wget     //查看已经安装版本
    wget.x86_64.1.12-10.el6        

解决

1.卸载

    #yum remove wget        

2.安装最新包

    #yum list wget  //查看可选版本 无可选择      wget.x86_64.1.12-10.el6 
下载最新版http://mirrors.ustc.edu.cn/gnu/wget/



    #tar -zxvf wget-1.19.4.tar.gz //解压
    
    依赖gnutls
    http://www.lysator.liu.se/~nisse/archive/nettle-2.5.tar.gz 
    ftp://ftp.gnutls.org/gcrypt/gnutls/v3.1/gnutls-3.1.9.1.tar.xz 
    先安装 nettle




#kernel security, bug fix, and enhancement update 
Android和其他产品中使用的Linux kernel 4.3.2及之前版本中的networking实现过程中存在安全漏洞。由于程序未能验证协议族的协议标识符。本地攻击者可通过使用CLONE_NEWUSER支持运行特制的SOCK_RAW应用，利用该漏洞拒绝服务（空指针逆向引用和系统崩溃）。

#RHSA-2017:0680: glibc security and bug fix update
GNU glibc是一种按照LGPL许可协议发布的开源免费的C语言编译程序。

GNU glibc存在栈缓冲区溢出漏洞，允许攻击者可利用该漏洞使应用程序崩溃或执行任意代码。

#RHSA-2016:0466: openssh security update
OpenSSH sshd漏洞
OpenSSH（OpenBSD Secure Shell）是OpenBSD计划组所维护的一套用于安全访问远程计算机的连接工具。该工具是SSH协议的开源实现，支持对所有的传输进行加密，可有效阻止窃听、连接劫持以及其他网络级的攻击。 
CVEID: CVE-2015-5600
OpenSSH 6.9及之前版本的sshd中的auth2-chall.c文件中的‘kbdint_next_device’函数存在安全漏洞。远程攻击者利用该漏洞可借助ssh -oKbdInteractiveDevices选项中较长且重复的列表实施暴力破解攻击，或造成拒绝服务（CPU消耗）。

#RHSA-2017:0286: openssl security update
OpenSSL拒绝服务漏洞（CNVD-2017-01532）

OpenSSL是OpenSSL团队开发的一个开源的能够实现安全套接层（SSL v2/v3）和安全传输层（TLS v1）协议的通用加密库，它支持多种加密算法，包括对称密码、哈希算法、安全散列算法等。

#RHSA-2017:0680: glibc security and bug fix update 
GNU glibc栈缓冲区溢出漏洞
GNU glibc是一种按照LGPL许可协议发布的开源免费的C语言编译程序。

GNU glibc存在栈缓冲区溢出漏洞，允许攻击者可利用该漏洞使应用程序崩溃或执行任意代码。

#RHSA-2016:1547: libtiff security update
Silicon Graphics LibTiff远程内存破坏漏洞
Silicon Graphics LibTiff是美国Silicon Graphics公司的一个读写TIFF（标签图像文件格式）文件的库。该库包含一些处理TIFF文件的命令行工具。
CVSS分值: 7.5
CVSS: CVSS:3.0/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H
披露时间: 2016-01-08 00:00:00
CVEID: CVE-2015-7554
Silicon Graphics LibTiff中存在远程内存破坏漏洞。攻击者可利用该漏洞在用户运行的受影响应用程序上下文中执行任意代码，也可能造成拒绝服务。

#RHSA-2018:0008: kernel security update
 CPU处理器内核存在Spectre漏洞 CVEID: CVE-2017-5754

 CPU hardware是一套运行在CPU（中央处理器）中用于管理和控制CPU的固件。 

CPU处理器内核存在Spectre漏洞，由于Intel未将低权限的应用程序与访问内核内存分开，导致攻击者可以使用恶意应用程序来获取应该被隔离的私有数据。

#RHSA-2016:1944: bind security update 
ISC BIND 9存在buffer.c 断言错误拒绝服务漏洞
ISC BIND 9是美国Internet Systems Consortium（ISC）组织所维护的一套DNS域名解析服务软件。

ISC BIND 9存在buffer.c断言错误拒绝服务漏洞。远程攻击者利用漏洞可导致程序断言失败退出缓冲区，最终导致BIND主进程崩溃。

#RHSA-2017:0892: kernel security and bug fix update 
: Linux kernel权限获取漏洞（CNVD-2017-02608）
Linux kernel 4.10.1及之前版本中的drivers/tty/n_hdlc.c文件存在权限获取漏洞。本地攻击者可利用该漏洞获取权限或造成拒绝服务（双重释放）。
CVEID: CVE-2017-2636
#RHSA-2016:0715: kernel security, bug fix, and enhancement update
 Linux kernel本地提权漏洞
 Linux kernel中存在本地提权漏洞，本地攻击者可利用该漏洞提升权限，或使内核崩溃。


#RHSA-2016:2824: expat security update 
CVEID: CVE-2016-0718
Expat内存破坏漏洞
Expat是美国软件开发者吉姆-克拉克所研发的一个基于C语言的XML解析器库，它采用了一个面向流的解析器。

Expat中存在内存破坏漏洞，该漏洞源于程序未能正确处理恶意的输入文档类型。攻击者可利用该漏洞造成拒绝服务（段错误和内存破坏），或执行任意代码。

#RHSA-2017:0225: libtiff security update 
LibTIFF tools/tiffcp.c堆缓冲区溢
CVEID: CVE-2016-9540
Silicon Graphics LibTIFF是美国Silicon Graphics公司的一个读写TIFF（标签图像文件格式）文件的库。该库包含一些处理TIFF文件的命令行工具。

libtiff 4.0.6版本在tools/tiffcp.c中存在堆缓冲区溢出漏洞，攻击者利用该漏洞在处理构造的图形时可导致越界写操作。

#RHSA-2017:1372: kernel security and bug fix update
Linux kernel拒绝服务漏洞（CNVD-2017-02483）
CVEID: CVE-2017-6214
Linux kernel是美国Linux基金会发布的操作系统Linux所使用的内核。

Linux kernel 4.9.11之前版本中net/ipv4/tcp.c文件的tcp_splice_read函数存在拒绝服务漏洞，允许远程攻击者通过涉及具有URG标志的TCP数据包的向量引起拒绝服务（无限循环和软锁定）。

#RHSA-2016:0459: bind security update 
 ISC BIND DNAME解析记录签名
 CVEID: CVE-2016-1286
 ISC BIND是一套实现了DNS协议的开源软件。

BIND服务器上DNAME解析记录支持签名校验。攻击者利用漏洞让服务器对恶意请求（包含DNAME解析记录签名校验）进行响应，导致resolver.c或 db.c.发生断言错误，最终导致BIND named主进程崩溃，造成拒绝服务攻击。

#RHSA-2016:1944: bind security update 
 ISC BIND 9存在buffer.c 断言错误
 CVEID: CVE-2016-2776
 ISC BIND 9是美国Internet Systems Consortium（ISC）组织所维护的一套DNS域名解析服务软件。

ISC BIND 9存在buffer.c断言错误拒绝服务漏洞。远程攻击者利用漏洞可导致程序断言失败退出缓冲区，最终导致BIND主进程崩溃。

#RHSA-2015:2655: bind security update 
 ISC BIND named拒绝服务漏洞
CVEID: CVE-2015-8000

 ISC BIND是美国Internet Systems Consortium（ISC）公司所维护的一套实现了DNS协议的开源软件。

ISC BIND 9.9.8-P2之前9.x版本和9.10.3-P2之前9.10.x版本的named中的db.c文件存在安全漏洞。远程攻击者可借助畸形的类属性利用该漏洞造成拒绝服务（REQUIRE断言失败和守护进程退出）。
#RHSA-2016:0494: kernel security, bug fix, and enhancement update
Linux kernel内存泄露漏洞
CVEID: CVE-2016-0774
Linux kernel是美国Linux基金会发布的操作系统Linux所使用的内核。

Linux kernel中存在安全漏洞，该漏洞源于程序在atomic读取失败后未能正确保持缓冲区偏移和长度同步。本地攻击者可利用该漏洞使内核崩溃，或泄露内核内存给用户空间。

#RHSA-2017:1105: bind security update 
ISC BIND 9 DNS64服务器拒绝服
CVEID: CVE-2017-3136
ISC BIND是美国Internet Systems Consortium（ISC）公司所维护的一套实现了DNS协议的开源软件。

ISC BIND 9 DNS64服务器存在拒绝服务漏洞，攻击者可利用漏洞影响使用包含break-dnssec yes;选项的DNS64服务器。
#RHSA-2016:2006: kernel security and bug fix update 
Linux kernel缓冲区溢出漏洞（CNVD-2016-04392）
CVEID: CVE-2016-5829
Linux kernel是美国Linux基金会发布的操作系统Linux所使用的内核。

Linux kernel中存在缓冲区溢出漏洞。攻击者可通过使用HIDIOCGUSAGES或HIDIOCSUSAGES命令调用hiddev ioctl利用该漏洞绕过边界检查，导致无限循环和值覆盖。

#RHSA-2016:2674: libgcrypt security update
GNU Libgcrypt和GnuPG可预测随机数生成漏洞

GNU Libgcrypt 1.6.3-2+deb8u2之前的版本和GnuPG 1.4.18-7+deb8u2之前的版本中的&lsquo;mixing&rsquo;函数存在可预测随机数生成漏洞，攻击者可利用该漏洞从RNG获得4640 bit数据后，轻易预测接下来的160 bit数据。

#RHSA-2017:0036: kernel security and bug fix update 
CVEID: CVE-2016-7117
Linux kernel the __sys_recvmmsg函数内容错误引用漏洞
Linux kernel 4.5.2之前的版本中的net/socket.c文件中的‘the 
__sys_recvmmsg’函数存在内容错误引用漏洞。远程攻击者可利用该漏洞执行任意代码。


#RHSA-2017:0892: kernel security and bug fix update 
Linux kernel权限获取漏洞（CNVD-2017-02608）
CVEID: CVE-2017-2636
Linux kernel是美国Linux基金会发布的操作系统Linux所使用的内核。

Linux kernel 4.10.1及之前版本中的drivers/tty/n_hdlc.c文件存在权限获取漏洞。本地攻击者可利用该漏洞获取权限或造成拒绝服务（双重释放）。

#RHSA-2016:0073: bind security update 
ISC BIND拒绝服务漏洞
CVEID: CVE-2015-8704
ISC BIND是一款开源的BIND程序。

ISC BIND存在安全漏洞，允许远程攻击者利用漏洞提交Address Prefix List (APL)数据触发缓冲区溢出，使服务崩溃。

#RHSA-2016:0715: kernel security, bug fix, and enhancement update 
Linux kernel本地提权漏洞
Linux kernel是美国Linux基金会发布的操作系统Linux所使用的内核。 
CVEID: CVE-2015-5157
Linux kernel中存在本地提权漏洞，本地攻击者可利用该漏洞提升权限，或使内核崩溃。
#RHSA-2016:1547: libtiff security update 
 Silicon Graphics LibTiff远程内存破坏漏洞
CVEID: CVE-2015-7554
Silicon Graphics LibTiff是美国Silicon Graphics公司的一个读写TIFF（标签图像文件格式）文件的库。该库包含一些处理TIFF文件的命令行工具。

Silicon Graphics LibTiff中存在远程内存破坏漏洞。攻击者可利用该漏洞在用户运行的受影响应用程序上下文中执行任意代码，也可能造成拒绝服务。
#RHSA-2017:0641: openssh security and bug fix update 
OpenSSH UseLogin环境变量任意代码执行漏洞
CVEID: CVE-2015-8325
OpenSSH（OpenBSD Secure Shell）是OpenBSD计划组所维护的一套用于安全访问远程计算机的连接工具。

OpenSSH中存在任意代码执行漏洞，本地攻击者可利用该漏洞绕过特定的安全限制，向/bin/login URI中下载受限制的库文件，以root权限执行任意代码。

#RHSA-2015:1447: grep security, bug fix, and enhancement update \
grep超长行处理整数溢出漏洞
CVEID: CVE-2012-5667
Grep是一款Unix系统下强大的文本搜索工具。当解析超长行时Grep存在一个整数溢出错误。允许攻击者构建恶意文件，诱使用户处理，触发基于堆的缓冲区溢出，成功利用漏洞可以以应用程序上下文执行任意代码。

#RHSA-2015:2504: libreport security update 
libreport信息泄露漏洞
CVEID: CVE-2015-5302
libreport是一套使用C#语言在DotNET1.1环境下开发的用于建立主从关系、分组报表的组件。

libreport 2.6.3之前及2.0.7版本存在安全漏洞。由于程序在编辑崩溃报告时只保存对第一个文件的更改。远程攻击者可利用该漏洞获取敏感信息。

#RHSA-2016:0741: openssh security, bug fix, and enhancement update 
OpenSSH身份验证漏洞
CVEID: CVE-2016-1908
OpenSSH（OpenBSD Secure Shell）是OpenBSD计划组所维护的一套用于安全访问远程计算机的连接工具。该工具是SSH协议的开源实现，支持对所有的传输进行加密，可有效阻止窃听、连接劫持以及其他网络级的攻击。

OpenSSH中存在安全漏洞，该漏洞源于OpenSSH客户端未能正确为不可信的X11转发生成身份验证cookie。攻击者可利用该漏洞与本地X服务器建立可信连接。
#RHSA-2016:2105: kernel security update 
 Linux kernel本地权限提升漏洞（Dirty COW）
 CVEID: CVE-2016-5195
 Linux kernel是美国Linux基金会发布的操作系统Linux所使用的内核。 

Linux Kernel本地权限提升漏洞，低权限的本地攻击者利用漏洞可获取其他只读内存映射的写权限，进而可导致权限提升执行进一步操作。
#RHSA-2016:2972: vim security update
 Vim输入验证漏洞
CVEID: CVE-2016-1248
Vim是一款开源的、可配置的用于创建和更改任何类型文本的文本编辑器，它可使用在大多数UNIX系统和Apple OS X中。

Vim patch 8.0.0056之前的版本中存在安全漏洞，该漏洞源于程序未能正确验证‘filetype’、‘syntax’和‘keymap’选项的值。攻击者可利用该漏洞执行任意代码。
#RHSA-2015:1482: libuser security update 
libuser本地提权漏洞
CVEID: CVE-2015-3246
libuser是一款用于操作和管理用户和组账户的标准接口库。

libuser中存在本地提权漏洞。本地攻击者可利用该漏洞获取root权限。
#RHSA-2017:1679: bind security and bug fix update
ISC BIND安全绕过漏洞（CNVD-2017-12537）
CVEID: CVE-2017-3143
BIND是一种开源的DNS（Domain Name System）协议的实现，包含对域名的查询和响应所需的所有软件。它是互联网上最广泛使用的一种DNS服务器。

ISC BIND存在安全绕过漏洞。攻击者可以利用该漏洞执行未经授权的操作，从而发起进一步攻击。
#RHSA-2016:2141: bind security update
ISC BIND 9存在DNAME拒绝服务漏洞
CVEID: CVE-2016-8864
BIND是一套开源的用于实现DNS协议的软件。

ISC BIND 9存在DNAME拒绝服务漏洞。当处理包含特制DNAME应答的递归响应包时，会导致目标解析器断言失败退出。攻击者利用漏洞可造成应用程序崩溃，导致拒绝服务攻击。

#RHSA-2017:0036: kernel security and bug fix update 
Linux kernel the __sys_recvmmsg函数内容错误引用漏洞
CVEID: CVE-2016-7117
Linux kernel是美国Linux基金会发布的操作系统Linux所使用的内核。

Linux kernel 4.5.2之前的版本中的net/socket.c文件中的‘the __sys_recvmmsg’函数存在内容错误引用漏洞。远程攻击者可利用该漏洞执行任意代码。
#RHSA-2015:1081: kernel security, bug fix, and enhancement update 
Linux kernel AESNI缓冲区溢出漏洞
CVEID: CVE-2015-3331
Linux kernel是一款开源操作系统。

Linux kernel /arch/x86/crypto/aesni-intel_glue.c文件的‘__driver_rfc4106_decrypt()’函数中存在缓冲区溢出漏洞，允许本地攻击者可利用漏洞发送特制的IPSec数据包使系统崩溃。

#RHSA-2017:1100: nss and nss-util security update 
Mozilla Network Security Services拒绝服务漏洞
CVEID: CVE-2017-5461
Mozilla Network Security Services（NSS）是美国Mozilla基金会开发的一个函数库（网络安全服务库），它可跨平台提供SSL、S/MIME和其他Internet安全标准支持。

Mozilla NSS中存在安全漏洞。远程攻击者可利用该漏洞造成拒绝服务（越边界写入）。

#RHSA-2016:1406: kernel security and bug fix update 
 Linux kernel限制使用写入漏洞
 CVEID: CVE-2016-4565
 Linux kernel是美国Linux基金会发布的操作系统Linux所使用的内核。

Linux kernel中存在安全漏洞，该漏洞源于drivers/infiniband栈使用不安全的‘write()’函数替换‘bi-directional ioctl()’函数。攻击者可利用该漏洞写入内核内存。

#RHSA-2017:0307: kernel security and bug fix update 
Linux Kernel信息泄露漏洞（CNVD-2016-11671）
CVEID: CVE-2016-9555
Linux kernel是美国Linux基金会发布的操作系统Linux所使用的内核。

Linux kernel 4.8.8之前的版本中的net/sctp/sm_statefuns.c文件的‘sctp_sf_ootb’函数存在安全漏洞，该漏洞源于程序未能检查chunk-length的首数据块大小。远程攻击者可借助特制的SCTP数据利用该漏洞造成拒绝服务（越边界访问）。

#RHSA-2017:0817: kernel security, bug fix, and enhancement update
: Linux kernel本地安全绕过漏洞（CNVD-2016-00852）
CVEID: CVE-2016-2069
Linux kernel是一款开源的操作系统。

Linux kernel存在安全漏洞，允许攻击者可利用该漏洞绕过安全限制，执行未授权操作。

解决方案:

#RHSA-2015:1633: subversion security update 
 Apache Subversion mod_dav_svn远程拒绝服务漏洞
 CVEID: CVE-2015-0248
 Subversion是一款开源多用户版本控制系统，支持非ASCII文本和二进制数据。

Subversion mod_dav_svn及svnserve服务器处理待评估的某些具特殊参数的请求时，会触发断言。断言会造成svnserve进程或进程代管mod_dav_svn模块(Apache)异常中止。这可导致拒绝服务。
#RHSA-2016:2093: bind security update
 ISC BIND 9存在断言错误拒绝服务漏洞
 CVEID: CVE-2016-2848
ISC BIND 9是美国Internet Systems Consortium（ISC）组织所维护的一套DNS域名解析服务软件。 

ISC BIND 9存在断言错误拒绝服务漏洞。远程攻击者利用漏洞可向服务器发送畸形数据包，导致服务器断言失败退出。

#RHSA-2016:2766: kernel security and bug fix update 
Linux kernel-table levels拒绝服务漏洞
CVEID: CVE-2016-2143
Linux kernel是美国Linux基金会发布的操作系统Linux所使用的内核。 

s390平台上的Linux kernel 4.5之前版本的fork实现过程中存在拒绝服务漏洞，该漏洞源于程序未能正确处理4个页表级别。本地攻击者可借助特制的应用程序利用该漏洞造成拒绝服务（系统崩溃）。

#RHSA-2017:0574: gnutls security, bug fix, and enhancement update 
GnuTLS堆栈缓冲区溢出漏洞
CVEID: CVE-2017-5336
GnuTLS是一个免费的用于实现SSL、TLS和DTLS协议的安全通信库。

GnuTLS存在栈缓冲区溢出的漏洞，允许远程攻击者可利用该漏洞提交特殊的请求使链接此库的应用程序崩溃。
#RHSA-2015:1634: sqlite security update

SQLite拒绝服务漏洞（CNVD-2015-02748）CVEID: CVE-2015-3416
SQLite是美国软件开发者D.Richard Hipp所研发的一套基于C语言的开源嵌入式关系数据库管理系统。该系统具有独立性、隔离性、可跨平台等特点。

SQLite 3.8.9之前版本的printf.c文件中的‘sqlite3VXPrintf’函数存在安全漏洞，该漏洞源于程序执行floating-point转换时未能正确处理‘precision’和‘width’值。攻击者利用该漏洞可借助SELECT语句中特制的‘printf’函数调用造成拒绝服务（整数溢出和基于栈的缓冲区溢出）。




#内核升级 

https://blog.csdn.net/daluguishou/article/details/52080250

http://elrepo.org/tiki/tiki-index.php

    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    rpm -Uvh http://www.elrepo.org/elrepo-release-6-8.el6.elrepo.noarch.rpm
    yum --enablerepo=elrepo-kernel install kernel-lt -y
    vi /etc/grub.conf

修改默认的启动内核，新安装的内核一般在第一个，这里把default = 1 改为 default = 0 就好了

reboot重启主机检查内核是否升级
    
    reboot 

    nginx worker_process

    events {
        
    }





# 应用 Openresty
