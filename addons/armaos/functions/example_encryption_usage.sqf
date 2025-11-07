/**
 * EXAMPLE SCRIPT: Programmatic Encryption/Decryption Usage
 *
 * This example demonstrates how to use the encryption functions programmatically
 * without requiring terminal interaction. Perfect for scripted scenarios, mission
 * events, or automated encryption/decryption workflows.
 *
 * NOTE: This is an example file and is NOT compiled or included in the mod.
 * Copy the code snippets below into your own scripts.
 */

// =============================================================================
// EXAMPLE 1: Basic Caesar Cipher Encryption
// =============================================================================

// Encrypt a message with Caesar cipher using key 3
private _plaintext = "HELLO WORLD";
private _encrypted = [_plaintext, "encrypt", 3, "caesar"] call AE3_armaos_fnc_encryption_crypto;
systemChat format ["Encrypted: %1", _encrypted]; // Output: "KHOOR ZRUOG"

// Decrypt the message
private _decrypted = [_encrypted, "decrypt", 3, "caesar"] call AE3_armaos_fnc_encryption_crypto;
systemChat format ["Decrypted: %1", _decrypted]; // Output: "HELLO WORLD"


// =============================================================================
// EXAMPLE 2: Columnar Transposition Cipher
// =============================================================================

// Encrypt with columnar cipher using a string key
private _message = "SECRET MESSAGE";
private _key = "PASSWORD";
private _encryptedColumnar = [_message, "encrypt", _key, "columnar"] call AE3_armaos_fnc_encryption_crypto;
systemChat format ["Encrypted: %1", _encryptedColumnar];

// Decrypt
private _decryptedColumnar = [_encryptedColumnar, "decrypt", _key, "columnar"] call AE3_armaos_fnc_encryption_crypto;
systemChat format ["Decrypted: %1", _decryptedColumnar];


// =============================================================================
// EXAMPLE 3: Crack Caesar Cipher (Bruteforce)
// =============================================================================

// Try all possible keys for Caesar cipher
private _encryptedMsg = "KHOOR ZRUOG";
private _crackResults = [_encryptedMsg, "bruteforce", "caesar"] call AE3_armaos_fnc_encryption_crack;

// Display all results
{
	systemChat _x;
} forEach _crackResults;
// Output will show all 26 possible decryptions


// =============================================================================
// EXAMPLE 4: Crack Caesar Cipher (Statistics)
// =============================================================================

// Use frequency analysis to find likely key
private _results = ["ENCRYPTED TEXT", "statistics", "caesar"] call AE3_armaos_fnc_encryption_crack;

{
	systemChat _x;
} forEach _results;
// Output shows character frequency and possible keys


// =============================================================================
// EXAMPLE 5: Find Columnar Key Lengths
// =============================================================================

// Find possible key lengths for columnar transposition
private _encryptedText = "SOMEENCRYPTEDTEXT";
private _keyLengths = [_encryptedText, "key", "columnar"] call AE3_armaos_fnc_encryption_crack;

{
	systemChat _x;
} forEach _keyLengths;


// =============================================================================
// EXAMPLE 6: Mission Scenario - Intercept and Decrypt Message
// =============================================================================

// Player intercepts encrypted enemy communication
private _interceptedMessage = "DWWDFN DW GDZQ";
private _enemyKey = 3; // Intelligence gathered this key

// Decrypt the message
private _decodedMessage = [_interceptedMessage, "decrypt", _enemyKey, "caesar"] call AE3_armaos_fnc_encryption_crypto;

// Show to player
hint format ["Decoded Enemy Message:\n%1", _decodedMessage];


// =============================================================================
// EXAMPLE 7: Automated Encryption System
// =============================================================================

// Function to encrypt all messages in an array
fnc_encryptMessages = {
	params ["_messages", "_key", "_algorithm"];

	private _encryptedMessages = [];

	{
		private _encrypted = [_x, "encrypt", _key, _algorithm] call AE3_armaos_fnc_encryption_crypto;
		_encryptedMessages pushBack _encrypted;
	} forEach _messages;

	_encryptedMessages
};

// Use the function
private _messagesToEncrypt = ["MESSAGE ONE", "MESSAGE TWO", "MESSAGE THREE"];
private _encryptedArray = [_messagesToEncrypt, 5, "caesar"] call fnc_encryptMessages;

{
	systemChat format ["Encrypted: %1", _x];
} forEach _encryptedArray;


// =============================================================================
// EXAMPLE 8: Secure Message Box (UI Integration)
// =============================================================================

// Create a custom dialog that automatically encrypts user input
fnc_createEncryptedMessageBox = {
	params ["_title", "_defaultText", "_key"];

	// Show input dialog (you would create your own dialog here)
	private _userInput = "USER TYPED MESSAGE"; // Placeholder

	// Automatically encrypt the message
	private _encrypted = [_userInput, "encrypt", _key, "caesar"] call AE3_armaos_fnc_encryption_crypto;

	// Return encrypted message
	_encrypted
};

// Usage
private _encryptedUserMessage = ["Enter Secret Message", "", 7] call fnc_createEncryptedMessageBox;
systemChat format ["User's encrypted message: %1", _encryptedUserMessage];


// =============================================================================
// EXAMPLE 9: Error Handling
// =============================================================================

// Always check if encryption/decryption was successful
private _result = ["TEST", "encrypt", 0, "caesar"] call AE3_armaos_fnc_encryption_crypto;

if (_result isEqualTo "") then {
	systemChat "Encryption failed! Check the logs for error details.";
} else {
	systemChat format ["Success: %1", _result];
};


// =============================================================================
// EXAMPLE 10: Integration with Computer Filesystem
// =============================================================================

/*
// This example shows how to encrypt/decrypt files on a computer
// (Assumes you have a computer object and filesystem access)

private _computer = objectFromNetId "..."; // Your computer object
private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";
private _username = "root";

// Read a file
private _fileContent = [_pointer, _filesystem, "/secret.txt", _username, 1] call AE3_filesystem_fnc_getFile;

// Encrypt the content
private _encryptedContent = [_fileContent, "encrypt", 13, "caesar"] call AE3_armaos_fnc_encryption_crypto;

// Write encrypted content to new file
[_pointer, _filesystem, "/encrypted.txt", _username, _encryptedContent, false] call AE3_filesystem_fnc_writeToFile;

// Later, decrypt it
private _encryptedFile = [_pointer, _filesystem, "/encrypted.txt", _username, 1] call AE3_filesystem_fnc_getFile;
private _decryptedContent = [_encryptedFile, "decrypt", 13, "caesar"] call AE3_armaos_fnc_encryption_crypto;
*/


// =============================================================================
// NOTES AND BEST PRACTICES
// =============================================================================

/*
1. Caesar Cipher:
   - Key must be a positive integer
   - Only encrypts A-Z letters and spaces
   - Case insensitive (converts to uppercase)

2. Columnar Transposition:
   - Key must be a string with length > 1
   - Spaces are replaced with underscores
   - Message length should be divisible by key length for clean encryption

3. Error Handling:
   - Both functions return empty string ("") on error
   - Error messages are logged via BIS_fnc_error
   - Always validate return values before using them

4. Performance:
   - Bruteforce cracking can be CPU intensive for long messages
   - Consider running heavy operations in scheduled environment
   - Cache results when encrypting/decrypting same content multiple times

5. Security:
   - These are educational ciphers, NOT cryptographically secure
   - Do not use for real-world security applications
   - Keys are easily crackable with the provided tools
*/
