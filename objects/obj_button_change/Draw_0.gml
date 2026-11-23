
event_inherited();

var ratio = obj_game.changesDone / obj_game.maxChanges;

draw_sprite_part_ext(sprite_index, image_index, 0, 0, sprite_width, sprite_height*ratio, x-sprite_width*0.5, y-sprite_height*0.5, image_xscale, image_yscale, c_black, 0.5);
