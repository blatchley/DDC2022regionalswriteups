# Cookies
Target difficulty: easy

This was meant to be a classic basic CBC bit flipping attack.

The server gives you a cookie which is an encryption of a json object stating {"flag":false}.

The goal is to make the cookie be set to {"flag":true} and go to the flag webpage.

Note that padding is also applied, so the real value is b'{"flag":false}\x02\x02' and the real target is b'{"flag":true}\x03\x03\x03'.

AES CBC mode, (https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation), has the property that if you flip a bit in the IV, then the corresponding bits in the first block of the ciphertext get flipped, so the solution is to flip the correct bits in the iv such that flipping the same bits in the ciphertext sets it to the target.

This can either be done in browser, (just copy paste cookie into python temrinal, seperate the iv and the ciphertext, (both are 16 bytes long)

Set newiv = xor(iv,(xor(cookie, target)))), and append this to the ciphertext as your new cookie, then visit flag page.

Alternatively, you could use a requests based python script.

The debug page was added to try and increase transparency as to what the cookie currently was, to help people with weird issues.
