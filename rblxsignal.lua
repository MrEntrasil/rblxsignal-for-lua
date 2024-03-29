local class = {
    classList = {}
}

class.new = function(name, structure, tab)
    local Pretable = structure
    if Pretable["Name"] then
        Pretable["Name"] = nil
    end
    Pretable["Name"] = name
    
    if tab then
        table.insert(tab, Pretable)
    else
        table.insert(class.classList, Pretable)
    end

    return Pretable
end

local function checkevent(list, name)
    for i, v in pairs(list["Events"]) do
        if v["Name"] == name then
            return v
        end
    end

    return nil
end

local module = {
    signal = {
        -- Create a new signal
        new = function(tab)
            if type(tab) ~= "table" then
                print("'tab' Parameter expected type = 'table'")
                return nil
            end
        
            local newClass = class.new(tab["Name"], tab)
        
            if not tab["Events"] then
                tab["Events"] = {}
            end
        
            for i, v in pairs(tab["Events"]) do
        
                if not v["Callbacks"] then
                    v["Callbacks"] = {}
                end
        
                v.OnFire = function(callback)
                    if type(callback) ~= "function" then
                        print("'callback' Parameter expected type = 'function'")
                        return
                    end
        
                    v["Callbacks"][#v["Callbacks"]+1] = callback
                end
        
                v.Fire = function(self, password, ...)
                    if not self then
                        return nil
                    end
            
                    if tab["Password"] and tab["Password"] == password then
                        for _, k in pairs(v["Callbacks"]) do
                            if type(k) == "function" then
                                k(...)
                            end
                        end
                    elseif not tab["Password"] then
                        for _, k in pairs(v["Callbacks"]) do
                            if type(k) == "function" then
                                k(...)
                            end
                        end
                    end
                end
            end
        
            return newClass
        end
    },
    event = {
        -- Create a new event in the given signal
        new = function(name, signal)
            local list = checkevent(signal, name)

            if list then
                print("list '"..name.."' already exists!")
                return nil
            end
        
            if not signal["Events"] then
                signal["Events"] = {}
            end
        
            local newEvent = class.new(name, {}, signal["Events"])
        
            if not newEvent["Callbacks"] then
                newEvent["Callbacks"] = {}
            end
        
            newEvent.OnFire = function(callback)
                if type(callback) ~= "function" then
                    print("'callback' Parameter expected type = 'function'")
                    return
                end
        
                newEvent["Callbacks"][#newEvent["Callbacks"]+1] = callback
            end
        
            newEvent.Fire = function(self, password, ...)
                if not self then
                    return nil
                end
        
                if signal["Password"] and signal["Password"] == password then
                    for _, k in pairs(newEvent["Callbacks"]) do
                        if type(k) == "function" then
                            k(...)
                        end
                    end
                elseif not signal["Password"] then
                    for _, k in pairs(newEvent["Callbacks"]) do
                        if type(k) == "function" then
                            k(...)
                        end
                    end
                end
            end
        
            return newEvent
        end,

        -- Find an event in the given signal (if not exists, return nil)
        find = function(signal, name)
            local list = checkevent(signal, name)

            return list
        end
    }
}

return module