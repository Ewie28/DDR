extends Node2D

#set before game starts
const in_edit_mode: bool = false
var current_level_name = "RHYTHM_COW"

# Time it takes for fk to reach crit point
var fk_fall_time: float = 2.43323599
var fk_output_arr = [[],[],[],[]]

var level_info = {
	"RHYTHM_COW" = {
		"fk_times": "[[-2.05990265507721, -0.7585693468573, 0.74543060164429, 2.19609750609375, 4.88409723143555, 6.06809724669434, 7.57209695677734, 8.76676381926514, 9.14009775023438, 9.5347644219873, 9.89743055205322, 10.2494307885645, 10.6014310250757, 10.9747640023706, 12.5747643838403, 12.9267636666772, 13.2680970559595, 13.5987635980127, 16.020096911001, 17.2147647271631, 19.5720969567773, 20.5320979485986, 20.8840972314355, 21.524096621084, 24.596097124624, 25.8654300103662, 26.2174312005518, 27.8494311700342, 29.8014289269922, 31.550765169668, 32.8947631249902, 36.574763430166, 37.6200972924707, 40.5214301476953, 41.8760978112695, 45.8654319177148, 48.4787627587793, 49.2040969262598, 49.8760978112695, 50.5694304833887, 56.7987624536035, 59.7747641931055, 63.102767122793, 64.53209604125, 64.9160987267969, 65.2467643151758, 65.5774299035547, 65.9507666955469, 66.3240958581445, 66.6974326501367, 68.5000983605859, 69.8547660241602, 70.2174292932031, 70.548094881582, 70.8787604699609, 74.4520942101953, 77.0867606530664, 78.1747657189844, 78.548094881582, 78.8787604699609, 85.204100740957, 85.5241004357813, 87.8814307580469, 88.2227622399805, 88.8520957360742, 100.500098360586, 107.220099581289], [-1.41990266938232, -0.054569350672, 1.47076405386902, 3.32676423888184, 3.74276412825562, 4.09476388792969, 6.80409730772949, 8.37209714751221, 11.5507642159937, 14.1960975060938, 15.5720969567773, 16.8307639489648, 17.8974315057275, 18.2707644830225, 18.6227637658594, 18.9534312615869, 21.8547641168115, 23.1987639794824, 23.52943147521, 23.9240981469629, 24.2760974297998, 25.2040969262598, 26.8787642846582, 28.5214301476953, 30.5267630944727, 32.2440978417871, 33.8547622094629, 36.1800986657617, 37.2894317040918, 40.8840972314355, 41.524096621084, 43.2414313683984, 45.1827651391504, 47.1880980859277, 51.9667655358789, 53.6200972924707, 55.0174323449609, 57.652098787832, 59.0707656274316, 61.7694312463281, 64.1800986657617, 67.0707618127344, 67.8387671838281, 69.1507636437891, 72.4894324670313, 73.8227607141016, 75.4654303918359, 76.7347632775781, 77.8014289269922, 79.6147605309961, 81.2147666345117, 82.5694342980859, 83.8280936608789, 86.516097200918, 88.5214301476953, 89.8760978112695, 91.2307654748438, 99.1987677941797, 104.329428804922, 106.196097506094, 106.60143197875, 106.932097567129], [-1.7292359938147, -1.12123595376038, 0.37209738593079, 1.09743059973694, 1.85476411681152, 2.97476400237061, 4.53209747176147, 5.6520968804834, 6.42009748320557, 7.14543069701172, 7.99876417021729, 11.2307635674951, 11.8707639108179, 12.2547637353418, 13.8654300103662, 15.2734309564111, 16.4254313836572, 17.56676401, 19.2307635674951, 20.2014304528711, 21.2147647271631, 22.516097200918, 24.9160968194482, 25.56676401, 26.5694304833887, 27.2307635674951, 27.5507632623193, 28.2014304528711, 30.1854316125391, 30.8680983911035, 31.9027625451563, 32.5960990319727, 33.5347625146387, 35.1667624841211, 35.8707648644922, 36.9374305139063, 37.8760978112695, 38.5800963769434, 39.1987639794824, 39.9027625451563, 41.2040969262598, 42.8787642846582, 43.8707648644922, 45.5454322228906, 46.5480986962793, 47.8494292626855, 51.177432192373, 52.7240973840234, 54.3454314599512, 61.1720992455957, 63.7960959802148, 67.4760962853906, 68.1800986657617, 68.8200980554102, 69.5241004357813, 71.2200995812891, 72.8414298425195, 73.481429232168, 74.1320945153711, 75.1240989099023, 75.7960959802148, 76.4254294763086, 77.4707633386133, 79.2734290490625, 80.0521003137109, 83.1667624841211, 84.5534278283594, 85.8654319177148, 87.2200995812891, 89.1720954308984, 90.548094881582, 97.9720984826563, 103.017432344961, 107.572096956777], [-0.4279025663855, 2.60143054823853, 5.24676383833862, 12.596097124624, 12.9160977731226, 13.2467643151758, 13.5774299035547, 14.5267630944727, 14.8787642846582, 19.8707648644922, 22.1747638116357, 22.8467646966455, 23.1987639794824, 23.5507632623193, 23.9240981469629, 24.2760974297998, 25.8760978112695, 26.2280970941064, 31.1880980859277, 33.2147628198145, 35.5187636743066, 42.5694304833887, 44.5214301476953, 58.3667632470605, 60.3507644067285, 63.4547644982813, 64.8947669396875, 65.2467643151758, 65.5774299035547, 65.9401008019922, 66.3027640710352, 66.6974326501367, 73.1507636437891, 74.8040992150781, 76.0947638879297, 80.4787665734766, 81.8974295983789, 85.2147666345117, 85.5347663293359, 87.9027625451563, 88.2334281335352, 89.5241004357813, 101.822760714102]]
",
		"music": load("res://assets/audio/song_1.wav")
	}
}

func _ready():
	
	$SongPlayer.stream = level_info.get(current_level_name).get("music")
	$SongPlayer.play()
	
	if in_edit_mode:
		Signals.KeyListnerPress.connect(KeyListenerPress)
	else:
		var fk_times = level_info.get(current_level_name).get("fk_times")
		var fk_times_arr = str_to_var(fk_times)
		
		var counter: int = 0
		for key in fk_times_arr:
			
			var button_name: String = ""
			match counter:
				0:
					button_name = "button_LEFT"
				1:
					button_name = "button_DOWN"
				2:
					button_name = "button_UP"
				3:
					button_name = "button_RIGHT"
			
			for delay in key:
				SpawnFallingKey(button_name, delay)
				
			counter +=1

func KeyListenerPress(button_name: String, array_num: int):
	#print(str(array_num) + " " + str($SongPlayer.get_playback_position()))
	fk_output_arr[array_num].append($SongPlayer.get_playback_position() - fk_fall_time)


func SpawnFallingKey(button_name: String, delay: float):
	await get_tree().create_timer(delay).timeout
	Signals.CreateFallingKey.emit(button_name)


func _on_song_player_finished() -> void:
	print(fk_output_arr)
