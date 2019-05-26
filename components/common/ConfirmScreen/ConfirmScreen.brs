'******************************************************************
'** Xfinity TV - Error Dialog
'** Copyright © COMCAST 2016  All Rights Reserved.
'******************************************************************


'******************************************************************
'** Show Service Error Dialog.    
'******************************************************************
Function Init()

    m.description = m.top.findNode("description")
    m.customButtonGroup = m.top.findNode("customBtnGroup")
    m.deviceInfo = CreateObject("roDeviceInfo")
    m.focusOwner = invalid
    m.ScreenBodyText = invalid
    m.button1Title = invalid
    m.button2Title = invalid
    m.descriptionFont = invalid
    m.callerId = invalid
    m.defaultFocusIndex = 0
    observeEventsOfInterest()

End Function

Function observeEventsOfInterest()
     m.top.observeField("customInfo", "onCustomInfoChange")
     m.top.observeField("moveToBackGround", "onMoveToBackGround")
     m.top.observeField("moveToForeGround", "onMoveToForeGround")
     m.top.observeField("terminate", "onScreenTerminate")
     
End Function

Function giveButtonFocus()

	if m.defaultFocusIndex = 0
    	setFocusToCancel()
    else
    	setFocusToSignOut()
    end if
        
End Function

Function initScreenComponents()
	 
     if m.descriptionFont <> invalid
		m.description.font = m.descriptionFont
	 else
     	m.description.font = m.global.fontRegistry.standard_44
     end if
     m.description.text = m.ScreenBodyText
     m.description.translation = [530,468]
     createButtons()
     
     confirmButtonsWidth = GetButtonGroupWidth()
     m.customButtonGroup.translation =  [850,550]
     giveButtonFocus()
     
     
End Function

Function createButtons()
	buttonChildHeight = 80
	buttonOffset = 0
	if m.callerId = "homeExitConfirm"
        	buttonChildHeight = 80
        	buttonOffset = 25
    end if
    numButtons =2
    buttonTitleArray = [m.button1Title,m.button2Title]
    
    for i=0 to numButtons-1
        
        numPrevChildren = m.customButtonGroup.GetChildCount()
        prevChild = m.customButtonGroup.GetChild(numPrevChildren-1)
        if (prevChild <> invalid)
        
            prevChildDimensions = prevChild.boundingRect()
            x=prevChildDimensions.x + prevChildDimensions.width + buttonOffset
        else
            x=0  
        end if
        
        buttonChild = m.customButtonGroup.CreateChild("Button")
        buttonChild.iconUri = "" 
        buttonChild.focusedIconUri = ""
        buttonChild.text = buttonTitleArray[i]
        buttonChild.focusBitmapUri =  "pkg:/locale/images/$$RES$$/Small-Button.png"
        buttonChild.minWidth = 100
        buttonChild.maxWidth = 250
        buttonChild.textFont = m.global.fontRegistry.standard_26
        buttonChild.focusedTextFont = m.global.fontRegistry.standard_26
        buttonChild.textColor = "#DDE2E6"
        buttonChild.focusedTextColor = "#DDE2E6"
        buttonChild.height = buttonChildHeight
        buttonChild.translation = [x,0]
        if (buttonChild.text = m.button1Title)
            m.actionButton1 = buttonChild
            m.actionButton1.ObserveField("buttonSelected","onActionButton1Press")
        else if (buttonChild.text = m.button2Title)   
            m.actionButton2 = buttonChild
            m.actionButton2.ObserveField("buttonSelected","onActionButton2Press")
        end if
        
    end for 
    
End Function
  
  
Function GetButtonGroupWidth()

    buttonsWidth = 0
    buttonCount = m.customButtonGroup.GetChildCount()
    
    for i= 0 to buttonCount-1
    
        child = m.customButtonGroup.GetChild(i)
        if (child<>invalid)
        
            itemWidth = child.boundingRect().width
            buttonsWidth = buttonsWidth+ itemWidth
            
        end if    
     end for 
     
     if (buttonCount>1)
        buttonsWidth = buttonsWidth + (buttonCount-1)*5
     end if
 
     return buttonsWidth
End Function
  
Function onCustomInfoChange()

    'ideally the button data should come from custom info instead of hardcoding
    ' TODO: make it generic when you have time :-)
    CustomData = m.top.customInfo
    if CustomData <> invalid
    	m.callerId = CustomData.id
     	if CustomData.bodyFont <> invalid
     		m.descriptionFont = CustomData.bodyFont
     	end if
     	m.button1Title = CustomData.button1Text
     	m.button2Title = CustomData.button2Text
     	m.ScreenBodyText = CustomData.bodyText
     	initScreenComponents()
   	end if
End Function

Function onActionButton1Press()
    if m.callerId = "homeExitConfirm"
    	navigateAwayFromConfirmationScreen(true)
    else
    	navigateAwayFromConfirmationScreen(false)
    end if
End Function
  
Function onActionButton2Press()
    if m.callerId = "signOutConfirmation"
    	navigateAwayFromConfirmationScreen(true)
    else
    	navigateAwayFromConfirmationScreen(false)
    end if

End Function  

Function navigateAwayFromConfirmationScreen(confirmed)
   m.top.actionConfirmed = confirmed
                       
End Function

Function setFocusToCancel()

    m.actionButton1.setFocus(true)
    m.actionButton2.setFocus(false)
    m.focusOwner = m.actionButton1
    
End Function

Function setFocusToSignOut()

    m.actionButton2.setFocus(true)
    m.actionButton1.setFocus(false)
    m.focusOwner = m.actionButton2
    
End Function

Function onMoveToBackGround() as boolean

    'Suspend tasks if required. Save data required for reLaunch if required.
    return true
    
End Function

Function onMoveToForeGround()

    'Restart the tasks if required. Prepare the screen using the saved data.
    return true
    
End Function

Function onScreenTerminate()

    return true
    
End Function

Function onKeyEvent(key,press) as boolean

    handled = false

    if press=true
 
        if (m.focusOwner <> invalid)
            if (m.focusOwner.isSameNode(m.actionButton1) or m.focusOwner.isSameNode(m.actionButton2))
                
                handled= handleNavigationFromButtons(key,press)
                
            End if
        end if
        
        if handled=false
        
            if (key <> "back")
                handled = true
                'do nothing
            else
              'publish event to controller
            end if       
        end if
    else
        'nothing
    End if
    
    return handled
    
End Function

Function handleNavigationFromButtons(key, press)

    handled = false
    if (press)
             
        focusedButton = m.focusOwner
       
        if (key="right")
            if(m.focusOwner.isSameNode(m.actionButton1))
                setFocusToSignOut()
            else
                'do nothing    
            end if
            handled=true
        else if (key="left")
            
            if(m.focusOwner.isSameNode(m.actionButton2))
                setFocusToCancel()
            else
                'do nothing    
            end if
            handled=true
            
        else if (key="down" or key="up")
            handled=true
        else if (key = "back")
        	navigateAwayFromConfirmationScreen(false)     	
        else
            'no action..               
        end if
        
     end if
        
    return handled
    
End Function
