local _d=script.Parent.Parent;local ad=require(_d.util.bit)
local bd=string;local cd=math;local dd=require(_d.util.queue)
local __a={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local a_a=ad.band;local b_a=ad.bor;local c_a=ad.bnot;local d_a=ad.bxor;local _aa=ad.lrotate
local aaa=ad.rrotate;local baa=ad.lshift;local caa=ad.rshift
local daa=function(dba,_ca,aca,bca)local cca=dba;cca=baa(cca,8)cca=b_a(cca,_ca)
cca=baa(cca,8)cca=b_a(cca,aca)cca=baa(cca,8)cca=b_a(cca,bca)return cca end
local _ba=function(dba)local _ca,aca,bca,cca;cca=a_a(dba,0xFF)dba=caa(dba,8)bca=a_a(dba,0xFF)
dba=caa(dba,8)aca=a_a(dba,0xFF)dba=caa(dba,8)_ca=a_a(dba,0xFF)
return _ca,aca,bca,cca end
local aba=function(dba,_ca,aca,bca,cca,dca,_da,ada)local bda=daa(dba,_ca,aca,bca)local cda=daa(cca,dca,_da,ada)return
(bda*0x100000000)+cda end
local bba=function(dba)local _ca,aca,bca,cca=_ba(dba)
local dca,_da,ada,bda=_ba(cd.floor(dba/0x100000000))return dca,_da,ada,bda,_ca,aca,bca,cca end
local cba=function()local dba=dd()local _ca=0x6a09e667;local aca=0xbb67ae85;local bca=0x3c6ef372;local cca=0xa54ff53a
local dca=0x510e527f;local _da=0x9b05688c;local ada=0x1f83d9ab;local bda=0x5be0cd19;local cda={}
local dda=function()local __b=_ca;local a_b=aca
local b_b=bca;local c_b=cca;local d_b=dca;local _ab=_da;local aab=ada;local bab=bda;local cab={}for i=0,15 do
cab[i]=daa(dba.pop(),dba.pop(),dba.pop(),dba.pop())end
game:GetService("RunService").Heartbeat:Wait()
for i=16,63 do if i%20 ==0 then
game:GetService("RunService").Heartbeat:Wait()end
local dab=d_a(aaa(cab[i-15],7),d_a(aaa(cab[i-15],18),caa(cab[
i-15],3)))
local _bb=d_a(aaa(cab[i-2],17),d_a(aaa(cab[i-2],19),caa(cab[i-2],10)))
cab[i]=a_a(cab[i-16]+dab+cab[i-7]+_bb,0xFFFFFFFF)end
for i=0,63 do if i%12 ==0 then
game:GetService("RunService").Heartbeat:Wait()end
local dab=d_a(aaa(d_b,6),d_a(aaa(d_b,11),aaa(d_b,25)))local _bb=d_a(a_a(d_b,_ab),a_a(c_a(d_b),aab))local abb=
bab+dab+_bb+__a[i+1]+cab[i]
local bbb=d_a(aaa(__b,2),d_a(aaa(__b,13),aaa(__b,22)))
local cbb=d_a(a_a(__b,a_b),d_a(a_a(__b,b_b),a_a(a_b,b_b)))local dbb=bbb+cbb;bab=aab;aab=_ab;_ab=d_b;d_b=c_b+abb;c_b=b_b;b_b=a_b;a_b=__b
__b=abb+dbb end;_ca=a_a(_ca+__b,0xFFFFFFFF)
aca=a_a(aca+a_b,0xFFFFFFFF)bca=a_a(bca+b_b,0xFFFFFFFF)
cca=a_a(cca+c_b,0xFFFFFFFF)dca=a_a(dca+d_b,0xFFFFFFFF)
_da=a_a(_da+_ab,0xFFFFFFFF)ada=a_a(ada+aab,0xFFFFFFFF)
bda=a_a(bda+bab,0xFFFFFFFF)
game:GetService("RunService").Heartbeat:Wait()end
cda.init=function()dba.reset()_ca=0x6a09e667;aca=0xbb67ae85;bca=0x3c6ef372
cca=0xa54ff53a;dca=0x510e527f;_da=0x9b05688c;ada=0x1f83d9ab;bda=0x5be0cd19;return cda end
cda.update=function(__b)
for a_b in __b do dba.push(a_b)if dba.size()>=64 then dda()end end;return cda end
cda.finish=function()local __b=dba.getHead()*8;dba.push(0x80)while(
(dba.size()+7)%64)<63 do dba.push(0x00)end
local a_b,b_b,c_b,d_b,_ab,aab,bab,cab=bba(__b)dba.push(a_b)dba.push(b_b)dba.push(c_b)
dba.push(d_b)dba.push(_ab)dba.push(aab)dba.push(bab)
dba.push(cab)while dba.size()>0 do dda()end;return cda end
cda.asBytes=function()local __b,a_b,b_b,c_b=_ba(_ca)local d_b,_ab,aab,bab=_ba(aca)local cab,dab,_bb,abb=_ba(bca)
local bbb,cbb,dbb,_cb=_ba(cca)local acb,bcb,ccb,dcb=_ba(dca)local _db,adb,bdb,cdb=_ba(_da)local ddb,__c,a_c,b_c=_ba(ada)
local c_c,d_c,_ac,aac=_ba(bda)return
{__b,a_b,b_b,c_b,d_b,_ab,aab,bab,cab,dab,_bb,abb,bbb,cbb,dbb,_cb,acb,bcb,ccb,dcb,_db,adb,bdb,cdb,ddb,__c,a_c,b_c,c_c,d_c,_ac,aac}end
cda.asHex=function()local __b,a_b,b_b,c_b=_ba(_ca)local d_b,_ab,aab,bab=_ba(aca)local cab,dab,_bb,abb=_ba(bca)
local bbb,cbb,dbb,_cb=_ba(cca)local acb,bcb,ccb,dcb=_ba(dca)local _db,adb,bdb,cdb=_ba(_da)local ddb,__c,a_c,b_c=_ba(ada)
local c_c,d_c,_ac,aac=_ba(bda)
local bac="%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x"return
bd.format(bac,__b,a_b,b_b,c_b,d_b,_ab,aab,bab,cab,dab,_bb,abb,bbb,cbb,dbb,_cb,acb,bcb,ccb,dcb,_db,adb,bdb,cdb,ddb,__c,a_c,b_c,c_c,d_c,_ac,aac)end;return cda end;return cba