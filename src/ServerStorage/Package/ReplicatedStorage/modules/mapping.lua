local b={}b.equipmentPosition={}b.equipmentPosition.weapon=1
b.equipmentPosition.head=2;b.equipmentPosition.body=3
b.equipmentPosition["left arm"]=4;b.equipmentPosition["right arm"]=5
b.equipmentPosition["left leg"]=6;b.equipmentPosition["right leg"]=7
b.equipmentPosition["upper"]=8;b.equipmentPosition["lower"]=9
b.equipmentPosition["pet"]=10;b.equipmentPosition["offhand"]=11
b.equipmentPosition["arrow"]=12;b.dataType={}b.dataType.item=1;b.dataType.ability=2;b.gripType={}
b.gripType.right=1;b.gripType.left=2;b.gripType.both=2;b.equipmentHairType={}
b.equipmentHairType.all=1;b.equipmentHairType.partial=2;b.equipmentHairType.none=3
b.accountBanState={}b.accountBanState.warned=1;b.accountBanState.day1=2
b.accountBanState.day3=3;b.accountBanState.day7=4;b.accountBanState.permanent=5
b.questState={}b.questState.accepted=1;b.questState.active=2
b.questState.completed=3;b.questState.cooldown=4;b.questState.insufficient=5
b.questState.denied=6;b.questState.handing=7;b.questState.unassigned=8
b.questState.objectiveDone=9;b.accessoryType={}b.accessoryType.hair=1
b.accessoryType.skin=2;b.accessoryType.eyebrow=3;b.accessoryType.undershirt=4
b.accessoryType.underwear=5;function b.getMappingByValue(c,d)for _a,aa in pairs(b[c])do if aa==d then return _a end end
return nil end;return b