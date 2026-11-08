
y = aux_y + 2*sin(current_time*0.001 + random_sin);

if (mousein) {
    var wave_mouse = sin(current_time * 0.01 + random_sin);
    image_angle = lerp(image_angle, start_angle + (1.2 * wave_mouse), 0.2);
} else {
    image_angle = lerp(image_angle, start_angle, 0.1)
}

image_xscale = lerp(image_xscale, target_xscale, 0.2);
image_yscale = lerp(image_yscale, target_yscale, 0.2);