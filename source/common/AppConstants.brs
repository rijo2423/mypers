Function getCommonDimensions()

   m.commonConstants = createObject("roAssociativeArray")
   m.commonConstants.designedScreenWidth = 1920
   m.commonConstants.designedScreenHeight = 1080
   m.commonConstants.baseImagePathForResolution = "pkg:/locale/images/$$RES$$/"
   return m.commonConstants
    
End Function

function getHomeDimensions()

    homePageConstants = createObject("roAssociativeArray")
    homePageConstants.homebackgroundImageFileName = "pkg:/locale/images/$$RES$$/home_background.jpg"
    return homePageConstants

end function

Function searchItemComponentConstants()

    searchItemConstants = CreateObject("roAssociativeArray")
    searchItemConstants.widthOfMarkupList = 928
    searchItemConstants.searchTitleColor = "0xDDE2E6"
    searchItemConstants.searchTitleFocusColor = "0x031926"
    searchItemConstants.focusRectColor = "0xDDE2E6"

    return searchItemConstants
End Function

Function getOnDemandPageDimensions()

    onDemandPageConstants = createObject("roAssociativeArray")
    
    onDemandPageConstants.onDemandGridTranslation= [120, 900]
    onDemandPageConstants.onDemandGridDrawFocusFeedback = "true"
    onDemandPageConstants.onDemandGridItemSize=[1815, 500] ' width & height of entire row
    onDemandPageConstants.onDemandGridNumRows= 3
    onDemandPageConstants.onDemandGriditemSpacing= [0, 500] ' yaxis spacing
    onDemandPageConstants.onDemandGridrowItemSpacing= [[18, 100]]
    onDemandPageConstants.onDemandGridfocusXOffset= [0]
    onDemandPageConstants.onDemandGridrowLabelOffset= [[0, 30]]
    onDemandPageConstants.onDemandGridshowRowLabel= "true"
    onDemandPageConstants.onDemandGridshowRowCounter= "false"
    onDemandPageConstants.onDemandGridrowLabelColor = "0xDDE2E6"
    onDemandPageConstants.rowSpacing = 100
    
    return onDemandPageConstants
    
End Function