-- VESTERIA NPC INSTRUCTIONS 


-- Please use this rig as a template whenever you create NPC's for Vesteria. 

-- In Vesteria, NPC's are animated, which requires them to be properly rigged.
-- This template is rigged in the required way, which will allow us to throw your NPC
-- into the game as soon as we get it!

-- RULES:
--[[
	
	#1 	NO SCRIPTS! 
		If we find any scripts in your NPC besides the NPCWelder script, your NPC will be rejected.
		Please let us know if you have suggestions for something cool your NPC can do, and we may implement it.
			
	#2	DO NOT TOUCH THE DEFAULT "NPCWelder" SCRIPT. 
		Studio may display an error that the source could not be properly
		loaded. That's fine! It will work when inserted into Vesteria
		
	#3	DO NOT WELD ANYTHING! 
		We have a script that will automatically weld clothing to your NPC... which brings us
		to the next rule:
		
	#4	PARENT CLOTHING/NON-BODY PARTS TO THE BODY PART YOU WANT THEM TO BE ATTACHED TO. 
		For example, if you had a shirt, you would parent the main part of the shirt to "UpperTorso". Our 
		NPCWelder script will then go through and automatically attach the clothing to that body part. 
		Parent hair, hats, eyes, etc. to the "Head" part.
		
	#5	DO NOT RENAME OR REPOSITION ANY OF THE BODY PARTS! 
		As stated earlier, this template is rigged in a very specific way, and if you rename or move any
		of the body parts, you will break the rig and your NPC will not be functional. 
		
	#6	DON'T PARENT ANYTHING DIRECTLY TO THE MODEL, DON'T TOUCH ANYTHING PARENTED DIRECTLY TO THE MODEL
		If it is parented directly under the model, it is important and you shouldn't touch it.
		If it is a clothing item or decoration, it should be parented to the part it is attached to.
		DO NOT PARENT DIRECTLY TO THE MODEL!	
		
	#7	LET US TAKE CARE OF THE REST.
		Don't worry about whether or not your clothing/decor items are Anchored or CanCollide, or how they are named,
		our script will automatically take care of those relevant properties. Just make sure they are parented
		inside the body part you want them to be attached to, and you're good!
]]
		
-- That's all! Thanks for contributing to the development of Vesteria.		
