Class careia.bs.Embedding Extends Ens.BusinessService
{

Method OnProcessInput(pInput As Ens.StringContainer, Output pOutput As careia.messages.VectorResponseMSG, ByRef pHint As %String) As %Status
{
    /// EmbeddingProcess request refers to business process class care.ia.bp.EmbeddingBP
    Return ..SendRequestSync("EmbeddingProcess", .pInput, .pOutput, 30)
}

}
