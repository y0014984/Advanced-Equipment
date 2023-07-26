# ArmaOS

## Variables

Name                   | Type        | Desciption                                                                    | Location
----                   | -----       | -----------                                                                   | -------
computer_mutex         | object      | Current user (player)                                                         | public
terminal               | hashmap     | Terminal settings (reference below)                                           | server
filesystem             | hashmap     | [name, [content, owner, [[ownerX, ownerR, ownerW],[ otherX, otherR, otherW]]] | server
filepointer            | array       | Pointer to the current directory                                              | server
Links                  | hashmap     | Storing available system commands (name -> [path, desc, man])                 | public
Userlist               | hashmap     | Storing user -> pwd pairs                                                     | public
terminalKeyboardLayout | string      | Defining keyboard layout ("DE", "US", "FR, "IT")                              | public

### terminal

Name                         | Type              | Desciption
----                         | -----             | -----------  
terminalComputer             | object            | referencing the computer, the current terminal is running on
terminalLoginUser            | string            | currently loged in user
terminalApplication          | string            | Terminal mode ("LOGIN" | "PASSWORD" | "SHELL" | "INPUT")
terminalPrompt               | string            | contains the current terminal prompt
terminalInputBuffer          | string            |
terminalBuffer               | array             |
terminalBufferVisible        | array             |
terminalCursorLine           | int               |
terminalCursorPosition       | int               |
terminalScrollPosition       | int               |
terminalMaxRows              | int               |
terminalMaxColumns           | int               |
terminalAllowedKeys          | hashmap           | format ["%1-%2-%3-%4", _key, _shift, _ctrl, _alt]
terminalProcess              | int               | Handler of the currently running programm
terminalCommandHistory       | array             | List of last commands
terminalCommandHistoryIndex  | int               |
terminalOutput               | Control UI object | referencing the current ui control for output
