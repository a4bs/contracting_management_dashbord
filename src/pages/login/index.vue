<template>
  <v-container class="fill-height align-center justify-center mt-10" fluid>
    <v-row align="center" justify="center">
      <v-col cols="12" sm="8" md="4">
        <v-card class="elevation-12">
          <v-toolbar color="primary" dark flat>
            <v-toolbar-title>تسجيل الدخول</v-toolbar-title>
          </v-toolbar>
          <v-card-text>
            <v-form @submit.prevent="handleLogin">
              <!-- رسالة الخطأ القادمة من الـ API -->
              <v-alert
                v-if="errorMessage"
                type="error"
                variant="tonal"
                class="mb-4"
                closable
                @click:close="errorMessage = ''"
              >
                {{ errorMessage }}
              </v-alert>

              <v-text-field
                v-model="username"
                label="اسم المستخدم"
                name="username"
                prepend-inner-icon="mdi-account"
                type="text"
                variant="outlined"
                required
                :disabled="loading"
              ></v-text-field>

              <v-text-field
                v-model="password"
                id="password"
                label="كلمة المرور"
                name="password"
                prepend-inner-icon="mdi-lock"
                :type="showPassword ? 'text' : 'password'"
                variant="outlined"
                required
                :disabled="loading"
              >
                <template v-slot:append-inner>
                  <v-icon @click="showPassword = !showPassword">
                    {{ showPassword ? 'mdi-eye' : 'mdi-eye-off' }}
                  </v-icon>
                </template>
              </v-text-field>

              <v-btn
                type="submit"
                color="primary"
                block
                class="mt-4"
                size="large"
                :loading="loading"
                :disabled="loading"
              >
                دخول
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang="ts" setup>


import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
definePage({
  meta: {
    layout: 'AuthLayout', // If you want to use the AuthLayout
  },
})
const router = useRouter()
const authStore = useAuthStore()

const username = ref('')
const password = ref('')
const showPassword = ref(false)
const loading = ref(false)
const errorMessage = ref('')

const handleLogin = async () => {
  if (loading.value) return;

  if (!username.value || !password.value) {
    errorMessage.value = 'يرجى إدخال اسم المستخدم وكلمة المرور'
    return
  }

  loading.value = true
  errorMessage.value = ''

  try {
    await authStore.login({
      username: username.value,
      password: password.value,
    })
    
    router.push('/')
  } catch (error: any) {
    // إظهار الرسالة القادمة من السيرفر مباشرة
    errorMessage.value = error.message || 'فشل تسجيل الدخول: حدث خطأ غير متوقع'
    console.error('Login Error:', error)
  } finally {
    loading.value = false
  }
}
</script>
