// 1. ANIMACIÓN DE DAR LA VUELTA
if (turning) {
    if (!showing_front) {
        image_xscale -= turn_speed;
        if (image_xscale <= 0) {
            image_xscale = 0;
            showing_front = true;
        }
    } else {
        image_xscale += turn_speed;
        if (image_xscale >= 1) {
            image_xscale = 1;
            turning = false;
        }
    }
}

// Inicializar la variable de suavizado de flotación si no existe
if (!variable_instance_exists(id, "float_factor")) float_factor = 0;

if (moving) {
    if (owner != noone) {
        var separation = 55;
        var target_x = 75 + separation * index;
        var target_y = 277;
        
        x = lerp(x, target_x, 0.25);
        y = lerp(y, target_y, 0.25);
        
        float_factor = 0;
        
        if (point_distance(x, y, target_x, target_y) < 0.5) {
            x = target_x;
            y = target_y;
            
            moving = false;
            show_debug_message("333");
            
            aux_x = x;
            aux_y = y;
            start_x = x;
            start_y = y;
        }
    }
} else {
    float_factor = lerp(float_factor, 1, 0.05);
    
    var time_sec = current_time * 0.001;
    var wave_y = sin(time_sec * 2.5 + random_sin); 
    
    var wave_angle = sin(time_sec * 1.8 + random_sin + 1.5); 
    
    var yOffsetSelected = selected ? -3 : 0;
    
    y = lerp(y, aux_y + (2 * wave_y * float_factor), 0.2) + yOffsetSelected;
    image_xscale = lerp(image_xscale, target_xscale, 0.2);
    image_yscale = lerp(image_yscale, target_yscale, 0.2);
    
    if (mousein) {
        var wave_mouse = sin(current_time * 0.01 + random_sin);
        image_angle = lerp(image_angle, start_angle + (1.2 * wave_mouse), 0.2);
    } else {
        image_angle = lerp(image_angle, start_angle, 0.1)
    }
}

var alreadyInAnotherCard = false;
if(position_meeting(mouse_x, mouse_y, id)) {
    with(obj_card) {
        if(id != other.id) {
            if(mousein) {
                alreadyInAnotherCard = true;
            }
        }
    }
    
    if(!alreadyInAnotherCard) {
        event_user(1);
    }
} else {
    event_user(0);
}