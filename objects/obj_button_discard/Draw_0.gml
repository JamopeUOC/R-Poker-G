
event_inherited();

var ratio = obj_game.discardsDone / obj_game.maxDiscards;

draw_sprite_part_ext(sprite_index, image_index, 0, 0, sprite_width, sprite_height*ratio, x-sprite_width*0.5, y-sprite_height*0.5, image_xscale, image_yscale, c_black, 0.5);

/*
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, maxDiscardsDone() ? c_black : c_white, maxDiscardsDone() ?  0.5 : 1);
