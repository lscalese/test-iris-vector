Class careia.services.AIChat
{

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

    
    Set messages = [], user = "Dr Sombrelune", patient = "Moisés García Pérez"

    Set formatter = ##class(%JSON.Formatter).%New()

    Set systemMsg = "Parle en français.  Tu assistes {user}  qui consulte les données du patient {patient}."

    For var = $lb("{user}",user), $lb("{patient}",patient) {
        Set systemMsg = $Replace(systemMsg, $lg(var,1), $lg(var,2))
    }

    Do messages.%Push({
        "role": "system",
        "content": (systemMsg)
    })

    While 1 {

        Write !,!, "You: ",!

        Read question

        If question = "exit" {
            Return $$$OK
        }
        
        Do messages.%Push({
            "role": "user",
            "content": (question)
        })

        
        
        Set request = ##class(careia.messages.requests.OllamaChatRQ).%New()
        Do formatter.FormatToStream(messages, request.messages)

        Set request.options = {
            "temperature" : 0.2
        }.%ToJSON()

        Set sc = ..SendChat(request, .pResponse)

        If $$$ISERR(sc) {
            Write !,!, "Error: ",$SYSTEM.Status.GetErrorText(sc) , !
        } Else {
            Set responseJSON = {}.%FromJSON(pResponse.message)
            ;Write !,!,"Response: ", !,$Translate(responseJSON.message.content,$Char(10), $Char(13,10)), !

            Write !,!,"Response: ", ! ;,responseJSON.message.content, !
            zw responseJSON.message.content
            Write !
            Do messages.%Push(responseJSON.message)
        }

        Kill pResponse
    }

    Return sc
}

ClassMethod IsAboutPatient(question As %String, history As %DynamicObject = {[]}, Output jsonResponse As %DynamicObject) As %Boolean
{
    Set sc = $$$OK
    
    Set system = "L'utilisateur consulte les données d'un patient et peut vous poser des questions le concernant ou non. "
                _ "Votre rôle est uniquement de déterminer si le prompt concerne ce patient. Ne répondez pas au prompt. "
                _ "Retournez un JSON avec `aboutPatient` défini à `true` si le prompt concerne le patient, ou à `false` pour toute autre demande."

    Set formatter = ##class(%JSON.Formatter).%New()

    ;w !,system,!

    Set messages = [{
        "role": "system",
        "content": (system)
    },{
        "role": "user",
        "content": (question)
    }]
    
    Set request = ##class(careia.messages.requests.OllamaChatRQ).%New()

    Set request.options = {
        "seed" : 150,
        "temperature" : 0.8
    }.%ToJSON()

    Do formatter.FormatToStream(messages, request.messages)

    $$$TOE(sc, ..SendChat(request, .pResponse))

    Set contentResponse = {}.%FromJSON(pResponse.message).message.content
    
    Set jsonResponse = {}.%FromJSON(contentResponse)
    
    Do formatter.FormatToString(jsonResponse, .formattedJSON)
    Write:$Get(%zverbose,0) !,formattedJSON,!

    Return jsonResponse.aboutPatient
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

ClassMethod GetStringFileData(pFileName As %String = "/home/irisowner/dev/data/rapport_hospit.txt") As %String
{
    Set file = ##class(%Stream.FileCharacter).%New()
    Do file.LinkToFile(pFileName)
    Set content = ""
    While 'file.AtEnd {
        Set content = content _ $zcvt(file.Read(), "I", "UTF8")
    }
    Return content
}

}
