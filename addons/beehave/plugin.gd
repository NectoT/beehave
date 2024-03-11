@tool
extends EditorPlugin

const BeehaveEditorDebugger := preload("debug/debugger.gd")
var editor_debugger: BeehaveEditorDebugger
var frames: RefCounted

const BeehaveEditorGraph := preload("debug/graph_edit.gd")
var graph: BeehaveEditorGraph

func _init():
	name = "BeehavePlugin"
	add_autoload_singleton("BeehaveGlobalMetrics", "metrics/beehave_global_metrics.gd")
	add_autoload_singleton("BeehaveGlobalDebugger", "debug/global_debugger.gd")
	print("Beehave initialized!")


func _enter_tree() -> void:
	editor_debugger = BeehaveEditorDebugger.new()
	frames = preload("debug/frames.gd").new()
	graph = BeehaveEditorGraph.new(frames)
	add_debugger_plugin(editor_debugger)


func _exit_tree() -> void:
	remove_debugger_plugin(editor_debugger)


func _handles(object: Object) -> bool:
	return object is BeehaveTree


func _edit(object: Object) -> void:
	if object == null:
		return
	
	var tree := object as BeehaveTree
	graph.beehave_tree = tree._get_debugger_data(tree)


func _make_visible(visible: bool) -> void:
	if visible:
		add_control_to_bottom_panel(graph, '🐝 Beehave')
	else:
		remove_control_from_bottom_panel(graph)
