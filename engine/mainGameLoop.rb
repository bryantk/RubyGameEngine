class Main_game_loop
attr_accessor :ticks_per_second, :slow_frames, :deltaT, :sleep_time
	def initialize(fps)
	@sleep_time = 0
	@slow_frames = 0
	@deltaT = 1
	@ticks_per_second = 30
	@ticks_per_second = fps if fps != nil
	@ticks_per_second = 60 if @ticks_per_second > 60
	@ticks_per_second = 1 if @ticks_per_second < 1
	@skip_ticks = (1.to_f/@ticks_per_second) #in seconds
	@time_old = Time.now.to_f
	@time_now = @time_old
	end

	def sleep_MGL()
		@time_now  = Time.now.to_f
		@deltaT  = @time_now - @time_old
		@sleep_time = @skip_ticks - @deltaT 	
		@slow_frames += 1 if sleep_time < 0
		@time_old = @time_now
		if sleep_time >= 0
			sleep(sleep_time)	
			@time_old = Time.now.to_f
			return true
		end
		return false
	end

end

