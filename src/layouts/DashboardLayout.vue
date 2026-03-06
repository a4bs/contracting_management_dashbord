<template>
  <v-layout>
    <!-- App Bar -->
    <v-app-bar color="surface" density="compact" elevation="0" border="b">
      <v-app-bar-nav-icon color="primary" @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-app-bar-title class="font-weight-bold text-primary text-body-2">
        إدارة الاشتراكات والعملاء
      </v-app-bar-title>

      <v-spacer></v-spacer>

      <v-btn icon color="medium-emphasis" class="mx-1">
        <v-icon>mdi-bell-outline</v-icon>
      </v-btn>

      <v-menu min-width="220px" rounded="lg" transition="scale-transition">
        <template v-slot:activator="{ props }">
          <v-btn icon v-bind="props" class="mr-2">
            <v-avatar color="primary" size="36" variant="tonal">
              <span class="text-subtitle-2 font-weight-bold">{{ userInitials }}</span>
            </v-avatar>
          </v-btn>
        </template>
        <v-card elevation="4" class="rounded-lg">
          <v-card-text class="pa-0">
            <div class="pa-4 bg-primary text-center">
              <h3 class="text-h6 font-weight-bold text-white">{{ authStore.user?.name || 'المالك' }}</h3>
              <p class="text-caption text-white opacity-80 mt-1">{{ authStore.user?.email }}</p>
            </div>
            <v-list density="compact" class="py-2">
              <v-list-item prepend-icon="mdi-account-cog-outline" @click="router.push('/settings')">
                <v-list-item-title>إعدادات الحساب</v-list-item-title>
              </v-list-item>
              <v-divider class="my-1"></v-divider>
              <v-list-item prepend-icon="mdi-logout" color="error" @click="handleLogout">
                <v-list-item-title class="text-error font-weight-medium">تسجيل الخروج</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-card-text>
        </v-card>
      </v-menu>
    </v-app-bar>

    <!-- Navigation Drawer -->
    <v-navigation-drawer v-model="drawer" :location="$vuetify.locale.isRtl ? 'right' : 'left'" color="surface" elevation="0" border="e">
      <div class="pa-4 text-center">
        <v-avatar size="48" color="primary" variant="tonal" class="mb-3">
          <v-icon size="24" color="primary">mdi-shield-crown-outline</v-icon>
        </v-avatar>
        <h4 class="text-subtitle-2 font-weight-bold tracking-tight">النظام السحابي</h4>
        <p class="text-caption text-medium-emphasis mt-1" style="font-size: 0.70rem !important;">Super Admin Panel</p>
      </div>

      <v-divider class="mx-4 mb-2"></v-divider>

      <v-list density="compact" nav class="px-3">
        <v-list-item
          v-for="(item, i) in menuItems"
          :key="i"
          :value="item"
          :to="item.to"
          rounded="lg"
          class="mb-1 transition-fast-in-fast-out"
          active-class="bg-primary text-white"
        >
          <template v-slot:prepend>
            <v-icon :icon="item.icon" size="small" class="mr-3"></v-icon>
          </template>
          <v-list-item-title class="font-weight-medium text-body-2">{{ item.title }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>

    <!-- Main Content -->
    <v-main class="bg-background">
      <v-container fluid class="pa-4 pa-sm-6 pa-md-8 mx-auto" style="max-width: 1600px;">
        <slot></slot>
      </v-container>
    </v-main>
  </v-layout>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '../stores/auth';

const drawer = ref(true);
const authStore = useAuthStore();
const router = useRouter();

const userInitials = computed(() => {
  const name = authStore.user?.name || 'S A';
  return name.substring(0, 2).toUpperCase();
});

const menuItems = [
  { title: 'الرئيسية', icon: 'mdi-view-dashboard', to: '/' },
  { title: 'إدارة الشركات', icon: 'mdi-office-building', to: '/companies' },
  { title: 'العملات', icon: 'mdi-currency-usd', to: '/currencies' },
  { title: 'استهلاك المساحة', icon: 'mdi-database', to: '/storage' },
  { title: 'الإعدادات', icon: 'mdi-cog', to: '/settings' },
];

const handleLogout = async () => {
  await authStore.logout();
};
</script>

<style scoped>
.v-navigation-drawer .v-list-item--active .v-icon {
  color: white !important;
}
.tracking-tight {
  letter-spacing: -0.025em !important;
}
</style>
