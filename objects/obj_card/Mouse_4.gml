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