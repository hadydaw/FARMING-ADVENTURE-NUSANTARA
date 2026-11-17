class_name BackendClient
extends RefCounted
## Antarmuka klien backend (fondasi). Implementasi default = mode offline.
##
## Game hanya boleh bicara ke backend lewat kelas ini, supaya penyedia backend
## (lihat docs/technical/BACKEND_DESIGN.md) bisa diganti tanpa mengubah gameplay.
## Belum ada permintaan jaringan pada tahap fondasi.

const ERR_NOT_IMPLEMENTED := "not_implemented"


func is_configured() -> bool:
	return false


## Masuk / buat akun. Dikembalikan: {"ok": bool, "error": String, ...}
func sign_in() -> Dictionary:
	return _not_implemented()


## Kirim snapshot save ke server. Server memutuskan konflik berdasarkan revision.
func push_save(_slot: int, _envelope: Dictionary) -> Dictionary:
	return _not_implemented()


## Ambil snapshot save terbaru dari server.
func pull_save(_slot: int) -> Dictionary:
	return _not_implemented()


func _not_implemented() -> Dictionary:
	return {"ok": false, "error": ERR_NOT_IMPLEMENTED}
