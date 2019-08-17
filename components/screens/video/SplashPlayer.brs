function init()
    
    m.video = m.top.findNode("videoPlayer")
    observeFields()
    
end function

Function observeFields()

    m.video.observeField("state", "onVideoPlayerStateChange")
    
End Function

function customInfoChanged()

    customInfo = m.top.customInfo
    m.source = customInfo.source
    
    m.streamUrl = customInfo.url
    playVideo()

end function

function playVideo() as void

    videoContent = createObject("RoSGNode", "ContentNode")
    videoContent.url = m.streamUrl
    videoContent.streamformat = "mp4"
    m.video.content = videoContent
    m.video.control = "play"
    m.video.setFocus(true)
    
end function

Function OnKeyEvent(key, press) as Boolean

    handled = true
    
    if press = true
    
        if key = "back"
            closePlayer()
        end if
       
    end if
    
    return handled
    
end function   

function onVideoPlayerStateChange()

    state = m.video.state  
    if state = "finished" or state = "error" 
        closePlayer()
    end if

end function    

function closePlayer()

    navigationInfo = {terminate:true, moveToBackground:false, appTerminate:false}
    customInfo = {source : m.source}
    publishAppEvent("back", true, "SplashVideo", m.top.screenType, navigationInfo, customInfo)

end function
