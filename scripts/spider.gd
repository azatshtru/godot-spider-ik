extends Node3D

@export var threshold: float = 2
@export var step_height: float = 0.9
@export var step_speed: float = 10
@export var body_move_speed: float = 3.1
@export var speed_multiplier: float = 5
@export var limb_count: float = 2

@onready var spider_body = $SpiderBody

var limbs = []
var limb_targets = []

var central_position: Vector3
var target_position_delta: float
var odd: bool = false

var state = "none"

func _ready():
	for i in range(2*limb_count):
		var limb = IKBasicLimb3D.new()
		limb.bone_count = 3
		limb.position = Vector3(0, 1, 0)
		limb.rotation = Vector3(PI/2, 0, 0)
		add_child(limb)
		limbs.append(limb)
		limb_targets.append(Vector3.ZERO)
		
	target_position_delta = threshold
	state = "switch_limb_pairs"
	
func odd_pair_of_legs(n):
	return floor((n+2)/2)%2
	
func calculate_limb_targets():
	for i in range(2*limb_count):
		var angle = PI/2 + (PI/2/limb_count) * floor((i+2)/2)
		var basis_rotation = Vector3.FORWARD.signed_angle_to(-basis.z, Vector3.UP)
		var limb_target = Vector3(
			central_position.x+2.5*abs(cos(angle))*(1 if i%2 else -1),
			0,
			central_position.z-3*abs(sin(angle)))
		limb_target = (limb_target - central_position).rotated(Vector3.UP, basis_rotation) + central_position
		limb_targets[i] = limb_target
	
func switch_limb_pairs(delta):
	target_position_delta += delta * (body_move_speed) * speed_multiplier
	
	if target_position_delta > threshold:
		state = "chase_target"
		odd = not odd
		central_position = global_position
		calculate_limb_targets()
	
func chase_target(delta):
	target_position_delta -= delta * step_speed
	
	for i in range(2*limb_count):
		if odd and odd_pair_of_legs(i+1):
			continue
		if not odd_pair_of_legs(i+1) and not odd:
			continue
		limbs[i].spider_step_lerp(limb_targets[i], step_speed*delta, step_height, threshold, target_position_delta)
	
	if(target_position_delta < 0):
		target_position_delta = 0
		state = "switch_limb_pairs"

func _process(delta):
	var movement = Input.get_axis("back", "forward")
	position -= movement * delta * (body_move_speed + (randf_range(0, speed_multiplier-1.5))) * basis.z
	
	var y_rotation = Input.get_axis("left", "right")
	rotation.y -= y_rotation * delta * 2 * PI/2
	
	match state:
		"switch_limb_pairs":
			switch_limb_pairs(delta)
		"chase_target":
			chase_target(delta)
	
	spider_body.position.y = 1 + (0.66 * sin(PI * target_position_delta * 0.1))
	spider_body.rotation.x = (deg_to_rad(2) * sin(PI * target_position_delta * 0.2))
	667
	for limb in limbs:
		limb.fabrik()
