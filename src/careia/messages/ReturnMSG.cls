Class careia.messages.ReturnMSG Extends Ens.Response
{

Property status As %String;

Property message As %String(MAXLEN = 2048, TRUNCATE = 1);

Property body As %Stream.GlobalCharacter;

Storage Default
{
<Data name="ReturnMSGDefaultData">
<Subscript>"ReturnMSG"</Subscript>
<Value name="1">
<Value>status</Value>
</Value>
<Value name="2">
<Value>message</Value>
</Value>
<Value name="3">
<Value>body</Value>
</Value>
</Data>
<DefaultData>ReturnMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
