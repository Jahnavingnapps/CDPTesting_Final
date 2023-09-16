*** Settings ***
Resource    service_variables.robot                   #A file where the baseurl,endurl and token are there
Library    RequestsLibrary
Library    Collections
Library    String
Library    JSONLibrary
Library    Dialogs

*** Variables ***
${user_id}
${id}

*** Test Cases ***
List all the Orders API                                #List  all order present in the api
    [Tags]   Demo
    Create Session    session1     ${base_url}
    ${endpoint}      Set Variable    ${end_url}
    ${headers}=      Create Dictionary    Authorization=${access_token}
    ${response}=     GET On Session    session1   ${endpoint}   headers=${headers}
    #Log To Console    ${response.headers}
    #Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    #Validations
    ${status_code}=   Convert To String   ${response.status_code}
    Should Be Equal    ${status_code}      200



Create a ServicePass Template API
    [Tags]    Demo
    Create Session   session2    ${base_url}
    ${endpoint}      set variable     ${end_url}
    ${headers}=      Create Dictionary    Authorization=${access_token}    Content-Type=application/json
     ${body}=    Catenate
     ...    {
     ...        #"id": "abcd-xyzz-sdfeer0-sdflk2342551987",                   ##Every time you need to create a new user
     ...         "id":"65057428c70ee767bf246bc7",
     ...        "name": "WELCOME_NOTIFICATIONS_DEMO",
     ...        "description": "This is description",
     ...         "zoneId": "1024",
     ...         "mccList": [
     ...                   "102,234"
     ...                    ],
     ...         "mncList": [
     ...                   "102,234"
     ...                    ],
     ...           "qos": 1024,
     ...          "volume": 1024,
     ...         "notifications": { },
     ...            "active": false
     ...     }
     ${response}=    POST On Session    session2    ${endpoint}    data=${body}    headers=${headers}

    Log To Console    ${response.content}
    Should Be Equal As Integers    ${response.status_code}    200
    ${json_response}=    Convert String To Json    ${response.content}

    ${response_json}=    Evaluate    json.loads('''${response.content}''')
    ${created_user_id}=    Set Variable    ${response_json['id']}
    Log To Console    Created User ID: ${created_user_id}
    Set Suite Variable    ${id}    ${created_user_id}

Read a ServicePass Template API
    [Tags]   Demo
    Create Session    session1     ${base_url}
    ${endpoint}      Set Variable    ${end_url}/${id}
    ${headers}=      Create Dictionary    Authorization=${access_token}
    ${response}=     GET On Session    session1   ${endpoint}   headers=${headers}
    #Log To Console    ${response.headers}
    #Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    #Validations
    ${status_code}=   Convert To String   ${response.status_code}
    Should Be Equal    ${status_code}      200



Update a ServicePass Template API
    [Tags]    Demo
    Create Session   session2    ${base_url}
    ${endpoint}      set variable     ${end_url}/${id}
    ${body}=    Catenate
    ...     {
    ...        "qos":"1026"
    ...      }
    ${headers}=      Create Dictionary    Authorization=${access_token}    Content-Type=application/json
    ${response}=    Put On Session    session2    ${endpoint}    data=${body}    headers=${headers}
    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    #Validations
    ${status_code}=    convert to string    ${response.status_code}
    should be equal    ${status_code}    200

*** Comments ***
Delete a ServicePass Template API
    [Tags]   Demo
    Create Session    session1     ${base_url}
    ${endpoint}      Set Variable    ${end_url}/${id}
    ${headers}=      Create Dictionary    Authorization=${access_token}
    ${response}=     GET On Session    session1   ${endpoint}   headers=${headers}
    #Log To Console    ${response.headers}
    #Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    #Validations
    ${status_code}=   Convert To String   ${response.status_code}
    Should Be Equal    ${status_code}      200

