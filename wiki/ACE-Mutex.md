# AE3 Mutex System Guide

This guide explains the mutex (mutual exclusion) system used in AE3 to prevent concurrent access to computers and prevent race conditions in multiplayer environments.

## Table of Contents

1. [What is a Mutex?](#what-is-a-mutex)
2. [Why Mutexes are Needed](#why-mutexes-are-needed)
3. [Computer Mutex](#computer-mutex)
4. [Power Mutex](#power-mutex)
5. [Best Practices](#best-practices)
6. [Code Examples](#code-examples)
7. [Troubleshooting](#troubleshooting)

---

## What is a Mutex?

A **mutex** (mutual exclusion) is a synchronization mechanism that prevents multiple processes from accessing a shared resource simultaneously. In AE3, mutexes prevent:

- Multiple players from operating the same computer at once
- Race conditions in power operations
- Concurrent terminal access that could corrupt state
- Simultaneous device control operations

Think of a mutex like a lock on a door - only one person can hold the lock at a time. When someone wants to use the resource, they must:

1. Check if the mutex is free
2. Acquire the mutex (lock it)
3. Perform their operation
4. Release the mutex (unlock it)

---

## Why Mutexes are Needed

### The Problem: Race Conditions

Without mutexes, this could happen:

```
Time    Player 1                    Player 2
----    --------                    --------
T0      Turn on computer
T1                                  Turn on computer
T2      Set state = "booting"
T3                                  Set state = "booting"
T4      Init terminal
T5                                  Init terminal
T6      State corrupted!            State corrupted!
```

Both players try to turn on the same computer, leading to:
- Duplicate terminal initialization
- Corrupted computer state
- Multiple conflicting operations
- Network synchronization issues

### The Solution: Mutex Lock

With a mutex:

```
Time    Player 1                    Player 2
----    --------                    --------
T0      Check mutex (free)
T1      Acquire mutex               Check mutex (locked) -> WAIT
T2      Turn on computer
T3      Init terminal
T4      Release mutex
T5                                  Check mutex (free)
T6                                  Acquire mutex
T7                                  (Computer already on) -> Skip
T8                                  Release mutex
```

Player 2 waits for Player 1 to finish before checking the computer state.

---

## Computer Mutex

### Variable: `AE3_computer_mutex`

The computer mutex prevents concurrent terminal access and power operations.

**Stored on:** Computer object
**Type:** BOOL
**Network Synced:** Yes (public variable, synced to all clients)

### When is it Set?

The computer mutex is set during:

1. **Computer Turn On**
   ```sqf
   [_computer] call AE3_armaos_fnc_computer_turnOn
   ```

2. **Computer Turn Off**
   ```sqf
   [_computer] call AE3_armaos_fnc_computer_turnOff
   ```

3. **Computer Standby**
   ```sqf
   [_computer] call AE3_armaos_fnc_computer_standby
   ```

### When is it Cleared?

The mutex is automatically cleared after the operation completes.

### How to Check the Mutex

Before performing any computer operation:

```sqf
private _mutex = _computer getVariable ["AE3_computer_mutex", false];

if (!_mutex) then {
    // Mutex is free - safe to proceed
} else {
    // Mutex is locked - operation in progress
    hint "Computer is busy";
};
```

### How Operations Use the Mutex

```sqf
// Example: Turn on device wrapper
if (!(_computer getVariable ["AE3_computer_mutex", false])) then {
    // Acquire mutex
    _computer setVariable ["AE3_computer_mutex", true, true];

    // Perform operation
    [_computer] call AE3_armaos_fnc_computer_turnOn;

    // Release mutex
    _computer setVariable ["AE3_computer_mutex", false, true];
};
```

---

## Power Mutex

### Variable: `AE3_power_mutex`

The power mutex prevents concurrent power operations on devices.

**Stored on:** Device object (laptop, generator, battery, etc.)
**Type:** BOOL
**Network Synced:** Yes (public variable)

### When is it Set?

The power mutex is set during:

1. **Turn On Device**
   ```sqf
   [_device] call AE3_power_fnc_turnOnDevice
   ```

2. **Turn Off Device**
   ```sqf
   [_device] call AE3_power_fnc_turnOffDevice
   ```

3. **Standby Device**
   ```sqf
   [_device] call AE3_power_fnc_standbyDevice
   ```

### Turn On Condition Check

The `turnOnDevice` function checks multiple conditions including the mutex:

```sqf
private _turnOnCondition = (
    (_device call (_device getVariable ["AE3_power_fnc_turnOnCondition", {true}])) and
    (alive _device) and
    (_device getVariable ["AE3_power_powerState", -1] != 1) and
    !(_device getVariable ["AE3_power_mutex", false]) and  // <-- Mutex check
    (_device getVariable ["AE3_interaction_closeState", 0] == 0)
);
```

If any condition fails, the operation is prevented.

### How Power Operations Use the Mutex

```sqf
// From AE3_power_fnc_turnOnDevice
if (_turnOnCondition && ((_device getVariable ["AE3_power_fnc_turnOn", {}]) isNotEqualTo {})) then {
    // Acquire mutex
    _device setVariable ["AE3_power_mutex", true, true];

    // Call device-specific turn on function
    [_device] call (_device getVariable "AE3_power_fnc_turnOnWrapper");

    // Release mutex
    _device setVariable ["AE3_power_mutex", false, true];

    _result = true;
};
```

---

## Best Practices

### 1. Always Check Before Acquiring

```sqf
// GOOD - Check before acquiring
if (!(_computer getVariable ["AE3_computer_mutex", false])) then {
    _computer setVariable ["AE3_computer_mutex", true, true];
    // ... operation
    _computer setVariable ["AE3_computer_mutex", false, true];
};

// BAD - Acquire without checking
_computer setVariable ["AE3_computer_mutex", true, true];
// ... operation (might conflict with another operation)
_computer setVariable ["AE3_computer_mutex", false, true];
```

### 2. Always Release the Mutex

```sqf
// GOOD - Guaranteed release with params and proper flow
if (!(_device getVariable ["AE3_power_mutex", false])) then {
    _device setVariable ["AE3_power_mutex", true, true];

    [_device] call AE3_power_fnc_turnOnDevice;

    _device setVariable ["AE3_power_mutex", false, true];
};

// BAD - Early exit without release
_device setVariable ["AE3_power_mutex", true, true];
if (!alive _device) exitWith {};  // Mutex never released!
[_device] call AE3_power_fnc_turnOnDevice;
_device setVariable ["AE3_power_mutex", false, true];
```

### 3. Use Public Variables for Network Sync

Always use the third parameter `true` to sync the mutex across the network:

```sqf
// GOOD - Synced to all clients
_computer setVariable ["AE3_computer_mutex", true, true];

// BAD - Local only, other clients won't see it
_computer setVariable ["AE3_computer_mutex", true];
```

### 4. Keep Critical Sections Short

```sqf
// GOOD - Short critical section
if (!(_computer getVariable ["AE3_computer_mutex", false])) then {
    _computer setVariable ["AE3_computer_mutex", true, true];

    // Quick operation
    private _state = _computer getVariable "AE3_power_powerState";
    _state = _state + 1;
    _computer setVariable ["AE3_power_powerState", _state];

    _computer setVariable ["AE3_computer_mutex", false, true];
};

// BAD - Long critical section blocks others
if (!(_computer getVariable ["AE3_computer_mutex", false])) then {
    _computer setVariable ["AE3_computer_mutex", true, true];

    sleep 10;  // Locks mutex for 10 seconds!
    // Long operation

    _computer setVariable ["AE3_computer_mutex", false, true];
};
```

### 5. Don't Nest Mutex Locks

```sqf
// BAD - Nested mutexes can cause deadlock
if (!(_computer getVariable ["AE3_computer_mutex", false])) then {
    _computer setVariable ["AE3_computer_mutex", true, true];

    if (!(_device getVariable ["AE3_power_mutex", false])) then {
        _device setVariable ["AE3_power_mutex", true, true];
        // ... operation
        _device setVariable ["AE3_power_mutex", false, true];
    };

    _computer setVariable ["AE3_computer_mutex", false, true];
};

// GOOD - Separate mutex operations
if (!(_computer getVariable ["AE3_computer_mutex", false])) then {
    _computer setVariable ["AE3_computer_mutex", true, true];
    // ... computer operation
    _computer setVariable ["AE3_computer_mutex", false, true];
};

if (!(_device getVariable ["AE3_power_mutex", false])) then {
    _device setVariable ["AE3_power_mutex", true, true];
    // ... power operation
    _device setVariable ["AE3_power_mutex", false, true];
};
```

---

## Code Examples

### Example 1: Safe Computer Turn On

```sqf
// Check if computer can be turned on
private _canTurnOn = (
    (alive _computer) and
    !(_computer getVariable ["AE3_computer_mutex", false]) and
    (_computer getVariable ["AE3_power_powerState", -1] != 1)
);

if (_canTurnOn) then {
    // Acquire mutex
    _computer setVariable ["AE3_computer_mutex", true, true];

    // Turn on computer
    [_computer] call AE3_armaos_fnc_computer_turnOn;

    // Release mutex
    _computer setVariable ["AE3_computer_mutex", false, true];

    hint "Computer turned on";
} else {
    hint "Computer is busy or already on";
};
```

### Example 2: Safe Power Device Control

```sqf
// Check power mutex before operation
if (!(_generator getVariable ["AE3_power_mutex", false])) then {
    // Acquire mutex
    _generator setVariable ["AE3_power_mutex", true, true];

    // Perform power operation
    private _success = [_generator] call AE3_power_fnc_turnOnDevice;

    // Release mutex
    _generator setVariable ["AE3_power_mutex", false, true];

    if (_success) then {
        hint "Generator started";
    } else {
        hint "Failed to start generator";
    };
} else {
    hint "Generator is busy";
};
```

### Example 3: Custom Operation with Mutex

```sqf
// Custom function that modifies computer state
AE3_custom_fnc_modifyComputer = {
    params ["_computer", "_newValue"];

    // Check mutex
    if (_computer getVariable ["AE3_computer_mutex", false]) exitWith {
        hint "Computer is busy";
        false
    };

    // Acquire mutex
    _computer setVariable ["AE3_computer_mutex", true, true];

    // Perform operation
    private _result = false;
    try {
        _computer setVariable ["customData", _newValue, true];
        _result = true;
    } catch {
        hint format ["Error: %1", _exception];
    };

    // Release mutex (always, even if error occurred)
    _computer setVariable ["AE3_computer_mutex", false, true];

    _result
};
```

### Example 4: Waiting for Mutex

```sqf
// Wait for mutex to become available (use with caution!)
waitUntil {
    sleep 0.1;
    !(_computer getVariable ["AE3_computer_mutex", false])
};

// Now safe to acquire
_computer setVariable ["AE3_computer_mutex", true, true];

// ... operation

_computer setVariable ["AE3_computer_mutex", false, true];
```

**Warning:** Waiting for mutex can cause indefinite blocking if the mutex is never released (e.g., due to a bug). Use timeouts:

```sqf
// Wait with timeout
private _timeout = time + 30;  // 30 second timeout
private _acquired = false;

while {time < _timeout} do {
    if (!(_computer getVariable ["AE3_computer_mutex", false])) exitWith {
        _computer setVariable ["AE3_computer_mutex", true, true];
        _acquired = true;
    };
    sleep 0.1;
};

if (_acquired) then {
    // ... operation
    _computer setVariable ["AE3_computer_mutex", false, true];
} else {
    hint "Timeout waiting for computer";
};
```

---

## Troubleshooting

### Problem: Computer is Always Busy

**Symptoms:**
- Cannot turn on/off computer
- "Computer is busy" message appears
- Mutex never cleared

**Causes:**
1. Previous operation crashed without releasing mutex
2. Script error during operation
3. Server/client desync

**Solutions:**

```sqf
// Manual mutex reset (for debugging only!)
_computer setVariable ["AE3_computer_mutex", false, true];

// Check current mutex state
private _mutex = _computer getVariable ["AE3_computer_mutex", false];
hint format ["Mutex state: %1", _mutex];

// Check power state
private _powerState = _computer getVariable ["AE3_power_powerState", -1];
hint format ["Power state: %1", _powerState];  // -1: Off, 0: Standby, 1: On
```

### Problem: Multiple Players Can Access Computer

**Symptoms:**
- Two players can operate same computer
- Duplicate terminal instances
- Corrupted state

**Causes:**
1. Mutex not set/checked properly
2. Network sync disabled
3. Custom code bypassing mutex

**Solutions:**

```sqf
// Verify network sync is enabled
_computer setVariable ["AE3_computer_mutex", true, true];  // Third param MUST be true

// Check if mutex is being respected
if (!(_computer getVariable ["AE3_computer_mutex", false])) then {
    hint "Mutex check working";
} else {
    hint "Mutex is locked";
};
```

### Problem: Deadlock

**Symptoms:**
- Computer permanently locked
- Operation never completes
- Mutex never released

**Causes:**
1. Script error during critical section
2. Nested mutex locks
3. Exception thrown without cleanup

**Solutions:**

Use try-catch to ensure mutex is always released:

```sqf
if (!(_computer getVariable ["AE3_computer_mutex", false])) then {
    _computer setVariable ["AE3_computer_mutex", true, true];

    try {
        // Critical section
        [_computer] call AE3_armaos_fnc_computer_turnOn;
    } catch {
        hint format ["Error: %1", _exception];
    };

    // Always release, even if error occurred
    _computer setVariable ["AE3_computer_mutex", false, true];
};
```

### Debug: Monitor Mutex State

```sqf
// Add this to debug output or hint
private _computerMutex = _computer getVariable ["AE3_computer_mutex", false];
private _powerMutex = _computer getVariable ["AE3_power_mutex", false];
private _powerState = _computer getVariable ["AE3_power_powerState", -1];

hint format [
    "Computer Mutex: %1\nPower Mutex: %2\nPower State: %3",
    _computerMutex,
    _powerMutex,
    _powerState
];
```

---

## Summary

**Key Takeaways:**

1. **Always Check** - Check mutex before acquiring
2. **Always Sync** - Use public variables (`setVariable [name, value, true]`)
3. **Always Release** - Ensure mutex is released after operation
4. **Keep it Short** - Minimize time mutex is held
5. **Use Try-Catch** - Protect against errors preventing release
6. **Don't Nest** - Avoid nested mutex locks (deadlock risk)
7. **Add Timeouts** - When waiting for mutex, use timeouts

**Mutex Variables:**

| Variable | Purpose | Object Type |
|----------|---------|-------------|
| `AE3_computer_mutex` | Prevents concurrent terminal access | Computer |
| `AE3_power_mutex` | Prevents concurrent power operations | Any power device |

**Network Sync:**

```sqf
// Correct way to set mutex (synced)
_computer setVariable ["AE3_computer_mutex", true, true];
                                                      ^
                                                      |
                                    Third parameter = public variable
```

---

For more information, see:
- [API Reference](API-Reference.md) - Function documentation
- [Architecture Guide](Architecture.md) - System architecture
- [Terminal Guide](Terminal-Guide.md) - Terminal usage
