function RegistryService_Read(section, key) as Object
    sec = CreateObject("roRegistrySection", section)
    if sec.Exists(key):
        return ParseJson(sec.Read(key))
    end if
    return invalid
end function

function RegistryService_Write(section, key, data) as Boolean
    sec = CreateObject("roRegistrySection", section)
    txtData = FormatJson(data)
    sec.Write(key, txtData)
    sec.Flush()
    return true
end function

function RegistryService_Delete(section, key) as Boolean
    sec = CreateObject("roRegistrySection", section)
    sec.Delete(key)
    sec.Flush()
    return true
end function