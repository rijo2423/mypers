function init()

    'm.video = m.top.findNode("videoPlayer")
    'm.radio = m.top.findNode("radioPlayer")  
    'observeFields()
    
    m.deviceId = m.global.deviceId
    
end function

Function observeFields()
    'm.radio.observeField("state","onVideoPlayerStateChange")
End Function

function showRadioBGColor()

    m.radioBGColor = m.top.findNode("radioBGColor")
    m.radioBGColor.visible = true

end function

function hideRadioBGColor()

    m.radioBGColor = m.top.findNode("radioBGColor")
    m.radioBGColor.visible = false

end function

function customInfoChanged()
    print "customInfoChanged" ; m.top.customInfo
    m.streamUrl = ""
    m.streamType = "homeVideo"
    m.pgmPosterUrl = ""
    m.channelName = ""
    m.colmIndex = 0
    
    m.top.setFocus(true)
    
    m.source = m.top.customInfo.source
    
    print "m.top.customInfo.focusedCont" ; m.top.customInfo.focusedCont
    
    if m.top.customInfo.focusedCont <> invalid
        m.streamUrl = m.top.customInfo.focusedCont.streamUrl
        m.streamType = m.top.customInfo.focusedCont.streamType
        m.pgmPosterUrl = m.top.customInfo.focusedCont.pgmPosterUrl
        m.channelName = m.top.customInfo.focusedCont.channelName
        m.colmIndex = m.top.customInfo.colmIndex
        
        item = m.top.customInfo.focusedCont
        
        pageTitle = item.channelName
        pageUrl = "/films/title/" + pageTitle
        fireGAEvent(pageTitle, pageUrl, m.deviceId, "player-video", "playVideo", pageTitle, 0)
        
    end if
    
    if m.top.customInfo.homeVideo <> invalid and m.top.customInfo.homeVideo.videoUrl <> invalid
        m.streamUrl = m.top.customInfo.homeVideo.videoUrl
    end if
    
    if m.top.customInfo.focusedCont <> invalid and m.top.customInfo.focusedCont.videoUrl <> invalid
        m.streamUrl = m.top.customInfo.focusedCont.streamUrl        
    end if
    
    m.deepLink = m.top.customInfo.deepLink
    print "m.deepLink" ; m.deepLink
    
    m.channelInfo = m.global.channelInfo
    m.radioInfo = m.global.radioInfo
    
    if m.streamType = "radio"
        showRadioBGColor()
        m.logo = m.top.findNode("logo")
        m.logo.visible = true
    end if 
    
    createTimer()
    setVideo()

end function

function setVideo() as void

    m.video = m.top.findNode("videoPlayer")
    videoContent = createObject("RoSGNode", "ContentNode")
    videoContent.url = m.streamUrl
    videoContent.streamformat = ""
    m.video.content = videoContent
    m.video.control = "play"
    m.focusOwner = "videoplayer"
    
    m.channelNode = m.top.findNode("channelName")
    m.channelNode.text = m.channelName
    m.channelNode.font = m.global.fontRegistry.standard_30
    
    createComponentGallery()
    
    m.logo = m.top.findNode("logo")
    m.logo.uri = m.pgmPosterUrl
    
end function

Function OnKeyEvent(key, press) as Boolean

    handled = true
    
    if press = true
    
       if key = "back"
       
            if m.focusOwner = "rowlist"
 
                m.gradient = m.top.findNode("gradient")
                m.gradient.id = "gradient"
                m.gradient.visible = false

                channelNameAnimation("up")
                rowListAnimation("down")

                m.miniguideTimer.control = "stop" 
            
            else
            
                ? "sadjnasfkjbasdjklfbjkadsbfjkadsbfkjadsbjk" ; m.source
                m.video.control = "stop"
                
                if m.deepLink = true
                    launchHome()
                else
                    navigationInfo = {terminate:true, moveToBackground:false, appTerminate:false}
                    customInfo = {source : m.source}
                    publishAppEvent("back", true, "Video", m.top.screenType, navigationInfo, customInfo)                
                end if
            
            end if
            
       else if key = "up" 
       
            if m.focusOwner = "rowlist"
 
                m.gradient = m.top.findNode("gradient")
                m.gradient.visible = false
                
                channelNameAnimation("up")
                rowListAnimation("down")
                
                handled = true   
                m.miniguideTimer.control = "stop"  
            
            end if        
       
       else if key = "OK" or key = "down"
       
            if m.focusOwner = "videoplayer"
                if m.streamType = "live" or m.streamType = "radio"
                    m.gradient = m.top.findNode("gradient")
                    m.gradient.visible = true
                    
                    channelNameAnimation("down")
                    rowListAnimation("up")
                    m.miniguideTimer.control = "start" 
                    
                end if
            end if   
            
            handled = true     
       
       end if
    
    end if
    
    return handled

end function

function createComponentGallery()

    m.commonConstants = getCommonDimensions()
    m.onDemandPageConstants = getOnDemandPageDimensions()
    
    m.childRowList = m.top.findnode("childRowList")
    m.childRowList.itemComponentName="MiniGuideItemComponent"
    m.childRowList.drawFocusFeedback = m.onDemandPageConstants.onDemandGridDrawFocusFeedback
    m.childRowList.itemSize= m.onDemandPageConstants.onDemandGridItemSize
    m.childRowList.numRows= 3
    m.childRowList.itemSpacing = m.onDemandPageConstants.onDemandGriditemSpacing
    m.childRowList.rowItemSpacing= m.onDemandPageConstants.onDemandGridrowItemSpacing
    m.childRowList.focusXOffset= m.onDemandPageConstants.onDemandGridfocusXOffset      
    m.childRowList.rowLabelOffset= m.onDemandPageConstants.onDemandGridrowLabelOffset
    m.childRowList.showRowLabel= m.onDemandPageConstants.onDemandGridshowRowLabel    
    m.childRowList.showRowCounter= m.onDemandPageConstants.onDemandGridshowRowCounter
    m.childRowList.rowLabelColor= m.onDemandPageConstants.onDemandGridrowLabelColor
    m.childRowList.rowLabelFont= m.global.fontRegistry.standard_30
    m.childRowList.rowFocusAnimationStyle= "fixedFocusWrap"
    m.childRowList.id="RowListForGallery"

    m.childRowList.ObserveField("rowItemFocused","OnItemFocused")
    m.childRowList.ObserveField("rowItemSelected","OnRowItemSelected")
    m.childRowList.content = GetRowListContent()
    
    m.childRowList.jumpToRowItem = [0, m.colmIndex]

end function


function GetRowListContent() as object

    streamType = m.streamType

    Dim arrayContent[50, 50]
    rowHeights = []
    rowItemSize = []
    rowSpacings = []
    rowIndex = 0
    
    ContentNode = createObject("RoSGNode","ContentNode")
    ContentNode.title = "Channels"

    if streamType = "live"

        channels = m.channelInfo.channels
        channelCount = channels.Count()
    
        if channelCount > 0
    
            ChannelNode = ContentNode.createChild("ContentNode")
            ChannelNode.title = "Canales De Television"
        
            for i=0 to channelCount-1
            
                liveItem = ChannelNode.createChild("GalleryNode")
                liveItem.channelName = channels[i].channelName
                liveItem.streamType = channels[i].streamType

                channelLogo = channels[i].channelLogo
                if channelLogo.split("1080p") <> invalid 
                    liveItem.pgmPosterUrl = channelLogo.split("1080p")[0] + "$$RES$$" + channelLogo.split("1080p")[1]
                end if                 
                
                liveItem.streamUrl = channels[i].streamUrl
                arrayContent[rowIndex,i] = liveItem
            
            end for
        
            rowSpacings = []           
            rowSpacing = m.onDemandPageConstants.rowSpacing
            rowSpacings.push(rowSpacing)
        
            item_width = 400
            item_height = 224
            rowHeights.push(item_height + 70)
            
            size = []
            size.push(item_width)
            size.push(item_height)
            rowItemSize.push(size)   
            
            rowIndex = rowIndex + 1
             
        end if
    
    else if streamType = "radio"
    
        radios = m.radioInfo.radios
        radioCount = radios.Count()
    
        if radioCount > 0
    
            RadiodNode = ContentNode.createChild("ContentNode")
            RadiodNode.title = "Estaciones De Radio"
        
            for i=0 to radioCount-1
        
                radioItem = RadiodNode.createChild("GalleryNode")
                radioItem.channelName = radios[i].channelName
                radioItem.streamType = radios[i].streamType
                
                channelLogo = radios[i].channelLogo
                if channelLogo.split("1080p") <> invalid 
                    radioItem.pgmPosterUrl = channelLogo.split("1080p")[0] + "$$RES$$" + channelLogo.split("1080p")[1]
                end if                 
                
                radioItem.streamUrl = radios[i].streamUrl
                arrayContent[rowIndex,i] = radioItem
        
            end for
    
            rowSpacing = m.onDemandPageConstants.rowSpacing
            rowSpacings.push(rowSpacing)
            
            item_width = 400
            item_height = 224
            rowHeights.push(item_height + 70)
            
            size = []
            size.push(item_width)
            size.push(item_height)
            rowItemSize.push(size)  
              
        end if    
    
    end if
    
    m.childRowList.rowHeights = rowHeights
    m.childRowList.rowItemSize = rowItemSize
    m.childRowList.rowSpacings = rowSpacings
    
    m.arrayContent = arrayContent
    
    return ContentNode    

end function

function OnItemFocused()

    itemFocused = m.childRowList.rowItemFocused
    rowIndex = itemFocused[0]
    colmIndex = itemFocused[1]
    m.focusedCont = m.arrayContent[rowIndex][colmIndex]
    
    m.miniguideTimer.control = "stop"
    m.miniguideTimer.control = "start"

end function

function OnRowItemSelected()

    m.colmIndex = m.childRowList.rowItemFocused[1]

    m.video.control = "stop"
    
    m.streamUrl = m.focusedCont.streamUrl
    m.pgmPosterUrl = m.focusedCont.pgmPosterUrl
    m.channelName = m.focusedCont.channelName
    
    m.video.control = "stop"
    videoContent = createObject("RoSGNode", "ContentNode")
    videoContent.url = m.streamUrl
    videoContent.streamformat = ""
    m.video.content = videoContent
    m.video.control = "play"
    
    m.logo = m.top.findNode("logo")
    m.logo.uri = m.pgmPosterUrl
    
    m.channelNode = m.top.findNode("channelName")
    if m.channelName = "9"
        m.channelNode.text = "Canal 9"
    else
        m.channelNode.text = m.channelName    
    end if
    
    channelNameAnimation("up")
    rowListAnimation("down")    
    
    m.gradient = m.top.findNode("gradient")
    m.gradient.visible = false
    
    m.miniguideTimer.control = "stop"
    
end function

Function createTimer()

    m.miniguideTimer = m.top.createChild("Timer")
    m.miniguideTimer.repeat = false
    m.miniguideTimer.duration = 10
    m.miniguideTimer.observeField("fire", "miniguideTimerFired")
    
end function   

function miniguideTimerFired()

    m.gradient.visible = false
    channelNameAnimation("up")
    rowListAnimation("down")    

end function

function channelNameAnimation(direction)
   
   if direction = "down"
        transAnimation1 = m.top.FindNode("transAnimation1")
        transAnimation1.control = "start"
   else if direction = "up"
        transAnimation2 = m.top.FindNode("transAnimation2")
        transAnimation2.control = "start"   
   end if

end function

function rowListAnimation(direction)
   
   if direction = "up"
        transAnimation3 = m.top.FindNode("transAnimation3")
        transAnimation3.control = "start"
        m.childRowList.setFocus(true)
        m.focusOwner = "rowlist"        
   else if direction = "down"
        transAnimation4 = m.top.FindNode("transAnimation4")
        transAnimation4.control = "start"   
        m.childRowList.setFocus(false)
        m.focusOwner = "videoplayer"      
        m.top.setFocus(true)        
   end if

end function
