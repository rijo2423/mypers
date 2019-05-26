Function Init()
    print "ggggg"
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
    
    m.slideTimer = m.top.findNode("slideTimer")
    m.slideTimer.ObserveField("fire","onSlideTimerFired")
     
End Function

function initValues()

    m.video = m.top.findNode("video")
    m.homeVideoPoster = m.top.findNode("homeVideoPoster")
    m.homeVideoTitle = m.top.findNode("homeVideoTitle")
    m.homeVideoDesc = m.top.findNode("homeVideoDesc")
    m.homeVideoButton = m.top.findNode("homeVideoButton")

    m.homeVideoTitle.font = m.global.fontRegistry.standard_64
    m.homeVideoTitle.color = "#DDE2E6"
    
    m.homeVideoDesc.color = "#DDE2E6"
    m.homeVideoDesc.font = m.global.fontRegistry.regular_35
    
    m.episodeScreen = m.top.findNode("episodeSection")     

end function

function contentAvailable() 

    drawHomeScreen()
    createGalleryRow()
    startSlideTimer()
     
end function

sub onSlideTimerFired()

    stopSlideTimer()
    showNextSlide()
    startSlideTimer()

end sub

function startAnimation(index)
   
   if index = 0
        transAnimation5 = m.top.FindNode("transAnimation5")
        transAnimation5.control = "start"
   else if index = 1
        transAnimation6 = m.top.FindNode("transAnimation6")
        transAnimation6.control = "start"    
   end if

end function

function showNextSlide()

    nextIndex = m.currentIndex + 1
    if m.homeVideos[nextIndex] = invalid
        nextIndex = 0    
    end if
    m.currentIndex = nextIndex
    ? "onSlideTimerFired" ; m.currentIndex 
    drawHomeScreen()

end function

function drawHomeScreen()

    index = m.currentIndex
    
    m.homeVideos = m.homeInfo.videos
    m.homeVideoPoster.uri = m.homeVideos[index].videoPoster
    m.homeVideoTitle.text = m.homeVideos[index].videoTitle
    m.homeVideoDesc.text = m.homeVideos[index].videoDesc
    if m.homeVideos[index].videoType = "series"
        m.homeVideoButton.uri = "pkg:/locale/images/$$RES$$/Episode.png"
    else
        m.homeVideoButton.uri = "pkg:/locale/images/$$RES$$/Watch.png"
    end if

end function

function customInfoChanged()

    'm.genericScreen.setFocus = true

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
    print "home press " ; press ; " key " ; key
    if press = true
    print "hhh"
        if key = "back"
            if m.episodeScreen <> invalid and m.episodeScreenVisible = true
                 hideEpisodeScreen()
                 m.top.setFocus(true)
                 m.homeVideoButton.visible = true
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
            print "m.episodeListScreen" ; m.episodeListScreen
            if m.episodeScreen <> invalid and m.episodeScreenVisible = true
                print "1111"
            else if m.genericScreen <> invalid
                print "2222"
                
                m.source = "RowList"
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
                m.source = "Home"
                m.genericScreen.setScreenFocus = false 
                m.genericScreen.setFocus(false)
                m.top.setFocus(true)
                homeVideoGroupAnimation("down")
                channelGroupAnimation("down")                
             
             end if
        else if key = "OK"
            print "m.homeVideos[m.currentIndex].videoType" ; m.homeVideos[m.currentIndex].videoType
            if m.homeVideos[m.currentIndex].videoType = "series"
                m.homeVideoButton.visible = false
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
            showNextSlide()
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

    print "m.source =========" ; m.source
    if m.source = "RowList"
        if m.genericScreen <> invalid
            m.genericScreen.moveToForeGround = true
        end if
    else if m.episodeScreen <> invalid and m.episodeScreenVisible = true   
        m.episodeScreen.setFocus(true)
        m.episodeScreen.setScreenFocus = true
    else
        m.slideshow = true    
    end if
    return true
    
End Function

Function onScreenTerminate() as boolean

    return true
    
End Function


function homeVideoGroupAnimation(direction)
   
   if direction = "down"
        transAnimation1 = m.top.FindNode("transAnimation1")
        transAnimation1.control = "start"
   else if direction = "up"
        transAnimation2 = m.top.FindNode("transAnimation2")
        transAnimation2.control = "start"   
   end if

end function

function channelGroupAnimation(direction)
   
   if direction = "up"
        transAnimation3 = m.top.FindNode("transAnimation3")
        transAnimation3.control = "start"
   else if direction = "down"
        transAnimation4 = m.top.FindNode("transAnimation4")
        transAnimation4.control = "start"   
   end if

end function