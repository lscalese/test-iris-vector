Class careia.messages.responses.OllamaGenerateRSP Extends (Ens.Response, %JSON.Adaptor)
{

Property model As %String;

Property response As %String(MAXLEN = "");

Property context As %Vector;

Storage Default
{
<Data name="OllamaGenerateRSPDefaultData">
<Subscript>"OllamaGenerateRSP"</Subscript>
<Value name="1">
<Value>model</Value>
</Value>
<Value name="2">
<Value>response</Value>
</Value>
<Value name="3">
<Value>context</Value>
</Value>
</Data>
<DefaultData>OllamaGenerateRSPDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
