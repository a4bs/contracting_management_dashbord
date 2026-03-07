<template>
  <v-app >
    <!-- الشريط الجانبي (Sidebar) -->
    <v-navigation-drawer
      v-model="drawer"
      :rail="rail"
      order="2"
      permanent
      @click="rail = false"
      color="primary"
    >
      <v-list-item
        prepend-avatar="https://randomuser.me/api/portraits/men/32.jpg"
        title="المدير العام"
        nav
      >
        <template v-slot:append>
          <v-btn
            variant="text"
            icon="mdi-chevron-left"
            @click.stop="rail = !rail"
          ></v-btn>
        </template>
      </v-list-item>

      <v-divider></v-divider>

      <v-list density="compact" nav>
        <v-list-item 
          prepend-icon="mdi-view-dashboard" 
          title="لوحة التحكم" 
          value="home" 
          to="/"
        ></v-list-item>
        
        <v-list-item 
          prepend-icon="mdi-office-building" 
          title="المشاريع" 
          value="projects"
        ></v-list-item>

        <v-list-item 
          prepend-icon="mdi-account-group" 
          title="الموظفين" 
          value="users"
        ></v-list-item>

        <v-list-item 
          prepend-icon="mdi-cog" 
          title="الإعدادات" 
          value="settings"
        ></v-list-item>
      </v-list>

      <template v-slot:append>
        <div class="pa-2">
          <v-btn
            block
            color="red-darken-2"
            prepend-icon="mdi-logout"
            @click="logout"
            :variant="rail ? 'text' : 'elevated'"
          >
            <span v-if="!rail">تسجيل الخروج</span>
          </v-btn>
        </div>
      </template>
    </v-navigation-drawer>

    <!-- الشريط العلوي (Top Bar) -->
    <v-app-bar flat border>
      <v-app-bar-title>نظام إدارة المقاولات</v-app-bar-title>
      <v-spacer></v-spacer>
      <v-btn icon="mdi-bell-outline"></v-btn>
    </v-app-bar>

    <!-- المحتوى الرئيسي (Main Content) -->
    <v-main class="bg-grey-lighten-4">
      <v-container fluid>
        <slot />
      </v-container>
    </v-main>
  </v-app>
</template>

<script lang="ts" setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const drawer = ref(true)
const rail = ref(false)
const router = useRouter()
const authStore = useAuthStore()

const logout = () => {
  authStore.logout()
  router.push('/login')
}
</script>

<style scoped>
.v-navigation-drawer {
  transition: width 0.2s ease-in-out;
}
</style>