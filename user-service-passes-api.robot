*** Settings ***
                   #A file where the baseurl,endurl and token are there
Library    RequestsLibrary
Library    Collections
Library    String
Library    JSONLibrary
Library    Dialogs

*** Variables ***
${base_url}      https://47.206.223.110:8443
${end_url}    /cdp/v1/user-service-passes/userId/
${access_token}    Bearer eyJraWQiOiIwY2Y5NTJlYS0wYTIwLTRhODItYTNjNi1lZGQyOTMwYTQxY2MiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImF1ZCI6ImFkbWluIiwibmJmIjoxNjk0NTg2Njc2LCJzY29wZSI6WyJTWVNURU1fTUFOQUdFIiwib3BlbmlkIl0sImlzcyI6Imh0dHBzOi8vNDcuMjA2LjIyMy4xMTA6ODQ0MyIsImV4cCI6MTY5NTE5MTQ3NiwiaWF0IjoxNjk0NTg2Njc2fQ.aNB_4EaYdz8W3t-51HypooKLFHb0PhBjbEYyWQCHqj990LUHSiWAR6voEib9Vpn7YE2FPMcRUIBReH51YJHMM688p4GjFBePMJju2jUpjQz9QoGsTLrSM6DuNSsHK1TiWy9uiWyhoSngN-busLojakDIoxSBw7-ofJVSjq-7e62KBvCCwNK4xrCen9EZ7qdxNPBBM48CFriL4OAZ0UAL0jb81oRP_e7aBJT-mtxYzAX2tgDsfMY924-nBHpbH6t0RHBM3ZkB0XhagW92Dp2F9QJzmrstnNGjLtx9Wf10RaJiNrExi6XBm80WOpQ-3HzPv2buDkOs6oQzxDvF1jC8pjit9Rot4h1MxPup0U9_j1idKSOqPDU7pX1wZAVlt1IQxSrGrWtb8lFsJfKNq3JAfhrPBWu23KOFBLPSi9K8AmBi-UvTfQdRiEx3_Rk738JobI6at-vz6cIiX2_G5EoZwur-nBmaRrd5Qe04MoJi40LqQBBAkbqjR_oul9uP9-RC-mk1DM0XoqC6wGvcoHUKDChVgm7qLVfES4_vMU5uNzu2FPt2TloxxiAS5mRBaZbbpeWlllFqbF9yH7XfXZ_7Fadbv-8DUgKPt3dUcte7OclgSq-sGxyl-229QPvjvm-xJ9breVAqeQdscX_axrP9-TAtH_gsQzmcxjnJvFojc4I
${end}      /cdp/v1/user-service-passes/
${id}
*** Test Cases ***
List ServicePasses API of a User
   [Tags]   Demo
    Create Session    session1     ${base_url}
    ${endpoint}      Set Variable    ${end_url}/11
    ${headers}=      Create Dictionary    Authorization=${access_token}
    ${response}=     GET On Session    session1   ${endpoint}   headers=${headers}
    #Log To Console    ${response.headers}
    #Log To Console    ${response.status_code}
    Log To Console    ${response.content}
     ${json_response}=    Convert String To Json    ${response.content}

    #Validations
    ${status_code}=   Convert To String   ${response.status_code}
    Should Be Equal    ${status_code}      200
    ${response_json}=    Evaluate    json.loads('''${response.content}''')
    ${created_user_id}=    Set Variable    ${response_json[0]['id']}
    Log To Console    Created User ID: ${created_user_id}
    Set Suite Variable    ${id}    ${created_user_id}

Read a ServicePass API
   [Tags]   Demo

    Create Session    session1     ${base_url}
    ${endpoint}      Set Variable    ${end}/${id}
    ${headers}=      Create Dictionary    Authorization=${access_token}
    ${response}=     GET On Session    session1   ${endpoint}   headers=${headers}
    #Log To Console    ${response.headers}
    #Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    #Validations
    ${status_code}=   Convert To String   ${response.status_code}
    Should Be Equal    ${status_code}      200

