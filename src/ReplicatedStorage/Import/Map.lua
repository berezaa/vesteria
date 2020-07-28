--[[
    Implementation Example:

    {
        container = basically the singlemost top ancestor of where all the files are located,
        map = { -- list of all of the files (in string form)
            "module",

            "folder/module"
        }
    };
]]

return {
    {
        container = game:GetService("ReplicatedStorage"),
        map = {
            "monsterLookup",

            "dialogue/genericShopkeeper",
            "dialogue/testNPCDialog",
        };
    }
}