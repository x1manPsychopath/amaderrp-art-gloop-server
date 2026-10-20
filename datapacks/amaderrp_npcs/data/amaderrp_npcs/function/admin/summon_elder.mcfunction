kill @e[type=minecraft:villager,tag=community_npc_elder,distance=..16]
summon minecraft:villager ~ ~ ~ {Tags:["community_npc","community_npc_elder"],PersistenceRequired:1b,Invulnerable:1b,NoAI:1b,Silent:1b,CustomName:'{"text":"Elder Gloop","color":"aqua","bold":true}',CustomNameVisible:1b,VillagerData:{profession:"minecraft:librarian",level:5,type:"minecraft:plains"}}
tellraw @s [{"text":"[AmaDerrp NPCs] ","color":"aqua","bold":true},{"text":"Elder Gloop was placed at your position.","color":"green"}]

