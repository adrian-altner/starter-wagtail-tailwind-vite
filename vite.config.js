import { defineConfig } from 'vite';
import path from 'path';

export default defineConfig({
  base: '/static/', // This should match Django's settings.STATIC_URL
  build: {
    // Where Vite will save its output files.
    // This should be something in your settings.STATICFILES_DIRS
    outDir: path.resolve(__dirname, './core/static'),
    emptyOutDir: false, // Preserve the outDir to not clobber Django's other files.
    manifest: "manifest.json",
    rollupOptions: {
      input: {
        'core': path.resolve(__dirname, './assets/core.js'),
      },
      output: {
        // Output JS bundles to js/ directory with -bundle suffix
        entryFileNames: `js/[name]-[hash].js`,
        assetFileNames: (assetInfo) => {
          if (assetInfo.name && assetInfo.name.endsWith('.css')) {
            return 'css/[name]-[hash][extname]';
          }
          return 'assets/[name]-[hash][extname]';
        },
      },
    },
  },
});
