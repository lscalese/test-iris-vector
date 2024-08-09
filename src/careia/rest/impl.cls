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
ClassMethod InvokePutPatientData(message) As %DynamicObject
{
	Set response = {}
	Set sc = ##class(Ens.Director).CreateBusinessService("careia.bs.PutPatientDataBS", .instance)
	If $$$ISOK(sc) {
		#dim response as %DynamicObject
		Set sc = instance.OnProcessInput(message, .pResponse)
		Set response.status = pResponse.status
		Set response.message = pResponse.message
	}

	If $$$ISERR(sc) $$$ThrowStatus(sc)
	Return response
}

Parameter ExposeServerExceptions = 1;

}
