function init()

    observeEventsOfInterest()
    m.episodeTitle = m.top.findNode("episodeTitle")
    m.episodeTitle.text = "EPISODIOS"
    m.episodeTitle.font = m.global.fontRegistry.standard_52

end function

function getContent()
    print "getContent"  
    resultNode=createObject("RoSGNode","ContentNode")
    resultNode.title = "Episodes"
    
    m.customInfo = m.top.customInfo
    
    episodes = m.customInfo.homeVideo.episodes
    
    Dim arrayContent[50, 50]
    rowIndex = 0
    
    for i = 0 to episodes.Count()-1
        itemNode = resultNode.createChild("EpisodeNode") 
        print "episodes[i]" ; episodes[i]
        itemNode.name = episodes[i].name
        itemNode.index = i
        itemNode.streamUrl = episodes[i].videoUrl
        arrayContent[rowIndex,i] = itemNode
    end for
    
    m.arrayContent = arrayContent
    
    return resultNode

end function

function customInfoChanged()

    createEpisodeScreen()

end function

function createEpisodeScreen()

    m.itemRect = m.top.findNode("itemRect")
    m.itemRect.visible = true
    
    m.episodeListScreen = m.top.findNode("episodeListScreen")
    m.episodeListScreen.observeField("itemSelected","onRowItemSelected")
    m.episodeListScreen.observeField("itemFocused","OnItemFocused")    
    m.episodeListScreen.content = getContent()
    m.episodeListScreen.setFocus(true)
    m.episodeListScreen.visible = true
end function

function onRowItemSelected()

    m.selectedItem = m.episodeListScreen.itemSelected
    ? "m.selectedItem" ; m.selectedItem
    contentList = m.episodeListScreen.content
    navigationInfo = {terminate:false, moveToBackground:true, appTerminate:false, eventKey :"VideoPlayer"}
    customInfo = {content : contentList, currentIndex : m.selectedItem, autoplay : true, deepLink : false, source : "EpisodeScreen"}
    publishAppEvent("Ok", true, "EpisodeScreen", m.top.screenType, navigationInfo, customInfo) 
    
end function

function OnItemFocused()
    
    itemFocused = m.episodeListScreen.itemFocused
    print "itemFocused" ; itemFocused
    
end function

Function OnKeyEvent(key, press) as Boolean

    handled = true
    
    if press = true
        if key = "back"
               handled = false          
        end if
    end if
    
    return handled

end function

Function observeEventsOfInterest()

     m.top.observeField("moveToBackGround", "onMoveToBackGround")
     m.top.observeField("moveToForeGround", "onMoveToForeGround")
     
End Function

Function onMoveToBackGround()
    
    if m.episodeListScreen <> invalid
        m.episodeListScreen.moveToBackGround = true
    end if
    return true
    
End Function

Function onMoveToForeGround()

    print "m.episodeListScreen =====" ; m.episodeListScreen
    if m.episodeListScreen <> invalid
        m.episodeListScreen.setFocus(true) 
    else
        createEpisodeScreen()            
    end if    
    
    return true
    
End Function

function setScreenFocusonRowList()
    print "m.episodeListScreen =====" ; m.episodeListScreen
    if m.episodeListScreen <> invalid
        m.episodeListScreen.setFocus(true) 
    else
        createEpisodeScreen()            
    end if  
end function

