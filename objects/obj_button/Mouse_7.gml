mousein = false;
target_xscale = start_xscale;
target_yscale = start_yscale;

if (global.gameState != GameState.PLAYERTURN) exit;

if (label == "Play Hand") {
    if (array_length(obj_player.selected_cards) >= 1) {
        if (obj_game.startsplayer) {
            global.gameState = GameState.ENEMYTURN;
        } else {
            global.gameState = GameState.RESOLUTION;
        }
    }
} else if (label == "Discard") {
    with (obj_player) {
        if (array_length(selected_cards) > 0 && !maxDiscardsDone()) {
            for (var i = 0; i < array_length(selected_cards); i++) {
                var _inst = selected_cards[i].object;
                if (instance_exists(_inst)) {
                    _inst.discarded = true;
                    _inst.moving = true;
                    _inst.selected = false;
                }
            }
            selected_cards = [];
            obj_game.discardsDone++;
        }
    }
}