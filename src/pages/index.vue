<template>
  <HelloWorld />
</template>

<script lang="ts" setup>
  import HelloWorld from '@/components/HelloWorld.vue'
  definePage({
  meta: {
    layout: 'DefaultLayout', // If you want to use the AuthLayout
  },
})
</script>
