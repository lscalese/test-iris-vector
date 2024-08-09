Class careia.messages.PutPatientEmbedding Extends Ens.Request
{

Property patientId As %String;

Property embedding As %Vector;

Property type As %String;

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
</Data>
<DefaultData>PutPatientEmbeddingDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
