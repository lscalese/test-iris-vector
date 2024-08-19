Class careia.messages.requests.PatientEmbeddingRQ Extends Ens.Request
{

Property patientId As %String;

Property type As %String;

Property document As %Stream.GlobalCharacter;

Storage Default
{
<Data name="PatientEmbeddingRQDefaultData">
<Subscript>"PatientEmbeddingRQ"</Subscript>
<Value name="1">
<Value>patientId</Value>
</Value>
<Value name="2">
<Value>type</Value>
</Value>
<Value name="3">
<Value>document</Value>
</Value>
</Data>
<DefaultData>PatientEmbeddingRQDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
