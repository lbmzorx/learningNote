<?php
/**
 * Created for advanced-admin.
 * User: aa
 * Date: 2018/4/10 10:13
 */
namespace admin\widgets;


use admin\tool\System;
class SystemDfInfo extends SystemInfo
{
    public $dfOption=[];
    public $dfBarOption=[];

    public function run()
    {
        echo $this->renderDf();
    }

    public function renderDf(){
        $df=System::getDf();
        $dom='';
        foreach ($df as $k=>$v){
            $id=str_replace('/','_',$k);
            $info="磁盘{$k}:<span id='system-df-total-{$id}'>{$v['total']}</span>&nbsp;<span id='system-df-total-unit'>{$v['unit']}</span>&nbsp;&nbsp;
                        <a href=\"#\" title=\"磁盘current显示的是网站所在的目录的可用空间，非服务器上所有磁盘之可用空间！\">可用空间: </a>
                        <span id='system-df-free-{$id}'>{$v['free']}</span>&nbsp;<span id='system-df-free-unit'>{$v['unit']}</span> 已使用：
                        <span id='system-df-used-{$id}'>{$v['used']}</span> <span id='system-df-used-unit'>{$v['unit']}</span>";
            $dom.='<div class=\'system-df\' id="system-df-'.$id.'">'.$info.$this->renderProcess(100,$v['percent'],0,$this->dfOption,$this->dfBarOption).'</div>';
        }
        return $dom;
    }
}