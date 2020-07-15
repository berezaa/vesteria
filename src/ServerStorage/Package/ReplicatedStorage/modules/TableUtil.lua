local dc={}local _d=game:GetService("HttpService")local ad=table.find
local function bd(bba)
assert(
type(bba)=="table","First argument must be a table")local cba=table.create(#bba)
for dba,_ca in pairs(bba)do if(type(_ca)=="table")then
cba[dba]=bd(_ca)else cba[dba]=_ca end end;return cba end;local function cd(bba)local cba=table.create(#bba)
for dba,_ca in pairs(bba)do cba[dba]=_ca end;return cba end
local function dd(bba,cba)
assert(type(bba)==
"table","First argument must be a table")
assert(type(cba)=="table","Second argument must be a table")
for dba,_ca in pairs(bba)do local aca=cba[dba]
if(aca==nil)then bba[dba]=nil elseif(type(_ca)~=type(aca))then
if(
type(aca)=="table")then bba[dba]=bd(aca)else bba[dba]=aca end elseif(type(_ca)=="table")then dd(_ca,aca)end end;for dba,_ca in pairs(cba)do local aca=bba[dba]
if(aca==nil)then if(type(_ca)=="table")then
bba[dba]=bd(_ca)else bba[dba]=_ca end end end end
local function __a(bba,cba)local dba=#bba;bba[cba]=bba[dba]bba[dba]=nil end
local function a_a(bba,cba)
assert(type(bba)=="table","First argument must be a table")
assert(type(cba)=="function","Second argument must be an array")local dba=table.create(#bba)for _ca,aca in pairs(bba)do
dba[_ca]=cba(aca,_ca,bba)end;return dba end
local function b_a(bba,cba)
assert(type(bba)=="table","First argument must be a table")
assert(type(cba)=="function","Second argument must be an array")local dba=table.create(#bba)
if(#bba>0)then local _ca=0
for i=1,#bba do local aca=bba[i]if
(cba(aca,i,bba))then _ca=(_ca+1)dba[_ca]=aca end end else
for _ca,aca in pairs(bba)do if(cba(aca,_ca,bba))then dba[_ca]=aca end end end;return dba end
local function c_a(bba,cba,dba)
assert(type(bba)=="table","First argument must be a table")
assert(type(cba)=="function","Second argument must be an array")
assert(dba==nil or type(dba)=="number","Third argument must be a number or nil")local _ca=(dba or 0)
for aca,bca in pairs(bba)do _ca=cba(_ca,bca,aca,bba)end;return _ca end;local function d_a(bba,...)
for cba,dba in ipairs({...})do for _ca,aca in pairs(dba)do bba[_ca]=aca end end;return bba end
local function _aa(bba,cba,dba)
assert(
type(bba)=="table","First argument must be a table")
assert(cba==nil or type(cba)=="string","Second argument must be a string or nil")cba=(cba or"TABLE")local _ca={}local aca=" - "local function bca(_da,ada)
_ca[#_ca+1]=(aca:rep(ada).._da.."\n")end;local function cca(_da,ada)return
(tostring(_da.k)<tostring(ada.k))end
local function dca(_da,ada,bda)
bca(bda..":",ada-1)local cda={}local dda={}local __b=0
for a_b,b_b in pairs(_da)do if(type(b_b)=="table")then
table.insert(dda,{k=a_b,v=b_b})else
table.insert(cda,{k=a_b,v="["..typeof(b_b).."] "..tostring(b_b)})end;local c_b=#
tostring(a_b)+1;if(c_b>__b)then __b=c_b end end;table.sort(cda,cca)table.sort(dda,cca)for a_b,b_b in ipairs(cda)do
bca(
tostring(b_b.k)..":"..
(" "):rep(__b-#tostring(b_b.k))..b_b.v,ada)end
if(dba)then for a_b,b_b in ipairs(dda)do
dca(b_b.v,ada+1,
tostring(b_b.k)..
(" "):rep(__b-#tostring(b_b.k)).." [Table]")end else for a_b,b_b in ipairs(dda)do
bca(
tostring(b_b.k)..":"..
(" "):rep(__b-#tostring(b_b.k)).."[Table]",ada)end end end;dca(bba,1,cba)print(table.concat(_ca,""))end;local function aaa(bba)local cba=#bba;local dba=table.create(cba)
for i=1,cba do dba[i]=bba[cba-i+1]end;return dba end
local function baa(bba)
assert(
type(bba)=="table","First argument must be a table")local cba=Random.new()for i=#bba,2,-1 do local dba=cba:NextInteger(1,i)
bba[i],bba[dba]=bba[dba],bba[i]end end;local function caa(bba)return(next(bba)==nil)end;local function daa(bba)
return _d:JSONEncode(bba)end
local function _ba(bba)return _d:JSONDecode(bba)end;local function aba(bba,cba)local dba=ad(bba,cba)if(dba)then __a(bba,dba)return true,dba end;return false,
nil end
dc.Copy=bd;dc.CopyShallow=cd;dc.Sync=dd;dc.FastRemove=__a;dc.FastRemoveFirstValue=aba
dc.Print=_aa;dc.Map=a_a;dc.Filter=b_a;dc.Reduce=c_a;dc.Assign=d_a;dc.IndexOf=ad
dc.Reverse=aaa;dc.Shuffle=baa;dc.IsEmpty=caa;dc.EncodeJSON=daa;dc.DecodeJSON=_ba;return dc