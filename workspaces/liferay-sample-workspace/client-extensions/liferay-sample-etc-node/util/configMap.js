import config from "config";
import path from "path";
import { readdir, readFile } from "fs/promises";

const getConfigMapValues = async () => {
  const configMapValues = {};

  const fileConfigs = config.util.loadFileConfigs();

  if (!fileConfigs?.mountedConfigMapDirectories) {
    return configMapValues;
  }

  for (const mountedConfigMapDirectory of fileConfigs[
    "mountedConfigMapDirectories"
  ]) {
    const files = await readdir(mountedConfigMapDirectory, {
      withFileTypes: true
    });

    for (const file of files) {
      if (!file.isDirectory() && !file.name.startsWith("..")) {
        const filePath = path.join(mountedConfigMapDirectory, file.name);
        try {
          configMapValues[file.name] = await readFile(filePath, "utf-8");
        } catch (error) {
          console.error(`Could not read configMap file ${filePath}: ${error}`);
        }
      }
    }
  }

  return configMapValues;
};

const init = async () => {
  return config.util.extendDeep(config, await getConfigMapValues());
};

export default await init();
