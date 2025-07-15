--|| Interfaces ||--
export type Item = {
    Name: string,
    Description: string,
    MaxStack: number,
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
    self.MaxStack = maxStack
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
    return self.MaxStack
end

return items
