
import os
from pwn import *

MAGIC = [
    0x42,0x65,0x74,0x74,
    0x65,0x72,0x20,0x53,
    0x65,0x63,0x75,0x72,
    0x65,0x20,0x48,0x61,
    0x73,0x68,0x20,0x41,
    0x6c,0x67,0x6f,0x72,
    0x69,0x74,0x68,0x6d,
    0x20,0x33,0x30,0x30
]

def hash(val):
    assert len(val) == 256
    p = process(['./kidz'])
    p.sendline(val.hex())
    p.recvuntil('LOL, git gut m8: ')
    hsh = bytearray.fromhex(p.recvall(0.01).decode('utf-8'))
    print(len(hsh))
    assert len(hsh) == 32
    # return hsh
    return bytes([hsh[i] ^ MAGIC[i] for i in range(32)])

def bits(hsh):
    print(len(hsh))
    l = len(hsh)
    # assert len(hsh) == 32
    return [int(c) for c in '{:0256b}'.format(int(hsh.hex(), 16)).zfill(l * 8)]


tt = 32
pre = b'cat flag.txt\n' +  b'A' * (256 - tt - len(b'cat flag.txt\n'))
basis = []
inpvals = []
for v in range(300):
    inp = os.urandom(tt)
    # inp = os.urandom(256)
    s = pre + inp
    # s = inp
    inpvals.append(bits(inp))
    basis.append(bits(hash(s)))

import json

with open('hashes.json', 'w') as f:
    json.dump(basis, f)
with open('inputs.json', 'w') as f:
    json.dump(inpvals, f)