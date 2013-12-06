WebRequest := Object clone do(
    urlParser := method(request, 
        if(request == "/", "index.html", request replaceSeq("/", ""))
    )

    handleSocket := method(aSocket,
        aSocket streamReadNextChunk
        request := aSocket readBuffer betweenSeq("GET ", " HTTP")
        filename := urlParser(request)
        f := File with(filename) 
        if(f exists, 
            f streamTo(aSocket)
        , 
            aSocket streamWrite("Resource not found")
        )
        aSocket close
    )
)

WebServer := Server clone do(
    setPort(8000)
    handleSocket := method(aSocket, 
        WebRequest clone asyncSend(handleSocket(aSocket))
    )
)

WebServer start