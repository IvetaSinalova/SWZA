import { defineConfig } from 'astro/config';
export default defineConfig({
  site: 'https://www.startupweekendzilina.sk',
  base: process.env.ASTRO_BASE_PATH || '/',
  output: 'static',
});
