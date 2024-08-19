Class careia.services.PatientEmbeddingsService
{

ClassMethod Test() As %Status
{
    Set sc = ..PutPatientData(1, "test", "This is a test")
    Return sc
}

ClassMethod PutPatientData(patientId As %Integer, type As %String, sentences As %String) As %Status
{
    Set sc = $$$OK
   
    Set model = ##class(careia.rest.model.putPatientDatabody).%New()
    Set model.patientId = patientId
    Do model.sentences.Insert(sentences)
    Set model.type = type

	Set sc = ##class(Ens.Director).CreateBusinessService("careia.bs.PutPatientDataBS", .instance)
	If $$$ISOK(sc) {
		#dim response as %DynamicObject
		Set sc = instance.OnProcessInput(model, .pResponse)
	}

    Return sc
}

ClassMethod PutPatientEmbedding(patientId As %Integer, type As %String, sentences As %ListOfDataTypes) As %Status
{
    Set pRequest = ##class(careia.messages.requests.PatientEmbeddingRQ).%New()
    Set pRequest.patientId = patientId
    Set pRequest.type = type

    #dim iter As %Iterator.Array

    Set key = ""

    For  {
        Set value = sentences.GetNext(.key)
        If key = "" Quit

        Do pRequest.document.Write(value)
    }

    Set sc = ##class(Ens.Director).CreateBusinessService("careia.bs.PutPatientDataBS", .instance)

    If $$$ISERR(sc) Return sc

    Set sc = instance.OnProcessInput(pRequest, .pResponse)

    Return sc
}

ClassMethod PutPatientEmbeddingFile(patientId As %Integer, type As %String, file As %String = "/home/irisowner/dev/data/rapport_hospit.txt") As %Status
{
    Set pRequest = ##class(careia.messages.requests.PatientEmbeddingRQ).%New()
    Set pRequest.patientId = patientId
    Set pRequest.type = "report"

    Set fileCharacter = ##class(%Stream.FileCharacter).%New()
    Do fileCharacter.LinkToFile(file)
    
    Do pRequest.document.Write($zcvt(fileCharacter.Read(), "I", "UTF8"))

    Set sc = ##class(Ens.Director).CreateBusinessService("careia.bs.PutPatientDataBS", .instance)

    If $$$ISERR(sc) Return sc

    Set sc = instance.OnProcessInput(pRequest, .pResponse)

    Return sc
}

ClassMethod GenerateAnswer(prompt As %String, model As %String = "", Output pResponse As careia.messages.responses.OllamaGenerateRSP = "") As %Status
{
    Set sc = $$$OK
   
    Set request = ##class(careia.messages.requests.OllamaGenerateRQ).%New()
    Set request.model = model
    Set request.prompt = prompt

    Set sc = ##class(Ens.Director).CreateBusinessService("careia.bs.GenerateAnswer", .instance)
    If $$$ISOK(sc) {
        #dim response as %DynamicObject
        Set sc = instance.OnProcessInput(request, .pResponse)
    }

    Return sc
}

}
