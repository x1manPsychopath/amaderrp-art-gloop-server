execute if score @s npc_dialogue matches 0 run function amaderrp_npcs:dialogue/elder_1
execute if score @s npc_dialogue matches 1 run function amaderrp_npcs:dialogue/elder_2
execute if score @s npc_dialogue matches 2 run function amaderrp_npcs:dialogue/elder_3
scoreboard players add @s npc_dialogue 1
execute if score @s npc_dialogue matches 3.. run scoreboard players set @s npc_dialogue 0
advancement revoke @s only amaderrp_npcs:talk_to_elder

