<template>
  <DashboardLayout>
    <div class="d-flex flex-column flex-md-row justify-space-between align-md-center mb-6">
      <div class="mb-4 mb-md-0">
        <h2 class="text-h4 text-primary font-weight-bold mb-2 tracking-tight">إدارة واشتراكات العملاء</h2>
        <p class="text-body-1 text-medium-emphasis">تحكم بتراخيص وبرمجيات الشركات (المقاولات، المعدات الثقيلة) ومراقبة استهلاكها</p>
      </div>
      <v-btn color="primary" variant="elevated" rounded="pill" elevation="2" class="px-6" height="44" prepend-icon="mdi-domain-plus" @click="openAddDialog">
        تسجيل شركة جديدة
      </v-btn>
    </div>

    <v-card elevation="0" border class="rounded-xl">
      <div class="px-6 py-4 d-flex align-center border-b bg-grey-lighten-4">
        <v-icon color="primary" class="mr-3 ml-3">mdi-office-building-cog</v-icon>
        <h3 class="text-subtitle-1 font-weight-bold mb-0">قائمة الشركات المسجلة</h3>
        <v-spacer></v-spacer>
        <v-text-field
          v-model="search"
          prepend-inner-icon="mdi-magnify"
          label="البحث عن شركة أو رقم..."
          single-line
          hide-details
          variant="solo-filled"
          flat
          density="compact"
          class="search-input"
          style="max-width: 300px"
          rounded="pill"
        ></v-text-field>
      </div>

      <v-data-table
        :headers="headers"
        :items="companies"
        :search="search"
        :loading="loading"
        hover
        class="text-body-2 custom-table pb-4"
        density="comfortable"
      >
        <template v-slot:item.logo_path="{ item }">
          <v-avatar size="36" color="grey-lighten-2" rounded>
            <v-icon v-if="!item.logo_path">mdi-domain</v-icon>
            <v-img v-else :src="item.logo_path" alt="logo"></v-img>
          </v-avatar>
        </template>

        <template v-slot:item.name="{ item }">
          <div class="py-2">
            <span class="font-weight-bold text-subtitle-2">{{ item.name }}</span>
            <div class="text-caption text-medium-emphasis">{{ item.company_type === 'contracting' ? 'مقاولات' : 'معدات ثقيلة' }}</div>
          </div>
        </template>

        <template v-slot:item.status="{ item }">
          <v-chip :color="item.status === 'active' ? 'success' : 'error'" size="small" variant="tonal" class="font-weight-medium px-3">
            <v-icon start size="x-small">{{ item.status === 'active' ? 'mdi-check-circle' : 'mdi-alert-circle' }}</v-icon>
            {{ item.status === 'active' ? 'نشط' : 'معلق' }}
          </v-chip>
        </template>

        <template v-slot:item.storage="{ item }">
          <div class="d-flex align-center">
            <span class="mr-2" dir="ltr">{{ item.storage_used_mb }} / {{ item.storage_limit_mb }} MB</span>
            <v-progress-linear 
              :model-value="(item.storage_used_mb / item.storage_limit_mb) * 100" 
              :color="((item.storage_used_mb / item.storage_limit_mb) * 100) > 90 ? 'error' : 'primary'"
              height="8"
              rounded
              style="width: 60px;"
            ></v-progress-linear>
          </div>
        </template>

        <template v-slot:item.subscription="{ item }">
          <div class="d-flex flex-column text-caption py-2" style="min-width: 100px;">
            <div class="d-flex align-center text-medium-emphasis mb-1">
              <v-icon size="x-small" class="mr-1 ml-1" color="success">mdi-calendar-start</v-icon>
              <span>{{ item.subscription_start_date ? item.subscription_start_date.split('T')[0] : '---' }}</span>
            </div>
            <div class="d-flex align-center text-medium-emphasis">
              <v-icon size="x-small" class="mr-1 ml-1" color="error">mdi-calendar-end</v-icon>
              <span>{{ item.subscription_end_date ? item.subscription_end_date.split('T')[0] : '---' }}</span>
            </div>
          </div>
        </template>

        <template v-slot:item.actions="{ item }">
          <div class="d-flex align-center justify-center ga-2">
            <v-btn icon variant="tonal" size="small" color="primary" @click="openEditDialog(item)">
              <v-icon size="small">mdi-pencil</v-icon>
              <v-tooltip activator="parent" location="top">تعديل وتجديد</v-tooltip>
            </v-btn>
            <v-btn 
              icon 
              variant="tonal" 
              size="small" 
              :color="item.status === 'active' ? 'error' : 'success'" 
              @click="confirmToggleStatus(item)"
            >
              <v-icon size="small">{{ item.status === 'active' ? 'mdi-pause' : 'mdi-play' }}</v-icon>
              <v-tooltip activator="parent" location="top">
                {{ item.status === 'active' ? 'إيقاف النظام' : 'تفعيل النظام' }}
              </v-tooltip>
            </v-btn>
          </div>
        </template>
      </v-data-table>
    </v-card>

    <!-- Add Company Modal -->
    <v-dialog v-model="addDialog" max-width="800" persistent>
      <v-card class="rounded-lg">
        <v-card-title class="bg-primary text-white px-4 py-3 d-flex justify-space-between align-center">
          <span>إضافة شركة جديدة</span>
          <v-btn icon variant="text" color="white" @click="addDialog = false" :disabled="submitting">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        
        <v-card-text class="pt-6">
          <v-form ref="addForm" @submit.prevent="submitCompany">
            <div class="text-subtitle-1 font-weight-bold mb-3">القسم الأول: بيانات الشركة</div>
            <v-row>
              <v-col cols="12" sm="6">
                <v-text-field
                  v-model="newCompany.name"
                  label="اسم الشركة"
                  variant="outlined"
                  density="comfortable"
                  :rules="[v => !!v || 'مطلوب']"
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="6">
                <v-text-field
                  v-model="newCompany.contact_number"
                  label="رقم التواصل"
                  variant="outlined"
                  density="comfortable"
                  dir="ltr"
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="6">
                <v-text-field
                  v-model="newCompany.email"
                  label="البريد الإلكتروني"
                  variant="outlined"
                  density="comfortable"
                  type="email"
                  dir="ltr"
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="6">
                <v-text-field
                  v-model="newCompany.storage_limit_mb"
                  label="مساحة التخزين (بالميجا)"
                  type="number"
                  variant="outlined"
                  density="comfortable"
                  :rules="[v => !!v || 'مطلوب', v => v > 0 || 'يجب أن يكون أكبر من 0']"
                  dir="ltr"
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="6">
                <v-select
                  v-model="newCompany.company_type"
                  :items="[
                    { title: 'شركة مقاولات', value: 'contracting' },
                    { title: 'شركة معدات ثقيلة', value: 'heavy_equipment' }
                  ]"
                  item-title="title"
                  item-value="value"
                  label="نوع الشركة"
                  variant="outlined"
                  density="comfortable"
                  :rules="[v => !!v || 'مطلوب']"
                ></v-select>
              </v-col>
              <v-col cols="12" sm="6">
                <v-text-field
                  v-model="newCompany.subscription_months"
                  label="مدة الاشتراك (بالأشهر)"
                  type="number"
                  variant="outlined"
                  density="comfortable"
                  :rules="[v => !!v || 'مطلوب', v => v > 0 || 'يجب أن يكون شهر على الأقل']"
                  dir="ltr"
                ></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-file-input
                  v-model="newCompany.logo"
                  label="شعار الشركة (Logo)"
                  prepend-icon=""
                  prepend-inner-icon="mdi-camera"
                  variant="outlined"
                  density="comfortable"
                  accept="image/*"
                  show-size
                ></v-file-input>
              </v-col>
            </v-row>

            <v-divider class="my-4"></v-divider>
            <div class="text-subtitle-1 font-weight-bold mb-3">القسم الثاني: حساب مدير الشركة (Admin User)</div>
            
            <v-row>
              <v-col cols="12" sm="4">
                <v-text-field
                  v-model="newCompany.admin_name"
                  label="الاسم الكامل للمدير"
                  variant="outlined"
                  density="comfortable"
                  :rules="[v => !!v || 'مطلوب']"
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="4">
                <v-text-field
                  v-model="newCompany.admin_username"
                  label="اسم المستخدم (Username)"
                  variant="outlined"
                  density="comfortable"
                  :rules="[v => !!v || 'مطلوب']"
                  dir="ltr"
                ></v-text-field>
              </v-col>
              <v-col cols="12" sm="4">
                <v-text-field
                  v-model="newCompany.admin_password"
                  label="كلمة المرور"
                  type="password"
                  variant="outlined"
                  density="comfortable"
                  :rules="[v => !!v || 'مطلوب', v => v?.length >= 6 || 'أقل شيء 6 أحرف']"
                  dir="ltr"
                ></v-text-field>
              </v-col>
            </v-row>
          </v-form>
        </v-card-text>
        <v-card-actions class="px-6 pb-6 pt-0">
          <v-spacer></v-spacer>
          <v-btn variant="text" @click="addDialog = false" :disabled="submitting">إلغاء</v-btn>
          <v-btn color="primary" variant="elevated" :loading="submitting" @click="submitCompany">
            حفظ وإنشاء
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Edit/Suspend Dialog -->
    <v-dialog v-model="editDialog" max-width="500">
      <v-card class="rounded-lg">
        <v-card-title class="bg-primary text-white px-4 py-3">تعديل الشركة المحددة</v-card-title>
        <v-card-text class="pt-6">
          <v-text-field
            v-model="selectedCompany.storage_limit_mb"
            label="مساحة التخزين الإجمالية (بالميجا)"
            type="number"
            variant="outlined"
            density="comfortable"
            dir="ltr"
          ></v-text-field>

          <v-text-field
            v-model="selectedCompany.extend_subscription_months"
            label="تجديد الاشتراك المتبقي / إضافة أشهر (اختياري)"
            type="number"
            variant="outlined"
            density="comfortable"
            hint="اتركه فارغاً إذا كنت لا ترغب بتجديد/إضافة أشهر"
            persistent-hint
            dir="ltr"
            class="mb-3"
          ></v-text-field>
          
          <v-switch
            v-model="selectedCompany.status"
            false-value="suspended"
            true-value="active"
            :color="selectedCompany.status === 'active' ? 'success' : 'error'"
            :label="selectedCompany.status === 'active' ? 'الشركة نشطة' : 'الشركة معلقة'"
            inset
          ></v-switch>
          <p class="text-caption text-error" v-if="selectedCompany.status === 'suspended'">
            * عند تعليق الشركة، سيتم منع جميع مديريها وعمالها من الدخول للنظام فوراً.
          </p>
        </v-card-text>
        <v-card-actions class="px-6 pb-6 pt-0">
          <v-spacer></v-spacer>
          <v-btn variant="text" @click="editDialog = false">إلغاء</v-btn>
          <v-btn color="primary" variant="elevated" :loading="submitting" @click="saveEdit">حفظ التعديلات</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Confirm Suspend Modal -->
    <v-dialog v-model="confirmDialog" max-width="400">
      <v-card class="rounded-lg text-center pa-2">
        <v-card-text class="pt-6 px-4">
          <v-icon size="64" color="warning" class="mb-4">mdi-alert-circle-outline</v-icon>
          <h3 class="text-h6 mb-2">هل أنت متأكد؟</h3>
          <p class="text-body-2 text-medium-emphasis mb-4">
            هل أنت متأكد من رغبتك في {{ confirmActionCompany?.status === 'active' ? 'إيقاف وتعليق' : 'تفعيل' }} عمل شركة ({{ confirmActionCompany?.name }})؟
            <span v-if="confirmActionCompany?.status === 'active'"><br>سيؤدي ذلك لمنع مديريها من الدخول.</span>
          </p>
          <div class="d-flex justify-center ga-3">
            <v-btn variant="outlined" color="secondary" @click="confirmDialog = false">إلغاء</v-btn>
            <v-btn :color="confirmActionCompany?.status === 'active' ? 'error' : 'success'" :loading="submitting" @click="executeToggleStatus">
              نعم، متأكد
            </v-btn>
          </div>
        </v-card-text>
      </v-card>
    </v-dialog>

  </DashboardLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import DashboardLayout from '../layouts/DashboardLayout.vue';
import api from '../services/api';
import { API_ROUTES } from '../constants/apiRoutes';
import { useToast } from 'vue-toast-notification';

const toast = useToast();

const search = ref('');
const loading = ref(false);
const submitting = ref(false);

const headers = [
  { title: 'ST', key: 'logo_path', align: 'center', sortable: false },
  { title: 'اسم الشركة', key: 'name', align: 'start' },
  { title: 'الحالة', key: 'status', align: 'center' },
  { title: 'رقم التواصل', key: 'contact_number', align: 'start' },
  { title: 'الخزن (مستهلك/كلي)', key: 'storage', align: 'start' },
  { title: 'صلاحية الاشتراك', key: 'subscription', align: 'start' },
  { title: 'تاريخ الانضمام', key: 'join_date', align: 'start' },
  { title: 'الإجراءات', key: 'actions', align: 'center', sortable: false },
] as const;

const companies = ref<any[]>([]);

// Modals state
const addDialog = ref(false);
const editDialog = ref(false);
const confirmDialog = ref(false);

const addForm = ref();
const newCompany = ref({
  name: '',
  contact_number: '',
  email: '',
  storage_limit_mb: 1024,
  company_type: 'contracting',
  subscription_months: 1,
  status: 'active',
  admin_name: '',
  admin_username: '',
  admin_password: '',
  logo: null as any
});

const selectedCompany = ref<any>({});
const confirmActionCompany = ref<any>(null);

const fetchCompanies = async () => {
  loading.value = true;
  try {
    const res: any = await api.get(API_ROUTES.COMPANIES);
    if(res.status) {
      companies.value = res.data;
    }
  } catch (error) {
    // Error handled in interceptor
  } finally {
    loading.value = false;
  }
};

const openAddDialog = () => {
  newCompany.value = {
    name: '', contact_number: '', email: '',
    storage_limit_mb: 1024, company_type: 'contracting', subscription_months: 1, status: 'active',
    admin_name: '', admin_username: '', admin_password: '', logo: null
  };
  addDialog.value = true;
};

const submitCompany = async () => {
  const { valid } = await addForm.value.validate();
  if (!valid) return;

  submitting.value = true;
  try {
    const formPayload = new FormData();
    Object.keys(newCompany.value).forEach(key => {
      const value = (newCompany.value as any)[key];
      if (value !== null && value !== '') {
        formPayload.append(key, value);
      }
    });

    const res: any = await api.post(API_ROUTES.COMPANIES, formPayload, {
      headers: { 'Content-Type': 'multipart/form-data' }
    });

    if (res.status) {
      toast.success(res.message || 'تم إنشاء الشركة بنجاح', { position: 'bottom-right' });
      addDialog.value = false;
      fetchCompanies(); // refresh list
    }
  } catch (error) {
    // Handled in interceptor
  } finally {
    submitting.value = false;
  }
};

const openEditDialog = (item: any) => {
  selectedCompany.value = { ...item, extend_subscription_months: null };
  editDialog.value = true;
};

const saveEdit = async () => {
  submitting.value = true;
  try {
    const payload: any = {
      status: selectedCompany.value.status,
      storage_limit_mb: selectedCompany.value.storage_limit_mb
    };
    
    // Add subscription months if extended
    if (selectedCompany.value.extend_subscription_months && selectedCompany.value.extend_subscription_months > 0) {
      payload.subscription_months = selectedCompany.value.extend_subscription_months;
    }

    const res: any = await api.put(API_ROUTES.COMPANY_DETAILS(selectedCompany.value.id), payload);
    
    if(res.status) {
      toast.success(res.message || 'تم تحديث الشركة بنجاح', { position: 'bottom-right' });
      editDialog.value = false;
      fetchCompanies();
    }
  } catch (error) {
    // Intercepted
  } finally {
    submitting.value = false;
  }
};

const confirmToggleStatus = (item: any) => {
  confirmActionCompany.value = item;
  confirmDialog.value = true;
};

const executeToggleStatus = async () => {
  submitting.value = true;
  try {
    const newStatus = confirmActionCompany.value.status === 'active' ? 'suspended' : 'active';
    const res: any = await api.put(API_ROUTES.COMPANY_DETAILS(confirmActionCompany.value.id), {
      status: newStatus
    });

    if (res.status) {
      toast.success(newStatus === 'active' ? 'تم تفعيل الشركة بنجاح' : 'تم تعليق عمل الشركة بنجاح', { position: 'bottom-right' });
      confirmDialog.value = false;
      fetchCompanies();
    }
  } catch (error) {
    // interceptor
  } finally {
    submitting.value = false;
  }
};

onMounted(() => {
  // Using Mock data until API is fully ready or backend is attached, but standard calls will work.
  // We will call the API anyway
  fetchCompanies();
});

</script>

<style scoped>
.tracking-tight {
  letter-spacing: -0.025em !important;
}

.custom-table :deep(th) {
  background-color: transparent !important;
  color: rgba(var(--v-theme-on-surface), 0.6) !important;
  text-transform: uppercase;
  font-size: 0.75rem !important;
  letter-spacing: 0.05em;
  padding-top: 12px !important;
  padding-bottom: 12px !important;
  border-bottom: 1px solid rgba(var(--v-border-color), 0.5) !important;
}

.search-input :deep(.v-field) {
  background: white !important;
}
</style>
