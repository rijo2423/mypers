Function itemContentChanged()
        
    m.pgmPosterUrl.uri = m.top.itemContent.pgmPosterUrl
    m.channelName.text = m.top.itemContent.channelName
    
    if m.top.itemContent.streamType = "live"
        m.destacadosRect.visible = true
        m.radioRect.visible = false
        m.pgmPosterUrl.width = 400
        m.pgmPosterUrl.height = 224
    else
        m.destacadosRect.visible = false
        m.radioRect.visible = true
        m.pgmPosterUrl.width = 400
        m.pgmPosterUrl.height = 224                  
    end if
    
End Function

Function widthChanged()

    
End Function

Function heightChanged()

End Function

Function focusPercentChanged()

End Function

Function init()

    m.destacadosRect = m.top.findNode("destacadosRect")
    m.radioRect = m.top.findNode("radioRect")
    
    m.pgmPosterUrl  = m.top.findNode("pgmPosterUrl")
    m.channelName  = m.top.findNode("channelName")
    m.channelName.font = m.global.fontRegistry.standard_30
    m.channelName.visible = false
    
end Function