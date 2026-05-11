# 可复用代码清单

> 以下代码已在项目中实现，其他模块应优先复用，避免重复实现。
> 发现新的可复用代码时，请及时添加到此文档。

## 工具函数

| 函数 | 位置 | 用途 | 使用示例 |
|------|------|------|---------|
| `formatDate()` | `utils/date.ts` | 日期格式化 | `formatDate(new Date())` |
| `debounce()` | `utils/performance.ts` | 防抖函数 | `debounce(fn, 300)` |
| `throttle()` | `utils/performance.ts` | 节流函数 | `throttle(fn, 300)` |
| `deepClone()` | `utils/object.ts` | 深拷贝 | `deepClone(obj)` |
| `isEmpty()` | `utils/validation.ts` | 空值检查 | `isEmpty(value)` |

## 通用组件

| 组件 | 位置 | 用途 | Props |
|------|------|------|-------|
| `Button` | `components/Button.tsx` | 通用按钮 | `variant, size, onClick` |
| `Modal` | `components/Modal.tsx` | 模态框 | `isOpen, onClose, title` |
| `Table` | `components/Table.tsx` | 数据表格 | `columns, data, pagination` |
| `Form` | `components/Form.tsx` | 表单 | `fields, onSubmit, validation` |
| `Loading` | `components/Loading.tsx` | 加载状态 | `size, text` |

## 业务逻辑

| 逻辑 | 位置 | 用途 | 调用方式 |
|------|------|------|---------|
| `useAuth()` | `hooks/useAuth.ts` | 认证状态 | `const { user, login } = useAuth()` |
| `useApi()` | `hooks/useApi.ts` | API 请求 | `const { data, loading } = useApi(url)` |
| `useLocalStorage()` | `hooks/useLocalStorage.ts` | 本地存储 | `const [value, setValue] = useLocalStorage(key)` |
| `useDebounce()` | `hooks/useDebounce.ts` | 防抖 Hook | `const debouncedValue = useDebounce(value, delay)` |

## 服务层

| 服务 | 位置 | 用途 | 主要方法 |
|------|------|------|---------|
| `AuthService` | `services/auth.ts` | 认证服务 | `login()`, `logout()`, `getUser()` |
| `ApiService` | `services/api.ts` | API 服务 | `get()`, `post()`, `put()`, `delete()` |
| `StorageService` | `services/storage.ts` | 存储服务 | `get()`, `set()`, `remove()` |

## 数据模型

| 模型 | 位置 | 用途 | 主要字段 |
|------|------|------|---------|
| `User` | `models/user.ts` | 用户模型 | `id, name, email` |
| `Product` | `models/product.ts` | 产品模型 | `id, name, price` |
| `Order` | `models/order.ts` | 订单模型 | `id, userId, products` |

## 配置模式

| 模式 | 位置 | 用途 | 使用示例 |
|------|------|------|---------|
| 环境变量 | `config/env.ts` | 环境配置 | `import { API_URL } from '@/config/env'` |
| 常量定义 | `config/constants.ts` | 常量管理 | `import { MAX_RETRY } from '@/config/constants'` |
| 主题配置 | `config/theme.ts` | 主题管理 | `import { colors } from '@/config/theme'` |

## 错误处理模式

| 模式 | 位置 | 用途 | 使用示例 |
|------|------|------|---------|
| 全局错误处理 | `utils/error.ts` | 错误捕获 | `handleError(error)` |
| API 错误处理 | `services/api.ts` | API 错误 | `catchApiError(error)` |
| 表单验证 | `utils/validation.ts` | 表单验证 | `validateForm(data, rules)` |

## 性能优化模式

| 模式 | 位置 | 用途 | 使用示例 |
|------|------|------|---------|
| 懒加载 | `utils/lazy.ts` | 组件懒加载 | `const LazyComponent = lazy(() => import('./Component'))` |
| 缓存 | `utils/cache.ts` | 数据缓存 | `cache.set(key, value, ttl)` |
| 虚拟列表 | `components/VirtualList.tsx` | 长列表优化 | `<VirtualList items={items} renderItem={renderItem} />` |

## 使用指南

### 如何使用可复用代码

1. **查找**: 在本文档中查找需要的功能
2. **导入**: 从指定位置导入
3. **使用**: 按照示例使用
4. **反馈**: 如有问题或改进建议，更新本文档

### 如何添加新的可复用代码

1. **识别**: 发现可复用的代码
2. **重构**: 确保代码通用、可配置
3. **测试**: 编写充分的测试
4. **文档**: 添加到本文档

### 注意事项

1. **不要修改**: 使用可复用代码时，不要修改原实现
2. **配置优先**: 优先使用配置而非硬编码
3. **类型安全**: 确保类型定义完整
4. **测试覆盖**: 确保有充分的测试

---

*最后更新: [日期]*
