extends Node
## Event bus global (autoload "Events"). Sistem saling berkomunikasi lewat sinyal
## di sini agar tidak saling mengunci (TECHNICAL_ARCHITECTURE.md bagian 4).
## Hanya sinyal lintas sistem yang boleh ditambahkan di sini; sinyal internal
## tetap milik kelasnya sendiri.

@warning_ignore("unused_signal")
signal language_changed(locale: String)
@warning_ignore("unused_signal")
signal setting_changed(id: String, value: Variant)
@warning_ignore("unused_signal")
signal scene_change_started(scene_id: String)
@warning_ignore("unused_signal")
signal scene_changed(scene_id: String)
@warning_ignore("unused_signal")
signal scene_change_failed(scene_id: String, reason: String)
@warning_ignore("unused_signal")
signal back_requested
@warning_ignore("unused_signal")
signal input_source_changed(source: String)

# --- Waktu permainan (D-055) ---
@warning_ignore("unused_signal")
signal time_changed(total_minutes: int)
@warning_ignore("unused_signal")
signal hour_changed(hour: int)
@warning_ignore("unused_signal")
signal day_changed(day_index: int)
@warning_ignore("unused_signal")
signal phase_changed(phase_id: String)
@warning_ignore("unused_signal")
signal season_changed(season_id: String)
@warning_ignore("unused_signal")
signal time_paused_changed(paused: bool)

# --- Interaksi objek ---
@warning_ignore("unused_signal")
signal interaction_target_changed(target: Node)
@warning_ignore("unused_signal")
signal interaction_performed(target: Node, actor: Node)
