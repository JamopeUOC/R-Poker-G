// Inherit the parent event
event_inherited();

with (obj_player) {
    if(!maxErasesDone()) {
        for (var i = 0; i < array_length(hand); i++) {
            var _inst = hand[i].object;
            if (instance_exists(_inst)) {
                _inst.discarded = true;
                _inst.moving = true;
                _inst.selected = false;
            }
        }
        selected_cards = [];
        obj_game.eraseDone++;
    }
}
