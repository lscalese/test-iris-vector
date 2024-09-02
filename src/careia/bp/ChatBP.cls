Class careia.bp.ChatBP Extends Ens.BusinessProcess
{

Method OnRequest(requestMessage As careia.messages.requests.OllamaChatRQ, Output responseMessage As careia.messages.responses.OllamaChatRSP) As %Status
{
    Set sc = $$$OK
    #DIM messages As %DynamicArray = {}.%FromJSON(requestMessage.messages)
    #DIM iter As %Iterator = messages.%GetIterator()

    Set key = "", last = {}

    For  {
        If 'iter.%GetNext(.key, .value) {
            Quit
        }
        Set last = value
    }

    If ..IsPatientDataRequired(last.content) {
        ; ici on ajoute la gestion du RAG
        $$$LOGINFO("Patient data required")

        Set data = ..GetStringFileData()

        Set (RAGTemplate) = "En utilisant les données suivantes : \n\n"
                        _ "{data}\n\n"
                        _ "Réponds à cette question : \n\n {question} "

        For var = $lb("{data}",..GetStringFileData()), $lb("{question}",last.content) {
            Set RAGTemplate = $Replace(RAGTemplate, $lg(var,1), $lg(var,2))
        }
        Set last.content = RAGTemplate
        
        Do requestMessage.messages.Clear()

        Set formatter = ##class(%JSON.Formatter).%New()
        Do formatter.FormatToStream(messages, requestMessage.messages)

    }

    If $$$ISERR(sc) {
        $$$LOGERROR("Error: "_$SYSTEM.Status.GetErrorText(sc))
    }

    Set requestMessage.model = "mixtral:8x7b"

    Set sc = ..SendRequestSync("OllamaRESTOperation", .requestMessage, .responseMessage, 45)

    Return sc
}

Method IsPatientDataRequired(question As %String, history As %DynamicObject = {[]}, Output jsonResponse As %DynamicObject) As %Boolean
{
    Set sc = $$$OK
    
    Set system = "Vous êtes un outil d'analyse de prompt pour un logiciel médical. \n"
                _ "Votre rôle consiste à déterminer si la réponse à la question nécessite d'intégrer des données sur le patient. \n\n"
                _ "Contexte : \n\n"
                _ "* Un utilisateur consulte les données d'un patient et peut poser des questions sur ces données ou toutes autres questions\n"
                _ "* Le LLM ne dispose d'aucune information préalable concernant les patients.\n\n"
                _ "Ne répondez pas directement au prompt.\n\n"
                ;_ "Répondez au format JSON avec un boolean `patientDataRequired` sans explication."
                ;_ "Répondez simplement, si la réponse au prompt nécessite d'intégrer des informations sur le patient et pourquoi.\n"
                ;_ "Répondez au format JSON avec un boolean `patientDataRequired` et pourquoi dans `reason`."
                _ "Répondez au format JSON avec un boolean `patientDataRequired` si la réponse à la question nécessite d'intégrer des données sur le patient."


    Set formatter = ##class(%JSON.Formatter).%New()

    Set messages = [{
        "role": "system",
        "content": (system)
    },{
        "role": "user",
        "content": (question)
    }]
    
    Set request = ##class(careia.messages.requests.OllamaChatRQ).%New()
    Set request.model = "mixtral:8x7b"
    Set request.options = {
        "temperature" : 0.5,
        "format" : "json"
    }.%ToJSON()

    Do formatter.FormatToStream(messages, request.messages)


    Set sc = ..SendRequestSync("OllamaRESTOperation", .request, .pResponse, 30)

    If $$$ISERR(sc) {
        $$$ThrowStatus(sc)
    }

    Set contentResponse = {}.%FromJSON(pResponse.message).message.content
    
    Set jsonResponse = {}.%FromJSON(contentResponse)
    
    Do formatter.FormatToString(jsonResponse, .formattedJSON)
    Write:$Get(%zverbose,0) !,formattedJSON,!

    Return jsonResponse.patientDataRequired
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

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
