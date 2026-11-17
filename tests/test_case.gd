class_name TestCase
extends RefCounted
## Basis uji headless. Subkelas mengganti run() (boleh memakai await).

var failures: Array[String] = []
var checks: int = 0
var tree: SceneTree


func run() -> void:
	pass


func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures.append(message)


func check_eq(actual: Variant, expected: Variant, message: String) -> void:
	checks += 1
	if actual != expected:
		failures.append("%s (aktual=%s, diharapkan=%s)" % [message, str(actual), str(expected)])


func check_near(actual: float, expected: float, message: String, epsilon: float = 0.001) -> void:
	checks += 1
	if absf(actual - expected) > epsilon:
		failures.append("%s (aktual=%f, diharapkan=%f)" % [message, actual, expected])


func wait_frames(count: int = 2) -> void:
	for i in count:
		await tree.process_frame
