import random

with open("encrypted.enc", "r") as f:
    ct = f.read()

mapping = [x for x in range(len(ct))]
random.seed("Crypto Gang")
random.shuffle(mapping)
random.shuffle(mapping)
random.shuffle(mapping)

plain = [x for x in ct]
for i in range(len(ct)):
    plain[mapping[i]] = ct[i]

print("".join(plain))
