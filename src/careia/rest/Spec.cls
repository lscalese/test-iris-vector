Class careia.rest.Spec Extends %RegisteredObject [ ProcedureBlock ]
{

XData OpenAPI [ MimeType = application/json ]
{
{
  "openapi":"3.0.0",
  "info":{
    "title":"Patient Embeddings API",
    "version":"1.0.0"
  },
  "servers":[
    {
      "url":"/"
    }
  ],
  "paths":{
    "/putPatientData":{
      "post":{
        "summary":"Store patient data and embeddings",
        "operationId":"putPatientData",
        "requestBody":{
          "content":{
            "application/json":{
              "schema":{
                "$ref":"#/components/schemas/putPatientData_body"
              }
            }
          },
          "required":true
        },
        "responses":{
          "200":{
            "description":"Data stored successfully",
            "content":{
              "application/json":{
                "schema":{
                  "$ref":"#/components/schemas/inline_response_200"
                }
              }
            }
          },
          "400":{
            "description":"Invalid input",
            "content":{
              "application/json":{
                "schema":{
                  "$ref":"#/components/schemas/inline_response_400"
                }
              }
            }
          },
          "500":{
            "description":"Internal server error",
            "content":{
              "application/json":{
                "schema":{
                  "$ref":"#/components/schemas/inline_response_400"
                }
              }
            }
          }
        }
      }
    }
  },
  "components":{
    "schemas":{
      "putPatientData_body":{
        "type":"object",
        "properties":{
          "patientId":{
            "type":"integer",
            "example":123
          },
          "type":{
            "type":"string",
            "example":"typeA"
          },
          "sentences":{
            "type":"array",
            "example":[
              "This is a sentence.",
              "This is another sentence."
            ],
            "items":{
              "type":"string"
            }
          }
        }
      },
      "inline_response_200":{
        "type":"object",
        "properties":{
          "status":{
            "type":"string",
            "example":"OK"
          }
        }
      },
      "inline_response_400":{
        "type":"object",
        "properties":{
          "status":{
            "type":"string",
            "example":"Error"
          }
        }
      }
    }
  }
}
}

}
