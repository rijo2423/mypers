  Function init() 

    m.commonConstants = getCommonDimensions()
    m.searchItemConstants = searchItemComponentConstants()
    m.searchResultTitle = m.top.findNode("searchResultTitle") 
    m.searchResultTitle.color = m.searchItemConstants.searchTitleColor
    m.searchResultTitle.font = m.global.fontRegistry.standard_28
    
    m.focusRect = m.top.findNode("focusRect") 
    m.focusRect.color = m.searchItemConstants.focusRectColor
    
    m.playIcon = m.top.findNode("playIcon") 
	
  End Function
  
  Function itemContentChanged() 
  
    itemData = m.top.itemContent
    print "itemData" ; itemData
    m.searchResultTitle.text = itemData.name
    
  end Function
  
  Function focusPercentChanged()
      
        print "m.top.focusPercent" ; m.top.focusPercent
        if m.top.focusPercent =1
            m.searchResultTitle.color = m.searchItemConstants.searchTitleFocusColor
            m.focusRect.visible = true
            m.playIcon.visible = true
        else
            m.searchResultTitle.color = m.searchItemConstants.searchTitleColor
            m.focusRect.visible = false
            m.playIcon.visible = false
        end if 
        
        print "m.top.listHasFocus " ; m.top.listHasFocus 
        if m.top.listHasFocus = false      
            m.focusRect.visible = true
            m.playIcon.visible = true
        end if   
          
   End Function