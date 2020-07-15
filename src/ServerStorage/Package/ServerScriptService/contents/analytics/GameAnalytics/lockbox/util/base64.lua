local bc=script.Parent.Parent;local cc=string
local dc=require(bc.util.bit)local _d=require(bc.util.array)
local ad=require(bc.util.stream)local bd=dc.band;local cd=dc.bor;local dd=dc.bnot;local __a=dc.bxor;local a_a=dc.lrotate
local b_a=dc.rrotate;local c_a=dc.lshift;local d_a=dc.rshift
local _aa={[0]="A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/"}local aaa={}for caa,daa in pairs(_aa)do aaa[caa]=daa;aaa[daa]=caa end
local baa={}
baa.fromStream=function(caa)local daa=0x00;local _ba=0;local aba={}local bba=caa()
while bba~=nil do
daa=cd(c_a(daa,8),bba)_ba=_ba+8
while _ba>=6 do _ba=_ba-6;local cba=d_a(daa,_ba)
table.insert(aba,aaa[cba])daa=bd(daa,dd(c_a(0xFFFFFFFF,_ba)))end;bba=caa()end
if(_ba==4)then daa=c_a(daa,2)table.insert(aba,aaa[daa])
table.insert(aba,"=")elseif(_ba==2)then daa=c_a(daa,4)table.insert(aba,aaa[daa])
table.insert(aba,"==")end;return table.concat(aba,"")end
baa.fromArray=function(caa)local daa=0x00;local _ba=0;local aba={}local bba=1;local cba=caa[bba]bba=bba+1
while cba~=nil do
daa=cd(c_a(daa,8),cba)_ba=_ba+8
while _ba>=6 do _ba=_ba-6;local dba=d_a(daa,_ba)
table.insert(aba,aaa[dba])daa=bd(daa,dd(c_a(0xFFFFFFFF,_ba)))end;cba=caa[bba]bba=bba+1 end
if(_ba==4)then daa=c_a(daa,2)table.insert(aba,aaa[daa])
table.insert(aba,"=")elseif(_ba==2)then daa=c_a(daa,4)table.insert(aba,aaa[daa])
table.insert(aba,"==")end;return table.concat(aba,"")end
baa.fromString=function(caa)return baa.fromArray(_d.fromString(caa))end
baa.toStream=function(caa)return ad.fromArray(baa.toArray(caa))end
baa.toArray=function(caa)local daa=0x00;local _ba=0;local aba={}
for bba in cc.gmatch(caa,".")do
if(bba=="=")then daa=d_a(daa,2)
_ba=_ba-2 else daa=c_a(daa,6)_ba=_ba+6;daa=cd(daa,aaa[bba])end;while(_ba>=8)do _ba=_ba-8;local cba=d_a(daa,_ba)table.insert(aba,cba)
daa=bd(daa,dd(c_a(0xFFFFFFFF,_ba)))end end;return aba end
baa.toString=function(caa)local daa=0x00;local _ba=0;local aba={}
for bba in cc.gmatch(caa,".")do
if(bba=="=")then daa=d_a(daa,2)_ba=_ba-
2 else daa=c_a(daa,6)_ba=_ba+6;daa=cd(daa,aaa[bba])end
while(_ba>=8)do _ba=_ba-8;local cba=d_a(daa,_ba)
table.insert(aba,cc.char(cba))daa=bd(daa,dd(c_a(0xFFFFFFFF,_ba)))end end;return table.concat(aba,"")end;return baa