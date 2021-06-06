class_name CartStep
extends Resource

enum Action { MOVE_TO, WAIT, WAIT_FOR }

export(Action) var action = Action.MOVE_TO
export(float) var duration = 1.0
export(float) var path_offset = 0
export(NodePath) var node_to_wait_for
