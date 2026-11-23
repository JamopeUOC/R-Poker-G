// Inherit the parent event
if (global.gameState != GameState.PLAYERTURN) exit;
event_inherited();

with (obj_player) {
    var playerSelectedCards = array_length(selected_cards);
    var enemySelectedCards = array_length(selected_cards_enemy);
    var condition = playerSelectedCards > 0 && enemySelectedCards > 0 && playerSelectedCards == enemySelectedCards;

    if (condition && !maxChangesDone() && !hand_busy(id) && !hand_busy(obj_enemy)) {
        for (var i = 0; i < playerSelectedCards; i++) {
            var _pCard = selected_cards[i];
            var _eCard = selected_cards_enemy[i];

            // Posición de cada carta en su mano
            var _pIdx = array_get_index(hand, _pCard);
            var _eIdx = array_get_index(obj_enemy.hand, _eCard);
            if (_pIdx == -1 || _eIdx == -1) continue;

            var _pInst = _pCard.object;
            var _eInst = _eCard.object;
            if (!instance_exists(_pInst) || !instance_exists(_eInst)) continue;

            // Intercambiar en los arrays de las manos
            hand[_pIdx] = _eCard;
            obj_enemy.hand[_eIdx] = _pCard;

            // Mi carta pasa al rival boca abajo en el hueco de la carta rival
            _pInst.owner = obj_enemy;
            _pInst.index = _eIdx;
            _pInst.hidden = true;
            _pInst.turning = false;
            _pInst.showing_front = false;

            // Se gira para mostrarse mis cartas
            _eInst.owner = obj_player;
            _eInst.index = _pIdx;
            _eInst.hidden = false;
            _eInst.turning = true;

            // Deseleccionar y animar hacia su nueva posición
            var _tmpDepth = _pInst.depth;
            _pInst.depth = _eInst.depth;
            _eInst.depth = _tmpDepth;

            _pInst.selected = false;
            _eInst.selected = false;
            _pInst.mousein = false;
            _eInst.mousein = false;
            _pInst.moving = true;
            _eInst.moving = true;
        }

        selected_cards = [];
        selected_cards_enemy = [];
        obj_game.changesDone++;
    }
}