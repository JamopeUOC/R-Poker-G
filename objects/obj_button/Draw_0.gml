
var wastedDiscards = label == "Discard" && maxDiscardsDone();

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, wastedDiscards ? c_black : c_white, wastedDiscards ?  0.5 : 1);


draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_default);
draw_text(x, y, label);