# 反模式清单

> 以下是在项目中应该避免的代码模式。
> 遇到这些模式时，应该重构为更合适的实现。

## 代码反模式

### 1. 硬编码值

**反模式**:
```typescript
const API_URL = 'http://localhost:3000/api';
const MAX_ITEMS = 10;
```

**正确做法**:
```typescript
const API_URL = process.env.API_URL || 'http://localhost:3000/api';
const MAX_ITEMS = parseInt(process.env.MAX_ITEMS || '10', 10);
```

**原因**: 硬编码值难以维护，不便于配置和测试。

### 2. 魔法数字

**反模式**:
```typescript
if (status === 200) {
  // ...
}
setTimeout(callback, 3000);
```

**正确做法**:
```typescript
const HTTP_STATUS_OK = 200;
const DEBOUNCE_DELAY = 3000;

if (status === HTTP_STATUS_OK) {
  // ...
}
setTimeout(callback, DEBOUNCE_DELAY);
```

**原因**: 魔法数字难以理解，容易出错。

### 3. 过长的函数

**反模式**:
```typescript
function processUserData(user) {
  // 100+ 行代码
}
```

**正确做法**:
```typescript
function processUserData(user) {
  const validatedUser = validateUser(user);
  const transformedUser = transformUser(validatedUser);
  const savedUser = saveUser(transformedUser);
  return savedUser;
}
```

**原因**: 过长的函数难以理解、测试和维护。

### 4. 深层嵌套

**反模式**:
```typescript
if (user) {
  if (user.role) {
    if (user.role === 'admin') {
      // ...
    }
  }
}
```

**正确做法**:
```typescript
if (!user?.role || user.role !== 'admin') {
  return;
}
// ...
```

**原因**: 深层嵌套难以阅读，容易出错。

### 5. 重复代码

**反模式**:
```typescript
// 在多处重复的验证逻辑
function validateEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}
```

**正确做法**:
```typescript
// 提取到工具函数
import { validateEmail } from '@/utils/validation';
```

**原因**: 重复代码难以维护，容易出现不一致。

## 设计反模式

### 1. 上帝对象

**反模式**:
```typescript
class UserManager {
  // 包含所有用户相关的功能
  createUser() {}
  deleteUser() {}
  updateUser() {}
  validateUser() {}
  sendEmail() {}
  generateReport() {}
  // ...
}
```

**正确做法**:
```typescript
class UserService {
  createUser() {}
  deleteUser() {}
  updateUser() {}
}

class UserValidator {
  validateUser() {}
}

class NotificationService {
  sendEmail() {}
}
```

**原因**: 上帝对象职责过多，难以理解和维护。

### 2. 循环依赖

**反模式**:
```typescript
// moduleA.ts
import { functionB } from './moduleB';
export function functionA() { functionB(); }

// moduleB.ts
import { functionA } from './moduleA';
export function functionB() { functionA(); }
```

**正确做法**:
```typescript
// 将共享逻辑提取到第三个模块
// shared.ts
export function sharedFunction() {}

// moduleA.ts
import { sharedFunction } from './shared';

// moduleB.ts
import { sharedFunction } from './shared';
```

**原因**: 循环依赖会导致初始化问题和难以理解的代码。

### 3. 全局状态

**反模式**:
```typescript
// 全局变量
let globalState = {};

function updateGlobalState(newState) {
  globalState = { ...globalState, ...newState };
}
```

**正确做法**:
```typescript
// 使用状态管理库
import { createStore } from 'zustand';

const useStore = createStore((set) => ({
  state: {},
  updateState: (newState) => set((state) => ({ ...state, ...newState })),
}));
```

**原因**: 全局状态难以追踪，容易导致副作用。

## 性能反模式

### 1. 不必要的重新渲染

**反模式**:
```typescript
function Parent() {
  const [count, setCount] = useState(0);
  
  // 每次渲染都创建新的函数和对象
  const handleClick = () => setCount(count + 1);
  const style = { color: 'red' };
  
  return <Child onClick={handleClick} style={style} />;
}
```

**正确做法**:
```typescript
function Parent() {
  const [count, setCount] = useState(0);
  
  // 使用 useCallback 和 useMemo
  const handleClick = useCallback(() => setCount(count + 1), [count]);
  const style = useMemo(() => ({ color: 'red' }), []);
  
  return <Child onClick={handleClick} style={style} />;
}
```

**原因**: 不必要的重新渲染会影响性能。

### 2. 内存泄漏

**反模式**:
```typescript
useEffect(() => {
  const subscription = subscribe();
  // 忘记清理
}, []);
```

**正确做法**:
```typescript
useEffect(() => {
  const subscription = subscribe();
  return () => subscription.unsubscribe();
}, []);
```

**原因**: 内存泄漏会导致应用变慢甚至崩溃。

### 3. 阻塞主线程

**反模式**:
```typescript
// 同步处理大量数据
function processData(data) {
  return data.map(item => heavyComputation(item));
}
```

**正确做法**:
```typescript
// 使用 Web Worker 或分批处理
async function processData(data) {
  const results = [];
  for (let i = 0; i < data.length; i += 100) {
    const batch = data.slice(i, i + 100);
    const batchResults = await processBatch(batch);
    results.push(...batchResults);
    // 让出主线程
    await new Promise(resolve => setTimeout(resolve, 0));
  }
  return results;
}
```

**原因**: 阻塞主线程会导致 UI 卡顿。

## 安全反模式

### 1. 直接使用用户输入

**反模式**:
```typescript
// 直接使用用户输入
const query = `SELECT * FROM users WHERE id = ${userId}`;
```

**正确做法**:
```typescript
// 使用参数化查询
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);
```

**原因**: 直接使用用户输入会导致 SQL 注入。

### 2. 硬编码敏感信息

**反模式**:
```typescript
const API_KEY = 'sk-1234567890';
const DATABASE_PASSWORD = 'password123';
```

**正确做法**:
```typescript
const API_KEY = process.env.API_KEY;
const DATABASE_PASSWORD = process.env.DATABASE_PASSWORD;
```

**原因**: 硬编码敏感信息会导致安全漏洞。

### 3. 不验证输入

**反模式**:
```typescript
function createUser(data) {
  // 直接使用未验证的数据
  db.insert(data);
}
```

**正确做法**:
```typescript
function createUser(data) {
  const validatedData = validateUserData(data);
  db.insert(validatedData);
}
```

**原因**: 未验证的输入可能导致数据损坏和安全漏洞。

## 测试反模式

### 1. 测试实现细节

**反模式**:
```typescript
it('should call internal method', () => {
  const spy = jest.spyOn(component, 'internalMethod');
  component.publicMethod();
  expect(spy).toHaveBeenCalled();
});
```

**正确做法**:
```typescript
it('should produce expected output', () => {
  const result = component.publicMethod();
  expect(result).toBe(expectedOutput);
});
```

**原因**: 测试实现细节会导致测试脆弱，难以维护。

### 2. 测试间共享状态

**反模式**:
```typescript
let sharedState;

beforeEach(() => {
  sharedState = createSharedState();
});

it('test 1', () => {
  sharedState.value = 1;
  // ...
});

it('test 2', () => {
  // 依赖 test 1 的修改
  expect(sharedState.value).toBe(1);
});
```

**正确做法**:
```typescript
it('test 1', () => {
  const state = createSharedState();
  state.value = 1;
  // ...
});

it('test 2', () => {
  const state = createSharedState();
  // 独立的测试
  // ...
});
```

**原因**: 测试间共享状态会导致测试顺序依赖，难以调试。

## 如何识别反模式

1. **代码审查**: 通过代码审查发现反模式
2. **静态分析**: 使用 ESLint 等工具检测
3. **测试覆盖**: 低测试覆盖率可能暗示反模式
4. **性能监控**: 性能问题可能源于反模式

## 如何重构反模式

1. **识别**: 发现反模式
2. **理解**: 理解为什么是反模式
3. **计划**: 制定重构计划
4. **重构**: 逐步重构
5. **测试**: 确保重构后功能正常
6. **文档**: 更新文档

---

*最后更新: [日期]*
