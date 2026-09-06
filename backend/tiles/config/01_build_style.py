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
    'base/land-use/protected/fill.json',
    'base/land-use/agriculture/fill.json',
    'base/land-use/park/fill.json',
    'base/land-use/golf/fill.json',
    'base/land-use/campground/fill.json',
    'base/land-use/horticulture/fill.json',
    'base/land-use/military/fill.json',
    'base/land-use/recreation/fill.json',
    'base/land-use/entertainment/fill.json',
    'base/land-use/education/fill.json',
    'base/land-use/medical/fill.json',
    'base/land-use/cemetery/fill.json',
    'base/land-cover/fill.json',
    'base/water/continent/fill.json',
    'base/water/continent/line.json',
    'base/water/continent/label.json',
    'base/infrastructure/airport/fill.json',
    'base/infrastructure/airport/line.json',
    'base/infrastructure/water/fill.json',
    'base/infrastructure/water/line.json',
    'base/infrastructure/quay/fill.json',
    'base/infrastructure/quay/line.json',
    'base/infrastructure/pier/fill.json',
    'base/infrastructure/pier/line.json',
    'base/infrastructure/transit/fill.json',
    'base/infrastructure/bridge/fill.json',
    'base/infrastructure/bridge/line.json',
    'base/infrastructure/tower/fill.json',
    'base/infrastructure/recreation/line.json',
    'transportation/overview/casing.json',
    'transportation/overview/line.json',
    'transportation/road/pedestrian/casing.json',
    'transportation/road/other/casing.json',
    'transportation/road/living-street/casing.json',
    'transportation/road/residential/casing.json',
    'transportation/road/tertiary/casing.json',
    'transportation/road/secondary/casing.json',
    'transportation/road/primary/casing.json',
    'transportation/road/steps/line.json',
    'transportation/road/pedestrian/line.json',
    'transportation/road/other/line.json',
    'transportation/road/living-street/line.json',
    'transportation/road/residential/line.json',
    'transportation/road/tertiary/line.json',
    'transportation/road/secondary/line.json',
    'transportation/road/primary/line.json',
    'transportation/road/trunk/casing.json',
    'transportation/road/motorway/casing.json',
    'transportation/road/trunk/line.json',
    'transportation/road/motorway/line.json',
    'divisions/division-boundary/inland/line.json',
    'divisions/division-boundary/maritime/line.json',
    'buildings/building/fill.json',
    'buildings/building-part/fill.json',
    'buildings/building/extrusion.json',
    'buildings/building-part/extrusion.json',
    'transportation/rail/line.json',
    'transportation/rail/ticks.json',
    'transportation/water/line.json',
    'transportation/water/label.json',
    'transportation/road/other/label.json',
    'transportation/road/living-street/label.json',
    'transportation/road/residential/label.json',
    'transportation/road/tertiary/label.json',
    'transportation/road/secondary/label.json',
    'transportation/road/primary/label.json',
    'transportation/road/trunk/label.json',
    'transportation/road/motorway/label.json',
    'transportation/rail/label.json',
    "divisions/division/county/label.json",
    "divisions/division/local/label.json",
    "divisions/division/region/label.json",
    "divisions/division/locality/label.json",
    "divisions/division/country/label.json"
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
