Class careia.messages.requests.OllamaGenerateRQ Extends (Ens.Request, %JSON.Adaptor)
{

Property prompt As %String(MAXLEN = 8192) [ Required ];

Property model As %String(MAXLEN = 50);

Storage Default
{
<Data name="OllamaGenerateRQDefaultData">
<Subscript>"OllamaGenerateRQ"</Subscript>
<Value name="1">
<Value>prompt</Value>
</Value>
<Value name="2">
<Value>model</Value>
</Value>
</Data>
<DefaultData>OllamaGenerateRQDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
