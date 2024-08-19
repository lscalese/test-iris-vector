Class careia.data.Source Extends %Persistent
{

Property text As %Stream.GlobalCharacter;

/// Hash of the source using $zcrc
Property hash As %String(MAXLEN = 256) [ InitialExpression = 0 ];

Index hashI On hash [ Unique ];

Storage Default
{
<Data name="SourceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>text</Value>
</Value>
<Value name="3">
<Value>hash</Value>
</Value>
</Data>
<DataLocation>^careia.data.SourceD</DataLocation>
<DefaultData>SourceDefaultData</DefaultData>
<IdLocation>^careia.data.SourceD</IdLocation>
<IndexLocation>^careia.data.SourceI</IndexLocation>
<StreamLocation>^careia.data.SourceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
