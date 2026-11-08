if (global.gameState != GameState.ENEMYTURN) {
    ai_state = 0;
    exit;
}

if (ai_timer > 0) {
    ai_timer--;
    exit;
}

switch (ai_state) {

    //esperar a tener la mano completa y sin animaciones
    case 0:
        var _ready = !hand_busy(id)
            && (array_length(hand) >= global.maxCardsInHand || array_length(global.deck) == 0)
            && !obj_giveCards.givecards;

        if (_ready) {
            selected_cards = [];
            ai_timer = 40;
            ai_state = 1;
        }
        break;

    //evaluar y decidir descartes
    case 1:
        ai_best = enemy_find_best(hand);

        var _discards = (discards_done < max_discards)
            ? enemy_choose_discards(hand, ai_best)
            : [];

        if (array_length(_discards) > 0) {
            for (var i = 0; i < array_length(_discards); i++) {
                var _inst = _discards[i].object;
                if (instance_exists(_inst)) {
                    _inst.discarded = true;
                    _inst.moving = true;
                }
            }
            discards_done++;
            ai_state = 2;
        } else {
            ai_pick_index = 0;
            ai_state = 3;
        }
        break;

    //esperar a que roben y se recoloquen
    case 2:
        var _full = (array_length(hand) >= global.maxCardsInHand) || (array_length(global.deck) == 0);
        if (!hand_busy(id) && _full) {
            ai_timer = 30;
            ai_state = 1;
        }
        break;

    //seleccionar carta a carta
    case 3:
        if (array_length(ai_best.cards) == 0) { ai_state = 1; break; }

        if (ai_pick_index < array_length(ai_best.cards)) {
            var _card = ai_best.cards[ai_pick_index];
            array_push(selected_cards, _card);
            if (instance_exists(_card.object)) _card.object.selected = true;
            ai_pick_index++;
            ai_timer = 15;
        } else {
            ai_timer = 45;
            ai_state = 4;
        }
        break;

    // 4: terminar turno
    case 4:
        if (obj_game.startsplayer) {
            global.gameState = GameState.RESOLUTION;
        } else {
            global.gameState = GameState.PLAYERTURN;
        }
        ai_state = 0;
        break;
}