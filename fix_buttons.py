import os
import re

lib_dir = "lib"

for root, _, files in os.walk(lib_dir):
    for f in files:
        if f.endswith(".dart"):
            path = os.path.join(root, f)
            with open(path, "r") as file:
                content = file.read()
            
            original = content
            
            # Remove backgroundColor: Theme...
            content = re.sub(r'backgroundColor:\s*Theme\.of\(context\)\.primaryColor,\s*', '', content)
            
            # Remove foregroundColor: Theme...
            content = re.sub(r'foregroundColor:\s*Theme\.of\(context\)\.colorScheme\.onPrimary,\s*', '', content)
            
            # Remove color: Theme.of(context).colorScheme.onPrimary inside CircularProgressIndicator
            # Note: Sometimes it's inside Text(), so we can also check for color: Theme...onPrimary,
            content = re.sub(r'color:\s*Theme\.of\(context\)\.colorScheme\.onPrimary,?\s*', '', content)
            
            if content != original:
                with open(path, "w") as file:
                    file.write(content)
                print(f"Fixed {path}")

