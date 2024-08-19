Class careia.services.VectorService
{

ClassMethod GetVector(sentence As %String, Output sc As %Status = {$$$OK}) As %Vector
{

    #dim pResponse As careia.messages.VectorResponseMSG
    
    Set vector = ""

    /// EmbeddingService refers to business service class care.ia.bs.Embedding
    Set sc = ##class(Ens.Director).CreateBusinessService("EmbeddingService", .instance)

    If $$$ISERR(sc) Return ""

	Set strintContainer = ##class(Ens.StringContainer).%New()
    Set strintContainer.StringValue = sentence

    Set sc = instance.OnProcessInput(strintContainer, .pResponse)
	
    If $$$ISERR(sc) Return ""

    Return pResponse.embedding
}

ClassMethod GetSimilarDesc(searchTerms As %String)
{
    set sc = $$$OK
    try {
        Set query = "SELECT top 3 chunk, VECTOR_COSINE(embedding, TO_VECTOR(?,double)) as cosine FROM careia_data.PatientEmbeddings "
                    _"ORDER BY VECTOR_COSINE(embedding, TO_VECTOR(?,double)) DESC"

        set tStatement = ##class(%SQL.Statement).%New()
        $$$ThrowOnError(tStatement.%Prepare(query))

        // convert input string to an embedding
        set searchTermsEmbedding = ..GetVector(searchTerms)
        
        Set param = ##class(%Vector).LogicalToDisplay(searchTermsEmbedding)

        set rset = tStatement.%Execute(param,param)
        if (rset.%SQLCODE < 0) {
            Throw ##class(%Exception.SQL).CreateFromSQLCODE(rset.%SQLCODE, rset.%Message)
        }

        // process retrieved descriptions here and return the result
        set retrievedInfo = ""
        while rset.%Next() {
            w !,"-------------------"
            w !,"cosine: ",rset.%Get("cosine")
            w !,$tr(rset.%Get("chunk"),$c(10),$c(13,10))
            w !,"-------------------"
            ;set retrievedInfo = retrievedInfo_" chunk: "_rset.%Get("chunk")
        }
        return retrievedInfo
    }
    catch e {
        set sc = e.AsStatus()
        zw sc
        return sc
    }

    return
}

}
