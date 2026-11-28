
function enemy_find_best(_hand) {
    var _n = array_length(_hand);

    if (_n <= 5) {
        var _copy = [];
        array_copy(_copy, 0, _hand, 0, _n);
        return { cards: _copy, comb: poker_evaluate(_copy) };
    }

    var _best_cards = undefined;

    for (var _mask = 0; _mask < (1 << _n); _mask++) {
        var _count = 0;
        for (var b = 0; b < _n; b++) if (_mask & (1 << b)) _count++;
        if (_count != 5) continue;

        var _sub = [];
        for (var b = 0; b < _n; b++) {
            if (_mask & (1 << b)) array_push(_sub, _hand[b]);
        }

        if (_best_cards == undefined || poker_compare(_sub, _best_cards) > 0) {
            _best_cards = _sub;
        }
    }
    return { cards: _best_cards, comb: poker_evaluate(_best_cards) };
}

function enemy_flush_draw(_hand) {
    var _suits = ["hearts", "clubs", "diamonds", "spades"];
    for (var s = 0; s < 4; s++) {
        var _group = [];
        for (var i = 0; i < array_length(_hand); i++) {
            if (_hand[i].suit == _suits[s]) array_push(_group, _hand[i]);
        }
        if (array_length(_group) == 4) return _group;
    }
    return [];
}

function enemy_straight_draw(_hand) {
    for (var s = 10; s >= 1; s--) {
        var _keep = [];
        var _seen = array_create(5, false);

        for (var i = 0; i < array_length(_hand); i++) {
            var _v = _hand[i].value;
            for (var k = 0; k < 5; k++) {
                var _w = s + k;
                if (_w == 14) _w = 1;
                if (_v == _w && !_seen[k]) {
                    _seen[k] = true;
                    array_push(_keep, _hand[i]);
                    break;
                }
            }
        }
        if (array_length(_keep) == 4) return _keep;
    }
    return [];
}

function enemy_choose_discards(_hand, _best) {
    if (_best.comb >= COMBINATIONS.STRAIGHT) return [];

    var _keep = [];

    var _counts = array_create(14, 0);
    for (var i = 0; i < array_length(_hand); i++) _counts[_hand[i].value]++;

    if (_best.comb == COMBINATIONS.TRIO || _best.comb == COMBINATIONS.DOUBLE_PAIR) {
        for (var i = 0; i < array_length(_hand); i++) {
            if (_counts[_hand[i].value] >= 2) array_push(_keep, _hand[i]);
        }
    } else {
        var _flush = enemy_flush_draw(_hand);
        var _straight = enemy_straight_draw(_hand);

        if (array_length(_flush) == 4) {
            _keep = _flush;
        } else if (array_length(_straight) == 4) {
            _keep = _straight;
        } else if (_best.comb == COMBINATIONS.PAIR) {
            for (var i = 0; i < array_length(_hand); i++) {
                if (_counts[_hand[i].value] >= 2) array_push(_keep, _hand[i]);
            }
        } else {
            var _sorted = [];
            array_copy(_sorted, 0, _hand, 0, array_length(_hand));
            array_sort(_sorted, function(a, b) { return card_rank(b.value) - card_rank(a.value); });
            _keep = [_sorted[0], _sorted[1]];
        }
    }

    var _discards = [];
    for (var i = 0; i < array_length(_hand); i++) {
        if (array_get_index(_keep, _hand[i]) == -1) array_push(_discards, _hand[i]);
        if (array_length(_discards) >= global.maxCardsSelected) break;
    }
    return _discards;
}

//Ver si el enemigo quiere borrarse la mano
function enemy_should_erase_hand(_hand, _best) {
    //Con escalera o mejor ya hecha, nunca
    if (_best.comb >= COMBINATIONS.STRAIGHT) return false;

    //Si ya tiene proyecto de color o escalera, mejor que no
    if (array_length(enemy_flush_draw(_hand)) == 4) return false;
    if (array_length(enemy_straight_draw(_hand)) == 4) return false;

    //Solo carta alta y sin proyectos, la borra siempre porque su mano es muy mala
    if (_best.comb == COMBINATIONS.HIGH_CARD) return true;

    //Pareja baja (diría que hasta el 8), a veces se la juega, a veces borra
    if (_best.comb == COMBINATIONS.PAIR) {
        var _counts = array_create(14, 0);
        for (var i = 0; i < array_length(_hand); i++) _counts[_hand[i].value]++;

        for (var v = 1; v <= 13; v++) {
            if (_counts[v] >= 2) {
                //borrará la mano con un 50% de probabilidaf
                if (card_rank(v) <= 8) return (irandom(99) < 50);
                break;
            }
        }
    }

    return false;
}

//Coge n cartas al azar de la mano del jugador (sin las que va a jugar porque rompería un poco el juego)
function enemy_pick_random_player_cards(_n) {
    var _pool = [];
    with (obj_player) {
        for (var i = 0; i < array_length(hand); i++) {
            var _c = hand[i];
            if (array_get_index(selected_cards, _c) == -1 && instance_exists(_c.object)) {
                array_push(_pool, _c);
            }
        }
    }

    //lo mezcla
    for (var i = array_length(_pool) - 1; i > 0; i--) {
        var _j = irandom(i);
        var _tmp = _pool[i];
        _pool[i] = _pool[_j];
        _pool[_j] = _tmp;
    }

    var _picked = [];
    for (var i = 0; i < min(_n, array_length(_pool)); i++) {
        array_push(_picked, _pool[i]);
    }
    return _picked;
}

//Devuelve { mine[], theirs[] } o undefined
function enemy_plan_swap(_hand, _best) {
    
    //Con escalera o mejor, no arriesga
    if (_best.comb >= COMBINATIONS.STRAIGHT) return undefined;

    //Sus cartas malas (las que descartaría) de menor a mayor valor
    var _junk = enemy_choose_discards(_hand, _best);
    if (array_length(_junk) == 0) return undefined;
    array_sort(_junk, function(a, b) { 
        return card_rank(a.value) - card_rank(b.value); 
    });

    var _n = irandom_range(1, min(3, array_length(_junk)));
    var _theirs = enemy_pick_random_player_cards(_n);
    _n = min(_n, array_length(_theirs));
    if (_n == 0) return undefined;

    var _mine = [];
    for (var i = 0; i < _n; i++) {
        array_push(_mine, _junk[i]);
    }

    return { mine: _mine, theirs: _theirs };
}