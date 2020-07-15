local c={}local d=0.01
function c:Expt(_a,aa,ba,ca)if math.abs(aa-_a)<d then return aa end
local da=c:Expty(_a,aa,ba,ca)local _b=(aa-_a)*da;return _a+_b end;function c:Expty(_a,aa,ba,ca)local da=1 -ba;local _b=-math.log(da)return
1 -math.exp(-_b*ca)end
function c:Sign(_a)if _a>0 then return 1 elseif
_a<0 then return-1 else return 0 end end
function c:BezierValForT(_a,aa,ba,ca,da)local _b=(1 -da)* (1 -da)* (1 -da)local ab=
3 *da* (1 -da)* (1 -da)local bb=3 *da*da* (1 -da)
local cb=da*da*da;return _b*_a+ab*aa+bb*ba+cb*ca end;c._BezierPt2ForT={x=0,y=0}
function c:BezierPt2ForT(_a,aa,ba,ca,da,_b,ab,bb,cb)
c._BezierPt2ForT.x=c:BezierValForT(_a,ba,da,ab,cb)c._BezierPt2ForT.y=c:BezierValForT(aa,ca,_b,bb,cb)return
c._BezierPt2ForT end;function c:YForPointOf2PtLine(_a,aa,ba)local ca=(_a.y-aa.y)/ (_a.x-aa.x)
local da=_a.y-ca*_a.x;return ca*ba+da end;function c:DeltaTimeToTimescale(_a)return
_a/ (1.0 /60.0)end;function c:SecondsToTick(_a)return
(1 /60.0)/_a end
function c:ExptValueInSeconds(_a,aa,ba)return 1 -
math.pow((_a/aa),1 / (60.0 *ba))end
function c:NormalizedDefaultExptValueInSeconds(_a)return self:ExptValueInSeconds(d,1,_a)end;return c