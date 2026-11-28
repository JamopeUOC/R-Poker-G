// Inherit the parent event
if (global.gameState != GameState.PLAYERTURN) exit;
event_inherited();

with (obj_player) {
    var playerSelectedCards = array_length(selected_cards);
    var enemySelectedCards = array_length(selected_cards_enemy);
    var condition = playerSelectedCards > 0 && enemySelectedCards > 0 && playerSelectedCards == enemySelectedCards;

    if (condition && !maxChangesDone() && !hand_busy(id) && !hand_busy(obj_enemy)) {
        for (var i = 0; i < playerSelectedCards; i++) {
            swapCards(selected_cards[i], selected_cards_enemy[i]);
        }

        selected_cards = [];
        selected_cards_enemy = [];
        obj_game.swapsDone++;
        
    }
}