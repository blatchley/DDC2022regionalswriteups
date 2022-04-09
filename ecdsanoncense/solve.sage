from hashlib import sha256, md5
from random import randint
from pwn import *
import ast

remoteIP = "127.0.0.1"
remotePort = 13337



p = 0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
A = p - 3
B = 0x5AC635D8AA3A93E7B3EBBD55769886BC651D06B0CC53B0F63BCE3C3E27D2604B
# Nist P256 curve,  y^2 = x^3 + A*x +B over GF(P) 
EE = EllipticCurve(GF(p), [A,B])
G = EE(0x6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296,0x4FE342E2FE1A7F9B8EE7EB4A7C0F9E162BCE33576B315ECECBB6406837BF51F5)
# Curve order
qq = 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551
EE.set_order(qq)


give = b'Flag Please'

print(give.hex())

# md5 collisions
m1 = "d131dd02c5e6eec4693d9a0698aff95c2fcab58712467eab4004583eb8fb7f8955ad340609f4b30283e488832571415a085125e8f7cdc99fd91dbdf280373c5bd8823e3156348f5bae6dacd436c919c6dd53e2b487da03fd02396306d248cda0e99f33420f577ee8ce54b67080a80d1ec69821bcb6a8839396f9652b6ff72a70"
m2 = "d131dd02c5e6eec4693d9a0698aff95c2fcab50712467eab4004583eb8fb7f8955ad340609f4b30283e4888325f1415a085125e8f7cdc99fd91dbd7280373c5bd8823e3156348f5bae6dacd436c919c6dd53e23487da03fd02396306d248cda0e99f33420f577ee8ce54b67080280d1ec69821bcb6a8839396f965ab6ff72a70"
msg1= bytes.fromhex(m1)
msg2= bytes.fromhex(m2)
h1 = int(sha256(msg1).digest().hex(),16)
h2 = int(sha256(msg2).digest().hex(),16)

def signmessage(r,m):
    r.sendline(b"1")
    r.recvuntil(b'Message (hex):')
    r.sendline(m.encode())
    r.recvuntil(b'r: ')
    r1 = int(r.readline().strip(),16)
    r.recvuntil(b's: ')
    s1 = int(r.readline().strip(),16)
    return r1,s1

def sign(h, k, x):
    xn, _ = (k*G).xy()
    r = Integer(xn)
    s = Integer((h + r*x)*pow(k, -1, qq) % qq)
    return r, s

with remote(remoteIP, remotePort) as r:
    r.recvuntil(b'public verification point is ')
    # receive and decode public point
    publicpoint = r.readline().decode().strip()[1:][:-1].split(' : ')
    pk = EE(int(publicpoint[0]), int(publicpoint[1])) 
    print(f'public point is {pk}')

    r.recvuntil(b'3- Close\n')
    r1, s1 = signmessage(r, m1)
    r2, s2 = signmessage(r, m2)

    # recover k algebraicly
    # many writeups online, first one i found on google: https://billatnapier.medium.com/ecdsa-weakness-where-nonces-are-reused-2be63856a01a
    k = Integer((h1-h2)*pow((s1-s2), -1, qq) % qq)
    # with k recover sk
    sk = Integer((s1*k-h1)*pow(r1,-1, qq) % qq)

    give = b'Flag Please'

    h = int(sha256(give).digest().hex(),16)
    # just sign using the secret key
    r3,s3 = sign(h, k, sk)

    # Send this to server
    r.sendline(b"2")
    r.sendline(give.hex().encode())
    r.sendline(hex(r3).encode())
    r.sendline(hex(s3).encode())
    r.interactive()