if(shakeLifes) {
    if(alarm[0] == -1) {
        var part = part_system_create(ps_loselife);
        
        var xSeparation = 25;
        var _totalWidth = (maxLifes - 1) * xSeparation;
        var _startX = room_width * 0.425 - _totalWidth * 0.5;
        var yOffset = -150;
        
        part_system_position(part, _startX + xSeparation * (lifes-1), room_height * 0.5 + yOffset);
        alarm[0] = room_speed*0.25;
    }
}

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
            
            //35% de probabilidad
            want_swap = (irandom(99) < 99);
        }
        break;

    //evaluar y decidir descartes
    case 1:
        ai_best = enemy_find_best(hand);

        //Borrar toda la mano
        if (eraseDone < global.maxErases && enemy_should_erase_hand(hand, ai_best)) {
            for (var i = 0; i < array_length(hand); i++) {
                var _inst = hand[i].object;
                if (instance_exists(_inst)) {
                    _inst.discarded = true;
                    _inst.moving = true;
                    _inst.selected = false;
                }
            }
            
            //sfx
            var pitch = random_range(0.64, 0.85);
            audio_play_sound(snd_sfx_card1, 1, false, 1, 0, pitch);
            
            eraseDone++;
            ai_state = 2;
            break;
        }
        
        //Intercambiar con el jugador
        if (want_swap && swaps_done < global.maxSwaps && !hand_busy(obj_player)) {
            var _plan = enemy_plan_swap(hand, ai_best);
            if (_plan != undefined) {
                for (var i = 0; i < array_length(_plan.mine); i++) {
                    swapCards(_plan.theirs[i], _plan.mine[i]);
                }
                obj_player.selected_cards_enemy = [];
                swaps_done++;
                want_swap = false;
                ai_state = 2;
                break;
            }
            want_swap = false;
        }
        
        var _discards = (discards_done < global.maxDiscards)
            ? enemy_choose_discards(hand, ai_best)
            : [];

        if (array_length(_discards) > 0) {
            for (var i = 0; i < array_length(_discards); i++) {
                var _inst = _discards[i].object;
                if (instance_exists(_inst)) {
                    _inst.discarded = true;
                    _inst.moving = true;
                    
                    
                    //sfx
                    var pitch = random_range(0.64, 0.85);
                    audio_play_sound(snd_sfx_card1, 1, false, 1, 0, pitch);
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
            
            //sfx
            var pitch = random_range(0.85, 1.15);
            audio_play_sound(snd_sfx_card1, 1, false, 1, 0, pitch);
            
        } else {
            ai_timer = 45;
            ai_state = 4;
        }
        break;

    // 4: terminar turno
    case 4:
        global.gameState = GameState.RESOLUTION;
        ai_state = 0;
        break;
}