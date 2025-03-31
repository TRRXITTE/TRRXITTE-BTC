import os
import time
import binascii
import hashlib

def create_genesis_block():
    timestamp = "TRRXITTE BTC - 31/Mar/2025"
    pszTimestamp = timestamp.encode('utf-8')
    pubkey = binascii.unhexlify("04678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5f")
    bits = 0x1e0ffff0  # Initial difficulty
    nNonce = 0

    genesis = "01000000"  # Version
    genesis += "0000000000000000000000000000000000000000000000000000000000000000"  # Prev block hash
    genesis += binascii.hexlify(hashlib.sha256(hashlib.sha256(pubkey + pszTimestamp).digest()).digest()).decode('utf-8')  # Merkle root
    genesis += binascii.hexlify(int(1746057600).to_bytes(4, 'little')).decode('utf-8')  # Timestamp: March 31, 2025
    genesis += binascii.hexlify(bits.to_bytes(4, 'little')).decode('utf-8')  # Bits
    genesis += "00000000"  # Nonce (updated below)

    while True:
        genesis_hash = hashlib.sha256(hashlib.sha256(binascii.unhexlify(genesis)).digest()).digest()
        if genesis_hash[::-1].hex() < "00000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff":
            print(f"Genesis Hash: {genesis_hash[::-1].hex()}")
            print(f"Nonce: {nNonce}")
            print(f"Merkle Root: {binascii.hexlify(hashlib.sha256(hashlib.sha256(pubkey + pszTimestamp).digest()).digest()).decode('utf-8')}")
            break
        nNonce += 1
        genesis = genesis[:-8] + binascii.hexlify(nNonce.to_bytes(4, 'little')).decode('utf-8')

create_genesis_block()
