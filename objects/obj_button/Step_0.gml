
y = aux_y + 2*sin(current_time*0.001 + random_sin);

image_xscale = lerp(image_xscale, target_xscale, 0.2);
image_yscale = lerp(image_yscale, target_yscale, 0.2);