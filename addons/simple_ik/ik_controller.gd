@tool
class_name IKBasicLimb3D
extends Node3D

@export var bone_count: int = 2
@export var epsilon: float = 0.6

var target_position: Vector3
var origin_position: Vector3
var limb_length: float = 0

var initial_basis: Vector3

var bones = []

func _enter_tree():
	origin_position = global_position
	initial_basis = -global_basis.z
	for i in range(0, bone_count):
		var bone = IKBone3D.new()
		bones.append(bone)
		add_child(bone)
		bone.in_position = origin_position + (bone.bone_length * initial_basis * i)
		limb_length += bone.bone_length

func recalibrate_origin(origin):
	origin_position = origin
	for i in range(bone_count):
		var bone = bones[i]
		bone.rotation = Vector3.ZERO
		bone.in_position = origin_position + (bone.bone_length * initial_basis * i)

func fabrik():
	if limb_length * limb_length < origin_position.distance_squared_to(target_position):
		return
	
	recalibrate_origin(global_position)
	
	while bones[-1].out_position.distance_squared_to(target_position) > (epsilon * epsilon):
		fabrik_backward()
		fabrik_forward()
	
func fabrik_forward():
	var current_origin = origin_position
	for bone in bones:
		bone.in_position = current_origin
		current_origin = bone.out_position
	
func fabrik_backward():
	var current_target = target_position
	for i in range(bone_count-1, -1, -1):
		var bone = bones[i]
		bone.look_at_from_position(bone.in_position, current_target, Vector3.UP + Vector3.FORWARD)
		bone.out_position = current_target
		current_target = bone.in_position

func spider_step_lerp(new_target_position, step_delta, step_max_height, step_max_length, t):
	target_position = target_position.lerp(new_target_position, step_delta)
	target_position.y = step_max_height * sin(PI*(t/step_max_length))
