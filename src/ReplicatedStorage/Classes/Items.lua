--|| Interfaces ||--
export type Item = {
    Name: string,
    Description: string,
    Max_Stack: number,
    GetName: () -> string,
    GetDescription: () -> string,
    GetMaxStack: () -> number,
}

--|| Module ||--
local items = {}
items.__index = items

--|| Constructor ||--
function items.new(name: string, description: string, maxStack: number): Item
    local self = setmetatable({}, items)
    self.Name = name
    self.Description = description
    self.Max_Stack = maxStack
    return table.freeze(self)
end

--|| Public Methods ||--
function items:GetName(): string
    return self.Name
end

function items:GetDescription(): string
    return self.Description
end

function items:GetMaxStack(): number
    return self.Max_Stack
end

return items
