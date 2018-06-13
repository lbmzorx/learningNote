<?php
/**
 * Created for advanced-admin.
 * User: aa
 * Date: 2018/4/10 10:58
 */

namespace admin\tool;


use yii\helpers\ArrayHelper;

class System
{
    public static function getDf(){
        $dffile=__DIR__.'/df-info.info';


        $df = round(@disk_free_space("."),3);
        $dt = round(@disk_total_space("."),3);
        $dfvalue=static::unit($dt,'B');
        $total=$dfvalue['value'];
        $free=round($df/($dt&&$dfvalue['value']?($dt/$dfvalue['value']):1),3);
        $current=[
            'current'=>[
                'name'=>'current',
                'total'=>$total,
                'free'=>$free,
                'used'=>($total-$free),
                'percent'=>round(($total-$free)/($total?:1)*100,3),
                'unit'=>$dfvalue['unit'],
            ],
        ];
        if(strtoupper(substr(PHP_OS,0,3)) ==='WIN'){
            return $current;
        }else{
            if(file_exists($dffile)){
                $str = @file($dffile);
                $res=[];
                unset($str[0]);
                foreach ($str as $v){
                    if(preg_match('/(?P<disk>[\w\/]+)\s+(?P<total>[\w\/]+)\s+(?P<used>[\w\/]+)\s+(?P<available>[\w\/]+)\s+(?P<persent>[\w\/%]+)\s+(?P<mounted>[\w\/]+)\s+/',$v,$match)){
                        $res[$match['mounted']]=[
                            'totalOld'=>$match['total'],
                            'name'=>$match['mounted'],
                            'free'=>round(@disk_free_space($match['mounted']),3),
                            'total'=>round(@disk_total_space($match['mounted']),3),
                        ];

                        $unitvalue=static::unit($res[$match['mounted']]['total'],'B');

                        $res[$match['mounted']]['free']=round($res[$match['mounted']]['free']/($unitvalue['value']&&$res[$match['mounted']]['total']?($res[$match['mounted']]['total']/$unitvalue['value']):1),3);
                        $res[$match['mounted']]['unit']=$unitvalue['unit'];
                        $res[$match['mounted']]['total']=round($unitvalue['value'],3);

                        $res[$match['mounted']]['used']=$res[$match['mounted']]['total']-$res[$match['mounted']]['free'];
                        $res[$match['mounted']]['percent']=round($res[$match['mounted']]['used']/($res[$match['mounted']]['total']?:1)*100,3);
                    }
                }

                return $res;
            }else{
                return $current;
            }
        }
    }

    public static function getMem(){
        if (false === ($str = @file("/proc/meminfo"))) return false;
        $res=[];
        foreach ($str as $v){
            if(preg_match('/^(?P<name>[\w_]+):\s*(?P<value>[\d]+)((\s*(?P<unit>[\w]+))|(\s*))/',$v,$match)){
                $res[$match['name']]=['name'=>$match['name'],'value'=>$match['value'],'unit'=>isset($match['unit'])?$match['unit']:''];
            }
        }
        foreach ($res as $name=>$v){
            if( $new=static::unit($v['value'],$v['unit']) ){
                $res[$name]=array_merge($v,$new);
            }
        }
        $res=ArrayHelper::merge($res,static::memExplain());
        return $res;
    }

    public static $unitlevel=['B'=>0,'KB'=>1,'MB'=>2,'GB'=>3,'TB'=>4,'PB'=>5];
    public static function unit($value,$unit='kb'){
        $unitlevel=static::$unitlevel;
        if(array_key_exists(strtoupper($unit),$unitlevel)){
            $level=$unitlevel[strtoupper($unit)];
        }else{
            return false;
        }
        $len=strlen((string)$value);
        if($len>=9){
            $sub=3;
        }elseif($len>=6){
            $sub=2;
        }elseif($len>=3){
            $sub=1;
        }else{
            $sub=0;
        }
        if($sub+$level>5){
            $sub=5-$level;
        }
        $subTotal=1;
        for($i=0;$i<$sub;$i++){
            $subTotal=$subTotal*1024;
        }
        $value=round($value/($subTotal?:1),3);
        $flip=array_flip($unitlevel);
        $unit=isset($flip[$sub+$level])?$flip[$sub+$level]:$unit;
        return ['value'=>$value,'unit'=>$unit];
    }

    public static function memExplain(){
        return [
            "MemTotal"=>[
                "name"=> "MemTotal",
                "name_cn"=> "总内存",
                "explain"=> "可用的总内存，总物理内存减去kernel 代码/数据段占用再减去保留的内存区",
            ],
            "MemFree"=>[
                "name"=> "MemFree",
                "name_cn"=> "空闲内存",
                "explain"=> "完全未用到的物理内存 LowFree+HighFree",
            ],
            "MemAvailable"=>[
                "name"=> "MemAvailable",
                "name_cn"=> "可用内存",
                "explain"=> "可回收的，比如cache/buffer、slab都有一部分可以回收，所以这部分可回收的内存加上MemFree是系统可用的内存",
            ],
            "Buffers"=>[
                "name"=> "Buffers",
                "name_cn"=> "文件的缓冲",
                "explain"=> "临时存储原始磁盘块的总量",
            ],
            "Cached"=>[
                "name"=> "Cached",
                "name_cn"=> "高速缓冲存储器",
                "explain"=> "用作缓存内存的物理内存总量",
            ],
            "SwapCached"=>[
                "name"=> "SwapCached",
                "name_cn"=> "0",
                "explain"=> "被高速缓冲存储用的交换空间大小，已经被交换出来的内存，但仍然被存放在swapfile中。用来在需要的时候很快的被替换而不需要再次打开I/O端口。",
            ],
            "Active"=>[
                "name"=> "Active",
                "name_cn"=> "活动内存",
                "explain"=> "最近经常被使用的内存大小总量",
            ],
            "Inactive"=>[
                "name"=> "Inactive",
                "name_cn"=> "不活动内存",
                "explain"=> "最近不是经常使用的内存",
            ],
            "Unevictable"=>[
                "name"=> "Unevictable",
                "name_cn"=> "Unevictable",
                "explain"=> "The amount of memeory,in kibibytes,discovered by the pageout code,that is not evictable because it is locked into memeory by user programs.",
            ],
            "Mlocked"=>[
                "name"=> "Mlocked",
                "name_cn"=> "Mlocked",
                "explain"=> " 因为被用户程序锁住不能被回收的内存总量",
            ],
            "SwapTotal"=>[
                "name"=> "SwapTotal",
                "name_cn"=> "Swap",
                "explain"=> "Swap分区在系统的物理内存不够用的时候，把硬盘空间中的一部分空间释放出来，以供当前运行的程序使用",
            ],
            "SwapFree"=>[
                "name"=> "SwapFree",
                "name_cn"=> "未被使用交换空间",
                "explain"=> "剩余swap空间的大小",
            ],
            "Dirty"=>[
                "name"=> "Dirty",
                "name_cn"=> "脏内存",
                "explain"=> "等待被写回到磁盘的大小",
            ],
            "Writeback"=>[
                "name"=> "Writeback",
                "name_cn"=> "Writeback",
                "explain"=> "正在被写回的大小 ",
            ],
            "AnonPages"=>[
                "name"=> "AnonPages",
                "name_cn"=> "AnonPages",
                "explain"=> "未映射的页的大小 ",
            ],
            "Mapped"=>[
                "name"=> "Mapped",
                "name_cn"=> "Mapped",
                "explain"=> "设备和文件映射的大小 ",
            ],
            "Shmem"=>[
                "name"=> "Shmem",
                "name_cn"=> "Shmem",
                "explain"=> "内核数据结构缓存的大小,可减少申请和释放内存带来的消耗，The total amount of memeory,in kibibytes,used by shared memeory(shmem) and tmpfs ",
            ],
            "Slab"=>[
                "name"=> "Slab",
                "name_cn"=> "132392",
                "explain"=> "内核数据结构缓存的大小,可减少申请和释放内存带来的消耗，The total amount of memeory,in kibibytes,used by the kernel to cache data structures for its own use.",
            ],
            "SReclaimable"=>[
                "name"=> "SReclaimable",
                "name_cn"=> "105932",
                "explain"=> "可收回slab的大小 ",
            ],
            "SUnreclaim"=>[
                "name"=> "SUnreclaim",
                "name_cn"=> "26460",
                "explain"=> "不可收回的slab的大小SUnreclaim+SReclaimable=Slab",
            ],
            "KernelStack"=>[
                "name"=> "KernelStack",
                "name_cn"=> "内核栈",
                "explain"=> "内核分配给系统任务的栈。The amount of memeory,in kibibytes,used by the kernel stack allocations done for each task in the system",
            ],
            "PageTables"=>[
                "name"=> "PageTables",
                "name_cn"=> "21156",
                "explain"=> "管理内存分页的索引表的大小，The total amount of memeory,in kibibytes,dedicated to the lowest page table level. ",
            ],
            "NFS_Unstable"=>[
                "name"=> "NFS_Unstable",
                "name_cn"=> "0",
                "explain"=> "不稳定页表的大小 ",
            ],
            "Bounce"=>[
                "name"=> "Bounce",
                "name_cn"=> "0",
                "explain"=> "bounce:退回 ",
            ],
            "WritebackTmp"=>[
                "name"=> "WritebackTmp",
                "name_cn"=> "0",
                "explain"=> "kB",
            ],
            "CommitLimit"=>[
                "name"=> "CommitLimit",
                "name_cn"=> "5225660",
                "explain"=> "The total amount of memory currently avaiable to be allocated on the system based on the overcommit ratio(vm.overcommit_ratio) This limit is only adhered of if stric overcommit accounting is enabled(mode 2 in vm.overcommit_memory) ",
            ],
            "Committed_AS"=>[
                "name"=> "Committed_AS",
                "name_cn"=> "Committed_AS",
                "explain"=> "The total amount of memory,in kibibytes,estimated to complete the workload.This value repsents the worst case scenario value,and also includes swap memory",
            ],
            "VmallocTotal"=>[
                "name"=> "VmallocTotal",
                "name_cn"=> "虚拟内存",
                "explain"=> "The total amount of memory,in kibibytes,of total allocated virtual address space",
            ],
            "VmallocUsed"=>[
                "name"=> "VmallocUsed",
                "name_cn"=> "已经被使用的虚拟内存大小 ",
                "explain"=> "The total amount of memory, in kibibytes, of used virtual address space.",
            ],
            "VmallocChunk"=>[
                "name"=> "VmallocChunk",
                "name_cn"=> "VmallocChunk",
                "explain"=> "The largest contiguous block of memory, in kibibytes, of available virtual address space.",
            ],
            "HardwareCorrupted"=>[
                "name"=> "HardwareCorrupted",
                "name_cn"=> "HardwareCorrupted",
                "explain"=> "The amount of memory, in kibibytes, with physical memory corruption problems, identified by the hardware and set aside by the kernel so it does not get used.",
            ],
            "AnonHugePages"=>[
                "name"=> "AnonHugePages",
                "name_cn"=> "311296",
                "explain"=> "The total amount of memory, in kibibytes, used by huge pages that are not backed by files and are mapped into userspace page tables.",
            ],
            "HugePages_Total"=>[
                "name"=> "HugePages_Total",
                "name_cn"=> "大页面的分配",
                "explain"=> "The total number of hugepages for the system. The number is derived by dividing Hugepagesize by the megabytes set aside for hugepages specified in /proc/sys/vm/hugetlb_pool. This statistic only appears on the x86, Itanium, and AMD64 architectures.",
            ],
            "HugePages_Free"=>[
                "name"=> "HugePages_Free",
                "name_cn"=> "HugePages_Free",
                "explain"=> "The total number of hugepages available for the system. This statistic only appears on the x86, Itanium, and AMD64 architectures.",
            ],
            "HugePages_Rsvd"=>[
                "name"=> "HugePages_Rsvd",
                "name_cn"=> "0",
                "explain"=> "The number of unused huge pages reserved for hugetlbfs.",
            ],
            "HugePages_Surp"=>[
                "name"=> "HugePages_Surp",
                "name_cn"=> "0",
                "explain"=> "The number of surplus huge pages.",
            ],
            "Hugepagesize"=>[
                "name"=> "Hugepagesize",
                "name_cn"=> "2048",
                "explain"=> "The size for each hugepages unit in kibibytes. By default, the value is 4096 KB on uniprocessor kernels for 32 bit architectures. For SMP, hugemem kernels, and AMD64, the default is 2048 KB. For Itanium architectures, the default is 262144 KB. This statistic only appears on the x86, Itanium, and AMD64 architectures.",
            ],
            "DirectMap4k"=>[
                "name"=> "DirectMap4k",
                "name_cn"=> "31240",
                "explain"=> "The amount of memory, in kibibytes, mapped into kernel address space with 4 kB page mappings.",
            ],
            "DirectMap2M"=>[
                "name"=> "DirectMap2M",
                "name_cn"=> "2531328",
                "explain"=> "The amount of memory, in kibibytes, mapped into kernel address space with 2 MB page mappings.",
            ],
            "DirectMap1G"=>[
                "name"=> "DirectMap1G",
                "name_cn"=> "1048576",
                "explain"=> "The amount of memory, in kibibytes, mapped into kernel address space with 1 GB page mappings.",
            ]
        ];
    }


    //linux系统探测
    function sys_linux()
    {
        // CPU
        if (false === ($str = @file("/proc/cpuinfo"))) return false;
        $str = implode("", $str);
        @preg_match_all("/model\s+name\s{0,}\:+\s{0,}([\w\s\)\(\@.-]+)([\r\n]+)/s", $str, $model);
        @preg_match_all("/cpu\s+MHz\s{0,}\:+\s{0,}([\d\.]+)[\r\n]+/", $str, $mhz);
        @preg_match_all("/cache\s+size\s{0,}\:+\s{0,}([\d\.]+\s{0,}[A-Z]+[\r\n]+)/", $str, $cache);
        @preg_match_all("/bogomips\s{0,}\:+\s{0,}([\d\.]+)[\r\n]+/", $str, $bogomips);
        if (false !== is_array($model[1]))
        {
            $res['cpu']['num'] = sizeof($model[1]);
            /*
            for($i = 0; $i < $res['cpu']['num']; $i++)
            {
                $res['cpu']['model'][] = $model[1][$i].'&nbsp;('.$mhz[1][$i].')';
                $res['cpu']['mhz'][] = $mhz[1][$i];
                $res['cpu']['cache'][] = $cache[1][$i];
                $res['cpu']['bogomips'][] = $bogomips[1][$i];
            }*/
            if($res['cpu']['num']==1)
                $x1 = '';
            else
                $x1 = ' ×'.$res['cpu']['num'];
            $mhz[1][0] = ' | 频率:'.$mhz[1][0];
            $cache[1][0] = ' | 二级缓存:'.$cache[1][0];
            $bogomips[1][0] = ' | Bogomips:'.$bogomips[1][0];
            $res['cpu']['model'][] = $model[1][0].$mhz[1][0].$cache[1][0].$bogomips[1][0].$x1;
            if (false !== is_array($res['cpu']['model'])) $res['cpu']['model'] = implode("<br />", $res['cpu']['model']);
            if (false !== is_array($res['cpu']['mhz'])) $res['cpu']['mhz'] = implode("<br />", $res['cpu']['mhz']);
            if (false !== is_array($res['cpu']['cache'])) $res['cpu']['cache'] = implode("<br />", $res['cpu']['cache']);
            if (false !== is_array($res['cpu']['bogomips'])) $res['cpu']['bogomips'] = implode("<br />", $res['cpu']['bogomips']);
        }

        // NETWORK

        // UPTIME
        if (false === ($str = @file("/proc/uptime"))) return false;
        $str = explode(" ", implode("", $str));
        $str = trim($str[0]);
        $min = $str / 60;
        $hours = $min / 60;
        $days = floor($hours / 24);
        $hours = floor($hours - ($days * 24));
        $min = floor($min - ($days * 60 * 24) - ($hours * 60));
        if ($days !== 0) $res['uptime'] = $days."天";
        if ($hours !== 0) $res['uptime'] .= $hours."小时";
        $res['uptime'] .= $min."分钟";

        // MEMORY
        if (false === ($str = @file("/proc/meminfo"))) return false;
        $str = implode("", $str);
        preg_match_all("/MemTotal\s{0,}\:+\s{0,}([\d\.]+).+?MemFree\s{0,}\:+\s{0,}([\d\.]+).+?Cached\s{0,}\:+\s{0,}([\d\.]+).+?SwapTotal\s{0,}\:+\s{0,}([\d\.]+).+?SwapFree\s{0,}\:+\s{0,}([\d\.]+)/s", $str, $buf);
        preg_match_all("/Buffers\s{0,}\:+\s{0,}([\d\.]+)/s", $str, $buffers);

        $res['memTotal'] = round($buf[1][0]/1024, 2);
        $res['memFree'] = round($buf[2][0]/1024, 2);
        $res['memBuffers'] = round($buffers[1][0]/1024, 2);
        $res['memCached'] = round($buf[3][0]/1024, 2);
        $res['memUsed'] = $res['memTotal']-$res['memFree'];
        $res['memPercent'] = (floatval($res['memTotal'])!=0)?round($res['memUsed']/($res['memTotal']*100?:1),2):0;

        $res['memRealUsed'] = $res['memTotal'] - $res['memFree'] - $res['memCached'] - $res['memBuffers']; //真实内存使用
        $res['memRealFree'] = $res['memTotal'] - $res['memRealUsed']; //真实空闲
        $res['memRealPercent'] = (floatval($res['memTotal'])!=0)?round($res['memRealUsed']/($res['memTotal']*100?:1),2):0; //真实内存使用率

        $res['memCachedPercent'] = (floatval($res['memCached'])!=0)?round($res['memCached']/($res['memTotal']*100?:1),2):0; //Cached内存使用率

        $res['swapTotal'] = round($buf[4][0]/1024, 2);
        $res['swapFree'] = round($buf[5][0]/1024, 2);
        $res['swapUsed'] = round($res['swapTotal']-$res['swapFree'], 2);
        $res['swapPercent'] = (floatval($res['swapTotal'])!=0)?round($res['swapUsed']/($res['swapTotal']*100?:1),2):0;

        // LOAD AVG
        if (false === ($str = @file("/proc/loadavg"))) return false;
        $str = explode(" ", implode("", $str));
        $str = array_chunk($str, 4);
        $res['loadAvg'] = implode(" ", $str[0]);

        return $res;
    }

    public static function getCpuInfo(){
        if (false === ($str = @file("/proc/cpuinfo"))) return false;
        $res=[];
        $num=0;
        foreach ($str as $v){
            $match=explode(':',$v);
            if(trim($match[0]) == 'processor'){
                $num=trim($match[1]);
            }
            if(count($match)>=2){
                $res[$num][trim($match[0])]=['name'=>trim($match[0]),'value'=>trim($match[1])];
            }
        }
        foreach ($res as $k=>$v){
            $res[$k]=ArrayHelper::merge($v,static::cpuInfoExplain());
        }
        return $res;
    }

    public static function cpuInfoExplain(){
        return [
            'processor'=>'系统中逻辑处理核的编号。对于单核处理器，则课认为是其CPU编号，对于多核处理器则可以是物理核、或者使用超线程技术虚拟的逻辑核',
            'vendor_id'=>'CPU制造商',
            'cpu family'=>'CPU产品系列代号',
            'model'=>'CPU属于其系列中的哪一代的代号',
            'model name'=>'CPU属于的名字及其编号、标称主频',
            'stepping　'=>'CPU属于制作更新版本',
            'cpu MHz　'=>'CPU的实际使用主频',
            'cache size'=>'CPU二级缓存大小',
            'physical id'=>'单个CPU的标号',
            'siblings'=>'单个CPU逻辑物理核数',
            'core id'=>'当前物理核在其所处CPU中的编号，这个编号不一定连续',
            'cpu cores'=>'该逻辑核所处CPU的物理核数',
            'apicid'=>'用来区分不同逻辑核的编号，系统中每个逻辑核的此编号必然不同，此编号不一定连续',
            'fpu'=>'是否具有浮点运算单元（Floating Point Unit）',
            'fpu_exception'=>'是否支持浮点计算异常',
            'cpuid level'=>'执行cpuid指令前，eax寄存器中的值，根据不同的值cpuid指令会返回不同的内容',
            'wp'=>'表明当前CPU是否在内核态支持对用户空间的写保护（Write Protection）',
            'bogomips'=>'在系统内核启动时粗略测算的CPU速度（Million Instructions Per Second）',
            'clflush size'=>'每次刷新缓存的大小单位',
            'cache_alignment'=>'缓存地址对齐单位',
            'address sizes'=>'可访问地址空间位数',
            'power management'=>'对能源管理的支持，有以下几个可选支持功能ts:temperature sensor,fid:frequency id control,vid:voltage id control,ttp:thermal trip,tm:,stc:,100mhzsteps:,hwpstate:　　',
            'flags'=>[
                'fpu'=>'Onboard (x87) Floating Point Unit',
                'vme'=>'Virtual Mode Extension',
                'de'=>'Debugging Extensions',
                'pse'=>'Page Size Extensions',
                'tsc'=>'Time Stamp Counter support for RDTSC and WRTSC instructions',
                'msr'=>'Model-Specific Registers',
                'pae'=>'Physical Address Extensions ability to access 64GB of memory; only 4GB can be accessed at a time though',
                'mce'=>'Machine Check Architecture',
                'cx8'=>'CMPXCHG8 instruction',
                'apic'=>'Onboard Advanced Programmable Interrupt Controller',
                'sep'=>'Sysenter/Sysexit Instructions; SYSENTER is used for jumps to kernel memory during system calls, and SYSEXIT is used for jumps back to the user code',
                'mtrr'=>'Memory Type Range Registers',
                'pge'=>'Page Global Enable',
                'mca'=>'Machine Check Architecture',
                'cmov'=>'CMOV instruction',
                'pat'=>'Page Attribute Table',
                'pse36'=>'36-bit Page Size Extensions allows to map 4 MB pages into the first 64GB RAM, used with PSE.',
                'pn'=>'Processor Serial-Number; only available on Pentium 3',
                'clflush'=>'CLFLUSH instruction',
                'dtes'=>'Debug Trace Store',
                'acpi'=>'ACPI via MSR',
                'mmx'=>'MultiMedia Extension',
                'fxsr'=>'FXSAVE and FXSTOR instructions',
                'sse'=>'Streaming SIMD Extensions. Single instruction multiple data. Lets you do a bunch of the same operation on different pieces of input in a single clock tick.',
                'sse2'=>'Streaming SIMD Extensions-2. More of the same.',
                'selfsnoop'=>'CPU self snoop',
                'acc'=>'Automatic Clock Control',
                'IA64'=>'IA-64 processor Itanium.',
                'ht'=>'HyperThreading. Introduces an imaginary second processor that doesn’t do much but lets you run threads in the same process a  bit quicker.',
                'nx'=>'No Execute bit. Prevents arbitrary code running via buffer overflows.',
                'pni'=>'Prescott New Instructions aka. SSE3',
                'vmx'=>'Intel Vanderpool hardware virtualization technology',
                'svm'=>'AMD "Pacifica" hardware virtualization technology',
                'lm'=>'Long Mode," which means the chip supports the AMD64 instruction set',
                'tm'=>'"Thermal Monitor" Thermal throttling with IDLE instructions. Usually hardware controlled in response to CPU temperature.',
                'tm2'=>'"Thermal Monitor 2″ Decrease speed by reducing multipler and vcore.',
                'est'=>'"Enhanced SpeedStep"'
            ],
        ];
    }

    public static function cpuStatExplain(){
        return [
            'user (432661) 从系统启动开始累计到当前时刻，用户态的CPU时间（单位：jiffies） ，不包含 nice值为负进程。1jiffies=0.01秒',
            'nice (13295) 从系统启动开始累计到当前时刻，nice值为负的进程所占用的CPU时间（单位：jiffies） ',
            'system (86656) 从系统启动开始累计到当前时刻，核心时间（单位：jiffies） ',
            'idle (422145968) 从系统启动开始累计到当前时刻，除硬盘IO等待时间以外其它等待时间（单位：jiffies） ',
            'iowait (171474) 从系统启动开始累计到当前时刻，硬盘IO等待时间（单位：jiffies） ，',
            'irq (233) 从系统启动开始累计到当前时刻，硬中断时间（单位：jiffies） ',
            'softirq (5346) 从系统启动开始累计到当前时刻，软中断时间（单位：jiffies） ',
            'CPU时间=user+system+nice+idle+iowait+irq+softirq',
            "intr"=>'这行给出中断的信息，第一个为自系统启动以来，发生的所有的中断的次数；然后每个数对应一个特定的中断自系统启动以来所发生的次数。',
            "ctxt"=>'给出了自系统启动以来CPU发生的上下文交换的次数。',
            "btime"=>'给出了从系统启动到现在为止的时间，单位为秒。',
            "processes"=>'(total_forks) 自系统启动以来所创建的任务的个数目。',
            "procs_running"=>'当前运行队列的任务的数目。',
            "procs_blocked"=>'当前被阻塞的任务的数目。'
        ];
    }

    public static $process=[];
    public static function getCPUUse(){
        if (false === ($data= @file('/proc/stat'))) return false;
        $cores= array();
        $other=array();
        foreach($data as $line) {
            if(preg_match('/^cpu[0-9]/',$line)){
                $info= explode(' ',$line);
                $cores[]=array('user'=>$info[1],'nice'=>$info[2],'sys'=> $info[3],'idle'=>$info[4],'iowait'=>$info[5],'irq'=> $info[6],'softirq'=> $info[7]);
            }else{
                $tmp=explode(' ',$line);
                $tmp=array_filter($tmp);
                if(count($tmp)==2){
                    $other[trim($tmp[0])]=trim($tmp[1]);
                }
            }
        }
        static::$process=$other;
        return $cores;
    }
    public static function getCPUPercent($CPU1,$CPU2){
        $num= count($CPU1);
        if($num!==count($CPU2))return false;
        $cpus= array();
        for($i=0;$i < $num;$i++) {
            $dif= array();
            $dif['user']    =$CPU2[$i]['user'] -$CPU1[$i]['user'];
            $dif['nice']    =$CPU2[$i]['nice'] -$CPU1[$i]['nice'];
            $dif['sys']     =$CPU2[$i]['sys'] -$CPU1[$i]['sys'];
            $dif['idle']    =$CPU2[$i]['idle'] -$CPU1[$i]['idle'];
            $dif['iowait']  =$CPU2[$i]['iowait'] -$CPU1[$i]['iowait'];
            $dif['irq']     =$CPU2[$i]['irq'] -$CPU1[$i]['irq'];
            $dif['softirq'] =$CPU2[$i]['softirq'] -$CPU1[$i]['softirq'];
            $total= array_sum($dif);
            $cpu= array();
            foreach($dif as $x=>$y)
                $cpu[$x] =round($y/($total?:1)*100, 2);
            $cpus['cpu'.$i] = $cpu;
        }
        return $cpus;
    }

    public static function getCPU(){
        $cache=\yii::$app->getCache();
        $key=[__METHOD__,'cpu1'];
        $CPU1=$cache->get($key);
        if($CPU1==false){
            $CPU1= static::getCPUUse();
            if($CPU1==false){
                return false;
            }
            sleep(1);
        }
        $CPU2= static::getCPUUse();
        $cache->set($key,$CPU2,2);
        return  static::getCPUPercent($CPU1,$CPU2);
//        return $data['cpu0']['user']."%us,  ".$data['cpu0']['sys']."%sy,  ".$data['cpu0']['nice']."%ni, ".$data['cpu0']['idle']."%id,  ".$data['cpu0']['iowait']."%wa,  ".$data['cpu0']['irq']."%irq,  ".$data['cpu0']['softirq']."%softirq";
    }


    public static function getAll(){
        $data=[];
        $df=System::getDf();
        if(is_array($df)){
            $data['df']=$df;
        }

        $mem=System::getMem();
        if(is_array($mem)){
            $data['MemTotal']=$mem['MemTotal']['value'];
            $data['MemTotal_unit']=$mem['MemTotal']['unit'];
            $data['MemFree']=$mem['MemFree']['value'];
            $data['MemFree_unit']=$mem['MemFree']['unit'];

            $data['MemAvailable']=$mem['MemAvailable']['value'];
            $data['MemAvailable_unit']=$mem['MemAvailable']['unit'];

            $data['MemUsed']=$mem['MemTotal']['value']-static::memUnitValue($mem['MemFree'],$mem['MemTotal']['unit']);
            $data['MemRealUsed']=$mem['MemTotal']['value']-static::memUnitValue($mem['MemAvailable'],$mem['MemTotal']['unit']);
            $data['MemPercent']=round($data['MemUsed']/($data['MemTotal']<1?1:$data['MemTotal'])*100,2);
            $data['MemRealPercent']=round($data['MemRealUsed']/($data['MemTotal']*100?:1),2);

            $data['SwapTotal']=$mem['SwapTotal']['value'];
            $data['SwapTotal_unit']=$mem['SwapTotal']['unit'];
            $data['SwapFree']=$mem['SwapFree']['value'];
            $data['SwapFree_unit']=$mem['SwapFree']['unit'];

            $data['SwapUsed']=round($data['SwapTotal']-static::memUnitValue($mem['SwapFree'],$data['SwapTotal']['unit']),6);
            $data['SwapPercent']=round($data['SwapUsed']/($data['SwapTotal']<1?1:$data['SwapTotal'])*100,2);

            $data['Cached']=$mem['Cached']['value'];
            $data['Cached_unit']=$mem['Cached']['unit'];
            $data['Buffers']=$mem['Buffers']['value'];
            $data['Buffers_unit']=$mem['Buffers']['unit'];
            $data['CachedPercent']=round( (static::memUnitValue($mem['Cached'],$data['MemTotal']['unit'])/($data['MemTotal']<1?1:$data['MemTotal'])*100),2);

            $data['VmallocTotal']=$mem['VmallocTotal']['value'];
            $data['VmallocTotal_unit']=$mem['VmallocTotal']['unit'];
            $data['VmallocUsed']=$mem['VmallocUsed']['value'];
            $data['VmallocUsed_unit']=$mem['VmallocUsed']['unit'];
            $data['VmallocPercent']=round(static::memUnitValue($mem['VmallocUsed'],$data['VmallocTotal_unit'])/($data['VmallocTotal']<1?1:$data['VmallocTotal'])*100,2);
            $data['VmallocPercenta']=static::memUnitValue($mem['VmallocUsed'],$data['VmallocTotal_unit']);
        }
        $cpus=System::getCpu();
        if(is_array($cpus)){
            $data['cpu']=array_keys($cpus);
            if(is_array($cpus)) {
                foreach ($cpus as $k=>$cpu){
                    $data[$k]['sys'] = $cpu['sys'];
                    $data[$k]['nice'] = $cpu['nice'];
                    $data[$k]['idle'] = $cpu['idle'];
                    $data[$k]['iowait'] = $cpu['iowait'];
                    $data[$k]['irq'] = $cpu['irq'];
                    $data[$k]['softirq'] = $cpu['softirq'];
                }
                $process=static::$process;
                $data['processes']=$process['processes'];
                $data['procs_running']=$process['procs_running'];
                $data['procs_blocked']=$process['procs_blocked'];
            }
        }

        return $data;
    }

    public static function memUnitValue($data,$unit){
        $unit=trim($unit);
        if(!isset($data['value']) && !isset($data['unit'])){
            return false;
        }
        $data['unit']=trim($data['unit']);
        if( !isset(static::$unitlevel[$unit]) || !isset(static::$unitlevel[$data['unit']]) || $data['unit']==$unit){
            return $data['value'];
        }
        $subLevel=static::$unitlevel[$unit]-static::$unitlevel[$data['unit']];
        if($subLevel>0){
            return round($data['value']/($subLevel*1024),6);
        }else{
            return $subLevel*1024*$data['value'];
        }

    }

}