Class careia.rest.requests.putPatientData Extends %RegisteredObject [ ProcedureBlock ]
{

Property %Consume As %String(MAXLEN = "");

Property %ContentType As %String(MAXLEN = "");

Property %URL As %String(MAXLEN = "") [ InitialExpression = {..#URL} ];

/// Use this property for body content with content-type = application/json.
Property putPatientDatabody As careia.rest.model.putPatientDatabody;

/// Load object properties from %CSP.Request object.
Method LoadFromRequest(request As %CSP.Request = {%request}) As %Status
{
	Set sc = $$$OK
	Set ..%ContentType = $Piece(request.ContentType, ";", 1)
	If ..%ContentType = "application/json"{
		Do ..putPatientDatabodyNewObject().%JSONImport(request.Content)
	}
	Quit sc
}

/// Load object properties from %CSP.Request object.
Method RequestValidate() As %Status
{
	Set sc = $$$OK
	$$$QuitOnError(..%ValidateObject())
	If ''$ListFind($ListFromString("application/json"), ..%ContentType) {
		Quit:..putPatientDatabody="" $$$ERROR(5659, "putPatientDatabody")
	}
	If $IsObject(..putPatientDatabody) $$$QuitOnError(..putPatientDatabody.%ValidateObject())
	Quit sc
}

Parameter METHOD = "post";

Parameter URL = "/putPatientData";

}
