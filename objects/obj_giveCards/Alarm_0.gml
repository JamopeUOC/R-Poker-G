if (addCardToHand(instance_find(obj_player, 0))) {
    alarm[0] = room_speed * 0.25;
} else {
    if (addCardToHand(instance_find(obj_enemy, 0))) {
        alarm[0] = room_speed * 0.25;
    } else {
        givecards = false;
        if (global.gameState == GameState.SETUP) {
            global.gameState = obj_game.startsplayer ? GameState.PLAYERTURN : GameState.ENEMYTURN;
        }
    }
}