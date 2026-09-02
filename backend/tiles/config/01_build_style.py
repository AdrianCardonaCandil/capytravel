# Importing libraries
import json
import sys
from pathlib import Path
from typing import TypeAlias, cast

# Route configuration
base_dir = Path("../")
style_file = base_dir / 'style.json'
layers_dir = base_dir / 'style'

# Type definitions
JSONValue: TypeAlias = (
    dict[str, 'JSONValue'] | list['JSONValue'] | str | int | float | bool | None
)

# Loading the style file
try:
    with open(style_file, 'r', encoding = 'utf-8') as file:
        style_data = cast(dict[str, JSONValue], json.load(file))
except FileNotFoundError:
    print(f"❌ Error: File not found {style_file}")
    sys.exit()

# Truncating layers property for various executions
style_data['layers'] = []

# Explicit layer orden building
manifest = [
    'base/water/ocean/fill.json',
    'base/bathymetry/fill.json',
    'base/land/fill.json',
    'base/land-use/fill.json',
    'base/land-cover/fill.json',
    'base/water/continental/fill.json',
    'base/water/continental/line.json',
    'base/water/continental/label.json',
    'base/infrastructure/fill.json',
    'base/infrastructure/line.json',
]

# Layers embedding
for layer_path in manifest:
    layer_file = layers_dir / layer_path
    if not layer_file.is_file():
        print(f"❌ Error: Layer file not found: {layer_file.relative_to(base_dir)}")
        sys.exit()
    with open(layer_file, 'r', encoding = 'utf-8') as file:
        try:
            layer_data = cast(dict[str, JSONValue], json.load(file))
            style_data['layers'].append(layer_data)
            print(f"✅ Embedded: {layer_file.relative_to(base_dir)}")
        except json.JSONDecodeError as error:
            print(f"❌ JSON Syntax Error on {layer_file.name}: {error}")
            sys.exit()

# Storing and indenting after embedding finished
with open(style_file, 'w', encoding = 'utf-8') as file:
    json.dump(style_data, file, indent = 4, ensure_ascii = False)
