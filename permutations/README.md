# Permutations
Target difficulty: very easy

In this challenge, we seed python random with a known value, then shuffle the flag several times using random.shuffle().

As we've seeded randomness, random.shuffle will make all the same "random" decisions while shuffling every time it shuffles. So by shuffling a list of numbers of the same length as the flag, this list will be permuted exactly how the flag was.

This tells us which index ended up where in the "encrypted" flag, so we can use this to map back to the original flag.

solution is in sol.py, just run it in the same folder as encrypted.enc