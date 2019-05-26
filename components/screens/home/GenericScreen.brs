Function Init()

     m.commonConstants = getCommonDimensions()
     m.onDemandPageConstants = getOnDemandPageDimensions()
     observeEventsOfInterest()
     
     m.channelInfo = m.global.channelInfo
     m.radioInfo = m.global.radioInfo

End Function

function contentAvailable() 

    m.deepLinkParams = m.top.deepLinkParams
    playable = false
    
    if m.deepLinkParams <> invalid and m.deepLinkParams.deepLink = true
    
        Dim arrayContent[1, 1]
        channels = m.channelInfo.channels
        channelCount = channels.Count()

        if channelCount > 0
            for i=0 to channelCount-1        
                if StrToI(m.deepLinkParams.contentID) = channels[i].contentID
                    liveItem = {}
                    liveItem.channelName = channels[i].channelName
                    liveItem.streamType = channels[i].streamType
                    channelLogo = channels[i].channelLogo
                    if channelLogo.split("1080p") <> invalid 
                        liveItem.pgmPosterUrl = channelLogo.split("1080p")[0] + "$$RES$$" + channelLogo.split("1080p")[1]
                    end if
                    liveItem.streamUrl = channels[i].streamUrl
                    arrayContent[0,0] = liveItem
                    playable = true
                    exit for
                end if
            end for
        end if
        
    end if
    
    if playable = true
        m.focusedCont = arrayContent[0,0]
        colmIndex = StrToI(m.deepLinkParams.contentID) - 1
        navigationInfo = {terminate:false, moveToBackground:true, appTerminate:false, eventKey :"VideoPlayer"}
        customInfo = {colmIndex : colmIndex, focusedCont : m.focusedCont, source : "Home"}
        publishAppEvent("Ok", true, "Home", m.top.screenType, navigationInfo, customInfo) 
    else
        createComponentGallery()
    end if
     
end function

function setScreenFocusonRowList()
    if m.childRowList <> invalid
        print "m.top.setScreenFocus" ; m.top.setScreenFocus
        if m.top.setScreenFocus = true
            m.childRowList.setFocus(true) 
        else
            m.childRowList.setFocus(false)         
        end if       
    end if
end function

Function observeEventsOfInterest()

     m.top.observeField("moveToBackGround", "onMoveToBackGround")
     m.top.observeField("moveToForeGround", "onMoveToForeGround")
     
End Function

function createComponentGallery()

    m.childRowList=m.top.createChild("RowList")
    m.childRowList.itemComponentName="ItemComponent"
    m.childRowList.drawFocusFeedback = m.onDemandPageConstants.onDemandGridDrawFocusFeedback
    m.childRowList.translation= [0,0]   
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
    m.childRowList.visible = true
    m.childRowList.setFocus(false)

end function

function OnItemFocused()

    itemFocused = m.childRowList.rowItemFocused
    m.rowIndex = itemFocused[0]
    m.colmIndex = itemFocused[1]
    m.focusedCont = m.arrayContent[m.rowIndex][m.colmIndex]

end function

function OnRowItemSelected()

    navigationInfo = {terminate:false, moveToBackground:true, appTerminate:false, eventKey :"VideoPlayer"}
    customInfo = {colmIndex : m.colmIndex, focusedCont : m.focusedCont, deepLink : false, source : "Channel"}
    publishAppEvent("Ok", true, "Home", m.top.screenType, navigationInfo, customInfo)      

end function

Function OnKeyEvent(key, press) as Boolean

    handled = false
    
    if press = true
    
        print "m.childRowList press " ; press ; " key " ; key
        if key = "down"
        
        else
        
        end if
    
    end if
    
    return handled

end function

function GetRowListContent() as object

    Dim arrayContent[50, 50]
    rowHeights = []
    rowItemSize = []
    rowSpacings = []
    rowIndex = 0
    
    ContentNode = createObject("RoSGNode","ContentNode")
    ContentNode.title = "Channels"

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
    
    m.childRowList.rowHeights = rowHeights
    m.childRowList.rowItemSize = rowItemSize
    m.childRowList.rowSpacings = rowSpacings
    
    m.arrayContent = arrayContent
    
    return ContentNode    

end function

Function onMoveToBackGround()
    
    return true
    
End Function

Function onMoveToForeGround()

    print "m.childRowList =====" ; m.childRowList
    if m.childRowList = invalid
        createComponentGallery()
    else
        m.childRowList.setFocus(true)         
    end if    
    
    return true
    
End Function


