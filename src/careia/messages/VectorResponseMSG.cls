Class careia.messages.VectorResponseMSG Extends Ens.Response
{

Property embedding As %Vector;

Storage Default
{
<Data name="VectorResponseMSGDefaultData">
<Subscript>"VectorResponseMSG"</Subscript>
<Value name="1">
<Value>embedding</Value>
</Value>
</Data>
<DefaultData>VectorResponseMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
