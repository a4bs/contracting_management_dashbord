<template>
  <v-app>
    <router-view />
  </v-app>
</template>

<script lang="ts" setup>
  import { useAuthStore } from './stores/auth';
  // You might want to initialize auth check here or in router guard.
</script>
