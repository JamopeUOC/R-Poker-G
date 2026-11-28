// Inherit the parent event
if (global.gameState != GameState.PLAYERTURN) exit;
event_inherited();

if (array_length(obj_player.selected_cards) >= 1) {
    global.gameState = GameState.ENEMYTURN;
    
    if(array_length(obj_player.selected_cards_enemy) > 0) {
        for(var i = 0; i < array_length(obj_player.selected_cards_enemy); i++) {
            obj_player.selected_cards_enemy[i].object.selected = false;
        }
    }
    
    obj_player.selected_cards_enemy = [];
    
}