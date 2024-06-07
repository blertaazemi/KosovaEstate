# Deploy `swagger-ui-react` to npm.

# https://www.peterbe.com/plog/set-ex
set -ex

# Parameter Expansion: http://stackoverflow.com/questions/6393551/what-is-the-meaning-of-0-in-a-bash-script
cd "${0%/*}"

mkdir -p ../dist

# Copy UI's dist files to our directory
cp ../../../dist/swagger-ui-es-bundle-core.js ../dist
cp ../../../dist/swagger-ui-es-bundle-core.js.map ../dist
cp ../../../dist/swagger-ui.js ../dist
cp ../../../dist/swagger-ui.js.map ../dist
cp ../../../dist/swagger-ui-bundle.js ../dist
cp ../../../dist/swagger-ui-es-bundle.js ../dist
cp ../../../dist/swagger-ui.css ../dist
cp ../../../dist/swagger-ui.css.map ../dist

# Create a releasable package manifest
node create-manifest.js > ../dist/package.json

# Transpile our top-level component
../../../node_modules/.bin/cross-env NODE_ENV=production BABEL_ENV=commonjs BROWSERSLIST_ENV=isomorphic-production ../../../node_modules/.bin/babel --config-file ../../../babel.config.js ../index.jsx > ../dist/index.cjs
../../../node_modules/.bin/cross-env NODE_ENV=production BABEL_ENV=esm BROWSERSLIST_ENV=browser-production ../../../node_modules/.bin/babel --config-file ../../../babel.config.js ../index.jsx > ../dist/index.mjs

# Copy our README into the dist folder for npm
cp ../README.md ../dist

# Copy LICENSE & NOTICE into the dist folder for npm
cp ../../../LICENSE ../dist
cp ../../../NOTICE ../dist

# Run the release from the dist folder
cd ../dist

if [ "$PUBLISH_FLAVOR_REACT" = "true" ] ; then
  npm publish .
else
  npm pack .
fi
