 
//Constructor de una carta
function Card(_value, _suit) constructor {
    
    value = _value
    suit = _suit
    object = noone;
    
}

//Creamos el mazo
global.deck = [];
global.maxCardsInHand = 8;
global.maxCardsSelected = 5;

//Función para resetear el mazo
function resetDeck() {
    global.deck = [];

    for (var i = 0; i < 13; i++) {
        array_push(global.deck, new Card(i + 1, "hearts"));
        array_push(global.deck, new Card(i + 1, "clubs"));
        array_push(global.deck, new Card(i + 1, "diamonds"));
        array_push(global.deck, new Card(i + 1, "spades"));
    }
}

resetDeck();

///Añade una carta a una mano, tanto del jugador como del rival
function addCardToHand(_obj) {
    if (array_length(global.deck) == 0) return false;
    
    var _index = irandom(array_length(global.deck) - 1);
    
    var card = global.deck[_index];
    
    with(_obj) {
        if (array_length(hand) < global.maxCardsInHand) {
            
            var _card_index = array_length(hand);
            
            array_push(hand, card);
            
            array_delete(global.deck, _index, 1);
            
            var _new_card = instance_create_layer(531, 176, "Instances", obj_card, {
                owner: other
            });
            
            with(_new_card) {
                value = card.value;
                suit = card.suit;
                index = _card_index;
                reference = card;
                
                if (index > 0) {
                    var _prev_card_inst = owner.hand[index - 1].object;
                    depth = _prev_card_inst.depth - 1;
                } else {
                    depth = 0;
                }
            }
            
            card.object = _new_card;
            
            //sfx
            var pitch = random_range(0.85, 1.15);
            audio_play_sound(snd_sfx_card1, 1, false, 1, 0, pitch);
            
            return true;
        } else {
            return false;
        }
    }
}

function maxDiscardsDone(){
     return obj_game.discardsDone >= global.maxDiscards
}

function maxChangesDone(){
     return obj_game.swapsDone >= global.maxSwaps
}

function maxErasesDone(){
     return obj_game.eraseDone >= global.maxErases
}

function hand_busy(_owner) {
    for (var i = 0; i < array_length(_owner.hand); i++) {
        var _o = _owner.hand[i].object;
        if (instance_exists(_o) && (_o.moving || _o.discarded || _o.turning)) return true;
    }
    return false;
}

function swapCards(_pCard, _eCard) {
    var _pIdx = array_get_index(obj_player.hand, _pCard);
    var _eIdx = array_get_index(obj_enemy.hand, _eCard);
    if (_pIdx == -1 || _eIdx == -1) return false;

    var _pInst = _pCard.object;
    var _eInst = _eCard.object;
    if (!instance_exists(_pInst) || !instance_exists(_eInst)) return false;

    //Intercambiar en los arrays de las manos
    obj_player.hand[_pIdx] = _eCard;
    obj_enemy.hand[_eIdx] = _pCard;

    //La carta del jugador pasa al rival boca abajo
    _pInst.owner = obj_enemy;
    _pInst.index = _eIdx;
    _pInst.hidden = true;
    _pInst.turning = false;
    _pInst.showing_front = false;

    //La carta del rival pasa al jugador y se gira
    _eInst.owner = obj_player;
    _eInst.index = _pIdx;
    _eInst.hidden = false;
    _eInst.turning = true;

    //Deseleccionar y animar hacia la nueva posición
    var _tmpDepth = _pInst.depth;
    _pInst.depth = _eInst.depth;
    _eInst.depth = _tmpDepth;

    _pInst.selected = false;
    _eInst.selected = false;
    _pInst.mousein = false;
    _eInst.mousein = false;
    _pInst.moving = true;
    _eInst.moving = true;
    
    
    //sfx
    var pitch = random_range(0.75, 1);
    audio_play_sound(snd_sfx_card1, 1, false, 1, 0, pitch);

    return true;
}

//Descarta cartas de una mano
function discardCardFromHand(_card_inst, _draw = true) {
    var _player = _card_inst.owner;
    var _ref = _card_inst.reference;

    with (_player) {
        var _i = array_get_index(hand, _ref);
        if (_i != -1) array_delete(hand, _i, 1);

        var _s = array_get_index(selected_cards, _ref);
        if (_s != -1) array_delete(selected_cards, _s, 1);

        for (var i = 0; i < array_length(hand); i++) {
            var _inst = hand[i].object;
            if (instance_exists(_inst) && !_inst.discarded) {
                _inst.index = i;
                _inst.moving = true;
            }
        }

        //Añadir nuevas cartas
        if (_draw) addCardToHand(id);
    }

    _ref.object = noone;
    array_push(global.deck, _ref);
}