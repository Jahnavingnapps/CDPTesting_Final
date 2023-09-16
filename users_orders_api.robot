*** Settings ***
Resource    oder_variables.robot                   #A file where the baseurl,endurl and token are there
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

Create an Order API
    [Tags]    Demo
    Create Session   session2    ${base_url}
    ${endpoint}      set variable     ${end_url}
    ${headers}=      Create Dictionary    Authorization=${access_token}    Content-Type=application/json
     ${body}=    Catenate
     ...    {
     ...        "userId": "647e89e4d19b54347e71f826",
     ...        "createdBy": "createdBy",
     ...        "couponCode": "NEWYEAR",
     ...        "servicePassTemplateId": "647e88d6d19b54347e71f824",
     ...        "servicePassId": "T435345-45345345",
     ...        "paymentMethodId": "T435345-45345345",
     ...        "activateDate": "2023-09-06T11:12:02.746Z",
     ...        "createdDate": "2023-09-06T11:12:02.746Z",
     ...        "status": "DRAFTED"
     ...     }

    ${response}=    POST On Session    session2    ${endpoint}    data=${body}    headers=${headers}

    Log To Console    ${response.content}
    Should Be Equal As Integers    ${response.status_code}    200
    ${json_response}=    Convert String To Json    ${response.content}

    ${response_json}=    Evaluate    json.loads('''${response.content}''')
    ${created_user_id}=    Set Variable    ${response_json['id']}
    Log To Console    Created User ID: ${created_user_id}
    Set Suite Variable    ${id}    ${created_user_id}
    
    ${c_user_id}=    Set Variable    ${response_json['userId']}
    Set Suite Variable    ${user_id}    ${c_user_id}

Read an Order API
    [Tags]   Demo
    Create Session    session1     ${base_url}
    ${endpoint}=      Set Variable    ${end_url}/${id}
    ${headers}=      Create Dictionary    Authorization=${access_token}
    ${response}=     GET On Session    session1   ${endpoint}   headers=${headers}
    Log To Console    ${response.headers}
    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    #Validations
    ${status_code}=    convert to string    ${response.status_code}
    should be equal    ${status_code}    200


List Orders by UserId API
    [Tags]    Demo1
    Create Session   session1    ${base_url}
    ${endpoint}=      Set Variable    ${end_url}/userId/${id}
    ${headers}=      Create Dictionary    Authorization=${access_token}
    ${response}=     GET On Session    session1   ${endpoint}   headers=${headers}
    Log To Console    ${response.content}

    #Validations
    ${status_code}=    convert to string    ${response.status_code}
    should be equal    ${status_code}    200

    #Log
#Cancel the order
#Read an Invoice API.