Class careia.data.PatientEmbeddings Extends %Persistent
{

Property embedding As %Vector(DATATYPE = "DOUBLE", LEN = 1024);

Property patientId As %Integer [ Required ];

Property type As %String;

Property source As careia.data.Source;

Property chunk As %String(MAXLEN = 3000000);

/// Hash du chunk
Property hash As %String(MAXLEN = 256) [ InitialExpression = 0 ];

Index PatientIdIndex On patientId;

Index sourceI On source;

/// Description of the foreign key
ForeignKey sourceFK(source) References careia.data.Source() [ OnDelete = cascade ];

Index uniqueI On (patientId, source, hash) [ Unique ];

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
<Value name="5">
<Value>source</Value>
</Value>
<Value name="6">
<Value>chunk</Value>
</Value>
<Value name="7">
<Value>hash</Value>
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
