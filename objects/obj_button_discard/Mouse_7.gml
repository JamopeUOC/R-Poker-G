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
                
                //sfx
                var pitch = random_range(0.64, 0.85);
                audio_play_sound(snd_sfx_card1, 1, false, 1, 0, pitch);
            }
        }
        selected_cards = [];
        obj_game.discardsDone++;
    }
}