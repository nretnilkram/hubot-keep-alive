import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export default (robot, scripts) => {
  const scriptsPath = path.resolve(__dirname, 'src');
  fs.access(scriptsPath, fs.constants.F_OK, (err) => {
    if (!err) {
      const scriptFiles = fs.readdirSync(scriptsPath);
      for (const script of scriptFiles) {
        if (scripts && !scripts.includes('*')) {
          if (scripts.includes(script)) {
            robot.loadFile(scriptsPath, script);
          }
        } else {
          robot.loadFile(scriptsPath, script);
        }
      }
    }
  });
};