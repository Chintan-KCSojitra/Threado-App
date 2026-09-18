const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const dir = 'C:/Users/chint/Downloads/Thredo/Thredo/Thredo/assets/png';
const files = fs.readdirSync(dir);

console.log(`Processing ${files.length} files in ${dir}`);

files.forEach(file => {
    const ext = path.extname(file).toLowerCase();
    const filePath = path.join(dir, file);

    if (ext === '.png') {
        console.log(`Compressing PNG: ${file}`);
        try {
            // optipng is generally safe and lossless
            execSync(`npx -p optipng-bin optipng -o2 "${filePath}"`, { stdio: 'inherit' });
        } catch (e) {
            console.error(`Failed to compress ${file}: ${e.message}`);
        }
    } else if (ext === '.jpg' || ext === '.jpeg') {
        console.log(`Compressing JPG: ${file}`);
        try {
            // jpegoptim --strip-all is lossless unless -m is specified
            execSync(`npx -p jpegoptim-bin jpegoptim --strip-all "${filePath}"`, { stdio: 'inherit' });
        } catch (e) {
            console.error(`Failed to compress ${file}: ${e.message}`);
        }
    }
});
