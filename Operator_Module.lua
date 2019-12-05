local Operator = {}
Operator.__index = Operator

function Operator.new(operator, value, associativity, apply)
	local newOperator = {}
	setmetatable(newOperator, Operator)
	
	newOperator.Sign = operator
	newOperator.Value = value --precedence over other operators
	newOperator.Associativity = associativity
	newOperator.Apply = apply
	
	return newOperator
end

function Operator:GetApply()
	return self.Apply or nil
end

function Operator:LessOrEqualTo(o)
	return self.Value <= o.Value
end

function Operator:GetSign()
	return self.Sign or nil
end

function Operator:GetValue()
	return self.Value or nil
end

function Operator:GetAssociativity()
	return self.Associativity or nil
end

return Operator
