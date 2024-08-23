Class careia.utils.ChatListener Extends dc.ipcutils.ListenerAbstract
{

Parameter EVENTTYPE = "Demo";

Parameter VERBOSE = 0;

Method Listen() As %Status
{
    Set sc = $$$OK
    $$$QuitOnError(..OnStartListen())
    Try {
        Write !,!,"Response: ",!
        Write:..Verbose !,$zdt($h,3,1)," + Type < ctrl+c > to stop listening.",!
        For  If ..Wait() = -1 $$$ThrowStatus($$$ERROR($$$GeneralError,$$$FormatText("Resource %1 deleted.",..ResourceName)))
    } Catch Ex {
        If Ex.Name '[ "<INTERRUPT>" Set sc = Ex.AsStatus()
        If ..Verbose, $$$ISERR(sc) Do $SYSTEM.Status.DisplayError(sc)
    }
    Quit $$$ADDSC(sc,..OnStopListen())
}

Method Update(Event As %DynamicObject, Data As %DynamicObject, Context As %DynamicObject) As %Status
{
    Write $Translate(Data.message.content,$Char(10),$Char(13,10))
    ;zw $zcvt(Data.message.content,"I","UTF8")
    If Data.done  {
        Do ..OnStopListen()
    }
    Quit $$$OK
}

ClassMethod Test() As %Status
{
    Quit ..%New().Listen()
}

}
