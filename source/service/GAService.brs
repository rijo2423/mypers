function fireGAEvent(pageTitle, pageUrl, userVal, eCategory, eAction, eLabel, eValue)

    if userVal = ""
        userVal = "Roku"
    end if

    hitType = "event"
    cdVal = ""
    if eCategory = "" and eAction = ""  
        hitType = "screenview"
        cdVal = "roku.dominicanatv.com" + pageUrl
    end if
    
    GoogleParams = {
        t  : hitType
        dt : pageTitle
        dp : pageUrl
        ec : eCategory
        ea : eAction
        el : eLabel
        ev : eValue
        cd : cdVal
    }

    m.global.RSG_analytics.trackEvent = {
        Google      : GoogleParams
    }

end function