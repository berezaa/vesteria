local b={}
for c,d in
pairs(require(game.ReplicatedStorage.monsterLookup))do b[c.."1/2"]={maxMonsters=5}b[c]={maxMonsters=10}
b[c.."2"]={maxMonsters=15}b[c.."3"]={maxMonsters=35}b[c.."0"]={maxMonsters=1}end;return b