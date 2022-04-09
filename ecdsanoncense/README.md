# ECDSA noncense
Target difficulty: medium-hard

This challenge implements ECDSA signatures, over nist curve P256, using a broken determinstic nonce generation scheme.

you are allowed signatuers of anything except the message "Flag Please", and then have to forge a signature on that message.

Unfortunately there was an unintended, where during the testing process the check that you couldn't ask for flag please was removed/commented out :(
As we didn't want to risk rebuilding challenges during the ctf for stability reasons, we made the decision to change the flag in ctfd, and that solutions would have to be verified by a supporter to get the real flag. 
We are very sorry for the confusion caused here, and for people who found the unintended a smaller number of points were awarded for their lost time, if they didn't end up solving the challenge properly.


The intended solution is to use the fact that if a nonce is ever reused in ECDSA, then you can take the two signature schemes which share the nonce, and use them to leak the secret key, allowing you to sign anything.

The nonce is genreated using md5 hashes, which are well known for having collisions, so the intended solution is to send two different messages which collide the md5 hash function, causing two signatures with different messages but the same nonce to be produced.

From these you can then calculate the secret key, and sign anything you want.

There are many online resources about how the leaking k, and recovering secret key works, but they're essentially all just basic algebra at this point, modulo the curve. (Modularity++ :D ). See fx: https://billatnapier.medium.com/ecdsa-weakness-where-nonces-are-reused-2be63856a01a

The attached script implements this attack, with an md5 collision we found randomly on stack overflow.