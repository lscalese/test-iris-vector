Class careia.rest.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// Process request SwaggerSpec /_spec
ClassMethod SwaggerSpec() As %Status
{
	Set spec = {}.%FromJSON(##class(%Dictionary.CompiledXData).%OpenId("careia.rest.Spec||OpenAPI").Data)
	Set url = $Select(%request.Secure:"https",1:"http") _ "://"_$Get(%request.CgiEnvs("SERVER_NAME")) _ ":" _ $Get(%request.CgiEnvs("SERVER_PORT")) _ %request.Application
	Set spec.servers = [{"url" : (url)}]
	Quit spec
}

/// Service implemntation for post /putPatientData
ClassMethod putPatientData(messageRequest As careia.rest.requests.putPatientData) As %Status
{
	; Implement your service here.
	; Return {}

	Set response = ..InvokePutPatientData(messageRequest.putPatientDatabody)

	Return response
}

/// Please note that the positional parameters are passed by the argv argument vector.
ClassMethod InvokePutPatientData(message As %DynamicObject) As %DynamicObject
{
	Set response = {}

	Set sc = ##class(careia.services.PatientEmbeddingsService).PutPatientEmbedding(message.patientId, message.type, message.sentences)
	
	If $$$ISOK(sc) {
		#dim response as %DynamicObject
		Set response.status = $Select($$$ISOK(sc):"OK",1:"ERROR")
		Set response.message = $Select($$$ISOK(sc):"Patient data added to the queue successfully",1:$SYSTEM.Status.GetErrorText(sc))
	}

	If $$$ISERR(sc) $$$ThrowStatus(sc)
	
	Return response
}

Parameter ExposeServerExceptions = 1;

}
