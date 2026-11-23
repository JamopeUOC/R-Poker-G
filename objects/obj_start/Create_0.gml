window_set_fullscreen(false);

var w = display_get_width();
var h = display_get_height();

var factor = 0.75;

window_set_size(w*factor, h*factor);
window_center();
