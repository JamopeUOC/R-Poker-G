switch (global.gameState) {
    case GameState.SETUP:
        if (instance_exists(obj_giveCards)) {
            obj_giveCards.givecards = true;
        }
        break;

    case GameState.RESOLUTION:
        if (res_timer > 0) {
            res_timer--;
        } else {
            switch (res_state) {

                //revelar cartas del enemigo
                case 0:
                    with (obj_enemy) {
                        for (var i = 0; i < array_length(selected_cards); i++) {
                            var _inst = selected_cards[i].object;
                            if (instance_exists(_inst)) {
                                _inst.hidden = false;
                                _inst.turning = true;
                            }
                        }
                    }
                    res_timer = 90;
                    res_state = 1;
                    break;

                //comparar y quitar vida
                case 1:
                    var _result = poker_compare(obj_player.selected_cards, obj_enemy.selected_cards);
                    if (_result > 0) obj_enemy.lifes--;
                    else if (_result < 0) obj_player.lifes--;

                    res_timer = 60;
                    res_state = 2;
                    break;

                //comprobar muerte y descartar TODA la mano
                case 2:
                    if (obj_enemy.lifes <= 0) { room_goto(rVictory); break; }
                    if (obj_player.lifes <= 0) { room_goto(rEnd); break; }

                    with (obj_player) {
                        for (var i = 0; i < array_length(hand); i++) {
                            var _inst = hand[i].object;
                            if (instance_exists(_inst)) {
                                _inst.discarded = true;
                                _inst.moving = true;
                                _inst.selected = false;
                                _inst.no_redraw = true;
                            }
                        }
                        selected_cards = [];
                    }
                    with (obj_enemy) {
                        for (var i = 0; i < array_length(hand); i++) {
                            var _inst = hand[i].object;
                            if (instance_exists(_inst)) {
                                _inst.discarded = true;
                                _inst.moving = true;
                                _inst.selected = false;
                                _inst.no_redraw = true;
                            }
                        }
                        selected_cards = [];
                    }
                    res_state = 3;
                    break;

                //cuando las manos están vacías, repartir
                case 3:
                    if (!hand_busy(obj_player) && !hand_busy(obj_enemy)
                        && array_length(obj_player.hand) == 0
                        && array_length(obj_enemy.hand) == 0) {

                        obj_giveCards.givecards = true;
                        res_state = 4;
                    }
                    break;

                //cuando termina el reparto, siguiente ronda
                case 4:
                    if (!obj_giveCards.givecards && !hand_busy(obj_player) && !hand_busy(obj_enemy)) {
                        discardsDone = 0;
                        obj_enemy.discards_done = 0;

                        startsplayer = !startsplayer;
                        global.gameState = startsplayer ? GameState.PLAYERTURN : GameState.ENEMYTURN;
                        res_state = 0;
                    }
                    break;
            }
        }
        break;
}