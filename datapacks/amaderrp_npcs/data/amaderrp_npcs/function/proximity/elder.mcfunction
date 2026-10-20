tag @s add npc_near_elder
scoreboard players set @s npc_greet_cooldown 200
tellraw @s [{"text":"Elder Gloop: ","color":"aqua","bold":true},{"text":"Welcome, traveler. Right-click me if you need a little local wisdom.","color":"white"}]
playsound minecraft:entity.villager.celebrate voice @s ~ ~ ~ 0.8 1.0

