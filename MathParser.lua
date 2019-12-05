local repr = require(3148021300)
local Stack = require(script.Parent:WaitForChild("Stack_Module"))
local Operator = require(script.Parent:WaitForChild("Operator_Module"))

local function Node(key)
	return {
		Value = key,
		Left = nil,
		Right = nil
		}
end

local function OperatorProp(operator)
	local Value, Associativity, Apply
	if operator == "+" then
		Value = 2
		Associativity = "left"
		Apply = function(arg1, arg2)
			return arg1 + arg2
		end
	elseif operator == "-" then
		Value = 2
		Associativity = "left"
		Apply = function(arg1, arg2)
			return arg1 - arg2
		end
	elseif operator == "*" then
		Value = 3
		Associativity = "left"
		Apply = function(arg1, arg2)
			return arg1 * arg2
		end
	elseif operator == "/" then
		Value = 3
		Associativity = "left"
		Apply = function(arg1, arg2)
			return arg1 / arg2
		end
	elseif operator == "^" then
		Value = 4
		Associativity = "right"
		Apply = function(arg1, arg2)
			return arg1 ^ arg2
		end
	else 
		return nil
	end
	return Value, Associativity, Apply
end

local function infixToPostfix(input)
	if #input == 0 then return end
	
	local output = Stack.new()
	local operatorStack = Stack.new()

	local s = 1
	local token
	local previousToken
	while s <= #input and wait() do
		-- read a token
		token = string.sub(input, s, s)
		if tonumber(token) == nil then
			s = s + 1
		else
			local i = s
			while (tonumber(string.sub(input, i+1, i+1)) or string.sub(input, i+1, i+1) == ".") and i < #input and wait() do
				i = i + 1
			end 
			token = string.sub(input, s, i)
			s = i + 1
		end
		
		-- token conditions
		if token == "(" then
			--expand
			if tonumber(previousToken) then
				local operator = Operator.new("*", OperatorProp("*"))
				operatorStack:Push(operator)
			end
			operatorStack:Push(token)
		elseif token == ")" then 
			while operatorStack:Peek() ~= "(" and wait() do
				output:Push(operatorStack:Pop())
			end
			-- if no left paren, mismatch
			if operatorStack:Peek() == "(" then
				operatorStack:Pop()
			end
		elseif tonumber(token) == nil then	
			local operator = Operator.new(token, OperatorProp(token))
		
			--if two operators between operands (+ and - only)
			if previousToken and tonumber(previousToken) == nil and previousToken:GetValue() == 2 then
				operator = (operator.Sign == previousToken.Sign) and Operator.new("+", OperatorProp()) or Operator.new("-", OperatorProp())
				if previousToken == operatorStack:Peek() then
					operatorStack:Pop()
				elseif previousToken == output:Peek() then
					output:Pop()
				end
			end	
				
			while not operatorStack:IsEmpty() and operatorStack:Peek() ~= "(" and operator:LessOrEqualTo(operatorStack:Peek()) and operatorStack:Peek().Associativity == "left" and wait() do
				output:Push(operatorStack:Pop())
			end	
			
			operatorStack:Push(operator)
			token = operator
		else
			output:Push(tonumber(token))			
		end
		previousToken = token
	end
		
	while not operatorStack:IsEmpty() and wait() do
		output:Push(operatorStack:Pop())
	end	

	return output	
end

local function BinaryTree(exp)
	local input = infixToPostfix(exp)
	local Tree 
	local TreeStack = Stack.new()
	
	for _, v in pairs(input) do
		if typeof(v) == "number" then
			TreeStack:Push(Node(v))
		elseif v.Sign then --if an operator
			local operator = Node(v)
			operator.Right = TreeStack:Pop()
			operator.Left = TreeStack:Pop()
			TreeStack:Push(operator)
		end
	end

	Tree = TreeStack:Pop()
	return Tree
end

local function evaluate(Node)
	local left = Node.Left
	local right = Node.Right
	
	if left and right then
		local Apply = Node.Value:GetApply()
		return Apply(evaluate(left), evaluate(right))
	else
		return Node.Value
	end
end

print(evaluate(BinaryTree("80(10)")))