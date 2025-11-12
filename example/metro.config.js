/**
 * Metro configuration for React Native
 * https://github.com/facebook/react-native
 *
 * @format
 */
const path = require('path');
const sdkPath = path.resolve(__dirname, '..');
const projectRoot = __dirname;
const { getDefaultConfig, mergeConfig } = require('@react-native/metro-config');
const defaultConfig = getDefaultConfig(__dirname);
const {
  resolver: { sourceExts, assetExts },
} = getDefaultConfig(__dirname);

// module.exports = {
//   transformer: {
//     getTransformOptions: async () => ({
//       transform: {
//         experimentalImportSupport: false,
//         inlineRequires: true,
//       },
//     }),
//     babelTransformerPath: require.resolve('react-native-svg-transformer'),
//     assetPlugins: ['expo-asset/tools/hashAssetFiles']
//   },

//   watchFolders: [sdkPath],

//   resolver: {
//     nodeModulesPaths: [
//       path.resolve(projectRoot, 'node_modules'),
//       path.resolve(sdkPath, 'node_modules'),
//     ],
//     extraNodeModules: new Proxy({}, {
//       get: (_, name) => path.resolve(projectRoot, 'node_modules', name),
//     }),
//     assetExts: config.resolver.assetExts.filter((ext) => ext !== 'svg'),
//     sourceExts: [...config.resolver.sourceExts, 'svg', 'd.ts']
//   },
// };
const config = {
  transformer: {
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: true,
      },
    }),
    babelTransformerPath: require.resolve('react-native-svg-transformer'),
  },
  watchFolders: [sdkPath],
  resolver: {
    assetExts: assetExts.filter(ext => ext !== 'svg'),
    sourceExts: [...sourceExts, 'svg'],
    nodeModulesPaths: [
      path.resolve(projectRoot, 'node_modules'),
      path.resolve(sdkPath, 'node_modules'),
    ],
    extraNodeModules: new Proxy({}, {
      get: (_, name) => path.resolve(projectRoot, 'node_modules', name),
    }),
  },
};

module.exports = mergeConfig(defaultConfig, config);