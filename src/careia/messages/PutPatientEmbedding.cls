Class careia.messages.PutPatientEmbedding Extends Ens.Request
{

Property patientId As %String;

Property embedding As %Vector;

Property type As %String;

Property chunk As %String(MAXLEN = 3000000);

Property sourceId As %Integer;

Storage Default
{
<Data name="PutPatientEmbeddingDefaultData">
<Subscript>"PutPatientEmbedding"</Subscript>
<Value name="1">
<Value>patientId</Value>
</Value>
<Value name="2">
<Value>embedding</Value>
</Value>
<Value name="3">
<Value>type</Value>
</Value>
<Value name="4">
<Value>chunk</Value>
</Value>
<Value name="5">
<Value>sourceId</Value>
</Value>
</Data>
<DefaultData>PutPatientEmbeddingDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
