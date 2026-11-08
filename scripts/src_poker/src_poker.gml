enum COMBINATIONS {
    HIGH_CARD,
    PAIR,
    DOUBLE_PAIR,
    TRIO,
    STRAIGHT,
    FLUSH,
    FULL_HOUSE,
    POKER,
    STRAIGHT_FLUSH,
    ROYAL_FLUSH
}

function card_rank(_v) {
    return (_v == 1) ? 14 : _v;
}

function poker_group_sizes(_cards) {
    var _counts = array_create(14, 0);
    for (var i = 0; i < array_length(_cards); i++) {
        _counts[_cards[i].value]++;
    }
    var _groups = [];
    for (var v = 1; v <= 13; v++) {
        if (_counts[v] > 0) array_push(_groups, _counts[v]);
    }
    array_sort(_groups, false);
    return _groups;
}

function poker_is_flush(_cards) {
    var _suit = _cards[0].suit;
    for (var i = 1; i < array_length(_cards); i++) {
        if (_cards[i].suit != _suit) return false;
    }
    return true;
}

function poker_straight_start(_cards) {
    var _present = array_create(15, false);
    for (var i = 0; i < array_length(_cards); i++) {
        var _v = _cards[i].value;
        if (_present[_v]) return -1;
        _present[_v] = true;
    }
    _present[14] = _present[1];

    for (var s = 1; s <= 10; s++) {
        var _ok = true;
        for (var k = 0; k < 5; k++) {
            if (!_present[s + k]) { _ok = false; break; }
        }
        if (_ok) return s;
    }
    return -1;
}

/// Acepta de 0 a 5 cartas. Escalera y color solo con 5.
function poker_evaluate(_cards) {
    var _n = array_length(_cards);
    if (_n == 0) return COMBINATIONS.HIGH_CARD;

    var _groups = poker_group_sizes(_cards);
    var _g0 = _groups[0];
    var _g1 = (array_length(_groups) > 1) ? _groups[1] : 0;

    var _flush    = (_n == 5) && poker_is_flush(_cards);
    var _start    = (_n == 5) ? poker_straight_start(_cards) : -1;
    var _straight = (_start != -1);

    if (_straight && _flush) {
        return (_start == 10) ? COMBINATIONS.ROYAL_FLUSH : COMBINATIONS.STRAIGHT_FLUSH;
    }
    if (_g0 == 4) return COMBINATIONS.POKER;
    if (_g0 == 3 && _g1 == 2) return COMBINATIONS.FULL_HOUSE;
    if (_flush)    return COMBINATIONS.FLUSH;
    if (_straight) return COMBINATIONS.STRAIGHT;
    if (_g0 == 3) return COMBINATIONS.TRIO;
    if (_g0 == 2 && _g1 == 2) return COMBINATIONS.DOUBLE_PAIR;
    if (_g0 == 2) return COMBINATIONS.PAIR;
    return COMBINATIONS.HIGH_CARD;
}

function poker_tiebreak(_cards, _comb) {
    if (_comb == COMBINATIONS.STRAIGHT || _comb == COMBINATIONS.STRAIGHT_FLUSH) {
        if (poker_straight_start(_cards) == 1) return [5];
    }

    var _counts = array_create(15, 0);
    for (var i = 0; i < array_length(_cards); i++) {
        _counts[card_rank(_cards[i].value)]++;
    }

    var _groups = [];
    for (var r = 2; r <= 14; r++) {
        if (_counts[r] > 0) array_push(_groups, { count: _counts[r], rank: r });
    }

    array_sort(_groups, function(a, b) {
        if (a.count != b.count) return b.count - a.count;
        return b.rank - a.rank;
    });

    var _key = [];
    for (var i = 0; i < array_length(_groups); i++) array_push(_key, _groups[i].rank);
    return _key;
}

/// 1 gana A, -1 gana B, 0 empate
function poker_compare(_a, _b) {
    var _ca = poker_evaluate(_a);
    var _cb = poker_evaluate(_b);
    if (_ca != _cb) return (_ca > _cb) ? 1 : -1;

    var _ka = poker_tiebreak(_a, _ca);
    var _kb = poker_tiebreak(_b, _cb);
    for (var i = 0; i < min(array_length(_ka), array_length(_kb)); i++) {
        if (_ka[i] != _kb[i]) return (_ka[i] > _kb[i]) ? 1 : -1;
    }
    return 0;
}