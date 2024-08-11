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

ClassMethod SessionChat() As %Status
{
    Set sc = $$$OK

    Write !, "SessionChat Started (type 'exit' to quit)",!

   
    Set messages = []

    Set formatter = ##class(%JSON.Formatter).%New()

    While 1 {

        Write !, "You: ",!

        Read message

        If message = "exit" {
            Return $$$OK
        }

        Do messages.%Push({
            "role": "user",
            "content": (message)
        })

        Set request = ##class(careia.messages.requests.OllamaChatRQ).%New()
        Do formatter.FormatToStream(messages, request.messages)

        Set sc = ..SendChat(request, .pResponse)
        If $$$ISERR(sc) {
            Write !,!, "Error: ",$SYSTEM.Status.GetErrorText(sc) , !
        } else {
            Set responseJSON = {}.%FromJSON(pResponse.message)
            Write !,!,"Response: ", !,responseJSON.message.content, !
            Do messages.%Push(responseJSON.message)
        }

        Kill pResponse
    }

    Return sc
}

ClassMethod ContextSessionChat() As %Status
{
    Set sc = $$$OK

    Write !, "Context SessionChat Started (type 'exit' to quit)",!

    Set messages = []

    Set formatter = ##class(%JSON.Formatter).%New()

    Set template = "En utilisant ces données: {data}. Répond à ce prompt: {question}."

    Set data = "il est positif aux allergies aux chats, chiens et graminés."

    While 1 {

        Write !, "You: ",!

        Read question

        If question = "exit" {
            Return $$$OK
        }

        Set prompt = $Replace(template, "{question}", question)
        Set prompt = $Replace(prompt, "{data}", data)

        Do messages.%Push({
            "role": "user",
            "content": (prompt)
        })

        Set request = ##class(careia.messages.requests.OllamaChatRQ).%New()
        Do formatter.FormatToStream(messages, request.messages)

        Set sc = ..SendChat(request, .pResponse)
        If $$$ISERR(sc) {
            Write !,!, "Error: ",$SYSTEM.Status.GetErrorText(sc) , !
        } else {
            Set responseJSON = {}.%FromJSON(pResponse.message)
            Write !,!,"Response: ", !,responseJSON.message.content, !
            Do messages.%Push(responseJSON.message)
        }

        Kill pResponse
    }

    Return sc
}

ClassMethod SendChat(request As careia.messages.requests.OllamaChatRQ, Output pResponse As careia.messages.responses.OllamaChatRSP = "") As %Status
{
    Set sc = $$$OK

    Set sc = ##class(Ens.Director).CreateBusinessService("careia.bs.Chat", .instance)
    If $$$ISOK(sc) {
        Set sc = instance.OnProcessInput(request, .pResponse)
    }

    Return sc
}

}
