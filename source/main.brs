Sub RunUserInterface(args as Dynamic)

    
    mainScreen = CreateObject("roSGScreen")
    appScene = mainScreen.CreateScene("Controller")
    
    port = CreateObject("roMessagePort")
    mainScreen.SetMessagePort(port)
        
    mainScreen.Show()
    appScene.observeField("terminate",port)
    
    appScene.appLaunchParams = args
    
    while true
        msg = wait(0, port)
        if type(msg)= "roSGNodeEvent"
            if msg.getField() = "terminate"
                exit while
            end if
        end if
    end while
   
    if mainScreen <> invalid then
        mainScreen.Close()
        mainScreen = invalid
    end if
    
End Sub
