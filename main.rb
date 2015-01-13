#!/usr/local/bin/ruby


require_relative "usefull_bits"

require_relative "engine/input"
require_relative "engine/update"
require_relative "engine/mainGameLoop"
require_relative "engine/timer"

#Constants
DEBUG2 = false
TICKS_PER_SECOND = 30
SKIP_TICKS = (1.to_f/TICKS_PER_SECOND) #in seconds
WINDOW_Y = 20
WINDOW_X = 80

puts "initialized"
#Call user input, game loop, draw methods, etc.
main_loop = Main_game_loop.new(TICKS_PER_SECOND)
timer = Timer.new(TICKS_PER_SECOND)
drawme = Updater.new(WINDOW_Y,WINDOW_X)
user_input = Input.new
fullBar = "--------------------------------------------------------------------------------"
logo_2= " (                             (         "                        
logo_1= " )\\ )                )         )\\ )     (  "
logo = "(()/(     )       ( /(  (      ( /(     (\\ )   (  (              "
logo2 = " /(_)) ( /(  (    )\\())))\\(    /(_))(  (()/(  ))\\ )(   (     (   " 
logo3 = "(_))_  )(_)) )\\ )(_))//((_)\\  (_))  )\\ )/(_))/((_|()\\  )\\ )  )\\  "
logo4 = " |   \\((_)_ _(_/(| |_(_))((_) |_ _|_(_/(_/ _(_))  ((_)_(_/( ((_) "
logo5 = " | |) / _` | ' \\)|  _/ -_|_-<  | || ' \\))  _/ -_)| '_| ' \\)/ _ \\ "
logo6 = " |___/\\__,_|_||_| \\__\\___/__/ |___|_||_||_| \\___||_| |_||_|\\___/ "

# Variables!
	@gameState = 0;
	@lookDes = "Look at what?"
	@oneTime = 3
	@timer1 = 0
	@timer2 = 0
	@random1 = rand(3)+1
	@PY = 0
	@PX = 0
	@noCommand = false

# functions
def draw_logo(str,time,speed)
	value = 70 - (time/speed)
	value = 1 if time > (70*speed-3)
	return str[0..-value]
end
# MAIN GAME LOOP
loop do
	#required
	drawme.tick()
	timer.tick()
	user_input.get_input()
	break if user_input.exists().to_s.include?'17'	#exit game
	#end required--------------------------------------------------------------------------
	user_input.clear  if timer.ticks < 3	#clear '410' from input pipeline
	drawme.add(WINDOW_Y-1,0,user_input.exists().to_s,10,-1)
	command = user_input.get_command()
	break if command == ":quit"
	command = nil if @noCommand

	if (@gameState == 0) 
		y=2
		x=5
		drawme.add(y,x,	draw_logo(logo_2,timer.ticks-150,1),nil,nil) 
		drawme.add(y+1,x,	draw_logo(logo_1,timer.ticks-150,1),nil,nil) 
		drawme.add(y+2,x,	draw_logo(logo,timer.ticks-140,1),nil,nil) 
		drawme.add(y+3,x,	draw_logo(logo2,timer.ticks-130,1),nil,nil) 
		drawme.add(y+4,x,	draw_logo(logo3,timer.ticks-120,1),nil,nil) 
		drawme.add(y+5,x,	draw_logo(logo4,timer.ticks,3),nil,nil) 
		drawme.add(y+6,x,	draw_logo(logo5,timer.ticks,3),nil,nil) 
		drawme.add(y+7,x,	draw_logo(logo6,timer.ticks,3),nil,nil)
		drawme.add(y+8,x+40,	draw_logo("By: Kyle Bryant",timer.ticks-160,1),nil,nil)
		drawme.add(y+10,x+16,	draw_logo("- press enter to begin -",timer.ticks-180,1),nil,nil)
		drawme.add(y+12,x+2,	draw_logo("Instuctions:",timer.ticks-200,1),nil,nil)
		drawme.add(y+13,x+2,	draw_logo("Type desired command and press enter.",timer.ticks-200,1),nil,nil)
		drawme.add(y+14,x+2,	draw_logo("Use simple commands, such as 'north', 'look', etc.",timer.ticks-200,1),nil,nil)
		drawme.add(y+15,x+2,	draw_logo("Type 'exit' at any time to quit.",timer.ticks-200,1),nil,nil)
		if command == ":"
			@gameState = 1 
			@oneTime = timer.ticks+1;
		end
	else
		drawme.add(0,0,	logo2,nil,nil) 
		drawme.add(1,0,	logo3,nil,nil) 
		drawme.add(2,0,	logo4,nil,nil) 
		drawme.add(3,0,	logo5,nil,nil) 
		drawme.add(4,0,	logo6,nil,nil)
		drawme.add(5,0,fullBar,nil,nil) 
		drawme.log(command)
		drawme.add(18,0,fullBar,nil,nil)

		drawme.log(@lookDes) if command == ":look" 

		if @gameState == -1	 #gameover
			if @oneTime == timer.ticks
				@lookDes = "GAME OVER"
				drawme.log("GAME OVER")
				drawme.log("Enter 'restart' to try again...")
				@PX = 0
				@PY = 0	
			end
			if command == ":restart"
			@gameState = 1 
			@oneTime = timer.ticks+1;
			drawme.clearLog
			end
		end
		if @gameState == 1	 #begining
			@lookDes = "You are in a forest savage, rough, and stern. There is a HILL to the EAST. The forest continues in all directions." if @random1 == 1 or @random1 == 5
			@lookDes = "An odd tree lies to the WEST. There is a HILL to the EAST. The forest continues in all directions." if @random1 == 2
			@lookDes = "Thick leaves blanket the forest ground in darkness. The forest continues in all directions." if @random1 == 3
			@lookDes = "There is an unnatural stillness in all directions. A large HILL is to the EAST." if @random1 == 4
			drawme.log("You are in a forest savage, rough, and stern. There is a bright HILL to the EAST.") if @oneTime == timer.ticks;
			@timer1 = timer.future_time(50) if @oneTime == timer.ticks;	#force moved on
			if (command.to_s.downcase) == ":north"
				@PY +=1
				@random1 = rand(5)+1 
				drawme.log(@lookDes)
			end
			if (command.to_s.downcase) == ":south"
				@PY -=1
				@random1 = rand(5)+1 
				drawme.log(@lookDes)
			end
			if (command.to_s.downcase) == ":east"
				@PX +=1
				@random1 = rand(5)+1 
				drawme.log(@lookDes) if @PX != 3
			end
			if (command.to_s.downcase) == ":west"
				@random1 = rand(5)+1 
				drawme.log(@lookDes)
			end
			if @timer1 == timer.ticks or @PX < -8 or @PY.abs > 20	#game over	
				@gameState = -1
				@oneTime = timer.ticks+1;
				drawme.log("You wander in the dense forest until hunger and thirst overtake you.")
				drawme.log("You have died without salvation.")
			end
			if @PX == 3
				command = ""
				@gameState = 2 
				@oneTime = timer.ticks+1;
				@PX = 0
				@PY = 0
			end
		end
		if @gameState == 2	 #Panther
			@lookDes = "In your path to the EAST is a PANTHER. WEST leads into a darkened valley."
			drawme.log("The forest begins to clear. In your path to the EAST is a PANTHER.") if @oneTime == timer.ticks;
			drawme.log("It does not seem to be impeading your way.") if (command.to_s.downcase) == ":look panther"
			drawme.log("You cannot go that way.") if (command.to_s.downcase) == ":north"
			drawme.log("You cannot go that way.") if (command.to_s.downcase) == ":south"
			if (command.to_s.downcase) == ":west"	#game over	
				drawme.log("As you turn to return to the valley, the PANTHER growls. You rethink your choice.")
			end
			if (command.to_s.downcase) == ":east"
				command = ""
				@gameState = 3
				@oneTime = timer.ticks+1;
			end
		end
		if @gameState == 3	 #Lion
			@lookDes = "In your path to the EAST is a LION. WEST leads into a darkened valley."
			drawme.log("The forest begins to clear. In your path to the EAST is a LION.") if @oneTime == timer.ticks;
			drawme.log("It does not seem to be impeading your way.") if (command.to_s.downcase) == ":look lion"
			drawme.log("You cannot go that way.") if (command.to_s.downcase) == ":north"
			drawme.log("You cannot go that way.") if (command.to_s.downcase) == ":south"
			if (command.to_s.downcase) == ":west"	#game over	
				drawme.log("As you turn to return to the valley, the LION growls. You rethink your choice.")
			end
			if (command.to_s.downcase) == ":east"	
				command = ""
				@timer1 = timer.future_time(5)
				@gameState = 4
				@oneTime = timer.ticks+1;
			end
		end
		if @gameState == 4	 #Wolf
			@lookDes = "In your path to the EAST is a SHE-WOLF. WEST leads into a darkened valley."
			drawme.log("The forest begins to clear. Blocking your path to the EAST is a viscious SHE-WOLF.") if @oneTime == timer.ticks;
			drawme.log("The SHE-WOLF snarls and snaps at you.") if (command.to_s.downcase) == ":look she-wolf"
			drawme.log("You cannot go that way.") if (command.to_s.downcase) == ":north"
			drawme.log("You cannot go that way.") if (command.to_s.downcase) == ":south"
			if (command.to_s.downcase) == ":west"	#game over	
				@gameState = -1
				@oneTime = timer.ticks+1;
				drawme.log("You return to the dense forest. Eventualy hunger and thirst overtake you.")
				drawme.log("You have died without salvation.")
			end
			if (command.to_s.downcase) == ":east" or (command.to_s.downcase) == ":west" or @timer1 == timer.ticks
				@gameState = 5
				command = ""
				@oneTime = timer.future_time(3)
				drawme.clearLog
				drawme.log("The SHE-WOLF sudenly jumps at you, spittle flying from its mouth!")
				@noCommand = true
				@timer1 = timer.future_time(3)
			end
		end
		if @gameState == 5	 #Virgil
			if @timer1 == timer.ticks
				drawme.log("You rush down the HILL back into the valley.")
				@oneTime = @timer1 + 30
			end
			if @oneTime != @timer1
				@noCommand = false
				@lookDes = "There is a man. It would be a good idea to TALK to the MAN."
				drawme.log("The forest seems darker than before. There is a MAN standing by a nearby tree.") if @oneTime == timer.ticks;
				drawme.log("With many words, he introduces himself as VIRGIL. He becons you to follow him to the NORTH.") if (command.to_s.downcase) == ":talk man"
				drawme.log("The man, hunched over a staff, has a long beard that almost touches the ground. He is wearing a TOGA and SANDALS. Obviously this man is a POET. You should talk to him (preferably in iambic pentameter)") if (command.to_s.downcase) == ":look man"
				if (command.to_s.downcase) == ":west" or (command.to_s.downcase) == ":east" or (command.to_s.downcase) == ":south"
					@gameState = -1
					@oneTime = timer.ticks+1;
					drawme.log("You follow your own paths. The forest begins to clear and opens into an open country with many paths.")
					drawme.log("You have died without salvation.")
				end
				if (command.to_s.downcase) == ":north"
					command = ""
					@gameState = 6
					@oneTime = timer.ticks+1;
				end
			end
		end
		if @gameState == 6	 #Virgil-follow1
			@lookDes = "The forest leads in all directions."
			drawme.log("For an old MAN, his pace is quite impressive. He leads you by a good 10 yards and heads NORTH.") if @oneTime == timer.ticks;
			if (command.to_s.downcase) == ":west" or (command.to_s.downcase) == ":east" or (command.to_s.downcase) == ":south"
				@gameState = -1
				@oneTime = timer.ticks+1;
				drawme.log("You follow your own paths. The forest begins to clear and opens into an open country with many paths.")
				drawme.log("You have died without salvation.")
			end
			if (command.to_s.downcase) == ":north"
				command = ""
				@gameState = 7
				@oneTime = timer.ticks+1;
			end
		end
		if @gameState == 7	 #Virgil-follow2
			@lookDes = "The forest leads in all directions."
			drawme.log("Huffing and panting, you are now 5 yards behind the old MAN who heads WEST.") if @oneTime == timer.ticks;
			if (command.to_s.downcase) == ":north" or (command.to_s.downcase) == ":east" or (command.to_s.downcase) == ":south"
				@gameState = -1
				@oneTime = timer.ticks+1;
				drawme.log("You follow your own paths. The forest begins to clear and opens into an open country with many paths.")
				drawme.log("You have died without salvation.")
			end
			if (command.to_s.downcase) == ":west"
				command = ""
				@gameState = 8
				@oneTime = timer.ticks+1;
			end
		end
		if @gameState == 8	 #Virgil-Hell Gates
			@lookDes = "To the WEST stands a CAVE. EAST leads into the forest."
			drawme.log("VIRGIL suddenly stops befor you. As you walk beside him, the forest parts revealing a cavernous maw opening into the ground.") if @oneTime == timer.ticks;
			drawme.log("VIRGIL explains that the way to HEAVEN is blocked. If you still desire to reach HEAVEN you must descent into the cavern and the underworld.") if (command.to_s.downcase) == ":talk virgil"
			drawme.log("You ask VIRGIL about HEAVEN. He speaks for what seems to be hours. It seems HEAVEN is a pretty chill place.") if (command.to_s.downcase) == ":talk heaven"
			if (command.to_s.downcase) == ":north" or (command.to_s.downcase) == ":south"
				drawme.log("You cannot go that way.")
			end
			if (command.to_s.downcase) == ":east"
				@gameState = -1
				@oneTime = timer.ticks+1;
				drawme.log("You return to the forest of darkness and your own ways.")
				drawme.log("You eventualy die... without salvation.")
			end
			if (command.to_s.downcase) == ":west"
				command = ""
				@gameState = 9
				@oneTime = timer.ticks+1;
			end
		end
		if @gameState == 9	 #Hell etnry
			@lookDes = "You stand at the banks of a great river. A FIGURE stands before a small boat. Many undead SHADES stand idly here and there."
			drawme.log("VIRGIL leads the way, moving around many SHADES and towards the river bank. You begin to estimate in your head how massive the cavern is, but are interupted by a FIGURE dressed in a holocaust cloak.") if @oneTime == timer.ticks;
			drawme.log("VIRGIL explains that CHARON will take you across the river if you ask him nicely.") if (command.to_s.downcase) == ":talk virgil"
			drawme.log("Many SHADES wander hopelessly about. VIRGIL states they are the souls of the uncomitted. You believe you can recognise one as pope Celestine.") if (command.to_s.downcase) == ":talk shades"
			drawme.log("He begrudgingly turns to you, requests that you address him by his name (CHARON), and turns back to his boat.") if (command.to_s.downcase) == ":talk figure"
			if (command.to_s.downcase) == ":north" or (command.to_s.downcase) == ":south" or (command.to_s.downcase) == ":west"
				drawme.log("You cannot go that way.")
			end
			if (command.to_s.downcase) == ":east"
				@gameState = -1
				@oneTime = timer.ticks+1;
				drawme.log("You return to the forest of darkness and your own ways.")
				drawme.log("You eventualy die... without salvation.")
			end
			if (command.to_s.downcase) == ":talk charon"
				drawme.log("CHARON refuses to give you passage.")
				command = ""
				@gameState = 10
				@timer1 = timer.future_time(2)
			end
		end
		if @gameState == 10	 #Hell etnry
			if @timer1 == timer.ticks
				drawme.log("He mumbles somthing about still being alive.")
				command = ""
				@gameState = 11
				@timer1 = timer.future_time(3)
			end
		end
		if @gameState == 11	 #Hell etnry
			if @timer1 == timer.ticks
				drawme.log("\"It is so willed there where is power to do; That which is willed.\" VIRGIL announces.")
				command = ""
				@gameState = 12
				@timer1 = timer.future_time(2)
			end
		end
		if @gameState == 12	 #Hell etnry
			if @timer1 == timer.ticks
				drawme.log("With that, CHARON reluctantly allows you on his boat. You depart immediately.")
				command = ""
				@timer2 = timer.future_time(20)
			end
			@lookDes = "You sit on charon's BOAT, it is most likely make of cypress. The dark sea streaches to the horizon."
			drawme.log("Yup, definatly cypress.") if (command.to_s.downcase) == ":look boat"
			drawme.log("He ignores you.") if (command.to_s.downcase) == ":talk charon"
			drawme.log("He launches into a ballad about the departed dead, but not before invoking the muses.") if (command.to_s.downcase) == ":talk virgil"	
			if @timer2 == timer.ticks
				drawme.clearLog
				drawme.log("A blast of other-worldly air rises up. Ths stench is overwhelming. You pass out.")
				command = ""
				@gameState = 13
			end
		end


	end

if DEBUG2
drawme.add(0,15,"                                        ",nil,nil)
drawme.add(1,25,"                                        ",nil,nil)
drawme.add(2,25,"                                        ",nil,nil)
drawme.add(0,55,"Game time: " + timer.get_time(),nil,nil)
drawme.add(1,55,"time: " + timer.ticks().to_s,nil,nil)
drawme.add(2,55,"t1:   " + @timer1.to_s,nil,nil)
drawme.add(2,70,"Y:" + @PY.to_s+" X:" + @PX.to_s,nil,nil)
drawme.add(0,5,"Real FPS: #{1/(main_loop.sleep_time+main_loop.deltaT)}",nil,nil) 
drawme.add(0,25,"Sslow Ticks #{main_loop.slow_frames}",nil,nil)
drawme.add(1,35,"Gamestate: #{@gameState}",nil,nil)
end
	#required-------------------------------------------------------------------------------
	drawme.draw_screen() if main_loop.sleep_MGL()	#draw screen if time avalible
		drawme.setPos(WINDOW_Y-1,user_input.command_size)
	#end required
#end
end
drawme.close()


