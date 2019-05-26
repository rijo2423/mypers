Function Init()

    m.commonConstants = getCommonDimensions()
    m.homePageConstants = getHomeDimensions()
    createBackground()
    m.top.addField("terminate","bool", true)
    setDeviceId()
    SetupAnalytics()
    initGlobalFontRegistry()
    
End Function

function setDeviceId()

    result = ""
    ba = CreateObject("roByteArray")
    ba.FromASCIIString(CreateObject("roDeviceInfo").GetDeviceUniqueId())
    digest = CreateObject("roEVPDigest") 
    digest.Setup("sha1")
    result = digest.Process(ba)
    
    ? "result================" ; result   
    
    m.global.addField("deviceId","string",false)
    m.global.setField("deviceId", result)
    
    ?"m.global.deviceId-----------" ; m.global.deviceId
      
    
end function

Sub SetupAnalytics()

    m.global.addField("RSG_analytics","node",false)
    m.global.RSG_analytics = CreateObject("roSGNode","Roku_Analytics:AnalyticsNode")
    m.global.RSG_analytics.debug = true
    
    trackingID = "UA-136755410-1"
    
    ? "trackingID" ; trackingID
       
    ' Analytics Initialization
    m.global.RSG_analytics.init = {
         
        'set data to IQ analytics
        Google : {
            trackingID : trackingID
            defaultParams : {
                an : "RokuAnalyticsClient"
            }
        }
        
    }

End Sub

Function createBackground()

    m.homeDimensions = m.top.createChild("Poster")
    m.homeDimensions.id = "bgPoster"
    m.homeDimensions.uri = m.homePageConstants.homebackgroundImageFileName
    
End Function

Function onAppLaunchParamsAvailable()

    m.appLaunchParams = m.top.appLaunchParams
    parseAppLaunchParams()

end Function

Function parseAppLaunchParams()

    launchParams = m.appLaunchParams
    m.deepLink = false
    
    m.global.addField("channelInfo" ,"assocarray",false)
    m.global.addField("radioInfo" ,"assocarray",false)
    m.global.addField("homeInfo" ,"assocarray",false)
    
    if ( m.appLaunchParams <> invalid)
    
        m.contentID = launchParams.ContentId
        m.mediaType = launchParams.MediaType
        
        print "contentID" ; m.contentID
        print "mediaType" ; m.mediaType
        
        if m.contentID <> invalid and m.mediaType <> invalid and (m.mediaType = "special" or m.mediaType = "live")
            m.deepLink = true        
        end if
        
    end if
    
    initNavigation()
    
    m.homeVideosFetched = false
    m.channelsFetched = false
    m.radiosFetched = false
    readHomeVideos()
    readChannels()
    readRadios()
    
End Function

function readHomeVideos()

    m.homeTask = m.top.createChild("ConfigTask")
    m.homeTask.functionName = "fetchInfo"
    
    requestParams = {}
    requestParams.url = "http://jcagarcia.com/dtv/content/homeInfo.json"
    requestParams.httpMethod = "GET"
    requestParams.responseType = "TEXT"
    
    m.homeTask.input = requestParams
    m.homeTask.observeField("output", "onHomeTaskCompleted")
    m.homeTask.control = "RUN"      
     
end function 

function onHomeTaskCompleted()

    if m.homeTask <> invalid and m.homeTask.output <> invalid and m.homeTask.output.result <> invalid
        print "m.homeTask=======" ; m.homeTask.output.result
        homeInfo = m.homeTask.output.result
        m.global.setField("homeInfo", homeInfo)
        m.homeVideosFetched = true
        process()
    end if
    
    removeHomeTask()

end function  

function removeHomeTask()

    if m.homeTask <> invalid
        m.top.removeChild(m.homeTask)
        m.homeTask = invalid
    end if 
    
end function 

function readChannels()

    m.channelTask = m.top.createChild("ConfigTask")
    m.channelTask.functionName = "fetchInfo"
    
    requestParams = {}
    requestParams.url = "http://jcagarcia.com/dtv/content/channelInfo.json"
    requestParams.httpMethod = "GET"
    requestParams.responseType = "TEXT"
    
    m.channelTask.input = requestParams
    m.channelTask.observeField("output", "onChannelTaskCompleted")
    m.channelTask.control = "RUN"       

end function

function onChannelTaskCompleted()

    if m.channelTask <> invalid and m.channelTask.output <> invalid and m.channelTask.output.result <> invalid
        print "m.channelTask=======" ; m.channelTask.output.result
        channelInfo = m.channelTask.output.result
        m.global.setField("channelInfo", channelInfo)
        m.channelsFetched = true
        process()
    end if
    
    removeChannelTask()

end function

function removeChannelTask()
    if m.channelTask <> invalid
        m.top.removeChild(m.channelTask)
        m.channelTask = invalid
    end if 
end function 

function readRadios()

    m.radioTask = m.top.createChild("ConfigTask")
    m.radioTask.functionName = "fetchInfo"
    
    requestParams = {}
    requestParams.url = "http://jcagarcia.com/dtv/content/radioInfo.json"
    requestParams.httpMethod = "GET"
    requestParams.responseType = "TEXT"
    
    m.radioTask.input = requestParams
    m.radioTask.observeField("output", "onRadioTaskCompleted")
    m.radioTask.control = "RUN"       

end function

function onRadioTaskCompleted()

    if m.radioTask <> invalid and m.radioTask.output <> invalid and m.radioTask.output.result <> invalid
        print "m.radioTask=======" ; m.radioTask.output.result
        radioInfo = m.radioTask.output.result
        m.global.setField("radioInfo", radioInfo)
        removeRadioTask()
        m.radiosFetched = true
        process()
    end if

end function

function removeRadioTask()
    if m.radioTask <> invalid
        m.top.removeChild(m.radioTask)
        m.radioTask = invalid
    end if 
end function   

function process()

    print "m.homeVideosFetched" ; m.homeVideosFetched
    print "m.channelsFetched" ; m.channelsFetched
    print "m.radiosFetched" ; m.radiosFetched
    if m.homeVideosFetched = true and m.channelsFetched = true and m.radiosFetched = true
        m.homeVideosFetched = false
        m.channelsFetched = false
        m.radiosFetched = false 
        launchHome()        
    end if

end function 

Function initNavigation()

    m.navStack = createObject("roArray",10,true)
    m.activeScreen = invalid
    m.activePopUp = invalid
    
    m.global.addField("eventTracker","assocarray", true)
    m.global.ObserveField("eventTracker", "keyEventHandler")
    initNavigationMap()
    
End Function

Function initNavigationMap()

    m.navigationMap = {}
    initWindowMap()
    buildDefaultNavInfoForScreens()
    
End Function

Function buildDefaultNavInfoForScreens()

    navMap = {}
    navMap["options"] = {terminate:false, moveToBackground:true, appTerminate:false, eventKey:"Settings"}
    navMap["back"] = {terminate:true, moveToBackground:false, appTerminate:true, eventKey :"none"}
    m.navigationMap.addReplace("Home", navMap)
    
End Function


Function launchHome()

     m.home = m.top.createChild("Home")
     m.activeScreen = m.home
     
     deepLinkParams = {}
     deepLinkParams.deepLink = m.deepLink
     deepLinkParams.contentID = m.contentID
     deepLinkParams.mediaType = m.mediaType
     m.home.deepLinkParams = deepLinkParams
     
     m.home.content = true
     m.activeScreen.setFocus(true)
     m.activeScreen.screenFocus = true
     
End Function

Function initGlobalFontRegistry()

    fontRegistryAssocarray = {}
    m.global.addField("fontRegistry" ,"assocarray",false)
    
    standard_30  = CreateObject("roSGNode", "Font")
    standard_30.uri = "pkg:/fonts/ttf/BIGJOHN.otf"
    standard_30.size = 30
    fontRegistryAssocarray.addReplace("standard_30", standard_30)

    standard_44  = CreateObject("roSGNode", "Font")
    standard_44.uri = "pkg:/fonts/ttf/BIGJOHN.otf"
    standard_44.size = 44
    fontRegistryAssocarray.addReplace("standard_44", standard_44)
    
    standard_26  = CreateObject("roSGNode", "Font")
    standard_26.uri = "pkg:/fonts/ttf/BIGJOHN.otf"
    standard_26.size = 26    
    fontRegistryAssocarray.addReplace("standard_26", standard_26)

    standard_64  = CreateObject("roSGNode", "Font")
    standard_64.uri = "pkg:/fonts/ttf/BIGJOHN.otf"
    standard_64.size = 64    
    fontRegistryAssocarray.addReplace("standard_64", standard_64)

    standard_35  = CreateObject("roSGNode", "Font")
    standard_35.uri = "pkg:/fonts/ttf/BIGJOHN.otf"
    standard_35.size = 35 
    fontRegistryAssocarray.addReplace("standard_35", standard_35)
    
    regular_35  = CreateObject("roSGNode", "Font")
    regular_35.uri = "pkg:/fonts/ttf/Lato-Regular.ttf"
    regular_35.size = 35 
    fontRegistryAssocarray.addReplace("regular_35", regular_35) 
    
    standard_52  = CreateObject("roSGNode", "Font")
    standard_52.uri = "pkg:/fonts/ttf/BIGJOHN.otf"
    standard_52.size = 52
    fontRegistryAssocarray.addReplace("standard_52", standard_52)           

    standard_28  = CreateObject("roSGNode", "Font")
    standard_28.uri = "pkg:/fonts/ttf/Lato-Regular.ttf"
    standard_28.size = 28
    fontRegistryAssocarray.addReplace("standard_28", standard_28) 
        
    m.global.setField("fontRegistry",fontRegistryAssocarray)
    
End Function

Function keyEventHandler()

    eventTracker = m.global.eventTracker
    eventInfo = eventTracker.eventInfo
    if eventInfo <> invalid
        navInfo = eventInfo.navInfo
        customInfo = eventInfo.customInfo
        pcCustomInfo = eventInfo.pcCustomInfo
        if navInfo = invalid
            key = eventTracker.key
            navInfo = buildNavInfo(eventInfo,key)
        else
        end if
        if navInfo <> invalid 
            if navInfo.appTerminate
                cleanUpAndTerminateApp()
            else if navInfo.appSignOut <> invalid and navInfo.appSignOut
                cleanUpAndGetStarted()    
            else
                Navigate(navInfo,customInfo)
            end if
        end if
    end if
    
End Function

Function initWindowMap()

     m.windowMap = {}
     m.windowMap["VideoPlayer"] = {windowType:"screen",windowId :"VideoPlayer"}
     m.windowMap["GenericScreen"] = {windowType:"screen",windowId :"GenericScreen"}
     m.windowMap["EpisodeScreen"] = {windowType:"screen",windowId :"EpisodeScreen"}
     m.windowMap["Home"] = {windowType:"screen",windowId :"Home"}
End Function

Function Navigate(navigationInfo, custEventInfo)

    nextWindowInfo = invalid
    nextWindowType = invalid
    nextWindowId = invalid
    if navigationInfo <> invalid
        nextWindowKey = navigationInfo.eventKey
        if nextWindowKey <> invalid
            nextWindowInfo = m.windowMap.LookUp(nextWindowKey)
            nextWindowType = nextWindowInfo.windowType
            nextWindowId = nextWindowInfo.windowId
        end if
        updateCurrentWindowState(navigationInfo, custEventInfo)
        handleNextWindowState(custEventInfo, navigationInfo, nextWindowType, nextWindowId)
    end if
         
End Function

Function updateCurrentWindowState(navigationInfo, custEventInfo)
    if m.activePopUp = invalid
        if navigationInfo.terminate=true
            disposeActiveWindow()
        else if navigationInfo.moveToBackground = true
            moveCurrentWindowToBackground()
        end if
    else
        disposeActiveDialog()
        if custEventInfo <> invalid and custEventInfo.dismissActiveScreenOnOk=true
            disposeActiveWindow()
        else
            setFocusToActiveWindow()
        end if
    end if
End Function

Function handleNextWindowState(custEventInfo, navigationInfo, nextWindowType, nextWindowId)

    if nextWindowType <> invalid
        if nextWindowType = "screen"
            if(nextWindowId<>invalid)
                  createAndShowNewWindow(nextWindowId, custEventInfo)
            else
                  showPrevWindowFromStack()
            end if 
        end if
    else
         if custEventInfo = invalid or custEventInfo.dismissActiveScreenOnOk <> false
            showPrevWindowFromStack()
         end if
    end if 
    
End Function

Function moveCurrentWindowToBackground()
	
	if m.activeScreen <> invalid
		m.activeScreen.setFocus(false)
	    m.activeScreen.screenFocus = false
	    m.activeScreen.moveToBackGround=true
	    m.activeScreen.visible=false
	    m.navStack.push(m.activeScreen)
	end if
    
End Function

Function disposeActiveWindow()
	
	if m.activeScreen <> invalid
		m.activeScreen.setFocus(false)
	    m.activeScreen.screenFocus = false
	    m.activeScreen.terminate=true
	    m.activeScreen.visible=false
	    m.top.RemoveChild(m.activeScreen)
	    m.activeScreen = invalid
	end if
    
End Function

Function disposeActiveDialog()

	if m.activePopUp <> invalid
		 m.activePopUp.setFocus(false)
	    m.activePopUp.screenFocus = false
	    m.activePopUp.visible=false
	    m.top.RemoveChild(m.activePopUp)
	    m.activePopUp = invalid
	end if
   
End Function

Function setFocusToActiveWindow()
	
	if  m.activeScreen <> invalid
		m.activeScreen.setFocus(true)
	    m.activeScreen.screenFocus = true
	    m.activeScreen.moveToForeGround = true
	end if
    
End Function

Function createAndShowNewWindow(screenName, custEventInfo)

    newScreen= m.top.createChild(screenName)
    if newScreen <> invalid
        newScreen.customInfo = custEventInfo
        m.activeScreen = newScreen
        if m.activeScreen <> invalid
	        m.activeScreen.setFocus(true)
	        m.activeScreen.screenFocus = true
	        m.activeScreen.visible=true
        end if
        
    end if
    
End Function

Function showPrevWindowFromStack()

    newScreen= m.navStack.pop()
    if newScreen <> invalid
        m.activeScreen = newScreen
        m.activeScreen.setFocus(true)
        m.activeScreen.screenFocus = true
        m.activeScreen.moveToForeGround = true
        m.activeScreen.visible=true
    end if
    
End Function

Function buildNavInfo(eventInfo as Object, key as String) as Object
    navInfo = invalid
    currActiveScreen = eventInfo.id
    currScreenType = eventInfo.screenType
    if currActiveScreen <> invalid 
        currNavInfoMap = m.navigationMap.LookUp(currActiveScreen)
        if currNavInfoMap<>invalid
            navInfo = currNavInfoMap.LookUp(key)    
        end if        
    end if
    if navInfo=invalid
        if(key="back")
            navInfo = {terminate:true, eventKey :invalid, moveToBackground:invalid, appTerminate:false}
        else if (key = invalid) ' A non-user interaction event eg: Issue in data fetch.
            navInfo = {terminate:false, eventKey :invalid, moveToBackground:invalid, appTerminate:false}
        end if
    end if
    
    return navInfo
    
End Function

Function onKeyEvent(key, press) as boolean
    return true
End Function

Function cleanUpAndTerminateApp()

    m.navStack = invalid
    m.activePopUp = invalid
    m.activeScreen = invalid
    m.top.setField("terminate", true)'Screen Terminate
    
End Function
