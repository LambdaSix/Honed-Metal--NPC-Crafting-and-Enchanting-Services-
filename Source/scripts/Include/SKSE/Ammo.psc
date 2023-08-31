Scriptname Ammo extends Form Hidden

; SKSE64 additions built 2021-11-10 05:57:47.902000 UTC

; Returns whether this ammo is a bolt
bool Function IsBolt() native

; Returns the projectile associated with this ammo
Projectile Function GetProjectile() native

; Returns the base damage of this ammo
float Function GetDamage() native
