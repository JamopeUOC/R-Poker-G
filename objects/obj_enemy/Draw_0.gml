var yOffset = -150;
var xSeparation = 25;

var _totalWidth = (maxLifes - 1) * xSeparation;
var _startX = room_width * 0.425 - _totalWidth * 0.5;

var _amplitude = 1;
var _speed = 0.0035;
var _phase = 0.8;

for (var i = 0; i < maxLifes; i++) {
    var spriteIdx = (i >= lifes) ? 1 : 0;
    
    var _float = sin(current_time * _speed + i * _phase) * _amplitude;
    
    draw_sprite_ext(spr_heart, spriteIdx, _startX + xSeparation * i, room_height * 0.5 + yOffset + _float, 2, 2, 0, c_white, 1);
}