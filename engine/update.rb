require "curses"

DEBUG = false

class Obj	#object to cointain the y,x, and string info needed to draw
attr_accessor :array

	def initialize(y,x,str,id,ticks)
		@array = Array.new
		@array << y << x << str << id << ticks
	end
end
#--------------------------------------------------------------------

class Updater
	LOG_LENGTH = 12
	LOG_Y = 6
	LOG_X = 0

	def initialize(y,x)
		Curses.init_screen
		@lines_y = Curses.lines
		@cols_x = Curses.cols
		@logs = Array.new
	#	puts "lines: #{Curses.lines} col: #{Curses.cols}"
		puts "\e[8;#{y};#{x};t"	#resize terminal
		@array = Array.new
		@new_y = y
		@new_x = x
	end

	def close()	#call before ending ruby program to resize the sceen and exit nicely
		puts "\e[8;#{@lines_y};#{@cols_x};t"
	end

	def add(y,x,str,id,ticks)	#y,x position of string to draw, id if needing to update it later, # of ticks to disp[lay item -1 for infinity
		ticks = 1 if ticks == nil
		if id == nil
			@array << Obj.new(y,x,str,0, ticks)
			return
		end
		@array.each do |i|
			if i.array[3] == id
				i.array[0] = y
				i.array[1] = x
				i.array[2] = str
				return
			end
		end
		@array << Obj.new(y,x,str,id, ticks)
	end

	def log(str)
		return if str == nil
		while str.size > @new_x
			offset = 0
			while str[@new_x-offset] != ' '
				offset +=1
			end
			str2 = str[0,@new_x-offset]	
			@logs << str2
			str = str[@new_x-offset+1,str.size]
		end
		@logs << str
		while @logs.size > LOG_LENGTH
			@logs.shift
		end
		for index in 0 ... @logs.size
			add(LOG_Y+index,LOG_X,@logs[index],200+index,-1)	#need better id and such
		end
	end

	def clearLog()
		for index in 0 ... LOG_LENGTH
			log("")
		end
	end

	def maddstr(y,x,str)
		Curses.setpos(y,x)
		Curses.addstr(str)
	end
	
	def draw_screen()
		Curses.clear
		@array.each do |i|
			if DEBUG
				maddstr(i.array[0],i.array[1],"#{i.array[2]} (#{i.array[3]},#{i.array[4]})")
			else
				maddstr(i.array[0],i.array[1],"#{i.array[2]}")
			end
		end
		maddstr(1,1,"Objects: #{@array.size()}") if DEBUG
		Curses.setpos(0,0)
	end
	
	def tick()
		@array.each do |i|
			i.array[4] -= 1
			if i.array[4] < 0
				i.array[4] =-1
			end
			if i.array[4] == 0
				@array.delete(i)
			end
		end
	end

	def dump()
		@array= Array.new
	end

	def remove(id)
		@array.each do |i|
			if i.array[3] == id
				@array.delete(i)
				return
			end
		end
	end

	def refresh()
		Curses.refresh
		Curses.setpos(0,0)
	end

	def setPos(y,x)
		Curses.setpos(y,x)
	end

end

puts "test"
