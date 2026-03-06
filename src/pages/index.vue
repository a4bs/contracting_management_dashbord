<template>
  <DashboardLayout>
    <v-row class="mb-6 align-center">
      <v-col cols="12" md="8">
        <h2 class="text-h4 text-primary font-weight-bold mb-2 tracking-tight">نظرة عامة على النظام</h2>
        <p class="text-body-1 text-medium-emphasis">مرحباً بك مجدداً! إليك ملخص لأداء واشتراكات النظام السحابي الخاص بك.</p>
      </v-col>
    </v-row>

    <div v-if="loading" class="d-flex justify-center my-6">
      <v-progress-circular indeterminate color="primary"></v-progress-circular>
    </div>

    <template v-else>
      <!-- Stat Cards -->
      <v-row>
        <v-col cols="12" sm="6" md="3">
          <v-card elevation="0" border class="rounded-xl pa-5 stat-card hover-lift transition-swing">
            <div class="d-flex justify-space-between align-start">
              <div>
                <p class="text-subtitle-2 font-weight-medium text-medium-emphasis mb-2">الشركات النشطة</p>
                <h3 class="text-h3 font-weight-bold text-grey-darken-4">{{ stats.activeCount }}</h3>
              </div>
              <v-avatar color="success" variant="flat" rounded="lg" size="54" class="elevation-2">
                <v-icon size="28" color="white">mdi-domain</v-icon>
              </v-avatar>
            </div>
            <v-chip color="success" size="x-small" class="mt-4 font-weight-medium" variant="flat">
              <v-icon start size="small">mdi-arrow-up-right</v-icon> تعمل حالياً
            </v-chip>
          </v-card>
        </v-col>

        <v-col cols="12" sm="6" md="3">
          <v-card elevation="0" border class="rounded-xl pa-5 stat-card hover-lift transition-swing">
            <div class="d-flex justify-space-between align-start">
              <div>
                <p class="text-subtitle-2 font-weight-medium text-medium-emphasis mb-2">الشركات المعلقة</p>
                <h3 class="text-h3 font-weight-bold text-grey-darken-4">{{ stats.suspendedCount }}</h3>
              </div>
              <v-avatar color="error" variant="flat" rounded="lg" size="54" class="elevation-2">
                <v-icon size="28" color="white">mdi-pause-circle</v-icon>
              </v-avatar>
            </div>
            <v-chip color="error" size="x-small" class="mt-4 font-weight-medium" variant="flat">
              <v-icon start size="small">mdi-alert-circle</v-icon> تتطلب انتباه
            </v-chip>
          </v-card>
        </v-col>

        <v-col cols="12" sm="6" md="3">
          <v-card elevation="0" border class="rounded-xl pa-5 stat-card hover-lift transition-swing">
            <div class="d-flex justify-space-between align-start">
              <div>
                <p class="text-subtitle-2 font-weight-medium text-medium-emphasis mb-2">المساحة المستهلكة (MB)</p>
                <h3 class="text-h4 font-weight-bold text-grey-darken-4 pt-1 pb-1">{{ stats.totalStorageUsed }}</h3>
              </div>
              <v-avatar color="primary" variant="flat" rounded="lg" size="54" class="elevation-2">
                <v-icon size="28" color="white">mdi-database-outline</v-icon>
              </v-avatar>
            </div>
            <v-progress-linear 
              :model-value="(stats.totalStorageUsed / (stats.totalStorageLimit || 1)) * 100" 
              color="primary" 
              height="6" 
              rounded="pill" 
              class="mt-4 mb-2"
            ></v-progress-linear>
            <div class="text-caption text-medium-emphasis d-flex justify-space-between font-weight-medium">
              <span>مستهلك</span>
              <span>من أصل {{ stats.totalStorageLimit }} MB</span>
            </div>
          </v-card>
        </v-col>

        <v-col cols="12" sm="6" md="3">
          <v-card elevation="0" border class="rounded-xl pa-5 stat-card hover-lift transition-swing">
            <div class="d-flex justify-space-between align-start">
              <div>
                <p class="text-subtitle-2 font-weight-medium text-medium-emphasis mb-2">أحدث انضمام</p>
                <div class="text-truncate pt-2" style="max-width: 140px" :title="stats.latestCompany?.name || '-'">
                  <h3 class="text-h5 font-weight-bold text-grey-darken-4 d-inline-block" dir="auto">
                    {{ stats.latestCompany?.name || 'لا يوجد' }}
                  </h3>
                </div>
              </div>
              <v-avatar color="info" variant="flat" rounded="lg" size="54" class="elevation-2">
                <v-icon size="28" color="white">mdi-rocket-launch</v-icon>
              </v-avatar>
            </div>
            <div class="mt-4 d-flex align-center text-caption text-medium-emphasis font-weight-medium">
              <v-icon size="small" class="mr-1" color="info">mdi-clock-outline</v-icon>
              <span>أحدث عميل مضاف للنظام</span>
            </div>
          </v-card>
        </v-col>
      </v-row>

      <!-- Table & Chart Area -->
      <v-row class="mt-4">
        <v-col cols="12" md="8">
          <v-card elevation="0" border class="rounded-xl pa-6" height="100%">
            <div class="d-flex justify-space-between align-center mb-6">
              <h4 class="text-h6 font-weight-bold text-grey-darken-3">أحدث الشركات المضافة</h4>
              <v-btn variant="text" color="primary" size="small" rounded prepend-icon="mdi-arrow-right" to="/companies">
                عرض الكل
              </v-btn>
            </div>
            
            <v-table density="comfortable" class="text-body-2 custom-table" hover>
              <thead>
                <tr>
                  <th class="text-right text-subtitle-2 text-medium-emphasis pb-3 font-weight-bold">اسم الشركة</th>
                  <th class="text-right text-subtitle-2 text-medium-emphasis pb-3 font-weight-bold">النوع</th>
                  <th class="text-right text-subtitle-2 text-medium-emphasis pb-3 font-weight-bold">المساحة المستهلكة</th>
                  <th class="text-center text-subtitle-2 text-medium-emphasis pb-3 font-weight-bold">الحالة</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="company in latestCompaniesList" :key="company.id" class="table-row-hover">
                  <td class="font-weight-medium py-3">
                    <div class="d-flex align-center">
                      <v-avatar size="32" color="grey-lighten-4" class="ml-3 border">
                        <v-img v-if="company.logo_path" :src="company.logo_path"></v-img>
                        <v-icon v-else size="18" color="grey-darken-1">mdi-domain</v-icon>
                      </v-avatar>
                      <span dir="auto" class="text-subtitle-2">{{ company.name }}</span>
                    </div>
                  </td>
                  <td class="py-3 text-medium-emphasis">{{ company.company_type === 'contracting' ? 'مقاولات' : 'معدات ثقيلة' }}</td>
                  <td dir="ltr" class="text-right py-3 font-weight-medium">{{ company.storage_used_mb || 0 }} <span class="text-caption text-medium-emphasis">MB</span></td>
                  <td class="text-center py-3">
                    <v-chip :color="company.status === 'active' ? 'success' : 'error'" size="small" variant="tonal" class="font-weight-medium px-3">
                      {{ company.status === 'active' ? 'نشط' : 'معلق' }}
                    </v-chip>
                  </td>
                </tr>
                <tr v-if="latestCompaniesList.length === 0">
                  <td colspan="4" class="text-center py-8 text-medium-emphasis">
                    لا يوجد بيانات متاحة حالياً
                  </td>
                </tr>
              </tbody>
            </v-table>
          </v-card>
        </v-col>
        <v-col cols="12" md="4">
          <!-- Placeholder for Chart / CTA -->
          <v-card elevation="0" border class="rounded-xl pa-8 d-flex flex-column align-center justify-center text-center text-white" style="background: linear-gradient(135deg, rgba(var(--v-theme-primary), 1) 0%, #3949AB 100%) !important;" height="100%">
            <div class="glass-icon-wrapper mb-6">
              <v-icon size="56" color="white">mdi-trending-up</v-icon>
            </div>
            <h4 class="text-h5 font-weight-bold mb-3">نمو قوي ومستمر</h4>
            <p class="text-body-2 opacity-80 mb-6 px-4" style="line-height: 1.6;">
              راقب أرباحك وتطور اشتراكات عملائك من خلال هذه المنصة. سيتوفر الرسم البياني التحليلي هنا بمجرد وصول البيانات للحد الكافي.
            </p>
            <v-btn color="white" variant="elevated" rounded="pill" class="text-primary font-weight-bold px-8" elevation="2" to="/companies">
              إدارة الاشتراكات
            </v-btn>
          </v-card>
        </v-col>
      </v-row>
    </template>
  </DashboardLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import DashboardLayout from '../layouts/DashboardLayout.vue';
import api from '../services/api';
import { API_ROUTES } from '../constants/apiRoutes';

const loading = ref(false);
const companies = ref<any[]>([]);

const fetchDashboardData = async () => {
  loading.value = true;
  try {
    const res: any = await api.get(API_ROUTES.COMPANIES);
    if (res.status) {
      companies.value = res.data;
    }
  } catch (error) {
    // Error handled in interceptor
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  fetchDashboardData();
});

// Computed Stats based on real data
const stats = computed(() => {
  const activeCount = companies.value.filter(c => c.status === 'active').length;
  const suspendedCount = companies.value.filter(c => c.status === 'suspended').length;
  
  const totalStorageUsed = companies.value.reduce((acc, curr) => acc + (parseFloat(curr.storage_used_mb) || 0), 0).toFixed(2);
  const totalStorageLimit = companies.value.reduce((acc, curr) => acc + (parseFloat(curr.storage_limit_mb) || 0), 0).toFixed(2);
  
  // Assuming the highest ID or latest connected is the last in the array (or we can sort by date if available)
  const latestCompany = companies.value.length > 0 ? companies.value[companies.value.length - 1] : null;

  return { activeCount, suspendedCount, totalStorageUsed, totalStorageLimit, latestCompany };
});

const latestCompaniesList = computed(() => {
  // Return the last 5 added companies
  return [...companies.value].reverse().slice(0, 5);
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
  transform: translateY(-4px);
  box-shadow: 0 12px 24px -10px rgba(0, 0, 0, 0.1) !important;
}

.bg-gradient-primary {
  background: linear-gradient(135deg, var(--v-theme-primary) 0%, #3949AB 100%) !important;
}

.custom-table th {
  border-bottom: 2px solid rgba(0,0,0,0.05) !important;
}

.table-row-hover:hover {
  background-color: rgba(var(--v-theme-primary), 0.03) !important;
}

.glass-icon-wrapper {
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(10px);
  border-radius: 50%;
  width: 90px;
  height: 90px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(255, 255, 255, 0.3);
}
</style>
