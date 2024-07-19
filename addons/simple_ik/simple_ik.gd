@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type("IKBone3D", "MeshInstance3D", preload("bone.gd"), preload("icon.png"))
	add_custom_type("IKBasicLimb3D", "Node3D", preload("ik_controller.gd"), preload("icon.png"))


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("IKBone3D")
	remove_custom_type("IKBasicLimb3D")
