WebRequest := Object clone do(
    handleSocket := method(aSocket,
        aSocket streamReadNextChunk
        request := aSocket readBuffer betweenSeq("GET ", " HTTP")
        path := request replaceSeq("/", "")
        f := File with(path) 
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