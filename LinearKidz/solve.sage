import json
import tqdm

F = GF(2)

with open('hashes.json', 'r') as f:
    basis = json.load(f)

with open("inputs.json", "r") as f:
    inps = json.load(f)

inpsarr = []
basisarr = []
# construct basis vectors with full rank
for i in tqdm.tqdm(range(len(basis))):

    M = Matrix(basisarr + [basis[i]], ring=F)
    IM = Matrix(inpsarr + [inps[i]], ring=F)

    if M.rank() == 256 and IM.rank() == 256:
        break
    if M.rank() == len(basisarr) + 1 and IM.rank() == len(inpsarr) + 1:
        basisarr.append(basis[i])
        inpsarr.append(inps[i])


print(f'M rows: {M.nrows()}')
print(f'M cols: {M.ncols()}')
print(f'IM rows: {IM.nrows()}')
print(f'IM cols: {IM.ncols()}')
print(M.rank())
assert M.rank() == 256
print(IM.rank())
assert IM.rank() == 256

# Solve for L matrix encoding hash
L = IM.solve_right(M)

print(L.ncols())
print(L.nrows())

print(L[0])

def bits(hsh):
    print(len(hsh))
    assert len(hsh) == 32
    return [int(c) for c in '{:0256b}'.format(int(hsh.hex(), 16))]

target = bytes([0 for i in range(32)])

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

target = bytes([target[i] ^^ MAGIC[i] for i in range(32)])
targetbits = bits(target)
T = Matrix(targetbits, ring=F)
print(f'Trows = {T.nrows()}')
print(f'Tcols = {T.ncols()}')

# Solve for input which gives target
sol = L.solve_left(T)
print("res = ")
print(sol * L)
print(hex(int("".join([str(x) for x in (sol*L)[0]]), 2)))

print("sol = ")
print(sol)
print(hex(int("".join([str(x) for x in (sol)[0]]), 2)).zfill(64))

print("full sol")
print(( b'cat flag.txt\n' +  b'A' * (256 - 32 - len(b'cat flag.txt\n'))).hex() + hex(int("".join([str(x) for x in (sol)[0]]), 2))[2:].zfill(64))
# a = [str(x) for x in sol[0]]
# b = hex(int("".join(a), 2))
# print(b)
