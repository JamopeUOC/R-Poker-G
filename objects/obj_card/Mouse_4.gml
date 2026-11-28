if(global.gameState == GameState.PLAYERTURN) {
    if(owner.object_index == obj_player) {
        with(obj_player) {
            var index = array_get_index(hand, other.reference);
            if(index != -1) {
                
                var index_selected = array_get_index(selected_cards, other.reference);
                
                if(index_selected != -1) {
                    array_remove(selected_cards, other.reference);
                    other.selected = false;
                } else {
                    if(array_length(selected_cards) < global.maxCardsSelected) {
                        array_push(selected_cards, hand[index]);
                        other.selected = true;
                    }
                }
            }
        }
    } else {
        with(obj_player) {
            var index = array_get_index(other.owner.hand, other.reference);
            if(index != -1) {
                
                var index_selected = array_get_index(selected_cards_enemy, other.reference);
                
                if(index_selected != -1) {
                    array_remove(selected_cards_enemy, other.reference);
                    other.selected = false;
                } else {
                    if(array_length(selected_cards_enemy) < global.maxCardsSelected) {
                        array_push(selected_cards_enemy, other.owner.hand[index]);
                        other.selected = true;
                    }
                }
            }
        }
    }
    
    //sfx
    var pitch = random_range(0.85, 1.15);
    audio_play_sound(snd_sfx_card1, 1, false, 1, 0, pitch);
}