require "curses"
# an input class for text adventures. I.e. enter text commands into a box
class Input
attr_accessor :str, :ready
	def initialize()
		Curses.raw # intercept everything
		Curses.noecho
		Curses.timeout=0
		Curses.stdscr.keypad(true) # enable arrow keys
		@commands = Array.new
		@str = ""
	end

	def get_input()
		char = Curses.getch
		if char != nil
			case char
				when 10	then	 # 10 = enter (line feed)
							@commands << ":"+@str
							@str = ""
				when 263	then	@str.chop! #backspace
				when 259	then	@commands << ":north"
				when 260	then	@commands << ":west"
				when 261	then	@commands << ":east"
				when 258	then	@commands << ":south"
				else		@str += char.to_s
			end
		end
	end

	def exists()
		return @str if @str.size > 0
	end

	def command_size()
		return @str.size
	end

	def clear()
		@str = ""
	end

	def get_command()	#returns first command in queue, nil if empty
		@commands.shift
	end
end


# global variable $name
# instance variable @name
# class variable @@name
