# crypto
The `crypto` command is meant to be used in conjuction with the `crack` command. The `crypto` command allows you to encrypt and decrypt text by using various algorithms. See the list below for available algorithms. `crypto` is no real world linux command. It's meant to create gameplay options.
There is a very good [website](http://www.crypto-it.net/eng/simple/index.html) explaining simple encryption methods. Future algorithms will be taken from there.

| algorithm | status | key type | allowed text characters |
| --- | --- | --- | --- |
| caesar | implemented | integer | latin alphabet A-Z, only upper case, no numbers or symbols, no language specific characters like ö, é or ô |
| columnar | in development | string | characters found in the [UTF-8 decimal table](https://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec), between 33 and 126 (both included) |

## Command syntax

```
crypto -a=<ALGORITHM> -m=<MODE> -k=<KEY> <MESSAGE>
```

## Parameter details

| parameter | mandatory | option type | available options |
| --- | --- | --- | --- |
| `-a=<ALGORITHM>` | yes | select from available options | `caesar` and `columnar` |
| `-m=<MODE>` | yes | select from available options | `encrypt` and `decrypt` |
| `-k=<KEY>` | yes | custom string, see algorithms for details | --- |
| `<MESSAGE>` | yes | custom string | --- |

## Caesar algorithm
The caesar algorithm is very old and very simple. You shift every character by the key number to the right. For example: If the key is `3` and you want to encrypt a `B` you will get an `E` because this is the character 3 digits to the right in the latin alphabet.
Because you can only use upper case latin alphabet you need to somehow adjust your messages according to that. This algorithm is meant to be easy crackable. You can do that in mind because of it's low complexity or with the `crack` command. 
Keep in mind, all characters of the message to be encrypted will be changed to upper case latin alphabet or a blank space. Also keep in mind that there are only 26 passible keys because that's the length of the alphabet. You can use higher numbers but the result will match a lower number.

## Example
Here's an example. Message to encrypt: HELLO WORLD

```
admin@armaOS:/> crypto -a=caesar -m=encrypt -k=3 HELLO WORLD
KHOOR ZRUOG
admin@armaOS:/> crypto -a=caesar -m=decrypt -k=3 KHOOR ZRUOG
HELLO WORLD
```

## Columnar transposition algorithm
The columnar transposition algorithm is a cipher that involves rearranging the characters in a message (*transposition*), without altering the characters themselves. It transposes the text based on a key that defines the number of columns and their order. First, the plaintext is written row-wise into a grid with the keyword letter count as width. Because this implementation represents a complete columnar transposition, the last row will be completed with underscores (`'_'`), should the message not fit perfectly into all columns (i.e. `count(ciphertext) mod count(keyword) != 0`).  Next, the columns are reordered based on the alphabetic order of the keyword's letters. The alphabetic order is determined by the corresponding [UTF-8 decimal](https://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec) order; Allowed characters are between decimal `33 = '!'` and decimal `126 = '~'`. If the key contains the same character multiple times, they are ordered front to back, in the order they appear in the message. Finally, the ciphertext is read out column-wise. To decipher a message, the process is reversed.

## Example

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

# crack
The `crack` command is meant to be used in conjuction with the `crypto` command. The `crack` command currently implements two methods each that allow you to crack the `caesar` and `columnar` algorithm.  `crack` is no real world linux command. It's meant to create gameplay options.

## Command syntax

```
crack -a=<ALGORITHM> -m=<MODE> <MESSAGE>
```

## Parameter details

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

## Example bruteforce mode
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
