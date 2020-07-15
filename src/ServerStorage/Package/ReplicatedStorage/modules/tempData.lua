local b={data={}}function b:set(c,d,_a)
if not self.data[c]then self.data[c]={}end;self.data[c][d]=_a end
function b:get(c,d)if
self.data[c]then return self.data[c][d]end end;function b:delete(c,d)if not self.data[c]then return end
self.data[c][d]=nil end;return b