 
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

//Añadimos las cartas al mazo
for(var i = 0; i < 13; i++) {
    var card1 = new Card(i+1, "hearts");
    var card2 = new Card(i+1, "clubs");
    var card3 = new Card(i+1, "diamonds");
    var card4 = new Card(i+1, "spades");
    
    array_push(global.deck, card1);
    array_push(global.deck, card2);
    array_push(global.deck, card3);
    array_push(global.deck, card4);
    
}

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
            
            var _new_card = instance_create_layer(531, 176, "Instances", obj_card);
            
            with(_new_card) {
                value = card.value;
                suit = card.suit;
                owner = other;
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
            
            return true;
        } else {
            return false;
        }
    }
}
