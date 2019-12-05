local Stack = {}
Stack.__index = Stack

function Stack.new()
	-- constructor for stack data
	return setmetatable({}, Stack)
end

function Stack:Push(v)
	self[#self+1] = v
end

function Stack:Pop()
	local copy = self[#self]
	self[#self] = nil
	return copy
end

function Stack:Peek()
	return self[#self]
end

function Stack:IsEmpty()
	return #self == 0
end

return Stack
