# Raymond's Algorithm in Ada

## Project Overview
This repository provides a strict, type-safe Ada implementation of **Raymond's Algorithm**, a robust algorithm used to achieve distributed mutual exclusion in a computer network. The nodes operate in an unrooted tree topology pointing toward the current token holder. A node can only enter its Critical Section (CS) when it holds the token.

## Features
- **Strict Data Typing**: Strong domain boundaries preventing ID spoofing or Message malformation.
- **Variant 1: Standard Protocol**: Pure FIFO queueing and propagation exactly as defined in Raymond's standard algorithmic paper.
- **Variant 2: Greedy Network Protocol**: An optimized algorithmic variant (`Greedy_Receive_Request`) that suppresses duplicate node requests to minimize token-network saturation. 
- **Deterministic Modeling**: Isolated state transitions allow for 100% reproducible testing.

## Testing
This project follows strict **Verification and Validation (V&V)** paradigms suitable for safety-critical systems. 
*Philosophy:* We approach the test suite under the assumption that the code is functionally broken. Tests **PASS** only when the code definitively disproves our pessimistic assumptions.

**Categories Verified:**
1. **Functional Initialization**: Verifies the baseline state vector. *(Proves memory is not corrupted or unsafely defaulting).*
2. **Data Structure Bounds**: Tests Queue Enqueue/Dequeue operations and boundary conditions (Overflow/Underflow). *(Proves catastrophic queue degradation cannot occur).*
3. **Control Flow (Root)**: Assesses token-holder responses to local CS requests. *(Proves the system avoids generating spam messaging when no routing is required).*
4. **Network Flow (Leaf/Routing)**: Validates correct routing behavior and 'Asked' state toggles. *(Proves nodes accurately route Requests without flooding the network).*
5. **Algorithmic Variants**: Verifies that the Greedy Protocol successfully suppresses duplicate payload generation. *(Proves the variant reduces network load efficiently).*

## Usage

### Compilation
The codebase uses a standard Makefile orchestrating GNAT tools. To build the executables:
```bash
make all
