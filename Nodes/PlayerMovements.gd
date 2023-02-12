extends KinematicBody

# Player movement speed
export var speed : float = 10
export var fall_acceleration : float = 10
export var stop_time : float = 0.25
export var start_time : float = 0.25

var velocity : Vector3 = Vector3.ZERO

var x_start_value : float = 0
var z_start_value : float = 0
var current_x_start_time : float = 0
var current_z_start_time : float = 0

var x_stop_value : float = 0
var z_stop_value : float = 0
var current_x_stop_time : float = 0
var current_z_stop_time : float = 0



func _physics_process(delta):
	var direction : Vector3
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		if direction.x != 0:
			lerp_speed_up_x(direction.x, delta)
			current_x_stop_time = 0
			if direction.z == 0 and velocity.z != 0 and current_z_stop_time > 0:
				current_z_stop_time += (stop_time / 5) * delta
		if direction.z != 0:
			lerp_speed_up_z(direction.z, delta)
			current_z_stop_time = 0
			if direction.x == 0 and velocity.x != 0 and current_x_stop_time > 0:
				current_x_stop_time += (stop_time / 5) * delta

	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if direction.x == 0: 
		current_x_start_time = 0
		lerp_slow_down_x(delta)
	if direction.z == 0: 
		current_z_start_time = 0
		lerp_slow_down_z(delta)

func lerp_speed_up_x(direction:float, delta:float):
	if (direction < 0 && velocity.x > 0 || direction > 0 && velocity.x < 0) && velocity.x != 0:
		current_x_start_time = 0
	if current_x_start_time == 0:
		x_start_value = velocity.x
	current_x_start_time += delta
	velocity.x = lerp(x_start_value, direction * speed, current_x_start_time / start_time)
	if current_x_start_time >= start_time:
		velocity.x = direction * speed
func lerp_speed_up_z(direction:float,delta:float):
	if (direction < 0 && velocity.z > 0 || direction > 0 && velocity.z < 0) && velocity.z != 0:
		current_z_start_time = 0
	if current_z_start_time == 0:
		z_start_value = velocity.z
	current_z_start_time += delta
	velocity.z = lerp(z_start_value, direction * speed, current_z_start_time / start_time)
	if current_z_start_time >= start_time:
		velocity.z = direction * speed 

func lerp_slow_down_x(delta:float):
	if current_x_stop_time == 0:
		x_stop_value = velocity.x
	current_x_stop_time += delta
	velocity.x = lerp(x_stop_value, 0, current_x_stop_time / stop_time)
	if current_x_stop_time >= stop_time:
		velocity.x = 0
func lerp_slow_down_z(delta:float):
	if current_z_stop_time == 0:
		z_stop_value = velocity.z
	current_z_stop_time += delta
	velocity.z = lerp(z_stop_value, 0, current_z_stop_time / stop_time)
	if current_z_stop_time >= stop_time:
		velocity.z = 0

