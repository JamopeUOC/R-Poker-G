
if (hidden) turning = false;
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
} else if (discarded) {
    
    if (showing_front) {
        image_xscale -= turn_speed;
        if (image_xscale <= 0) {
            image_xscale = 0;
            showing_front = false;
        }
    } else {
        image_xscale = min(1, image_xscale + turn_speed);
    }
}

if (!variable_instance_exists(id, "float_factor")) float_factor = 0;


if (moving) {
    var _tx, _ty;

    if (discarded) {
        _tx = 531;
        _ty = 176;
    } else {
        var separation = 55;
        _tx = 75 + separation * index;
        _ty = owner.object_index == obj_player ? room_height * 0.75 : room_height * 0.25;
    }

    x = lerp(x, _tx, 0.25);
    y = lerp(y, _ty, 0.25);
    float_factor = 0;

    if (point_distance(x, y, _tx, _ty) < 0.5) {
        x = _tx;
        y = _ty;

        if (discarded) {
            discardCardFromHand(id, !no_redraw);
            instance_destroy();
            exit;
        }

        moving = false;
        aux_x = x;
        aux_y = y;
        start_x = x;
        start_y = y;
    }
}

else {
    float_factor = lerp(float_factor, 1, 0.05);

    var time_sec = current_time * 0.001;
    var wave_y = sin(time_sec * 2.5 + random_sin);

    var _select_dir = (owner != noone && owner.object_index == obj_player) ? -1 : 1;
    var yOffsetSelected = selected ? (_select_dir * 24) : 0;
    
    y = lerp(y, aux_y + (2 * wave_y * float_factor) + yOffsetSelected, 0.2);

    if (!turning && !discarded) {
        image_xscale = lerp(image_xscale, target_xscale, 0.2);
    }
    image_yscale = lerp(image_yscale, target_yscale, 0.2);

    if (mousein) {
        var wave_mouse = sin(current_time * 0.01 + random_sin);
        image_angle = lerp(image_angle, start_angle + (1.2 * wave_mouse), 0.2);
    } else {
        image_angle = lerp(image_angle, start_angle, 0.1);
    }
}

var alreadyInAnotherCard = false;
if (position_meeting(mouse_x, mouse_y, id)) {
    with(obj_card) {
        if (id != other.id && mousein) alreadyInAnotherCard = true;
    }
    if (!alreadyInAnotherCard) event_user(1);
} else {
    event_user(0);
}