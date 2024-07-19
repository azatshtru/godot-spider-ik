@tool
class_name IKBone3D
extends MeshInstance3D

@onready var bone_length: float:
	get:
		return mesh.size.z
	set(value):
		mesh.size.z = value

@onready var in_position: Vector3:
	get:
		return global_position + (global_basis.z * bone_length/2)
	set(value):
		global_position = value - (global_basis.z * bone_length/2)
	
@onready var out_position: Vector3:
	get:
		return global_position - (global_basis.z * bone_length/2)
	set(value):
		global_position = value + (global_basis.z * bone_length/2)

func _enter_tree():
	mesh = BoxMesh.new()
	mesh.size = Vector3(0.2, 0.2, 2)
	
func _exit_tree():
	queue_free()
