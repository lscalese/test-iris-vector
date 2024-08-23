Class careia.data.StreamingRsp Extends %Stream.GlobalCharacter
{

Property EventType As %String [ Transient ];

Property JSONChunk As list Of %DynamicArray [ Transient ];

Method Write(data As %String = "") As %Status
{
    Set sc = ##super(data)
    
    Do ..Notify(data, "OnWrite")
    
    Return sc
}

Method WriteLine(data As %String = "") As %Status
{
    Set sc = ##super(data)
    
    Do ..Notify(data, "OnWriteLine")

    Return sc
}

Method Notify(data As %String = "", event As %String) As %Status
{
    Set sc = $$$OK
    Try {
        Set chunk = {}.%FromJSON(data)
        Do ..JSONChunk.Insert(chunk)
        Do ##class(dc.ipcutils.Manager).Notify(..EventType_":"_event,chunk)
    } Catch ex {
        Set sc = ex.AsStatus()
        Set ^last.error = $SYSTEM.Status.GetOneErrorText(sc)
    }
    Return sc
}

}
