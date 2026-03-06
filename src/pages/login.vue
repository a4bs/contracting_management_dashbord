<template>
  <v-main class="bg-gradient flex-center" style="min-height: 100vh;">
    <v-card width="420" elevation="0" border class="pa-8 rounded-xl glass-card">
      <div class="text-center mb-8">
        <v-avatar color="primary" variant="tonal" size="72" class="mb-4">
          <v-icon size="40" color="primary">mdi-shield-crown</v-icon>
        </v-avatar>
        <h2 class="text-h4 font-weight-bold tracking-tight text-grey-darken-4 mb-2">تسجيل الدخول</h2>
        <p class="text-body-1 text-medium-emphasis">لوحة تحكم مالك النظام (SaaS Super Admin)</p>
      </div>

      <v-form @submit.prevent="handleLogin" ref="form">
        <v-text-field
          v-model="credentials.username"
          label="اسم المستخدم"
          variant="outlined"
          density="comfortable"
          prepend-inner-icon="mdi-account"
          :rules="[v => !!v || 'مطلوب']"
          class="mb-2"
          dir="ltr"
        ></v-text-field>

        <v-text-field
          v-model="credentials.password"
          label="كلمة المرور"
          type="password"
          variant="outlined"
          density="comfortable"
          prepend-inner-icon="mdi-lock"
          :rules="[v => !!v || 'مطلوب']"
          class="mb-4"
          dir="ltr"
        ></v-text-field>

        <v-btn
          type="submit"
          color="primary"
          block
          size="x-large"
          :loading="authStore.loading"
          class="font-weight-bold text-subtitle-1 mt-2 mb-2"
          rounded="pill"
          elevation="2"
        >
          دخول للنظام
        </v-btn>
      </v-form>
      <div class="text-center mt-6">
        <span class="text-caption text-medium-emphasis">جميع الحقوق محفوظة &copy; {{ new Date().getFullYear() }}</span>
      </div>
    </v-card>
  </v-main>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '../stores/auth';
import { useToast } from 'vue-toast-notification';

const router = useRouter();
const authStore = useAuthStore();
const toast = useToast();
const form = ref();

const credentials = ref({
  username: '',
  password: ''
});

const handleLogin = async () => {
  const { valid } = await form.value.validate();
  if (!valid) return;

  try {
    const success = await authStore.login(credentials.value);
    if (success) {
      toast.success('تم تسجيل الدخول بنجاح.', { position: 'bottom-right' });
      router.push('/');
    }
  } catch (error: any) {
    if (error.response?.status === 401) {
      toast.error('بيانات الدخول غير صحيحة.', { position: 'bottom-right' });
    }
  }
};
</script>

<style scoped>
.flex-center {
  display: flex;
  align-items: center;
  justify-content: center;
}

.bg-gradient {
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
}

.glass-card {
  background: rgba(255, 255, 255, 0.9) !important;
  backdrop-filter: blur(20px);
  box-shadow: 0 16px 40px rgba(0, 0, 0, 0.08) !important;
  border: 1px solid rgba(255,255,255,0.6) !important;
}

.tracking-tight {
  letter-spacing: -0.025em !important;
}
</style>
