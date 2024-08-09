Class careia.data.PatientEmbeddings Extends %Persistent
{

Property embedding As %Vector(DATATYPE = "DOUBLE");

Property patientId As %Integer;

Property type As %String;

Index PatientIdIndex On patientId;

Index UniqueI On (patientId, type) [ Unique ];

Storage Default
{
<Data name="PatientEmbeddingsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>embedding</Value>
</Value>
<Value name="3">
<Value>patientId</Value>
</Value>
<Value name="4">
<Value>type</Value>
</Value>
</Data>
<DataLocation>^careia.data.PatientEmbeddingsD</DataLocation>
<DefaultData>PatientEmbeddingsDefaultData</DefaultData>
<IdLocation>^careia.data.PatientEmbeddingsD</IdLocation>
<IndexLocation>^careia.data.PatientEmbeddingsI</IndexLocation>
<StreamLocation>^careia.data.PatientEmbeddingsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
