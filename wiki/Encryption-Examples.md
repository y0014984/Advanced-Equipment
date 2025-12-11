# Programmatic Encryption/Decryption Examples for Arma 3

This file provides example usage of the encryption and cracking functions provided by the AE3_armaos mod. Copy the code snippets into your scripts or mission files.

---

## Table of Contents

- [Overview](#overview)
- [Examples](#examples)
  - [Example 1: Basic Caesar Cipher Encryption](#example-1-basic-caesar-cipher-encryption)
  - [Example 2: Columnar Transposition Cipher](#example-2-columnar-transposition-cipher)
  - [Example 3: Crack Caesar Cipher (Bruteforce)](#example-3-crack-caesar-cipher-bruteforce)
  - [Example 4: Crack Caesar Cipher (Statistics)](#example-4-crack-caesar-cipher-statistics)
  - [Example 5: Find Columnar Key Lengths](#example-5-find-columnar-key-lengths)
  - [Example 6: Mission Scenario - Intercept and Decrypt Message](#example-6-mission-scenario---intercept-and-decrypt-message)
  - [Example 7: Automated Encryption System](#example-7-automated-encryption-system)
  - [Example 8: Secure Message Box (UI Integration)](#example-8-secure-message-box-ui-integration)
  - [Example 9: Error Handling](#example-9-error-handling)
  - [Example 10: Integration with Computer Filesystem](#example-10-integration-with-computer-filesystem)
- [Notes and Best Practices](#notes-and-best-practices)

---

## Overview

These snippets demonstrate programmatic use of the following functions:

- `AE3_armaos_fnc_encryption_crypto` — encrypt/decrypt operations
- `AE3_armaos_fnc_encryption_crack` — cracking/bruteforce/statistics for ciphers

### crypto
The `crypto` command is meant to be used in conjuction with the `crack` command. The `crypto` command allows you to encrypt and decrypt text by using various algorithms. See the list below for available algorithms. `crypto` is no real world linux command. It's meant to create gameplay options.
There is a very good [website](http://www.crypto-it.net/eng/simple/index.html) explaining simple encryption methods. Future algorithms will be taken from there.

| algorithm | status | key type | allowed text characters |
| --- | --- | --- | --- |
| caesar | implemented | integer | latin alphabet A-Z, only upper case, no numbers or symbols, no language specific characters like ö, é or ô |
| columnar | in development | string | characters found in the [UTF-8 decimal table](https://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec), between 33 and 126 (both included) |

### Command syntax

```
crypto -a=<ALGORITHM> -m=<MODE> -k=<KEY> <MESSAGE>
```

### Parameter details

| parameter | mandatory | option type | available options |
| --- | --- | --- | --- |
| `-a=<ALGORITHM>` | yes | select from available options | `caesar` and `columnar` |
| `-m=<MODE>` | yes | select from available options | `encrypt` and `decrypt` |
| `-k=<KEY>` | yes | custom string, see algorithms for details | --- |
| `<MESSAGE>` | yes | custom string | --- |

### Caesar algorithm
The caesar algorithm is very old and very simple. You shift every character by the key number to the right. For example: If the key is `3` and you want to encrypt a `B` you will get an `E` because this is the character 3 digits to the right in the latin alphabet.
Because you can only use upper case latin alphabet you need to somehow adjust your messages according to that. This algorithm is meant to be easy crackable. You can do that in mind because of it's low complexity or with the `crack` command. 
Keep in mind, all characters of the message to be encrypted will be changed to upper case latin alphabet or a blank space. Also keep in mind that there are only 26 passible keys because that's the length of the alphabet. You can use higher numbers but the result will match a lower number.

### Example
Here's an example. Message to encrypt: HELLO WORLD

```
admin@armaOS:/> crypto -a=caesar -m=encrypt -k=3 HELLO WORLD
KHOOR ZRUOG
admin@armaOS:/> crypto -a=caesar -m=decrypt -k=3 KHOOR ZRUOG
HELLO WORLD
```

### Columnar transposition algorithm
The columnar transposition algorithm is a cipher that involves rearranging the characters in a message (*transposition*), without altering the characters themselves. It transposes the text based on a key that defines the number of columns and their order. First, the plaintext is written row-wise into a grid with the keyword letter count as width. Because this implementation represents a complete columnar transposition, the last row will be completed with underscores (`'_'`), should the message not fit perfectly into all columns (i.e. `count(ciphertext) mod count(keyword) != 0`).  Next, the columns are reordered based on the alphabetic order of the keyword's letters. The alphabetic order is determined by the corresponding [UTF-8 decimal](https://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec) order; Allowed characters are between decimal `33 = '!'` and decimal `126 = '~'`. If the key contains the same character multiple times, they are ordered front to back, in the order they appear in the message. Finally, the ciphertext is read out column-wise. To decipher a message, the process is reversed.

### Example

Take a look at the following example, with `ARMA` as the keyword and `TheEnemyWillAttackAt0600h` as the secret message. First, the message is distributed over `4` columns, because the keyword has a length of 4 characters:
| A | R | M | A |
|---|---|---|---|
| T | h | e | E |
| n | e | m | y |
| W | i | l | l |
| A | t | t | a |
| c | k | A | t |
| 0 | 6 | 0 | 0 |
| h |  |  |  |

Next, complete the last row with underscores:
| A | R | M | A |
|---|---|---|---|
| T | h | e | E |
| n | e | m | y |
| W | i | l | l |
| A | t | t | a |
| c | k | A | t |
| 0 | 6 | 0 | 0 |
| h | _ | _ | _ |

Once the matrix is complete, the columns are reordered in alphabetic order, with the first `A` coming before the second:
| A | A | M | R |
|---|---|---|---|
| T | E | e | h |
| n | y | m | e |
| W | l | l | i |
| A | a | t | t |
| C | t | A | k |
| 0 | 0 | 0 | 6 |
| h | _ | _ | _ |

The final step is writing down the encrypted message, column-wise:
`TnWAc0hEylat0_emltA0_heitk6_`

The same example via the console will look like this:
```
admin@armaOS:/> crypto -a=columnar -m=encrypt -k=ARMA TheEnemyWillAttackAt0600h
TnWAc0hEylat0_emltA0_heitk6_
admin@armaOS:/> crypto -a=columnar -m=decrypt -k=ARMA TnWAc0hEylat0_emltA0_heitk6_
TheEnemyWillAttackAt0600h___
```

### crack
The `crack` command is meant to be used in conjuction with the `crypto` command. The `crack` command currently implements two methods each that allow you to crack the `caesar` and `columnar` algorithm.  `crack` is no real world linux command. It's meant to create gameplay options.

### Command syntax

```
crack -a=<ALGORITHM> -m=<MODE> <MESSAGE>
```

### Parameter details

| parameter | mandatory | option type | available options |
| --- | --- | --- | --- |
| `-a=<ALGORITHM>` | yes | select from available options | `caesar` and `columnar` |
| `-m=<MODE>` | yes | select from available options | `bruteforce`, `key` (only for columnar) and `statistics` (only for caesar) |
| `<MESSAGE>` | yes | custom string | --- |

## Example statistics mode
### Caesar
The `statistics` mode takes advantage of the fact that some characters are more common than others. The most common character for example in german is the `E` so it's very likely that the most frequent character in the encrypted message corresponds to an `E`. From there it's quite easy to decrypt.
Here's an example with the `statistics` mode.

Original Message: THIS IS MY SECRET MESSAGE

Encrypted Message: WKLV LV PB VHFUHW PHVVDJH

```
admin@armaOS:/> crack -a=caesar -m=statistics WKLV LV PB VHFUHW PHVVDJH
Character 'B' found 1 times (Possible key, if this is an 'E': 23)
Character 'D' found 1 times (Possible key, if this is an 'E': 25)
Character 'F' found 1 times (Possible key, if this is an 'E': 1)
Character 'H' found 4 times (Possible key, if this is an 'E': 3)
Character 'J' found 1 times (Possible key, if this is an 'E': 5)
Character 'K' found 1 times (Possible key, if this is an 'E': 6)
Character 'L' found 2 times (Possible key, if this is an 'E': 7)
Character 'P' found 2 times (Possible key, if this is an 'E': 11)
Character 'U' found 1 times (Possible key, if this is an 'E': 16)
Character 'V' found 5 times (Possible key, if this is an 'E': 17)
Character 'W' found 2 times (Possible key, if this is an 'E': 18)
admin@armaOS:/> crypto -a=caesar -m=decrypt -k=17 WKLV LV PB VHFUHW PHVVDJH
FTUE UE YK EQODQF YQEEMSQ
admin@armaOS:/> crypto -a=caesar -m=decrypt -k=3 WKLV LV PB VHFUHW PHVVDJH
THIS IS MY SECRET MESSAGE
```

## Example key mode
### Columnar
The `key` mode prints out all possible key-lengths that could have been used to encrypt the message. This might help in the search for the correct key.
Here's an example using the same key and encrypted message from the [columnar transposition algorithm example](#example-1).
```
admin@armaOS:/> crack -m=key -a=columnar TnWAc0hEylat0_emltA0_heitk6_
Possible Key-Lengths are:
2
4
7
14
```

### Example bruteforce mode
### Caesar
With a `bruteforce` attack the `crack` command prints all possible key variants and you need to find the correct one by looking over it. This is quite easy because there are only 26 options.
Here's an example with the `bruteforce` mode.

Original Message: THIS IS MY SECRET MESSAGE

Encrypted Message: WKLV LV PB VHFUHW PHVVDJH

```
admin@armaOS:/> crack -m=bruteforce -a=caesar WKLV LV PB VHFUHW PHVVDJH
Test 1: VJKU KU OA UGETGV OGUUCIG
Test 2: UIJT JT NZ TFDSFU NFTTBHF
Test 3: THIS IS MY SECRET MESSAGE
Test 4: SGHR HR LX RDBQDS LDRRZFD
Test 5: RFGQ GQ KW QCAPCR KCQQYEC
Test 6: QEFP FP JV PBZOBQ JBPPXDB
Test 7: PDEO EO IU OAYNAP IAOOWCA
Test 8: OCDN DN HT NZXMZO HZNNVBZ
Test 9: NBCM CM GS MYWLYN GYMMUAY
Test 10: MABL BL FR LXVKXM FXLLTZX
Test 11: LZAK AK EQ KWUJWL EWKKSYW
Test 12: KYZJ ZJ DP JVTIVK DVJJRXV
Test 13: JXYI YI CO IUSHUJ CUIIQWU
Test 14: IWXH XH BN HTRGTI BTHHPVT
Test 15: HVWG WG AM GSQFSH ASGGOUS
Test 16: GUVF VF ZL FRPERG ZRFFNTR
Test 17: FTUE UE YK EQODQF YQEEMSQ
Test 18: ESTD TD XJ DPNCPE XPDDLRP
Test 19: DRSC SC WI COMBOD WOCCKQO
Test 20: CQRB RB VH BNLANC VNBBJPN
Test 21: BPQA QA UG AMKZMB UMAAIOM
Test 22: AOPZ PZ TF ZLJYLA TLZZHNL
Test 23: ZNOY OY SE YKIXKZ SKYYGMK
Test 24: YMNX NX RD XJHWJY RJXXFLJ
Test 25: XLMW MW QC WIGVIX QIWWEKI
Test 26: WKLV LV PB VHFUHW PHVVDJH
```

Check the lines one by one. You will recognize immediately the correct decrypted message. So we found the correct message in Test 3. That means that the correct key is 3.

### Columnar
Bruteforcing the `columnar` cipher as not as simple, as the `caesar` cipher. Though in a complete transposition, it is possible to first take all possible key-lengths (just like the [key mode](#columnar)) and then list the according columns. Keep in mind that there is no way of knowing the column order. So instead of printing all column-permutations, you have to form the words from the columns yourself.
Here's an example using the same key and encrypted message from the [columnar transposition algorithm example](#example-1).

```
admin@armaOS:/> crack -m=bruteforce -a=columnar TnWAc0hEylat0_emltA0_heitk6_
Columns: 2, Rows: 14
T e
n m
W l
A t
c A
0 0
h _
E h
y e
l i
a t
t k
0 6
_ _

Columns: 4, Rows: 7
T E e h
n y m e
W l l i
A a t t
c t A k
0 0 0 6
h _ _ _

Columns: 7, Rows: 4
T c y 0 l _ t
n 0 l _ t h k
W h a e A e 6
A E t m 0 i _

Columns: 14, Rows: 2
T W c h y a 0 e l A _ e t 6
n A 0 E l t _ m t 0 h i k _
```

---

## Examples

### Example 1: Basic Caesar Cipher Encryption

```sqf
// Encrypt a message (Caesar cipher, key = 3)
private _plaintext = \"HELLO WORLD\";
private _encrypted = [_plaintext, \"encrypt\", 3, \"caesar\"] call AE3_armaos_fnc_encryption_crypto;
systemChat format [\"Encrypted: %1\", _encrypted]; // \"KHOOR ZRUOG\"

// Decrypt
private _decrypted = [_encrypted, \"decrypt\", 3, \"caesar\"] call AE3_armaos_fnc_encryption_crypto;
systemChat format [\"Decrypted: %1\", _decrypted]; // \"HELLO WORLD\"
```

---

### Example 2: Columnar Transposition Cipher

```sqf
private _message = \"SECRET MESSAGE\";
private _key = \"PASSWORD\";
private _encryptedColumnar = [_message, \"encrypt\", _key, \"columnar\"] call AE3_armaos_fnc_encryption_crypto;
systemChat format [\"Encrypted: %1\", _encryptedColumnar];

// Decrypt
private _decryptedColumnar = [_encryptedColumnar, \"decrypt\", _key, \"columnar\"] call AE3_armaos_fnc_encryption_crypto;
systemChat format [\"Decrypted: %1\", _decryptedColumnar];
```

---

### Example 3: Crack Caesar Cipher (Bruteforce)

```sqf
private _encryptedMsg = \"KHOOR ZRUOG\";
private _crackResults = [_encryptedMsg, \"bruteforce\", \"caesar\"] call AE3_armaos_fnc_encryption_crack;
{
    systemChat _x;
} forEach _crackResults; // Shows all 26 possible decryptions
```

---

### Example 4: Crack Caesar Cipher (Statistics)

```sqf
private _results = [\"ENCRYPTED TEXT\", \"statistics\", \"caesar\"] call AE3_armaos_fnc_encryption_crack;
{
    systemChat _x;
} forEach _results; // Outputs frequency analysis and possible keys
```

---

### Example 5: Find Columnar Key Lengths

```sqf
private _encryptedText = \"SOMEENCRYPTEDTEXT\";
private _keyLengths = [_encryptedText, \"key\", \"columnar\"] call AE3_armaos_fnc_encryption_crack;
{
    systemChat _x;
} forEach _keyLengths;
```

---

### Example 6: Mission Scenario - Intercept and Decrypt Message

```sqf
private _interceptedMessage = \"DWWDFN DW GDZQ\";
private _enemyKey = 3; // intelligence
private _decodedMessage = [_interceptedMessage, \"decrypt\", _enemyKey, \"caesar\"] call AE3_armaos_fnc_encryption_crypto;
hint format [\"Decoded Enemy Message:\\n%1\", _decodedMessage];
```

---

### Example 7: Automated Encryption System

```sqf
fnc_encryptMessages = {
    params [\"_messages\", \"_key\", \"_algorithm\"];
    private _encryptedMessages = [];
    {
        private _encrypted = [_x, \"encrypt\", _key, _algorithm] call AE3_armaos_fnc_encryption_crypto;
        _encryptedMessages pushBack _encrypted;
    } forEach _messages;
    _encryptedMessages
};

private _messagesToEncrypt = [\"MESSAGE ONE\", \"MESSAGE TWO\", \"MESSAGE THREE\"];
private _encryptedArray = [_messagesToEncrypt, 5, \"caesar\"] call fnc_encryptMessages;
{
    systemChat format [\"Encrypted: %1\", _x];
} forEach _encryptedArray;
```

---

### Example 8: Secure Message Box (UI Integration)

```sqf
fnc_createEncryptedMessageBox = {
    params [\"_title\", \"_defaultText\", \"_key\"];
    // Replace with your dialog or input method
    private _userInput = \"USER TYPED MESSAGE\"; // placeholder
    private _encrypted = [_userInput, \"encrypt\", _key, \"caesar\"] call AE3_armaos_fnc_encryption_crypto;
    _encrypted
};

private _encryptedUserMessage = [\"Enter Secret Message\", \"\", 7] call fnc_createEncryptedMessageBox;
systemChat format [\"User's encrypted message: %1\", _encryptedUserMessage];
```

---

### Example 9: Error Handling

```sqf
private _result = [\"TEST\", \"encrypt\", 0, \"caesar\"] call AE3_armaos_fnc_encryption_crypto;
if (_result isEqualTo \"\") then {
    systemChat \"Encryption failed! Check the logs for error details.\";
} else {
    systemChat format [\"Success: %1\", _result];
};
```

---

### Example 10: Integration with Computer Filesystem

> Requires a computer object and the AE3 filesystem functions. This example is commented out because it depends on mission-specific objects.

```sqf
/*
private _computer = objectFromNetId \"...\"; // your computer object
private _pointer = _computer getVariable \"AE3_filepointer\";
private _filesystem = _computer getVariable \"AE3_filesystem\";
private _username = \"root\";

// Read a file
private _fileContent = [_pointer, _filesystem, \"/secret.txt\", _username, 1] call AE3_filesystem_fnc_getFile;

// Encrypt the content
private _encryptedContent = [_fileContent, \"encrypt\", 13, \"caesar\"] call AE3_armaos_fnc_encryption_crypto;

// Write encrypted content to new file
[_pointer, _filesystem, \"/encrypted.txt\", _username, _encryptedContent, false] call AE3_filesystem_fnc_writeToFile;

// Later, decrypt it
private _encryptedFile = [_pointer, _filesystem, \"/encrypted.txt\", _username, 1] call AE3_filesystem_fnc_getFile;
private _decryptedContent = [_encryptedFile, \"decrypt\", 13, \"caesar\"] call AE3_armaos_fnc_encryption_crypto;
*/
```

---

## Notes and Best Practices

1. **Caesar Cipher**
   - Key must be a positive integer.
   - Only encrypts A-Z letters and spaces.
   - Case insensitive. Converts to uppercase.

2. **Columnar Transposition**
   - Key must be a string with length greater than 1.
   - Spaces may be replaced (implementation dependent).
   - For clean encryption, message length divisible by key length is ideal.

3. **Error Handling**
   - Functions return `\"\"` on error.
   - Errors are logged server-side. Validate returns.

4. **Performance**
   - Bruteforce cracking can be CPU intensive for long messages.
   - Run heavy operations in scheduled or background tasks.
   - Cache repeated results where applicable.

