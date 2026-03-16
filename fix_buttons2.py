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
            
            # Remove any backgroundColor: ... inside styleFrom
            content = re.sub(r'backgroundColor:\s*[^,]+,\s*', '', content)
            # Remove any foregroundColor: ... inside styleFrom
            content = re.sub(r'foregroundColor:\s*[^,]+,\s*', '', content)
            
            # Put back any in app_theme.dart since we need them there!
            if "app_theme.dart" not in path:
                if content != original:
                    with open(path, "w") as file:
                        file.write(content)
                    print(f"Fixed {path}")

