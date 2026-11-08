//Estados de juego
enum GameState {
    SETUP,
    PLAYERTURN,
    ENEMYTURN,
    RESOLUTION
}

//Estado de juego actual
global.gameState = GameState.SETUP;


//Cambiamos de estado
function state(gameState) {
    global.gameState = gameState;
}