/obj/item/youtuberadio
	name = "youtube radio"
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	inhand_icon_state = "walkietalkie"
	worn_icon_state = "radio"
	desc = "A handheld radio that can transmit Telenet Streams."
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	dog_fashion = /datum/dog_fashion/back

	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_SMALL

	var/playing = 0
	var/currentsound = null


/obj/item/youtuberadio/attack_self(mob/user)

// need youtube dl command to just get audio

// youtube-dl -x --audio-format mp3 https://www.youtube.com/watch?v=uWusmdmc0to

	var/name =  "radio"
	var/channelnum = rand(999,9999)
	var/ytdl = CONFIG_GET(string/invoke_youtubedl)
	var/location = CONFIG_GET(string/youtubefolder)

	if(playing == 0)
		world.shelleo("del /q [location]\\*")
		playing = 1
		var/web_sound_input = input("Enter content URL (supported sites only, leave blank to stop playing)", "Play Internet Sound via youtube-dl") as text|null
		if(istext(web_sound_input))
			if(length(web_sound_input))
				to_chat(user, "LOADING SONG")
				web_sound_input = trim(web_sound_input)
				if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
					to_chat(src, "<span class='boldwarning'>Non-http(s) URIs are not allowed.</span>", confidential = TRUE)
					to_chat(src, "<span class='warning'>For youtube-dl shortcuts like ytsearch: please use the appropriate full url from the website.</span>", confidential = TRUE)
					return
				var/shell_scrubbed_input = shell_url_scrub(web_sound_input)
				// var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height<=360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_scrubbed_input]\"")
				// to_chat(world, "cd [location] && [ytdl] -x --audio-format mp3 -o [name] \"[shell_scrubbed_input]\"")
				// var/list/output = world.shelleo("[ytdl] -x --audio-format mp3 \"[shell_scrubbed_input]\"")
				world.shelleo("[ytdl] -x --audio-format wav -o [location]\\[name].%(ext)s \"[shell_scrubbed_input]\"")

				// var/errorlevel = output[SHELLEO_ERRORLEVEL]
				// to_chat(world, errorlevel)

				// var/stdout = output[SHELLEO_STDOUT]
				// to_chat(world, stdout)


				// var/stderr = output[SHELLEO_STDERR]
				// to_chat(world, stderr)


				// world.shelleo("ffmpeg -i [location]\\[name].wav [location]\\[name].wma")


				world.shelleo("ffmpeg -i [location]\\[name].wav -f segment -segment_time 1 -c copy [location]\\segment[name]%d.wav")
				// $ ffmpeg -i somefile.mp3 -f segment -segment_time 3 -c copy out%03d.mp3

				// Then regex out the numbers or some shit
				var/current = 0


				sleep(50)

				while(playing == 1)

					sleep(10)
					var/S = file("[location]\\segment[name][current].wav")
					currentsound = S
					if(S)
						current = current + 1
					else
						playing = 0
						world.shelleo("del /q [location]\\*")
					// new/sound()
					playsound(get_turf(src.loc), S, 100, FALSE, FALSE, filepath = TRUE, extrarange = 30, channel = channelnum)
					// The video should be saving somewhere - I need to grab the mp3 then pipe it
					// Where is it DLing?
					// Could just do CD to current folder - need to avoid the prompt for the command
					// Think just due to running on safe
	else
		playing = 0
		world.shelleo("del /q [location]\\*")

		// 		if(!errorlevel)
		// 			var/list/data
		// 			try
		// 				data = json_decode(stdout)
		// 			catch(var/exception/e)
		// 				to_chat(src, "<span class='boldwarning'>Youtube-dl JSON parsing FAILED:</span>", confidential = TRUE)
		// 				to_chat(src, "<span class='warning'>[e]: [stdout]</span>", confidential = TRUE)
		// 				return

		// 			if (data["url"])
		// 				web_sound_url = data["url"]
		// 				var/title = "[data["title"]]"
		// 				var/webpage_url = title
		// 				if (data["webpage_url"])
		// 					webpage_url = "<a href=\"[data["webpage_url"]]\">[title]</a>"
		// 				music_extra_data["start"] = data["start_time"]
		// 				music_extra_data["end"] = data["end_time"]
		// 				music_extra_data["link"] = data["webpage_url"]
		// 				music_extra_data["title"] = data["title"]

		// 				var/res = alert(usr, "Show the title of and link to this song to the players?\n[title]",, "No", "Yes", "Cancel")
		// 				switch(res)
		// 					if("Yes")
		// 						to_chat(world, "<span class='boldannounce'>An admin played: [webpage_url]</span>", confidential = TRUE)
		// 					if("Cancel")
		// 						return

		// 				SSblackbox.record_feedback("nested tally", "played_url", 1, list("[ckey]", "[web_sound_input]"))
		// 				log_admin("[key_name(src)] played web sound: [web_sound_input]")
		// 				message_admins("[key_name(src)] played web sound: [web_sound_input]")
		// 		else
		// 			to_chat(src, "<span class='boldwarning'>Youtube-dl URL retrieval FAILED:</span>", confidential = TRUE)
		// 			to_chat(src, "<span class='warning'>[stderr]</span>", confidential = TRUE)

		// 	else //pressed ok with blank
		// 		log_admin("[key_name(src)] stopped web sound")
		// 		message_admins("[key_name(src)] stopped web sound")
		// 		web_sound_url = null
		// 		stop_web_sounds = TRUE

		// 	if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
		// 		to_chat(src, "<span class='boldwarning'>BLOCKED: Content URL not using http(s) protocol</span>", confidential = TRUE)
		// 		to_chat(src, "<span class='warning'>The media provider returned a content URL that isn't using the HTTP or HTTPS protocol</span>", confidential = TRUE)
		// 		return
		// 	if(web_sound_url || stop_web_sounds)
		// 		for(var/m in GLOB.player_list)
		// 			var/mob/M = m
		// 			var/client/C = M.client
		// 			if(C.prefs.toggles & SOUND_MIDI)
		// 				if(!stop_web_sounds)
		// 					C.tgui_panel?.play_music(web_sound_url, music_extra_data)
		// 				else
		// 					C.tgui_panel?.stop_music()

		// SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Internet Sound")
/obj/item/youtubetv
	name = "youtube tv"
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	inhand_icon_state = "walkietalkie"
	worn_icon_state = "radio"
	desc = "A handheld radio that can transmit Telenet Streams."
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	dog_fashion = /datum/dog_fashion/back

	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_SMALL

	var/playing = 0
	var/currentsound = null


/obj/item/youtubetv/attack_self(mob/user)

// need youtube dl command to just get audio

// youtube-dl -x --audio-format mp3 https://www.youtube.com/watch?v=uWusmdmc0to

	var/vidname = "thevideo"
	var/channelnum = rand(999,9999)
	var/name = "video"


	var/ytdl = CONFIG_GET(string/invoke_youtubedl)
	var/location = CONFIG_GET(string/youtubevideofolder)


	if(playing == 0)
		world.shelleo("del /q [location]\\*")
		playing = 2
		var/web_sound_input = input("Enter content URL (supported sites only, leave blank to stop playing)", "Play Internet Sound via youtube-dl") as text|null
		if(istext(web_sound_input))
			if(length(web_sound_input))
				to_chat(user, "LOADING THIS IS SLOW AS FUCK PLEASE BE PATIENT :c")
				to_chat(user, "Like really really really fucking slow")
				web_sound_input = trim(web_sound_input)
				if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
					to_chat(src, "<span class='boldwarning'>Non-http(s) URIs are not allowed.</span>", confidential = TRUE)
					to_chat(src, "<span class='warning'>For youtube-dl shortcuts like ytsearch: please use the appropriate full url from the website.</span>", confidential = TRUE)
					return
				var/shell_scrubbed_input = shell_url_scrub(web_sound_input)
				// var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height<=360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_scrubbed_input]\"")
				// to_chat(world, "cd [location] && [ytdl] -x --audio-format mp3 -o [name] \"[shell_scrubbed_input]\"")
				// var/list/output = world.shelleo("[ytdl] -x --audio-format mp3 \"[shell_scrubbed_input]\"")

				// youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' url
				world.shelleo("[ytdl] -x --audio-format wav -o [location]\\[name].%(ext)s \"[shell_scrubbed_input]\"")


				world.shelleo("[ytdl] -f 'bestvideo\[ext=mp4]+bestaudio\[ext=m4a]/mp4 -o [location]\\[vidname].%(ext)s \"[shell_scrubbed_input]\"")


				world.shelleo("ffmpeg -i [location]\\[vidname].mp4 -filter:v \"setpts=0.66*PTS\" [location]\\speed[vidname].mp4")
				world.shelleo("ffmpeg -i [location]\\speed[vidname].mp4 -c copy [location]\\mk[vidname].mkv")

				world.shelleo("ffmpeg -stream_loop 1 -i [location]\\mk[vidname].mkv -c copy [location]\\finish[vidname].mp4")

				world.shelleo("ffmpeg -i [location]\\finish[vidname].mp4 -f gif -vf scale=96:64 [location]\\[vidname].gif")
				world.shelleo("magick convert -layers Optimize [location]\\[vidname].gif [location]\\[vidname].dmi")
				// var/errorlevel = output[SHELLEO_ERRORLEVEL]
				// to_chat(world, errorlevel)
				// ffmpeg -i benji.gif -f mp4 -pix_fmt yuv420p benji.mp4
				// var/stdout = output[SHELLEO_STDOUT]
				// to_chat(world, stdout)


				// var/stderr = output[SHELLEO_STDERR]
				// to_chat(world, stderr)


				// world.shelleo("ffmpeg -i [location]\\[name].wav [location]\\[name].wma")


				world.shelleo("ffmpeg -i [location]\\[name].wav -f segment -segment_time 1 -c copy [location]\\segment[name]%d.wav")
				// $ ffmpeg -i somefile.mp3 -f segment -segment_time 3 -c copy out%03d.mp3

				// Then regex out the numbers or some shit
				var/current = 0


				sleep(50)

				icon_state = ""
				icon = file("[location]\\[vidname].dmi")

				var/firstrun = 0
				playing = 1
				while(playing == 1)
					if(firstrun == 1)
						sleep(10)
					else
						firstrun = 1
					var/S = file("[location]\\segment[name][current].wav")
					currentsound = S
					if(S)
						current = current + 1
					else
						playing = 0
						world.shelleo("del /q [location]\\*")
						icon = 'icons/obj/radio.dmi'
					// new/sound()
					playsound(get_turf(src.loc), S, 100, FALSE, FALSE, filepath = TRUE, extrarange = 30, channel = channelnum)

					// The video should be saving somewhere - I need to grab the mp3 then pipe it
					// Where is it DLing?
					// Could just do CD to current folder - need to avoid the prompt for the command
					// Think just due to running on safe
	else
		if(playing == 1)
			playing = 0
			world.shelleo("del /q [location]\\*")
			icon = 'icons/obj/radio.dmi'
		else
			to_chat(user, "I'm still loading :C please wait")
