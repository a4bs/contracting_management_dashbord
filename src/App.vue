<template>
  <component :is="layout">
    <router-view />
  </component>
</template>

<script lang="ts" setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import AuthLayout from '@/layouts/AuthLayout.vue'

const route = useRoute()

// تحديد الـ Layout بناءً على البيانات التعريفية للصفحة
const layouts: Record<string, any> = {
  DefaultLayout,
  AuthLayout
}

const layout = computed(() => {
  const layoutName = (route.meta?.layout as string) || 'DefaultLayout'
  return layouts[layoutName] || DefaultLayout
})
</script>
