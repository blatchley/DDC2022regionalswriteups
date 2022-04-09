# Linear Kidz
Target difficulty: Hard -> Very hard

Linear kidz consists of a hash function implemented in C, where you give exactly 256 bytes as input, and it then keeps xor'ing these into a matrix of bytes, and between each new part of the input being added, performs a LOT of rotates and xor's on the state.

Any values sent to the server get hashed, and if the hash output is all 00 bytes, then the input gets run as a cli command on the server. The goal of the challenge is to find an input starting with a command like b'cat flag.txt\n@@@@@@' followed by lots of random bytes, which also hashes to 00. In that case the command will get executed, printing the flag.

The key trick here is that rotations and xor's between bytes are, (like the name suggests,) LINEAR operations (in GF(2)). This means they can be represented by matrix operations over GF(2).

Playing around with the code will also demonstrate that the linear transformation is full rank, meaning any input should be able to be mapped to any output.

This means we can make the first 256-32 bytes fixed to something starting with what we want, then randomly generate suffixes, calculating their hash, until we have enough suffixes to make a full rank 256x256 matrix of bits).

This matrix being full rank means we can then solve the linear algebra equation over GF(2)

Suffixes * C = outputs, where suffixes is the 256x256 suffix matrix, and outputs are the 256x256 hashed values. Then C is the linear matrix mapping sufixes to hashes. Once we know C, we have defined the hashing operaiton as a matrix, we can solve to get C, invert C, and then apply the inverted C to the zero vector on the right hand side to find a suffix that the matrix would have mapped to C.

Appending this suffix then gives as an input starting with our fixed prefx (which gets the flag,) and ending in a generated suffix which gives all 0's when hashed.


The solve script for this is in two parts. A python script which generates a lot of suffix/output pairs, and a sage script which uses these to construct the full rank matrices, and calculate and invert c to find the correct suffix and form the payload.

note that generate.py requires a compiled binary of the kidz binary, which it uses to quickly make samples, and that it's output gets saved to two files, which are then used by solve.sage. You could equivalently get these values from the server without needing to run kidz locally.

The value from the sage script can then be sent to the server to get the flag. (or just fed to the locally compiled kidz file :)).





