Class careia.messages.responses.OllamaChatRSP Extends (Ens.Response, %JSON.Adaptor)
{

Property message As %Stream.GlobalCharacter;

Storage Default
{
<Data name="message">
<Attribute>message</Attribute>
<Structure>node</Structure>
<Subscript>"careia.messages.responses.OllamaChatRSP.message"</Subscript>
</Data>
<Type>%Storage.Persistent</Type>
}

}
