<template>
  <DashboardLayout>
    <div class="d-flex flex-column flex-md-row justify-space-between align-md-center mb-6">
      <div class="mb-4 mb-md-0">
        <h2 class="text-h4 text-primary font-weight-bold mb-2 tracking-tight">الإعدادات والأمان</h2>
        <p class="text-body-1 text-medium-emphasis">إدارة حساب المالك والإعدادات الشخصية والتحكم المركزي</p>
      </div>
    </div>

    <v-row>
      <v-col cols="12" md="6">
        <v-card elevation="0" border class="rounded-xl pa-2 h-100 hover-lift transition-swing">
          <v-card-title class="px-4 py-4 d-flex align-center border-b mx-2 mb-4">
            <v-avatar color="primary" variant="tonal" class="mr-3 ml-3 rounded-lg" size="48">
              <v-icon color="primary" size="28">mdi-account-cog</v-icon>
            </v-avatar>
            <span class="text-h6 font-weight-bold text-grey-darken-3">بيانات المالك</span>
          </v-card-title>
          <v-card-text class="px-6 pt-2 pb-6">
            <v-form @submit.prevent="saveProfile">
              <v-text-field
                v-model="profile.name"
                label="الاسم الكامل"
                variant="outlined"
                density="comfortable"
              ></v-text-field>
              
              <v-text-field
                v-model="profile.username"
                label="اسم المستخدم (Username)"
                variant="outlined"
                density="comfortable"
                dir="ltr"
              ></v-text-field>
              
              <v-text-field
                v-model="profile.email"
                label="البريد الإلكتروني"
                variant="outlined"
                density="comfortable"
                dir="ltr"
              ></v-text-field>

              <v-btn color="primary" variant="elevated" type="submit" class="mt-4 px-8" rounded="pill" elevation="2">حفظ التغييرات</v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" md="6">
        <v-card elevation="0" border class="rounded-xl pa-2 h-100 hover-lift transition-swing">
          <v-card-title class="px-4 py-4 d-flex align-center border-b mx-2 mb-4">
            <v-avatar color="error" variant="tonal" class="mr-3 ml-3 rounded-lg" size="48">
              <v-icon color="error" size="28">mdi-shield-lock-outline</v-icon>
            </v-avatar>
            <span class="text-h6 font-weight-bold text-grey-darken-3">تغيير كلمة المرور</span>
          </v-card-title>
          <v-card-text class="px-6 pt-2 pb-6">
            <v-form @submit.prevent="changePassword">
              <v-text-field
                v-model="passwordForm.current"
                label="كلمة المرور الحالية"
                type="password"
                variant="outlined"
                density="comfortable"
                dir="ltr"
              ></v-text-field>
              
              <v-text-field
                v-model="passwordForm.new"
                label="كلمة المرور الجديدة"
                type="password"
                variant="outlined"
                density="comfortable"
                dir="ltr"
              ></v-text-field>
              
              <v-text-field
                v-model="passwordForm.confirm"
                label="تأكيد كلمة المرور الجديدة"
                type="password"
                variant="outlined"
                density="comfortable"
                dir="ltr"
              ></v-text-field>

              <v-btn color="primary" variant="elevated" type="submit" class="mt-4 px-8" rounded="pill" elevation="2">تحديث كلمة المرور</v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </DashboardLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import DashboardLayout from '../layouts/DashboardLayout.vue';
import { useAuthStore } from '../stores/auth';
import { useToast } from 'vue-toast-notification';

const authStore = useAuthStore();
const toast = useToast();

const profile = ref({
  name: '',
  username: '',
  email: ''
});

const passwordForm = ref({
  current: '',
  new: '',
  confirm: ''
});

onMounted(() => {
  if (authStore.user) {
    profile.value = {
      name: authStore.user.name,
      username: authStore.user.username,
      email: authStore.user.email
    };
  }
});

const saveProfile = () => {
  // Update mock
  toast.success('تم تحديث البيانات بنجاح.', { position: 'bottom-right' });
};

const changePassword = () => {
  if (passwordForm.value.new !== passwordForm.value.confirm) {
    toast.error('كلمة المرور غير متطابقة', { position: 'bottom-right' });
    return;
  }
  toast.success('تم تغيير كلمة المرور بنجاح.', { position: 'bottom-right' });
  passwordForm.value = { current: '', new: '', confirm: '' };
};
</script>

<style scoped>
.tracking-tight {
  letter-spacing: -0.025em !important;
}

.hover-lift {
  transition: transform 0.2s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.2s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

.hover-lift:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05) !important;
  border-color: rgba(var(--v-theme-primary), 0.3) !important;
}
</style>
