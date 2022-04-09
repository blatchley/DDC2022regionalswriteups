# Expander

Target difficulty: Medium

This is a challenge about brute forcing, and space-time tradeoff attacks like mitm (meet in the middle.)

The flag is repeatedly encrypted with AES, each time using one of 4 aes keys. The selection of these keys is determined by the flag.
Every 22 encryptions, we print the current cipher text.

The challenge can then be seen as having to calculate which 22 keys were used to get us from each printed ciphertext to the next. 

4^22 = 2^44 possible sequences of keys, which is way too many to reasonably brute directly. However we can peform what's called a meet-in-the-middle attack.

Here we take the starting text, and encrypt it 11 times, using every possbile combination of keys. (4^11 = 2^22), and store these encryptions in an array.

We then take the target text and decrypt it 11 times with every possible combination of keys, (4^11 = 2^22) and store these in an array.

We then search both arrays for any common shared value, and we know that was the midpoint where the encryptions to get there (and the decryptions to get there) from the two sides were the correct keys, hence, "meeting in the middle".

this reduces the brute at each step from 2^44, to 2 * 2^22, with 2 * 2^22 storage.

Then we deduces the key indexes, keep these in a list, and once we have all of them, we recmobined into the binary flag, and print it.

We had to lower the parameters a few times for this to be reasonable during the ctf, but at these params, the solve script runs in ~1h on my (badish) laptop, or in a few minutes if i run using pypy3.
