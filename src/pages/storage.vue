<template>
  <DashboardLayout>
    <div class="d-flex flex-column flex-md-row justify-space-between align-md-center mb-6">
      <div class="mb-4 mb-md-0">
        <h2 class="text-h4 text-primary font-weight-bold mb-2 tracking-tight">تقارير مساحة التخزين</h2>
        <p class="text-body-1 text-medium-emphasis">مراقبة استهلاك الشركات لسعة الخادم والتنبيهات الذكية</p>
      </div>
    </div>

    <v-card elevation="0" border class="rounded-xl pa-0">
      <div class="px-6 py-4 d-flex align-center border-b bg-grey-lighten-4">
        <v-icon color="primary" class="mr-3 ml-3">mdi-database-eye-outline</v-icon>
        <h3 class="text-subtitle-1 font-weight-bold mb-0">سجل الاستهلاك النشط</h3>
      </div>
      <v-list lines="two" bg-color="transparent" class="px-2 py-4">
        <v-list-item v-for="company in companies" :key="company.id" class="mb-3 border rounded-lg mx-2 px-4 hover-lift transition-swing">
          <template v-slot:prepend>
            <v-avatar color="grey-lighten-3" class="border" rounded="lg" size="48">
              <v-icon color="grey-darken-1" v-if="!company.logo_path">mdi-domain</v-icon>
              <v-img v-else :src="company.logo_path" alt="logo"></v-img>
            </v-avatar>
          </template>

          <v-list-item-title class="font-weight-bold text-subtitle-1 px-4">{{ company.name }}</v-list-item-title>
          <v-list-item-subtitle class="mt-2 px-4">
            <div class="d-flex justify-space-between text-body-2 mb-2">
              <span class="text-medium-emphasis">استهلكت <span dir="ltr" class="font-weight-bold text-grey-darken-4">{{ company.storage_used_mb }} MB</span> من أصل <span dir="ltr" class="font-weight-medium">{{ company.storage_limit_mb }} MB</span> المتاحة لهم.</span>
              <span class="font-weight-bold" :class="getUsagePercentage(company) > 90 ? 'text-error' : (getUsagePercentage(company) > 75 ? 'text-warning' : 'text-success')">
                {{ getUsagePercentage(company) }}%
              </span>
            </div>
            <v-progress-linear
              :model-value="getUsagePercentage(company)"
              :color="getUsagePercentage(company) > 90 ? 'error' : (getUsagePercentage(company) > 75 ? 'warning' : 'primary')"
              height="8"
              rounded="pill"
            ></v-progress-linear>
          </v-list-item-subtitle>
          
          <template v-slot:append>
             <v-btn
                variant="tonal" 
                size="small" 
                color="warning" 
                v-if="getUsagePercentage(company) > 80"
                prepend-icon="mdi-bell-ring"
                class="ml-2 px-4 rounded-pill font-weight-bold"
                @click="sendWarning(company)"
             >
                إرسال تحذير
             </v-btn>
          </template>
        </v-list-item>
      </v-list>

      <v-alert
        v-if="companies.length === 0 && !loading"
        color="info"
        variant="tonal"
        class="ma-4 rounded-lg"
        icon="mdi-information-outline"
      >
        لا توجد بيانات مسجلة بعد لعرض استهلاكهم.
      </v-alert>
    </v-card>
  </DashboardLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import DashboardLayout from '../layouts/DashboardLayout.vue';
import api from '../services/api';
import { API_ROUTES } from '../constants/apiRoutes';
import { useToast } from 'vue-toast-notification';

const toast = useToast();
const companies = ref<any[]>([]);
const loading = ref(false);

const fetchStorageLogs = async () => {
  loading.value = true;
  try {
    const res: any = await api.get(API_ROUTES.COMPANIES);
    if(res.status) {
      // For now, sort by usage descending
      companies.value = res.data.sort((a: any, b: any) => 
        (b.storage_used_mb / b.storage_limit_mb) - (a.storage_used_mb / a.storage_limit_mb)
      );
    }
  } catch (error) {
    //
  } finally {
    loading.value = false;
  }
};

const getUsagePercentage = (company: any) => {
  if(!company.storage_limit_mb) return 0;
  return Math.round((company.storage_used_mb / company.storage_limit_mb) * 100);
};

const sendWarning = (company: any) => {
  // Mock action for sending warning notification
  toast.success(`تم إرسال إشعار تحذيري لشركة ${company.name} بنجاح`, { position: 'bottom-right' });
};

onMounted(() => {
  fetchStorageLogs();
});
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
