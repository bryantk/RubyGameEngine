def within(x, lower, upper)		#returns value 'within' lower and upper bounds
	x = lower if (x < lower)
	x = upper if (x > upper)
	x
end
