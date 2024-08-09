Class careia.messages.PutPatientDataMSG Extends Ens.Request
{

Property patientId As %String;

Property sentences As list Of %String;

Property type As %String;

Storage Default
{
<Data name="PutPatientDataMSGDefaultData">
<Subscript>"PutPatientDataMSG"</Subscript>
<Value name="1">
<Value>patientId</Value>
</Value>
<Value name="2">
<Value>sentences</Value>
</Value>
<Value name="3">
<Value>type</Value>
</Value>
</Data>
<DefaultData>PutPatientDataMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
