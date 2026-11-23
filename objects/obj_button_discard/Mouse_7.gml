// Inherit the parent event

if (global.gameState != GameState.PLAYERTURN) exit;
event_inherited();
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