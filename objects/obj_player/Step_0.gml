if(shakeLifes) {
    if(alarm[0] == -1) {
        
        var part = part_system_create(ps_loselife);
        
        var xSeparation = 25;
        var _totalWidth = (maxLifes - 1) * xSeparation;
        var _startX = room_width * 0.425 - _totalWidth * 0.5;
        var yOffset = 150;
        
        part_system_position(part, _startX + xSeparation * (lifes-1), room_height * 0.5 + yOffset);
        
        alarm[0] = room_speed*0.25;
    }
}