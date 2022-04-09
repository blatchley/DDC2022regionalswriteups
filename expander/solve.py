import itertools
from Crypto.Cipher import AES
from tqdm import tqdm
from Crypto.Util.number import long_to_bytes

P = [AES.new(bytes([i]*16), mode=AES.MODE_ECB) for i in range(4)]

def getsequence(start,finish):
    print(start)
    print(finish)

    forward = {}
    backwards = {}
    for arg in tqdm(itertools.product("0123", repeat=11), total=4**11):
        a = start
        b = finish
        for x in arg:
            a = P[int(x)].encrypt(a)
            b = P[int(x)].decrypt(b)
        forward[a.hex()] = "".join(arg)    
        backwards[b.hex()] = "".join(arg)    

    fwset = set(forward)
    bwset = set(backwards)

    for name in fwset.intersection(bwset):
        print(name)
        print(forward[name])
        return forward[name] + backwards[name][::-1]


with open("walk.txt", "r") as f:
    walk = f.readlines()
    walk = [bytes.fromhex(x.strip()) for x in walk]
print(walk)


values = []
for i in range(len(walk)-1):
    start = walk[i]
    finish = walk[i+1]
    values += getsequence(start,finish)
    print(values)
print(values)


values = values[::-1]

mapping = {}
mapping["0"] = "00"
mapping["1"] = "01"
mapping["2"] = "10"
mapping["3"] = "11"

values = [mapping[x] for x in values]

res = int("".join(values), 2)
print(res)

print(long_to_bytes(res))