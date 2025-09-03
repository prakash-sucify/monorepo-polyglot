const { withNx } = require('@nx/rollup/with-nx');

module.exports = withNx(
  {
    main: './src/index.ts',
    outputPath: '../../../dist/libs/shared/ui-components',
    tsConfig: './tsconfig.lib.json',
    compiler: 'swc',
    format: ['cjs', 'esm'],
    assets: [{ input: '{projectRoot}', output: '.', glob: '*.md' }],
  },
  {
    // Provide additional rollup configuration here. See: https://rollupjs.org/configuration-options
    // e.g.
    // output: { sourcemap: true },
  }
);
