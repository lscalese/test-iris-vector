Class careia.messages.requests.OllamaChatRQ Extends (Ens.Request, %JSON.Adaptor, %XML.Adaptor)
{

Property model As %String(MAXLEN = 128);

/// "messages": [
///     {
///       "role": "user",
///       "content": "why is the sky blue?"
///     },
///     {
///       "role": "assistant",
///       "content": "due to rayleigh scattering."
///     },
///     {
///       "role": "user",
///       "content": "how is that different than mie scattering?"
///     }
///   ]
Property messages As %Stream.GlobalCharacter;

Storage Default
{
<Data name="OllamaChatRQDefaultData">
<Subscript>"OllamaChatRQ"</Subscript>
<Value name="1">
<Value>model</Value>
</Value>
</Data>
<Data name="messages">
<Attribute>messages</Attribute>
<Structure>node</Structure>
<Subscript>"careia.messages.requests.OllamaChatRQ.messages"</Subscript>
</Data>
<DefaultData>OllamaChatRQDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
