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

    Set messages = []

    Set formatter = ##class(%JSON.Formatter).%New()

    Set template = "En utilisant ces données: \n {data} \n. Répond à ces questions : {question}."

    Set data = ..GetStringFileData("/home/irisowner/dev/data/rapport_hospit.txt")

    While 1 {

        Write !,!, "You: ",!

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

        ;Set template = "{question}" ; pour ne mettre le context que la première fois

        If $$$ISERR(sc) {
            Write !,!, "Error: ",$SYSTEM.Status.GetErrorText(sc) , !
        } Else {
            Set responseJSON = {}.%FromJSON(pResponse.message)
            Write !,!,"Response: ", !,$Translate(responseJSON.message.content,$Char(10), $Char(13,10)), !
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
