class Timer
attr_accessor :ticks
	def initialize( ticks )
	@ticks_per_second = ticks
	@ticks = 0
	end

	def tick()
		@ticks += 1
	end

	def get_time()
		str = ""
		str << (@ticks/(@ticks_per_second*60*60)).to_s << ":" 
		str << "0" if ((@ticks/(@ticks_per_second*60))%60) < 10
		str << ((@ticks/(@ticks_per_second*60))%60).to_s << ":" 
		str << "0" if ((@ticks/@ticks_per_second)%60) < 10
		str << ((@ticks/@ticks_per_second)%60).to_s
		return str
	end

	def future_time(t)
		return ((t*@ticks_per_second)+@ticks)
	end

		def to_gt(i)
		str = ""
		str << (i/(@ticks_per_second*60*60)).to_s << ":" 
		str << "0" if ((i/(@ticks_per_second*60))%60) < 10
		str << ((i/(@ticks_per_second*60))%60).to_s << ":" 
		str << "0" if ((i/@ticks_per_second)%60) < 10
		str << ((i/@ticks_per_second)%60).to_s
		return str
	end

end

