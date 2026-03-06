<template>
  <DashboardLayout>
    <div class="d-flex flex-column flex-md-row justify-space-between align-md-center mb-6">
      <div class="mb-4 mb-md-0">
        <h2 class="text-h4 text-primary font-weight-bold mb-2 tracking-tight">إدارة العملات</h2>
        <p class="text-body-1 text-medium-emphasis">قاعدة التكويد للعملات المدعومة في النظام والمتاحة للعملاء</p>
      </div>
      <v-btn color="primary" variant="elevated" rounded="pill" elevation="2" class="px-6" height="44" prepend-icon="mdi-plus" @click="dialog = true">
        إضافة عملة جديدة
      </v-btn>
    </div>

    <v-card elevation="0" border class="rounded-xl">
      <div class="px-6 py-4 d-flex align-center border-b bg-grey-lighten-4">
        <v-icon color="primary" class="mr-3 ml-3">mdi-currency-usd</v-icon>
        <h3 class="text-subtitle-1 font-weight-bold mb-0">قائمة العملات المتوفرة</h3>
      </div>
      <v-data-table
        :headers="headers"
        :items="currencies"
        hover
        class="text-body-2 custom-table pb-4"
        density="comfortable"
      >
        <template v-slot:item.active="{ item }">
          <v-chip :color="item.active ? 'success' : 'error'" size="small" variant="tonal" class="font-weight-medium px-3">
            <v-icon start size="x-small">{{ item.active ? 'mdi-check-circle' : 'mdi-alert-circle' }}</v-icon>
            {{ item.active ? 'نشطة' : 'متوقفة' }}
          </v-chip>
        </template>
        <template v-slot:item.actions="{ item }">
          <v-btn icon variant="tonal" size="small" color="primary">
            <v-icon size="small">mdi-pencil</v-icon>
          </v-btn>
        </template>
      </v-data-table>
    </v-card>

    <v-dialog v-model="dialog" max-width="450">
      <v-card class="rounded-lg">
        <v-card-title class="bg-primary text-white px-4 py-3 d-flex justify-space-between align-center">
          <span>إضافة عملة جديدة</span>
          <v-btn icon variant="text" color="white" size="small" @click="dialog = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <v-card-text class="pt-6 pb-2">
          <v-text-field
            v-model="newCurrency.name"
            label="اسم العملة (مثال: ريال سعودي)"
            variant="outlined"
            density="comfortable"
            prepend-inner-icon="mdi-cash"
          ></v-text-field>
          <v-row>
            <v-col cols="6">
              <v-text-field
                v-model="newCurrency.code"
                label="الرمز (Code: SAR)"
                variant="outlined"
                density="comfortable"
                dir="ltr"
              ></v-text-field>
            </v-col>
            <v-col cols="6">
              <v-text-field
                v-model="newCurrency.symbol"
                label="العلامة (Symbol: ر.س)"
                variant="outlined"
                density="comfortable"
                dir="ltr"
              ></v-text-field>
            </v-col>
          </v-row>
        </v-card-text>
        <v-card-actions class="px-6 pb-6 pt-0">
          <v-spacer></v-spacer>
          <v-btn variant="text" @click="dialog = false">إلغاء الأمر</v-btn>
          <v-btn color="primary" variant="elevated" class="px-6" @click="saveCurrency">تسجيل العملة</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </DashboardLayout>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import DashboardLayout from '../layouts/DashboardLayout.vue';
import { useToast } from 'vue-toast-notification';

const toast = useToast();
const dialog = ref(false);

const headers = [
  { title: 'اسم العملة', key: 'name', align: 'start' },
  { title: 'كود العملة (Code)', key: 'code', align: 'start', sortable: false },
  { title: 'الرمز (Symbol)', key: 'symbol', align: 'start', sortable: false },
  { title: 'الحالة', key: 'active', align: 'center' },
  { title: 'إجراءات', key: 'actions', align: 'center', sortable: false },
] as const;

// Mock data
const currencies = ref([
  { id: 1, name: 'دولار أمريكي', code: 'USD', symbol: '$', active: true },
  { id: 2, name: 'دينار عراقي', code: 'IQD', symbol: 'د.ع', active: true },
]);

const newCurrency = ref({ name: '', code: '', symbol: '' });

const saveCurrency = () => {
  if(!newCurrency.value.name || !newCurrency.value.code) return;

  currencies.value.push({
    id: Date.now(),
    name: newCurrency.value.name,
    code: newCurrency.value.code,
    symbol: newCurrency.value.symbol,
    active: true
  });
  
  toast.success('تمت إضافة العملة بنجاح', { position: 'bottom-right' });
  dialog.value = false;
  newCurrency.value = { name: '', code: '', symbol: '' };
};
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
</style>
