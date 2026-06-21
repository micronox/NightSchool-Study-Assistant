import type { Config } from '@docusaurus/types';

const config: Config = {
  title: 'NightSchool Study Assistant',
  tagline: 'Architecture defense and preproduction packet',
  url: 'https://micronox.github.io',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  organizationName: 'micronox',
  projectName: 'NightSchool-Study-Assistant',
  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          routeBasePath: '/',
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      },
    ],
  ],
  themeConfig: {
    navbar: {
      title: 'NightSchool Study Assistant',
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'packetSidebar',
          position: 'left',
          label: 'Packet',
        },
        {
          href: 'https://github.com/micronox/NightSchool-Study-Assistant',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
  },
};

export default config;
