// Inherit the parent event
event_inherited();

if (array_length(obj_player.selected_cards) >= 1) {
    if (obj_game.startsplayer) {
        global.gameState = GameState.ENEMYTURN;
    } else {
        global.gameState = GameState.RESOLUTION;
    }
}