Function createTransferObject(requestObjParams) as Object

    httpReq = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    
    url = requestObjParams.url 
    httpReq.SetMessagePort(port)
    httpReq.SetUrl(url)
    httpReq.SetRequest(requestObjParams.httpMethod)
    
    httpReq.RetainBodyOnError(True)
    return httpReq
    
End Function

Function requestAndGetResponse(httpReq As Object, requestParams) 
    
    responseData = invalid
    if requestParams.responseType = "FILE" then
        if requestParams.httpMethod = "GET" then
            httpReq.AsyncGetToFile(requestParams.filePath)
        end if   
    else if requestParams.responseType = "TEXT" then
        if (requestParams.httpMethod = "POST" or requestParams.httpMethod = "PUT" or requestParams.httpMethod = "DELETE") then
            if requestParams.postValues <> invalid
                httpReq.AsyncPostFromString(requestParams.postValues)
            end if    
        else if requestParams.httpMethod = "GET" then
            httpReq.AsyncGetToString()
        end if
    end if
    
    while (true)
        
        msg = wait(5000, httpReq.GetPort())
        responseData = {}
        if msg <> invalid then            
            if (type(msg) = "roUrlEvent")            
                code = msg.GetResponseCode()
                
                if (code >= 200 and code < 300) 
                    json = msg.GetString()
                    headers = msg.GetResponseHeaders()
                    responseData.result = json
                    responseData.status = true
                    responseData.headers = headers
                    responseData.responsecode = code
                    exit while
                end if
                
            end if    
        end if
    end while 
    return responseData
    
End Function   

Function getServiceResponse(requestParams) as Object
    
    request = createTransferObject(requestParams)
    response = requestAndGetResponse(request, requestParams)
    
    if(response<>invalid)
        if(response.status <> invalid and response.status = true)
            if(response.result <> invalid and response.result <> "")
                if response.headers["content-type"] <> "application/xml"
                    response.result = ParseJSON(response.result)
                end if
            end if 
        end if
    end if
    return response
    
End Function
