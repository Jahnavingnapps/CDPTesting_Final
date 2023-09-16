*** Settings ***
Resource    Variables.robot                   #A file where the baseurl,endurl and token are there
Library    RequestsLibrary
Library    Collections
Library    String
Library    JSONLibrary
Library    Dialogs

*** Variables ***
${user_id}
${imsi_id}
*** Test Cases ***
Search for Users API
    [Tags]   Demo
    Create Session    session1     ${base_url}
    ${endpoint}      Set Variable    ${end_url}
    ${headers}=      Create Dictionary    Authorization=${access_token}
    ${response}=     GET On Session    session1   ${endpoint}   headers=${headers}
    Log To Console    ${response.headers}
    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    #Validations
    ${status_code}=   Convert To String   ${response.status_code}
    Should Be Equal    ${status_code}      200

Create a User API
    [Tags]    Demo
    Create Session   session2    ${base_url}
    ${endpoint}      set variable     ${end_url}
    ${headers}=      Create Dictionary    Authorization=${access_token}    Content-Type=application/json
    ${policyCounterIds}=    Create List
     ${body}=    Create Dictionary    imsi=1986
    Log To Console    ${body}
    ${json_string}=      Convert JSON to string    ${body}

    ${response}=    POST On Session    session2    ${endpoint}    data=${json_string}    headers=${headers}

    Log To Console    ${response.content}
    Should Be Equal As Integers    ${response.status_code}    200
    ${json_response}=    Convert String To Json    ${response.content}

    ${response_json}=    Evaluate    json.loads('''${response.content}''')      #Extaracted the id for the update,search and for delete
    ${created_user_id}=    Set Variable    ${response_json['id']}
    Log To Console    Created User ID: ${created_user_id}
    Set Suite Variable    ${user_id}    ${created_user_id}                     #made it global so that you can use anywhere


    ${created_user_imsi}=    Set Variable    ${response_json['imsi']}         #extracted the imsi to search by imsi
    Log To Console    Created User IMSI: ${created_user_imsi}
    Set Suite Variable    ${imsi_id}    ${created_user_imsi}                  #made it global so you can access anywhere



    #Validations
    ${status_code}=   Convert To String   ${response.status_code}
    Should Be Equal    ${status_code}      200










Read a User API
    [Tags]   Demo
    Create Session    session1     ${base_url}
    ${endpoint}=      Set Variable    ${end_url}/${user_id}
    ${headers}=      Create Dictionary    Authorization=${access_token}
    ${response}=     GET On Session    session1   ${endpoint}   headers=${headers}
    Log To Console    ${response.headers}
    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    #Validations
    ${status_code}=    convert to string    ${response.status_code}
    should be equal    ${status_code}    200



Update User API
    [Tags]    Demo
    Create Session   session2    ${base_url}
    ${endpoint}      set variable     ${end_url}/${user_id}
    ${body}=    Create Dictionary    gpsi=12345
    ${json_string}=      Convert JSON to string    ${body}
    ${headers}=      Create Dictionary    Authorization=${access_token}    Content-Type=application/json
    ${response}=    Put On Session    session2    ${endpoint}    data=${json_string}    headers=${headers}
    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    #Validations
    ${status_code}=    convert to string    ${response.status_code}
    should be equal    ${status_code}    200




Read a User API by IMSI
    [Tags]    Demo1
    Create Session   session1    ${base_url}
    ${endpoint}=      Set Variable    ${end_url}/imsi/${imsi_id}
    ${headers}=      Create Dictionary    Authorization=${access_token}
    ${response}=     GET On Session    session1   ${endpoint}   headers=${headers}
    Log To Console    ${response.content}

    #Validations
    ${status_code}=    convert to string    ${response.status_code}
    should be equal    ${status_code}    200


*** Comments ***
Delete User API
    [Tags]    Demo1
    Create Session   session1    ${base_url}
    ${endpoint}      set variable    ${end_url}/${user_id}
    ${headers}=      Create Dictionary    Authorization=${access_token}
    ${response}=    Delete On Session    session1    ${endpoint}    headers=${headers}
    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    #Validations
    ${status_code}=    convert to string    ${response.status_code}
    should be equal    ${status_code}    200







