Function Init()
    m.source = "Home"
    m.slideshow = true
    m.homePageConstants = getHomeDimensions()
    'createBackground()
    observeEventsOfInterest()
    m.homeInfo = m.global.homeInfo
    initValues()
    m.currentIndex = 0
    m.homeVideoGroup = m.top.findNode("homeVideoGroup")
    m.episodeScreenVisible = false
    
    m.isFirst = true
    
    m.paginationGrp = m.top.findNode("paginationGrp")
    
    m.slideTimer = m.top.findNode("slideTimer")
    m.slideTimer.ObserveField("fire","onSlideTimerFired")
     
End Function

function initValues()

    m.homeVideoPoster1 = m.top.findNode("homeVideoPoster1")
    m.homeVideoTitle1 = m.top.findNode("homeVideoTitle1")
    m.homeVideoDesc1 = m.top.findNode("homeVideoDesc1")
    m.homeVideoButton1 = m.top.findNode("homeVideoButton1")

    m.homeVideoTitle1.font = m.global.fontRegistry.standard_64
    m.homeVideoTitle1.color = "#DDE2E6"
    m.homeVideoDesc1.color = "#DDE2E6"
    m.homeVideoDesc1.font = m.global.fontRegistry.regular_35
    
    m.homeVideoPoster2 = m.top.findNode("homeVideoPoster2")
    m.homeVideoTitle2 = m.top.findNode("homeVideoTitle2")
    m.homeVideoDesc2 = m.top.findNode("homeVideoDesc2")
    m.homeVideoButton2 = m.top.findNode("homeVideoButton2")

    m.homeVideoTitle2.font = m.global.fontRegistry.standard_64
    m.homeVideoTitle2.color = "#DDE2E6"
    m.homeVideoDesc2.color = "#DDE2E6"
    m.homeVideoDesc2.font = m.global.fontRegistry.regular_35    
    
    m.episodeScreen = m.top.findNode("episodeSection")     

end function

function drawPagination()

    videos = m.homeVideos

    for i = 0 to videos.Count()-1
        rect = m.paginationGrp.createChild("Rectangle")
        if m.currentIndex = i
            rect.color = "0xFFFFFF"
        else
            rect.color = "0x4D5D66"
        end if
        rect.id = "rect" + i.tostr()
        rect.width = 56
        rect.height = 6
    end for
    
end function

function removePagination()

    count = m.paginationGrp.getChildCount()
    ssss = m.paginationGrp.removeChildrenIndex(count, 0)
    
end function

function contentAvailable() 

    m.drawnHome = false
    m.splashVideoUrl = m.top.splashVideo
    if m.splashVideoUrl <> ""
        m.drawnHome = false
        m.source = "Home"
        navigationInfo = {terminate:false, moveToBackground:true, appTerminate:false, eventKey :"SplashPlayer"}
        customInfo = {url : m.splashVideoUrl, source : m.source, deepLink : false}
        publishAppEvent("Ok", true, "Home", m.top.screenType, navigationInfo, customInfo)    
    else
        m.drawnHome = true
        drawHomeScreen()
        drawPagination()
        createGalleryRow()
        startSlideTimer()    
    end if
    
end function

sub onSlideTimerFired()

    stopSlideTimer()
    showNextSlide("right")
    startSlideTimer()

end sub

function startAnimation()
   
   ? "m.isFirst========================" ; m.isFirst
   if m.isFirst = true
        transAnimation5 = m.top.FindNode("transAnimation5")
        transAnimation5.control = "start"
   else if m.isFirst = false
        transAnimation6 = m.top.FindNode("transAnimation6")
        transAnimation6.control = "start"    
   end if

end function

function showNextSlide(key)

    nextIndex = m.currentIndex + 1
    if key = "left"
        videoCount = m.homeVideos.Count()
        if m.currentIndex = 0
            nextIndex = videoCount - 1
        else
            nextIndex = m.currentIndex - 1
        end if
    end if
    
    if m.homeVideos[nextIndex] = invalid
        nextIndex = 0    
    end if
    m.currentIndex = nextIndex
    
    setNextVideo()
    startAnimation()
    
    removePagination()
    drawPagination()

end function

function drawHomeScreen()

    index = m.currentIndex
    
    m.homeVideos = m.homeInfo.videos
    m.homeVideoPoster1.uri = m.homeVideos[index].videoPoster
    m.homeVideoTitle1.text = m.homeVideos[index].videoTitle
    m.homeVideoDesc1.text = m.homeVideos[index].videoDesc
    if m.homeVideos[index].videoType = "series"
        m.homeVideoButton1.uri = "pkg:/locale/images/$$RES$$/Episode.png"
    else
        m.homeVideoButton1.uri = "pkg:/locale/images/$$RES$$/Watch.png"
    end if
    m.isFirst = true
    
end function

function setNextVideo()

    index = m.currentIndex
    
    if m.isFirst = true
    
        m.homeVideoPoster2.uri = m.homeVideos[index].videoPoster
        m.homeVideoTitle2.text = m.homeVideos[index].videoTitle
        m.homeVideoDesc2.text = m.homeVideos[index].videoDesc
        if m.homeVideos[index].videoType = "series"
            m.homeVideoButton2.uri = "pkg:/locale/images/$$RES$$/Episode.png"
        else
            m.homeVideoButton2.uri = "pkg:/locale/images/$$RES$$/Watch.png"
        end if
        
        m.isFirst = false
    
    else
    
        m.homeVideoPoster1.uri = m.homeVideos[index].videoPoster
        m.homeVideoTitle1.text = m.homeVideos[index].videoTitle
        m.homeVideoDesc1.text = m.homeVideos[index].videoDesc
        if m.homeVideos[index].videoType = "series"
            m.homeVideoButton1.uri = "pkg:/locale/images/$$RES$$/Episode.png"
        else
            m.homeVideoButton1.uri = "pkg:/locale/images/$$RES$$/Watch.png"
        end if 
        
        m.isFirst = true   
    
    end if
    
end function

function createGalleryRow()

    m.genericScreen = m.top.createChild("GenericScreen")
    m.genericScreen.id = "genericScreen"
    m.genericScreen.deepLinkParams = m.top.deepLinkParams
    m.genericScreen.content = true
    m.genericScreen.translation = [120, 900]

end function

Function OnKeyEvent(key, press) as Boolean

    handled = false
    if press = true
        if key = "back"
            if m.episodeScreen <> invalid and m.episodeScreenVisible = true
                 hideEpisodeScreen()
                 m.top.setFocus(true)
                 m.homeVideoButton1.visible = true
                 m.homeVideoButton2.visible = true
                 m.paginationGrp.visible = true
                 m.genericScreen.visible = true
                 startSlideTimer()
            else
                m.overlay = m.top.CreateChild("Rectangle")
                m.overlay.color = "#001622"
                m.overlay.translation = [0,0]
                m.overlay.width = 1920
                m.overlay.height = 1080
                m.overlay.opacity = "0.96"
                m.overlay.visible = true
                m.appExitConfirmScreen = m.top.CreateChild("ConfirmScreen")
                m.appExitConfirmScreen.customInfo = {id:"homeExitConfirm", headingText:"", bodyText:"¿ESTA SEGURO QUE QUIERE SALIR?", bodyFont:m.global.fontRegistry.standard_44, button1Text:"SI", button2Text:"NO"}
                m.appExitConfirmScreen.ObserveField("actionConfirmed","OnAppExitActionConfirmed")
                m.appExitConfirmScreen.setfocus(true)           
            end if
        else if key="down"
            stopSlideTimer()
            if m.episodeScreen <> invalid and m.episodeScreenVisible = true
                
            else if m.genericScreen <> invalid
                
                'm.source = "RowList"
                m.genericScreen.setFocus(true)
                m.genericScreen.setScreenFocus = true
                homeVideoGroupAnimation("up")
                channelGroupAnimation("up")
                
            end if
        else if key="up"
             if m.episodeScreen <> invalid and m.episodeScreenVisible = true
                stopSlideTimer()
             else
                
                startSlideTimer()
                'm.source = "Home"
                m.genericScreen.setScreenFocus = false 
                m.genericScreen.setFocus(false)
                m.top.setFocus(true)
                homeVideoGroupAnimation("down")
                channelGroupAnimation("down")                
             
             end if
        else if key = "OK"
            if m.homeVideos[m.currentIndex].videoType = "series"
                m.homeVideoButton1.visible = false
                m.homeVideoButton2.visible = false
                m.paginationGrp.visible = false
                m.genericScreen.visible = false
                handled = true
                stopSlideTimer()
                showEpisodeScreen()
            else if m.homeVideos[m.currentIndex].videoType = "movie"
                stopSlideTimer()
                launchPlayer()
            end if
        else if key = "left" or key = "right"
            stopSlideTimer()
            showNextSlide(key)
            startSlideTimer()
        end if
    
    end if
    
    return handled

end function

sub startSlideTimer()

    m.slideTimer.control = "start"

end sub

sub stopSlideTimer()

    m.slideTimer.control = "stop"

end sub

function showEpisodeScreen()

    transAnimation7 = m.top.FindNode("transAnimation7")
    transAnimation7.control = "start"
    m.episodeScreen.customInfo = {homeVideo : m.homeVideos[m.currentIndex]}
    m.episodeScreen.setFocus(true)
    m.episodeScreenVisible = true

end function

function hideEpisodeScreen()

    transAnimation8 = m.top.FindNode("transAnimation8")
    transAnimation8.control = "start"
    m.episodeScreen.setFocus(false)
    m.episodeScreenVisible = false

end function

function launchPlayer()
    m.source = "Home"
    navigationInfo = {terminate:false, moveToBackground:true, appTerminate:false, eventKey :"VideoPlayer"}
    customInfo = {homeVideo : m.homeVideos[m.currentIndex], source : m.source, deepLink : false}
    publishAppEvent("Ok", true, "Home", m.top.screenType, navigationInfo, customInfo)
end function

Function OnAppExitActionConfirmed() as boolean
    navigationInfo = invalid
    customInfo = invalid
    key = "back"
    press = true
    if  m.appExitConfirmScreen.actionConfirmed
        navigationInfo = {terminate:true, appTerminate:true}    
    else
        m.overlay.visible = false
        m.top.removeChild(m.overlayBGRect)
        navigationInfo = {terminate:false, appTerminate:false}
        m.appExitConfirmScreen.setfocus(false)
        m.top.removeChild(m.appExitConfirmScreen)
        m.genericScreen.setFocus(true)
        m.genericScreen.visible = true
        m.genericScreen.moveToForeGround = true
    end if
    publishAppEvent(key, press, m.top.uniqueId, m.top.screenType, navigationInfo, customInfo)
End Function

Function observeEventsOfInterest()

     m.top.observeField("moveToBackGround", "onMoveToBackGround")
     m.top.observeField("moveToForeGround", "onMoveToForeGround")
     
End Function

Function createBackground()

    m.homeDimensions = m.top.createChild("Poster")
    m.homeDimensions.id = "bgPoster"
    m.homeDimensions.uri = m.homePageConstants.homebackgroundImageFileName
    
End Function

Function onMoveToBackGround() as boolean
    
    if m.genericScreen <> invalid
        m.genericScreen.moveToBackGround = true
    end if
    return true
    
End Function

Function onMoveToForeGround() as boolean

    ? "m.drawnHome=========================" ; m.drawnHome
    if m.source = "RowList"
        if m.genericScreen <> invalid
            m.genericScreen.moveToForeGround = true
        end if
    else if m.episodeScreen <> invalid and m.episodeScreenVisible = true   
        m.episodeScreen.setFocus(true)
        m.episodeScreen.setScreenFocus = true
    else if m.drawnHome = true
        m.slideshow = true
    else if m.drawnHome = false
        m.drawnHome = true
        drawHomeScreen()
        drawPagination()
        createGalleryRow()
        startSlideTimer()
    end if
    return true
    
End Function

Function onScreenTerminate() as boolean

    return true
    
End Function


function homeVideoGroupAnimation(direction)
   
   if direction = "down" and m.source = "RowList" 
        transAnimation1 = m.top.FindNode("transAnimation1")
        transAnimation1.control = "start"
        transAnimation1_1 = m.top.FindNode("transAnimation1_1")
        transAnimation1_1.control = "start"        
   else if direction = "up" and m.source = "Home"
        transAnimation2 = m.top.FindNode("transAnimation2")
        transAnimation2.control = "start"  
        transAnimation2_1 = m.top.FindNode("transAnimation2_1")
        transAnimation2_1.control = "start"         
   end if

end function

function channelGroupAnimation(direction)
   
   if direction = "up" and m.source = "Home"
        m.source = "RowList"
        transAnimation3 = m.top.FindNode("transAnimation3")
        transAnimation3.control = "start"
   else if direction = "down" and m.source = "RowList"
        m.source = "Home"
        transAnimation4 = m.top.FindNode("transAnimation4")
        transAnimation4.control = "start"   
   end if

end function