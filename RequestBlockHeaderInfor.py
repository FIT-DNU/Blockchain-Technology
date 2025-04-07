import requests
import hashlib
import struct

# Lấy block cụ thể theo hash (ví dụ: khối 700000)
block_height = 700000
url = f"https://blockchain.info/block-height/{block_height}?format=json"

# Gọi API
response = requests.get(url)
block = response.json()['blocks'][0]

# Lấy các trường của block header
version = block['ver']
previous_block_hash = bytes.fromhex(block['prev_block'])[::-1]  # đảo byte
merkle_root = bytes.fromhex(block['mrkl_root'])[::-1]
timestamp = block['time']
bits = int(block['bits'], 16)
nonce = block['nonce']

# Gộp thành block header (80 bytes)
header = (
    struct.pack("<L", version) +
    previous_block_hash +
    merkle_root +
    struct.pack("<L", timestamp) +
    struct.pack("<L", bits) +
    struct.pack("<L", nonce)
)

# Tính hash khối (SHA-256 hai lần)
block_hash = hashlib.sha256(hashlib.sha256(header).digest()).digest()[::-1].hex()

# Hiển thị kết quả
print("=== Block Header Fields ===")
print("Version:           ", version)
print("Previous Block:    ", block['prev_block'])
print("Merkle Root:       ", block['mrkl_root'])
print("Timestamp:         ", timestamp)
print("Bits (Difficulty): ", block['bits'])
print("Nonce:             ", nonce)
print("Block Hash:        ", block_hash)
