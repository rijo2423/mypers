Function publishAppEvent(key, press, screenId, screenType, navigationInfo, custEventInfo,pcCustomInfo=invalid) as boolean

    eventTrackerObj = {}
    eventTrackerObj.eventType = "RemoteKeyEvent"
    eventTrackerObj.press = press
    eventTrackerObj.key = key
    eventTrackerObj.eventInfo = {id:screenId, screenType:screenType, navInfo:navigationInfo, customInfo:custEventInfo, pcCustomInfo: pcCustomInfo}
    m.global.setField("eventTracker",eventTrackerObj)
    return true
    
End Function

Function publishRemoteKeyEvent(screen,key, press)

    turboKeyEvent = {key:key,press:press,originator:screen}
    m.global.setField("keyEventTracker", turboKeyEvent)
    return true
    
End Function

Function buildRequestUrl(urlPath,urlResource) 
    replacedPrefixUrlResource = urlResource.replace("../","")
    requiredurl = urlPath + replacedPrefixUrlResource
    return requiredurl
End Function
