import { readFile, writeFile } from 'node:fs/promises'

function parseThemeName(args) {
    let themeName = 'bright';
    for (let i = 0; i < args.length; i++) {
        if (args[i] === '--theme_name') {
            themeName = args[i + 1];
            i++;
        } else if (args[i].startsWith('--theme_name=')) {
            themeName = args[i].slice('--theme_name='.length);
        }
    }
    return themeName;
}

function flattenTheme(obj, prefix = '', map = {}) {
    for (const [key, value] of Object.entries(obj)) {
        const token = prefix ? prefix + '.' + key : key;
        if (value && typeof value === 'object' && !Array.isArray(value)) {
            flattenTheme(value, token, map);
        } else {
            map[token] = value;
        }
    }
    return map;
}

function resolveTokens(node, tokens, path = 'style') {
    if (typeof node === 'string') {
        const match = node.match(/^\$([A-Za-z0-9._-]+)$/);
        if (!match) return node;
        const color = tokens[match[1]];
        if (color === undefined) {
            console.warn('Warning: unresolved token:', node, 'at', path);
            return node;
        }
        return color;
    }
    if (Array.isArray(node)) {
        return node.map((item, index) => resolveTokens(item, tokens, path + '[' + index + ']'));
    }
    if (node && typeof node === 'object') {
        const resolved = {};
        for (const [key, value] of Object.entries(node)) {
            resolved[key] = resolveTokens(value, tokens, path + '.' + key);
        }
        return resolved;
    }
    return node;
}

async function main() {
    const themeName = parseThemeName(process.argv.slice(2));

    let style;
    try {
        style = JSON.parse(await readFile(
            './style.json',
            'utf8'
        ));
    } catch (error) {
        console.error('Error while loading style file:', error.message);
        return;
    }

    let manifest;
    try {
        manifest = JSON.parse(await readFile(
            '../manifest.json',
            'utf8'
        ));
    } catch (error) {
        console.error('Error while loading manifest file:', error.message);
        return;
    }

    if (!style || !manifest) return;

    let theme;
    try {
        theme = JSON.parse(await readFile(
            '../theme/' + themeName + '.json',
            'utf8'
        ));
    } catch (error) {
        console.error('Error while loading theme file:', error.message);
        process.exit(1);
    }

    style.layers = [];

    for (const layer_path of manifest) {
        try {
            const layer = JSON.parse(await readFile(
                '../' + layer_path,
                'utf8'
            ));
            style.layers.push(layer);
            console.log('Embedded layer:', layer_path);
        } catch (error) {
            console.error('Error while appending layer:', layer_path, error.message);
        }
    }

    style.name = themeName;
    style = resolveTokens(style, flattenTheme(theme));

    try {
        await writeFile(
            './style.json',
            JSON.stringify(style, null, 4)
        );
    } catch (error) {
        console.error('Error while writing style file:', error.message);
    }
}

main().catch(console.error);