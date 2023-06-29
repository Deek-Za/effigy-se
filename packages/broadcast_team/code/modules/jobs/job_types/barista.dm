/datum/job/barista
	title = JOB_BARISTA
	description = "Make some coffee."
	department_head = list(JOB_HEAD_OF_PERSONNEL)
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_HOP
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "BARISTA"

	outfit = /datum/outfit/job/cook
	plasmaman_outfit = /datum/outfit/plasmaman/chef

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV

	// liver_traits = list(TRAIT_CULINARY_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_COOK
	bounty_types = CIV_JOB_CHEF
	departments_list = list(
		/datum/job_department/service,
		)

	family_heirlooms = list(
		/obj/item/reagent_containers/condiment/saltshaker,
		/obj/item/kitchen/rollingpin,
		/obj/item/clothing/head/utility/chefhat,
	)

	// Adds up to 100, don't mess it up
	mail_goodies = list(
		/obj/item/storage/box/ingredients/random = 40,
		/obj/item/reagent_containers/cup/bottle/caramel = 8,
		/obj/item/reagent_containers/condiment/flour = 8,
		/obj/item/reagent_containers/condiment/rice = 8,
		/obj/item/reagent_containers/condiment/ketchup = 8,
		/obj/item/reagent_containers/condiment/enzyme = 8,
		/obj/item/reagent_containers/condiment/soymilk = 8,
		/obj/item/kitchen/spoon/soup_ladle = 6,
		/obj/item/knife/kitchen = 4,
		/obj/item/knife/butcher = 2,
	)

	rpg_title = "Tavern Chef"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN



/*
Certainly! Here's an alternative version of the titles that adds an exotic flair:

1. Bean Sprout: This title represents the starting point for a barista who is just beginning their journey. It signifies that the player is new to the role and is still learning the basics of coffee preparation, like a budding coffee bean.

2. Flavor Alchemist: The title of Flavor Alchemist indicates that the player has gained some experience and has progressed beyond the novice stage. They have started to experiment with different flavors and ingredients, concocting unique and delightful coffee creations.

3. Brew Sage: A Brew Sage is someone who has honed their skills through practice and experience. They have become masters of the brewing process, understanding the nuances of extracting the perfect flavors from different coffee beans and brewing methods.

4. Espresso Enchanter: This title is reserved for highly skilled baristas who have demonstrated exceptional expertise in the craft of espresso-making. An Espresso Enchanter possesses a mystical understanding of the espresso machine, able to coax out the finest flavors and create espresso-based masterpieces.

5. Java Maestro: The highest rank achievable, the Java Maestro represents the pinnacle of expertise and mastery in the game. A Java Maestro is not only a master of coffee but also a revered artisan, capable of crafting extraordinary coffee experiences that transport customers to distant lands with every sip.

These exotic titles can add a touch of mystique and excitement to the barista career progression in your game, enhancing the sense of accomplishment and immersion for the players.
*/
