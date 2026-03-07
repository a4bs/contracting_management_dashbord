/**
 * plugins/vuetify.ts
 *
 * Framework documentation: https://vuetifyjs.com`
 */

// Composables
import { createVuetify } from 'vuetify'
// Styles
import '@mdi/font/css/materialdesignicons.css'

import '../styles/layers.css'
import 'vuetify/styles'

// https://vuetifyjs.com/en/introduction/why-vuetify/#feature-guides
export default createVuetify({
  locale: {
    locale: 'ar',
    fallback: 'en',
  },
  theme: {
    defaultTheme: 'dark',

  },
  defaults: {
    VBtn: {
      color: 'primary',
      variant: 'flat',
    },
    VTextField: {
      variant: 'outlined',
      density: 'compact',
    },
    VCard: {
      class: 'rounded-lg',
    },
  },
})
