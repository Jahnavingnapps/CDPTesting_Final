*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Library    JSONLibrary
Library    Dialogs
*** Variables ***
${base_url}      https://47.206.223.110:8443
${end_url}    /cdp/v1/notification-templates
${access_token}    Bearer eyJraWQiOiIwY2Y5NTJlYS0wYTIwLTRhODItYTNjNi1lZGQyOTMwYTQxY2MiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImF1ZCI6ImFkbWluIiwibmJmIjoxNjk0NTg2Njc2LCJzY29wZSI6WyJTWVNURU1fTUFOQUdFIiwib3BlbmlkIl0sImlzcyI6Imh0dHBzOi8vNDcuMjA2LjIyMy4xMTA6ODQ0MyIsImV4cCI6MTY5NTE5MTQ3NiwiaWF0IjoxNjk0NTg2Njc2fQ.aNB_4EaYdz8W3t-51HypooKLFHb0PhBjbEYyWQCHqj990LUHSiWAR6voEib9Vpn7YE2FPMcRUIBReH51YJHMM688p4GjFBePMJju2jUpjQz9QoGsTLrSM6DuNSsHK1TiWy9uiWyhoSngN-busLojakDIoxSBw7-ofJVSjq-7e62KBvCCwNK4xrCen9EZ7qdxNPBBM48CFriL4OAZ0UAL0jb81oRP_e7aBJT-mtxYzAX2tgDsfMY924-nBHpbH6t0RHBM3ZkB0XhagW92Dp2F9QJzmrstnNGjLtx9Wf10RaJiNrExi6XBm80WOpQ-3HzPv2buDkOs6oQzxDvF1jC8pjit9Rot4h1MxPup0U9_j1idKSOqPDU7pX1wZAVlt1IQxSrGrWtb8lFsJfKNq3JAfhrPBWu23KOFBLPSi9K8AmBi-UvTfQdRiEx3_Rk738JobI6at-vz6cIiX2_G5EoZwur-nBmaRrd5Qe04MoJi40LqQBBAkbqjR_oul9uP9-RC-mk1DM0XoqC6wGvcoHUKDChVgm7qLVfES4_vMU5uNzu2FPt2TloxxiAS5mRBaZbbpeWlllFqbF9yH7XfXZ_7Fadbv-8DUgKPt3dUcte7OclgSq-sGxyl-229QPvjvm-xJ9breVAqeQdscX_axrP9-TAtH_gsQzmcxjnJvFojc4I
${id}
${user_id}
*** Test Cases ***
Search for Notification Templates API                                #List  all order present in the api
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

Create a Notification Templates API
    [Tags]    Demo
    Create Session   session2    ${base_url}
    ${endpoint}      set variable     ${end_url}
    ${headers}=      Create Dictionary    Authorization=${access_token}    Content-Type=application/json
     ${body}=    Catenate
     ...         {
     ...             "id":"65057428c70ee767bf246bc7",
     ...             "name": "WELCOME_NOTIFICATIONS_DEMO",
     ...             "description": "",
     ...             "channels": ["SMS", "EMAIL"],
     ...             "message": "you have used an  %usage% MB and your balance data is %balance% MB.",
     ...             "retryCount": 3,
     ...             "active": false
     ...          }


    ${response}=    POST On Session    session2    ${endpoint}    data=${body}    headers=${headers}

    Log To Console    ${response.content}
    Should Be Equal As Integers    ${response.status_code}    200
    ${json_response}=    Convert String To Json    ${response.content}

    ${response_json}=    Evaluate    json.loads('''${response.content}''')
    ${created_user_id}=    Set Variable    ${response_json['id']}
    Log To Console    Created User ID: ${created_user_id}
    Set Suite Variable    ${id}    ${created_user_id}

Read a Notification Template API
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


Update a Notification Template API
    [Tags]    Demo
    Create Session   session2    ${base_url}
    ${endpoint}      set variable     ${end_url}/65046f48c70ee767bf246bb9
    ${body}=    Catenate
    ...     {
    ...        "id": "65046f48c70ee767bf246bb9",
    ...        "name": "WELCOME_NOTIFICATIONS_6",
    ...        "description": "hello",
    ...        "channels": ["EMAIL", "SMS"],
    ...        "message": "you have used %usage% MB and your balance data is %balance% MB.",
    ...         "retryCount": 6,
    ...         "active": true
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









