# Interaction framework

## Variables

Name                     | Type        | Desciption                                                 | Location
----                     | -----       | -----------                                                | -------
fnc_open                 | code        | open function                                              | everywhere
fnc_openActionCondition  | code        | open action condition                                      | everywhere
fnc_openWrapper          | code        | function, which defines the open behavior                  | everywhere
fnc_close                | code        | close function                                             | everywhere
fnc_closeActionCondition | code        | close action condition                                     | everywhere
fnc_closeWrapper         | code        | function, which defines the close behavior                 | everywhere
closeState               | int         | `1` if close, `0` if open                                  | public