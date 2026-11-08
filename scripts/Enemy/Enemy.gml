
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