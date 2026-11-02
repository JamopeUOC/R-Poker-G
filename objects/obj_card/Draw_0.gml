
draw_set_colour(c_white);
if (!showing_front) {
    draw_sprite_ext(spr_card_reverse, 0, x, y, image_xscale, image_yscale, image_angle, c_white, 1);
} else {
    var val_str = (value < 10) ? "0" + string(value) : string(value);
    var asset_name = string("spr_card_" + val_str + "_" + suit);
    var asset = asset_get_index(asset_name);
    draw_sprite_ext(asset, 0, x, y, image_xscale, image_yscale, image_angle, c_white, 1);
}
