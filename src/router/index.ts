import { createRouter, createWebHistory } from 'vue-router'
import { routes } from 'vue-router/auto-routes'
import { UserTool } from '@/tools/user_tool'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
})

router.beforeEach((to, from, next) => {
  // استخدام UserTool للتحقق من وجود المستخدم
  const user = UserTool.getUser()

  if (to.path !== '/login' && !user) {
    // إذا كنت تحاول الدخول لأي صفحة غير تسجيل الدخول وأنت غير مسجل
    next('/login')
  } else if (to.path === '/login' && user) {
    // إذا كنت مسجل دخول بالفعل وتحاول الذهاب لصفحة تسجيل الدخول
    next('/')
  } else {
    // استمر بشكل طبيعي
    next()
  }
})

export default router
