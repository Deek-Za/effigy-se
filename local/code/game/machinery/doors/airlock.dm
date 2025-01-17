#define AIRLOCK_LIGHT_POWER 0.5
#define AIRLOCK_LIGHT_RANGE 2
#define AIRLOCK_LIGHT_ENGINEERING "engineering"
#define AIRLOCK_POWERON_LIGHT_COLOR LIGHT_COLOR_LIGHT_CYAN
#define AIRLOCK_BOLTS_LIGHT_COLOR LIGHT_COLOR_INTENSE_RED
#define AIRLOCK_EMERGENCY_LIGHT_COLOR LIGHT_COLOR_DIM_YELLOW
#define AIRLOCK_ENGINEERING_LIGHT_COLOR CIRCUIT_COLOR_SCIENCE
#define AIRLOCK_PERMIT_LIGHT_COLOR LIGHT_COLOR_VIVID_GREEN
#define AIRLOCK_DENY_LIGHT_COLOR LIGHT_COLOR_INTENSE_RED
#define AIRLOCK_WARN_LIGHT_COLOR CIRCUIT_COLOR_SCIENCE

#define AIRLOCK_CLOSED	1
#define AIRLOCK_CLOSING	2
#define AIRLOCK_OPEN	3
#define AIRLOCK_OPENING	4
#define AIRLOCK_DENY	5
#define AIRLOCK_EMAG	6

#define AIRLOCK_FRAME_CLOSED "closed"
#define AIRLOCK_FRAME_CLOSING "closing"
#define AIRLOCK_FRAME_OPEN "open"
#define AIRLOCK_FRAME_OPENING "opening"

/obj/machinery/door/airlock
	/// For those airlocks you might want to have varying "fillings" for, without having to
	/// have an icon file per door with a different filling.
	var/fill_state_suffix = null
	/// For the airlocks that use greyscale lights, set this to the color you want your lights to be.
	var/greyscale_lights_color = null
	/// For the airlocks that use a greyscale accent door color, set this color to the accent color you want it to be.
	var/greyscale_accent_color = null

	var/has_environment_lights = TRUE //Does this airlock emit a light?
	var/light_color_poweron = AIRLOCK_POWERON_LIGHT_COLOR
	var/light_color_bolts = AIRLOCK_BOLTS_LIGHT_COLOR
	var/light_color_emergency = AIRLOCK_EMERGENCY_LIGHT_COLOR
	var/light_color_engineering = AIRLOCK_ENGINEERING_LIGHT_COLOR
	var/light_color_permit = AIRLOCK_PERMIT_LIGHT_COLOR
	var/light_color_deny = AIRLOCK_DENY_LIGHT_COLOR
	var/light_color_warn = AIRLOCK_WARN_LIGHT_COLOR
	var/door_light_range = AIRLOCK_LIGHT_RANGE
	var/door_light_power = AIRLOCK_LIGHT_POWER
	///Is this door external? E.g. does it lead to space? Shuttle docking systems bolt doors with this flag.
	var/external = FALSE

/obj/machinery/door/airlock/external
	external = TRUE

/obj/machinery/door/airlock/shuttle
	external = TRUE

/obj/machinery/door/airlock/power_change()
	..()
	update_icon()

/obj/machinery/door/airlock/update_overlays()
	. = ..()
	var/pre_light_range = 0
	var/pre_light_power = 0
	var/pre_light_color = ""
	var/lights_overlay = ""

	var/frame_state
	var/light_state
	switch(airlock_state)
		if(AIRLOCK_CLOSED)
			frame_state = AIRLOCK_FRAME_CLOSED
			if(locked)
				light_state = AIRLOCK_LIGHT_BOLTS
				lights_overlay = "lights_bolts"
				pre_light_color = light_color_bolts
			else if(emergency)
				light_state = AIRLOCK_LIGHT_EMERGENCY
				lights_overlay = "lights_emergency"
				pre_light_color = light_color_emergency
			else if(engineering_override)
				light_state = AIRLOCK_LIGHT_ENGINEERING
				lights_overlay = "lights_engineering"
				pre_light_color = light_color_engineering
			else
				lights_overlay = "lights_poweron"
				pre_light_color = light_color_poweron
		if(AIRLOCK_DENY)
			frame_state = AIRLOCK_FRAME_CLOSED
			light_state = AIRLOCK_LIGHT_DENIED
			lights_overlay = "lights_denied"
			pre_light_color = light_color_deny
		if(AIRLOCK_EMAG)
			frame_state = AIRLOCK_FRAME_CLOSED
		if(AIRLOCK_CLOSING)
			frame_state = AIRLOCK_FRAME_CLOSING
			light_state = AIRLOCK_LIGHT_CLOSING
			lights_overlay = "lights_closing"
			pre_light_color = light_color_warn
		if(AIRLOCK_OPEN)
			frame_state = AIRLOCK_FRAME_OPEN
			if(locked)
				lights_overlay = "lights_bolts_open"
				pre_light_color = light_color_bolts
			else if(emergency)
				lights_overlay = "lights_emergency_open"
				pre_light_color = light_color_emergency
			else
				lights_overlay = "lights_poweron_open"
				pre_light_color = light_color_poweron
		if(AIRLOCK_OPENING)
			frame_state = AIRLOCK_FRAME_OPENING
			light_state = AIRLOCK_LIGHT_OPENING
			lights_overlay = "lights_opening"
			pre_light_color = light_color_permit

	. += get_airlock_overlay(frame_state, icon, src, em_block = TRUE)
	if(airlock_material)
		. += get_airlock_overlay("[airlock_material]_[frame_state]", overlays_file, src, em_block = TRUE)
	else
		. += get_airlock_overlay("fill_[frame_state + fill_state_suffix]", icon, src, em_block = TRUE)

	if(greyscale_lights_color && !light_state)
		lights_overlay += "_greyscale"

	if(lights && hasPower())
		. += get_airlock_overlay("lights_[light_state]", overlays_file, src, em_block = FALSE)
		pre_light_range = door_light_range
		pre_light_power = door_light_power
		if(has_environment_lights)
			set_light(pre_light_range, pre_light_power, pre_light_color, TRUE)
	else
		lights_overlay = ""

	var/mutable_appearance/lights_appearance = mutable_appearance(overlays_file, lights_overlay, FLOAT_LAYER, src, ABOVE_LIGHTING_PLANE)

	if(greyscale_lights_color && !light_state)
		lights_appearance.color = greyscale_lights_color

	. += lights_appearance

	if(panel_open)
		. += get_airlock_overlay("panel_[frame_state][security_level ? "_protected" : null]", overlays_file, src, em_block = TRUE)
	if(frame_state == AIRLOCK_FRAME_CLOSED && welded)
		. += get_airlock_overlay("welded", overlays_file, src, em_block = TRUE)

	if(airlock_state == AIRLOCK_EMAG)
		. += get_airlock_overlay("sparks", overlays_file, src, em_block = FALSE)

	if(hasPower())
		if(frame_state == AIRLOCK_FRAME_CLOSED)
			if(atom_integrity < integrity_failure * max_integrity)
				. += get_airlock_overlay("sparks_broken", overlays_file, src, em_block = FALSE)
			else if(atom_integrity < (0.75 * max_integrity))
				. += get_airlock_overlay("sparks_damaged", overlays_file, src, em_block = FALSE)
		else if(frame_state == AIRLOCK_FRAME_OPEN)
			if(atom_integrity < (0.75 * max_integrity))
				. += get_airlock_overlay("sparks_open", overlays_file, src, em_block = FALSE)

	if(note)
		. += get_airlock_overlay(get_note_state(frame_state), note_overlay_file, src, em_block = TRUE)

	if(frame_state == AIRLOCK_FRAME_CLOSED && seal)
		. += get_airlock_overlay("sealed", overlays_file, src, em_block = TRUE)

	if(hasPower() && unres_sides && frame_state == AIRLOCK_FRAME_CLOSED && !light_state)
		for(var/heading in list(NORTH,SOUTH,EAST,WEST))
			if(!(unres_sides & heading))
				continue
			var/mutable_appearance/floorlight = mutable_appearance(overlays_file, "unres_[heading]", FLOAT_LAYER, src, ABOVE_LIGHTING_PLANE)
			. += floorlight

/obj/machinery/door/airlock
	icon = 'local/icons/obj/doors/airlocks/station/generic.dmi'
	overlays_file = 'local/icons/obj/doors/airlocks/station/overlays.dmi'

/obj/machinery/door/airlock/atmos
	icon = 'local/icons/obj/doors/airlocks/station/atmos.dmi'

/obj/machinery/door/airlock/command
	icon = 'local/icons/obj/doors/airlocks/station/com.dmi'

/obj/machinery/door/airlock/engineering
	icon = 'local/icons/obj/doors/airlocks/station/engi.dmi'

/obj/machinery/door/airlock/hydroponics
	icon = 'local/icons/obj/doors/airlocks/station/hydro.dmi'

/obj/machinery/door/airlock/maintenance
	icon = 'local/icons/obj/doors/airlocks/station/maint-int.dmi'

/obj/machinery/door/airlock/maintenance/external
	icon = 'local/icons/obj/doors/airlocks/station/maint-ext.dmi'

/obj/machinery/door/airlock/medical
	icon = 'local/icons/obj/doors/airlocks/station/med.dmi'

/obj/machinery/door/airlock/mining
	icon = 'local/icons/obj/doors/airlocks/station/cargo.dmi'

/obj/machinery/door/airlock/research
	icon = 'local/icons/obj/doors/airlocks/station/rnd.dmi'

/obj/machinery/door/airlock/science
	icon = 'local/icons/obj/doors/airlocks/station/sci.dmi'

/obj/machinery/door/airlock/security
	icon = 'local/icons/obj/doors/airlocks/station/sec.dmi'

/obj/machinery/door/airlock/virology
	icon = 'local/icons/obj/doors/airlocks/station/viro.dmi'

/obj/machinery/door/airlock/silver
	icon = 'local/icons/obj/doors/airlocks/station/silver.dmi'

// Station2

/obj/machinery/door/airlock/public
	icon = 'local/icons/obj/doors/airlocks/station2/glass.dmi'
	overlays_file = 'local/icons/obj/doors/airlocks/station2/overlays.dmi'

// External

/obj/machinery/door/airlock/external
	icon = 'local/icons/obj/doors/airlocks/external/external.dmi'
	overlays_file = 'local/icons/obj/doors/airlocks/external/overlays.dmi'

/obj/machinery/door/airlock/external/glass
	icon = 'local/icons/obj/doors/airlocks/external/external.dmi'
	overlays_file = 'local/icons/obj/doors/airlocks/external/overlays.dmi'

// Effigy

/obj/machinery/door/airlock/service
	icon = 'local/icons/obj/doors/airlocks/station/service.dmi'

/obj/machinery/door/airlock/service/glass
	opacity = FALSE
	glass = TRUE

/obj/structure/door_assembly/door_assembly_svc
	name = "service airlock assembly"
	icon = 'local/icons/obj/doors/airlocks/station/service.dmi'
	base_name = "service airlock"
	glass_type = /obj/machinery/door/airlock/service/glass
	airlock_type = /obj/machinery/door/airlock/service

/obj/machinery/door/airlock/service/studio
	icon = 'local/icons/obj/doors/airlocks/station/studio.dmi'

/obj/machinery/door/airlock/service/studio/glass
	opacity = FALSE
	glass = TRUE

/obj/structure/door_assembly/door_assembly_sto
	name = "studio airlock assembly"
	icon = 'local/icons/obj/doors/airlocks/station/studio.dmi'
	base_name = "service airlock"
	glass_type = /obj/machinery/door/airlock/service/studio/glass
	airlock_type = /obj/machinery/door/airlock/service/studio

// EFFIGY DOOR ASSEMBLIES

/obj/structure/door_assembly
	icon = 'local/icons/obj/doors/airlocks/station/generic.dmi'
	overlays_file = 'local/icons/obj/doors/airlocks/station/overlays.dmi'

/obj/structure/door_assembly/door_assembly_public
	icon = 'local/icons/obj/doors/airlocks/station2/glass.dmi'
	overlays_file = 'local/icons/obj/doors/airlocks/station/overlays.dmi'

/obj/structure/door_assembly/door_assembly_com
	icon = 'local/icons/obj/doors/airlocks/station/com.dmi'

/obj/structure/door_assembly/door_assembly_sec
	icon = 'local/icons/obj/doors/airlocks/station/sec.dmi'

/obj/structure/door_assembly/door_assembly_eng
	icon = 'local/icons/obj/doors/airlocks/station/engi.dmi'

/obj/structure/door_assembly/door_assembly_min
	icon = 'local/icons/obj/doors/airlocks/station/cargo.dmi'

/obj/structure/door_assembly/door_assembly_atmo
	icon = 'local/icons/obj/doors/airlocks/station/atmos.dmi'

/obj/structure/door_assembly/door_assembly_research
	icon = 'local/icons/obj/doors/airlocks/station/rnd.dmi'

/obj/structure/door_assembly/door_assembly_science
	icon = 'local/icons/obj/doors/airlocks/station/sci.dmi'

/obj/structure/door_assembly/door_assembly_med
	icon = 'local/icons/obj/doors/airlocks/station/med.dmi'

/obj/structure/door_assembly/door_assembly_hydro
	icon = 'local/icons/obj/doors/airlocks/station/hydro.dmi'

/obj/structure/door_assembly/door_assembly_viro
	icon = 'local/icons/obj/doors/airlocks/station/viro.dmi'

/obj/structure/door_assembly/door_assembly_silver
	icon = 'local/icons/obj/doors/airlocks/station/silver.dmi'

/obj/structure/door_assembly/door_assembly_mai
	icon = 'local/icons/obj/doors/airlocks/station/maint-int.dmi'

/obj/structure/door_assembly/door_assembly_extmai
	icon = 'local/icons/obj/doors/airlocks/station/maint-ext.dmi'

#undef AIRLOCK_LIGHT_POWER
#undef AIRLOCK_LIGHT_RANGE
#undef AIRLOCK_LIGHT_ENGINEERING
#undef AIRLOCK_ENGINEERING_LIGHT_COLOR
#undef AIRLOCK_POWERON_LIGHT_COLOR
#undef AIRLOCK_BOLTS_LIGHT_COLOR
#undef AIRLOCK_EMERGENCY_LIGHT_COLOR
#undef AIRLOCK_PERMIT_LIGHT_COLOR
#undef AIRLOCK_DENY_LIGHT_COLOR
#undef AIRLOCK_WARN_LIGHT_COLOR
#undef AIRLOCK_CLOSED
#undef AIRLOCK_CLOSING
#undef AIRLOCK_OPEN
#undef AIRLOCK_OPENING
#undef AIRLOCK_DENY
#undef AIRLOCK_EMAG

#undef AIRLOCK_FRAME_CLOSED
#undef AIRLOCK_FRAME_CLOSING
#undef AIRLOCK_FRAME_OPEN
#undef AIRLOCK_FRAME_OPENING
