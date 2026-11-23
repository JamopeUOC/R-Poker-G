// Inherit the parent event
if (global.gameState != GameState.PLAYERTURN) exit;
event_inherited();

if (array_length(obj_player.selected_cards) >= 1) {
    global.gameState = GameState.ENEMYTURN;
}