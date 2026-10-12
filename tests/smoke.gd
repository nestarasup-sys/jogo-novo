extends SceneTree
## Rodar: godot --headless --path . --script res://tests/smoke.gd

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    var paths := {
        "bedroom": "res://scenes/maps/bedroom.tscn",
        "corridor": "res://scenes/maps/corridor.tscn",
        "garden": "res://scenes/maps/garden.tscn"
    }
    var expected := {"bedroom": ["corridor"], "corridor": ["bedroom", "garden"], "garden": ["corridor"]}
    var failures := 0
    for id in paths.keys():
        var scene: PackedScene = load(paths[id])
        if scene == null:
            failures += 1
            push_error("Cannot load scene: " + paths[id])
            continue
        var map = scene.instantiate()
        root.add_child(map)
        if map.map_id != id:
            failures += 1
            push_error("Unexpected map_id: " + id)
        var outgoing: Array[String] = []
        for interaction in map.interactions:
            if interaction["kind"] == "door":
                outgoing.append(interaction["target"])
                if not paths.has(interaction["target"]):
                    failures += 1
                    push_error("Invalid door target: " + interaction["target"])
                var spawn: Vector2 = interaction["spawn"]
                if spawn.x < 50 or spawn.x > 1230 or spawn.y < 50 or spawn.y > 670:
                    failures += 1
                    push_error("Spawn outside play area: " + id)
        outgoing.sort()
        var intended: Array = expected[id].duplicate()
        intended.sort()
        if outgoing != intended:
            failures += 1
            push_error("Door graph mismatch in " + id)
        map.free()
    if failures == 0:
        print("PASS: 3 scenes, door links and spawn bounds")
    else:
        print("FAIL: ", failures, " checks")
    quit(0 if failures == 0 else 1)
