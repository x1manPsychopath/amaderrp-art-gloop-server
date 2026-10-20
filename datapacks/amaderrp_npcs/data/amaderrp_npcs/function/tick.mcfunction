execute as @a unless score @s npc_greet_cooldown matches 0.. run scoreboard players set @s npc_greet_cooldown 0
execute as @a unless score @s npc_dialogue matches 0.. run scoreboard players set @s npc_dialogue 0
scoreboard players remove @a[scores={npc_greet_cooldown=1..}] npc_greet_cooldown 1
execute as @a[tag=!npc_near_elder,scores={npc_greet_cooldown=0}] at @s if entity @e[type=minecraft:villager,tag=community_npc_elder,distance=..8,limit=1] run function amaderrp_npcs:proximity/elder
execute as @a[tag=npc_near_elder] at @s unless entity @e[type=minecraft:villager,tag=community_npc_elder,distance=..12,limit=1] run tag @s remove npc_near_elder

