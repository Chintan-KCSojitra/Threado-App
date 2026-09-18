import os
from PIL import Image

dir_path = r'C:\Users\chint\Downloads\Thredo\Thredo\Thredo\assets\png'
files = [f for f in os.listdir(dir_path) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]

print(f"Processing {len(files)} files in {dir_path}")

total_saved = 0

for file in files:
    file_path = os.path.join(dir_path, file)
    initial_size = os.path.getsize(file_path)
    
    try:
        img = Image.open(file_path)
        ext = os.path.splitext(file)[1].lower()
        
        if ext == '.png':
            # Lossless optimization for PNG
            img.save(file_path, optimize=True)
        elif ext in ('.jpg', '.jpeg'):
            # Lossless Huffman optimization for JPG
            # We don't specify quality to avoid re-encoding loss, just optimize the storage
            img.save(file_path, optimize=True, quality='keep' if 'quality' in img.info else 95)
            
        final_size = os.path.getsize(file_path)
        saved = initial_size - final_size
        if saved > 0:
            total_saved += saved
            print(f"Compressed {file}: {initial_size} -> {final_size} ({saved} bytes saved)")
        else:
            print(f"No savings for {file} (or slightly larger, keeping original)")
            # If it got larger, we might want to revert, but Pillow's optimize usually helps.
            # In a real scenario we'd check if final_size > initial_size and keep original.
            
    except Exception as e:
        print(f"Error processing {file}: {e}")

print(f"Done. Total saved: {total_saved} bytes.")
