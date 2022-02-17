param logicAppName string = 'ContactForm'
param storageAccount string
param storageAccountTableName string

var storageAccountId =  resourceId('Microsoft.Storage/storageAccounts', storageAccount)

resource connections_office365_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: 'office365'
  location: 'eastus'
  properties: {
    displayName: 'SendEmail'
    api: {
      name: 'office365'
      displayName: 'Office 365 Outlook'
      description: 'Microsoft Office 365 is a cloud-based service that is designed to help meet your organization\'s needs for robust security, reliability, and user productivity.'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1538/1.0.1538.2621/office365/icon.png'
      brandColor: '#0078D4'
      id: subscriptionResourceId('Microsoft.Web/locations/managedApis', 'eastus', 'office365')
    }
    testLinks: [
      {                                                                                                                                                                          
        requestUri: uri('https://management.azure.com:443', 'subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup()}/providers/Microsoft.Web/connections/office365/extensions/proxy/testconnection?api-version=2018-07-01-preview')
        method: 'get'
      }
    ]
  }
}
resource azuretables_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: 'azuretables'
  location: 'eastus'
  properties: {
    displayName: 'AddToTable'
    api: {
      name: 'azuretables'
      displayName: 'Azure Table Storage'
      description: 'Azure Table storage is a service that stores structured NoSQL data in the cloud, providing a key/attribute store with a schemaless design. Sign into your Storage account to create, update, and query tables and more.'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1538/1.0.1538.2619/azuretables/icon.png'
      brandColor: '#804998'
      id: subscriptionResourceId('Microsoft.Web/locations/managedApis', 'eastus', 'azuretables')
    }
    parameterValues: {
      storageaccount: storageAccount
      sharedkey: listKeys(storageAccountId, '2019-04-01').keys[0].value
    }
    testLinks: [
      {                                                                                                                                                                                                                                                                                                                          
        requestUri: uri('https://management.azure.com:443', 'subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup()}/providers/Microsoft.Web/connections/AddToTable/extensions/proxy/testconnection?api-version=2018-07-01-preview')
        method: 'get'
      }
    ]
  }
}


resource workflows_ContactForm_name_resource 'Microsoft.Logic/workflows@2017-07-01' = {
  name: logicAppName
  location: 'eastus'
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        manual: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            schema: [
              {
                name: 'subject'
                value: 'sd'
              }
              {
                name: 'phone'
                value: 'sadasd'
              }
              {
                name: 'name'
                value: 'asdasd'
              }
              {
                name: 'email'
                value: 'adssd@gmail.com'
              }
              {
                name: 'message'
                value: 'dasdasd'
              }
            ]
          }
        }
      }
      actions: {
        Convert_String_to_Json_Object: {
          runAfter: {
            Iterate_Through_Array_of_JSON_Objects: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'JsonObject'
                type: 'object'
                value: '@json(concat(variables(\'JsonString\'), \'}\'))'
              }
            ]
          }
        }
        Create_HTML_Table_for_Email_Formatting: {
          runAfter: {
            Parse_HTTP_Request_JSON: [
              'Succeeded'
            ]
          }
          type: 'Table'
          inputs: {
            columns: [
              {
                header: ''
                value: '@item()?[\'name\']'
              }
              {
                header: ''
                value: '@item()?[\'value\']'
              }
            ]
            format: 'HTML'
            from: '@triggerBody()'
          }
        }
        Initialize_String_Variable_With_Table_Inputs: {
          runAfter: {
            'Send_an_email_(V2)': [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
          inputs: {
            variables: [
              {
                name: 'JsonString'
                type: 'string'
                value: '{\n"PartitionKey": "${storageAccountTableName}",\n"RowKey": "@{guid()}",'
              }
            ]
          }
        }
        Insert_Json_Object_as_New_Table_Entity: {
          runAfter: {
            Convert_String_to_Json_Object: [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            body: '@variables(\'JsonObject\')'
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azuretables\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/Tables/@{encodeURIComponent(\'${storageAccountTableName}\')}/entities'
          }
        }
        Iterate_Through_Array_of_JSON_Objects: {
          foreach: '@body(\'Parse_HTTP_Request_JSON\')'
          actions: {
            Append_Key_Value_Pairs_as_Strings_to_Variable_JsonString: {
              runAfter: {}
              type: 'AppendToStringVariable'
              inputs: {
                name: 'JsonString'
                value: '"@{items(\'Iterate_Through_Array_of_JSON_Objects\')[\'name\']}": "@{items(\'Iterate_Through_Array_of_JSON_Objects\')[\'value\']}",'
              }
            }
          }
          runAfter: {
            Initialize_String_Variable_With_Table_Inputs: [
              'Succeeded'
            ]
          }
          type: 'Foreach'
        }
        Parse_HTTP_Request_JSON: {
          runAfter: {}
          type: 'ParseJson'
          inputs: {
            content: '@triggerBody()'
            schema: {
              items: {
                properties: {
                  name: {
                    type: 'string'
                  }
                  value: {
                    type: 'string'
                  }
                }
                required: [
                  'name'
                  'value'
                ]
                type: 'object'
              }
              type: 'array'
            }
          }
        }
        Response: {
          runAfter: {
            Insert_Json_Object_as_New_Table_Entity: [
              'Succeeded'
            ]
          }
          type: 'Response'
          kind: 'Http'
          inputs: {
            body: 'Email and Table Entry Complete!'
            statusCode: 200
          }
        }
        'Send_an_email_(V2)': {
          runAfter: {
            Create_HTML_Table_for_Email_Formatting: [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            body: {
              Body: '<p><u><strong>Contact Form Information:</strong></u><br>\n@{body(\'Create_HTML_Table_for_Email_Formatting\')}</p>'
              Subject: 'Testing123'
              To: 'Raymond.Mazurik@Anikasystems.com'
            }
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'office365\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/v2/Mail'
          }
        }
      }
      outputs: {}
    }
    parameters: {
      '$connections': {
        value: {
          azuretables: {
            connectionId: subscriptionResourceId('Microsoft.Web/connections', 'azuretables')
            connectionName: 'azuretables'
            id: subscriptionResourceId('Microsoft.Web/locations/managedApis', 'eastus', 'azuretables')
          }
          office365: {
            connectionId: subscriptionResourceId('Microsoft.Web/connections', 'office365')
            connectionName: 'office365'
            id: subscriptionResourceId('Microsoft.Web/locations/managedApis', 'eastus', 'office365') 
          }
        }
      }
    }
  }
}
