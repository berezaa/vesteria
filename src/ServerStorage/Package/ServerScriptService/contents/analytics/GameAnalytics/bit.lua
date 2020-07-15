
local __a={_TYPE='module',_NAME='bit.numberlua',_VERSION='0.3.1.20120131'}__a.bits=32;local a_a=math.floor;local b_a=2 ^32;local c_a=b_a-1
local function d_a(dda)local __b={}
local a_b=setmetatable({},__b)
function __b:__index(b_b)local c_b=dda(b_b)a_b[b_b]=c_b;return c_b end;return a_b end
local function _aa(dda,__b)
local function a_b(b_b,c_b)local d_b,_ab=0,1
while b_b~=0 and c_b~=0 do local aab,bab=b_b%__b,c_b%__b;d_b=d_b+
dda[aab][bab]*_ab;b_b=(b_b-aab)/__b;c_b=(c_b-bab)/__b;_ab=
_ab*__b end;d_b=d_b+ (b_b+c_b)*_ab;return d_b end;return a_b end
local function aaa(dda)local __b=_aa(dda,2 ^1)
local a_b=d_a(function(b_b)return
d_a(function(c_b)return __b(b_b,c_b)end)end)return _aa(a_b,2 ^ (dda.n or 1))end;function __a.tobit(dda)return dda%2 ^32 end;__a.cast=__a.tobit
__a.bxor=aaa{[0]={[0]=0,[1]=1},[1]={[0]=1,[1]=0},n=4}local baa=__a.bxor;function __a.bnot(dda)return c_a-dda end;local caa=__a.bnot
function __a.band(dda,__b)return( (dda+
__b)-baa(dda,__b))/2 end;local daa=__a.band
function __a.bor(dda,__b)return c_a-daa(c_a-dda,c_a-__b)end;local _ba=__a.bor;local aba,bba
function __a.rshift(dda,__b)if __b<0 then return aba(dda,-__b)end;return a_a(
dda%2 ^32 /2 ^__b)end;bba=__a.rshift;function __a.lshift(dda,__b)if __b<0 then return bba(dda,-__b)end;return
(dda*2 ^__b)%2 ^32 end
aba=__a.lshift
function __a.tohex(dda,__b)__b=__b or 8;local a_b
if __b<=0 then if __b==0 then return''end;a_b=true;__b=-__b end;dda=daa(dda,16 ^__b-1)return
('%0'..__b.. (a_b and'X'or'x')):format(dda)end;local cba=__a.tohex;function __a.extract(dda,__b,a_b)a_b=a_b or 1
return daa(bba(dda,__b),2 ^a_b-1)end;local dba=__a.extract
function __a.replace(dda,__b,a_b,b_b)
b_b=b_b or 1;local c_b=2 ^b_b-1;__b=daa(__b,c_b)local d_b=caa(aba(c_b,a_b))return
daa(dda,d_b)+aba(__b,a_b)end;local _ca=__a.replace
function __a.bswap(dda)local __b=daa(dda,0xff)dda=bba(dda,8)
local a_b=daa(dda,0xff)dda=bba(dda,8)local b_b=daa(dda,0xff)dda=bba(dda,8)
local c_b=daa(dda,0xff)return
aba(aba(aba(__b,8)+a_b,8)+b_b,8)+c_b end;local aca=__a.bswap
function __a.rrotate(dda,__b)__b=__b%32;local a_b=daa(dda,2 ^__b-1)return
bba(dda,__b)+aba(a_b,32 -__b)end;local bca=__a.rrotate;function __a.lrotate(dda,__b)return bca(dda,-__b)end
local cca=__a.lrotate;__a.rol=__a.lrotate;__a.ror=__a.rrotate;function __a.arshift(dda,__b)local a_b=bba(dda,__b)
if dda>=
0x80000000 then a_b=a_b+aba(2 ^__b-1,32 -__b)end;return a_b end
local dca=__a.arshift;function __a.btest(dda,__b)return daa(dda,__b)~=0 end
__a.bit32=bit32;__a.bit={}__a.bit.bits=__a.bits;__a.bit.cast=__a.cast
function __a.bit.tobit(dda)dda=
dda%b_a;if dda>=0x80000000 then dda=dda-b_a end;return dda end;local _da=__a.bit.tobit
function __a.bit.tohex(dda,...)return cba(dda%b_a,...)end;function __a.bit.bnot(dda)return _da(caa(dda%b_a))end
local function ada(dda,__b,a_b,...)if a_b then return
ada(ada(dda,__b),a_b,...)elseif __b then return _da(_ba(dda%b_a,__b%b_a))else return
_da(dda)end end;__a.bit.bor=ada
local function bda(dda,__b,a_b,...)
if a_b then return bda(bda(dda,__b),a_b,...)elseif __b then return _da(daa(dda%b_a,
__b%b_a))else return _da(dda)end end;__a.bit.band=bda
local function cda(dda,__b,a_b,...)
if a_b then return cda(cda(dda,__b),a_b,...)elseif __b then return _da(baa(dda%b_a,
__b%b_a))else return _da(dda)end end;__a.bit.bxor=cda;function __a.bit.lshift(dda,__b)
return _da(aba(dda%b_a,__b%32))end;function __a.bit.rshift(dda,__b)return
_da(bba(dda%b_a,__b%32))end;function __a.bit.arshift(dda,__b)return
_da(dca(dda%b_a,__b%32))end;function __a.bit.rol(dda,__b)return
_da(cca(dda%b_a,__b%32))end;function __a.bit.ror(dda,__b)return
_da(bca(dda%b_a,__b%32))end;function __a.bit.bswap(dda)return
_da(aca(dda%b_a))end;return __a