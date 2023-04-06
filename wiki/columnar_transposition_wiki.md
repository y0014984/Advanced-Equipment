## Columnar transposition algorithm
The columnar transposition algorithm is a cipher that involves rearranging the characters in a message (*transposition*), without altering the characters themselves. It transposes the text based on a key that defines the number of columns and their order. First, the plaintext is written row-wise into a grid with keyword letter count width. Because this implementation represents a complete columnar transposition, the last row will be completed with random characters, should the message not fit perfectly into all columns: `count(ciphertext) mod count(keyword) != 0`.  Next, the columns are reordered based on the alphabetic order of the keyword's letters. The alphabetic order is determined by the corresponding [UTF-8 decimal](https://www.utf8-chartable.de/unicode-utf8-table.pl?utf8=dec) order; Allowed characters are between decimal `33 = '!'` and decimal `126 = '~'`. If the key contains the same character multiple times, they are ordered, front to back, in the order they appear in the message. Finally, the ciphertext is read out column-wise. To decipher a message, the process is reversed.

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

Next, complete the last row with random characters:
| A | R | M | A |
|---|---|---|---|
| T | h | e | E |
| n | e | m | y |
| W | i | l | l |
| A | t | t | a |
| c | k | A | t |
| 0 | 6 | 0 | 0 |
| h | 4 | 2 | O |

Once the matrix is complete, the columns are reordered in alphabetical order, with the first `A` coming before the second:
| A | A | M | R |
|---|---|---|---|
| T | E | e | h |
| n | y | m | e |
| W | l | l | i |
| A | a | t | t |
| C | t | A | k |
| 0 | 0 | 0 | 6 |
| h | O | 2 | 4 |

The final step is writing down the decrypted message, column-wise:
`TnWAc0hEylat0OemltA02heitk64`

The same example via the console will look like this:
```
admin@armaOS:/> crypto -a=columnar -m=encrypt -k=ARMA TheEnemyWillAttackAt0600h
TnWAc0hEylat0OemltA02heitk64
admin@armaOS:/> crypto -a=columnar -m=decrypt -k=ARMA TnWAc0hEylat0OemltA02heitk64
TheEnemyWillAttackAt0600h42O
```
Keep in mind that when trying this exact combination yourself, the last 3 characters of the decrypted message will be random.