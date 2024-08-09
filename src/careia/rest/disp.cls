Class careia.rest.disp Extends %CSP.REST [ ProcedureBlock ]
{

/// Process request SwaggerSpec /_spec
ClassMethod SwaggerSpec() As %Status
{
	Try {
		Do ##class(%REST.Impl).%SetContentType("application/json")
		If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
		Set response=##class(careia.rest.impl).SwaggerSpec()
		Do ##class(careia.rest.impl).%WriteResponse(response)
	} Catch(ex) {
		 Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$parameter("careia.rest.disp","ExposeServerExceptions"))
	}
	Quit $$$OK
}

/// Process request post /putPatientData
ClassMethod putPatientData() As %Status
{
	Set sc = $$$OK
	Try{
		Set acceptedMedia = $ListFromString("application/json")
		If '$ListFind(acceptedMedia,$$$LOWER(%request.ContentType)) {
			 Do ##class(%REST.Impl).%ReportRESTError(..#HTTP415UNSUPPORTEDMEDIATYPE,$$$ERROR($$$RESTContentType,%request.ContentType)) Quit
		}
		Do ##class(%REST.Impl).%SetContentType($Get(%request.CgiEnvs("HTTP_ACCEPT")))
		If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
		If '$isobject(%request.Content) Do ##class(%REST.Impl).%ReportRESTError(..#HTTP400BADREQUEST,$$$ERROR($$$RESTRequired,"body")) Quit
		Set requestMessage = ##class(careia.rest.requests.putPatientData).%New()
		Do requestMessage.LoadFromRequest(%request)
		Set scValidateRequest = requestMessage.RequestValidate()
		If $$$ISERR(scValidateRequest) Do ##class(%REST.Impl).%ReportRESTError(..#HTTP400BADREQUEST,$$$ERROR(5001,"Invalid requestMessage object.")) Quit
		Set response = ##class(careia.rest.impl).putPatientData(requestMessage)
		Do ##class(careia.rest.impl).%WriteResponse(response)
	} Catch(ex) {
		Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$parameter("careia.rest.impl","ExposeServerExceptions"))
	}
	Quit sc
}

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter IgnoreWrites = 1;

Parameter SpecificationClass = "careia.rest.Spec";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <Route Url="/putPatientData" Method="POST" Call="putPatientData" />
  <Route Url="/_spec" Method="get" Call="SwaggerSpec" />
</Routes>
}

}
