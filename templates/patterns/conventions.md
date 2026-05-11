# 编码约定

> 本文档记录项目的编码约定，所有代码应遵循这些约定。

## 命名约定

### 文件命名

| 类型 | 约定 | 示例 |
|------|------|------|
| 组件 | PascalCase | `UserProfile.tsx` |
| 工具函数 | camelCase | `formatDate.ts` |
| 常量 | UPPER_SNAKE_CASE | `API_CONSTANTS.ts` |
| 类型定义 | PascalCase | `UserTypes.ts` |
| 测试文件 | 原文件名.test.ts | `UserProfile.test.tsx` |

### 变量命名

| 类型 | 约定 | 示例 |
|------|------|------|
| 变量 | camelCase | `userName` |
| 常量 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| 布尔值 | is/has/can 前缀 | `isLoading`, `hasError` |
| 函数 | camelCase | `getUserData()` |
| 类 | PascalCase | `UserService` |
| 接口 | PascalCase，无 I 前缀 | `UserData` |
| 类型 | PascalCase | `UserType` |

### CSS 命名

| 类型 | 约定 | 示例 |
|------|------|------|
| 类名 | kebab-case | `user-profile` |
| BEM 块 | kebab-case | `card` |
| BEM 元素 | __ 连接 | `card__header` |
| BEM 修饰符 | -- 连接 | `card--active` |

## 代码风格

### 缩进

- 使用 2 个空格缩进
- 不使用 Tab

### 分号

- 使用分号
- 每行语句末尾添加分号

### 引号

- 字符串使用单引号 `'`
- JSX 属性使用双引号 `"`
- 模板字符串使用反引号 `` ` ``

### 括号

- 控制语句使用大括号 `{}`，即使只有一行
- 箭头函数参数只有一个时，可省略括号 `x => x * 2`

### 空格

- 操作符前后加空格 `a + b`
- 逗号后加空格 `fn(a, b)`
- 冒号后加空格 `{ key: value }`
- 花括号内加空格 `{ key: value }`

### 换行

- 每行不超过 100 个字符
- 函数之间加空行
- 逻辑块之间加空行
- 文件末尾加空行

## 注释规范

### 文件注释

```typescript
/**
 * 用户服务模块
 * 处理用户相关的业务逻辑
 */
```

### 函数注释

```typescript
/**
 * 获取用户数据
 * @param userId - 用户 ID
 * @param options - 查询选项
 * @returns 用户数据
 * @throws {UserNotFoundError} 用户不存在时抛出
 */
async function getUserData(userId: string, options?: QueryOptions): Promise<User> {
  // ...
}
```

### 行内注释

```typescript
// 使用缓存避免重复请求
const cachedData = cache.get(key);
```

### TODO 注释

```typescript
// TODO: 优化查询性能
// FIXME: 修复内存泄漏问题
// HACK: 临时解决方案，需要重构
// XXX: 需要重新设计
```

## 导入规范

### 导入顺序

1. Node.js 内置模块
2. 第三方库
3. 项目内部模块
4. 相对路径模块

```typescript
// 1. Node.js 内置模块
import path from 'path';
import fs from 'fs';

// 2. 第三方库
import React from 'react';
import axios from 'axios';

// 3. 项目内部模块
import { UserService } from '@/services/user';
import { Button } from '@/components/Button';

// 4. 相对路径模块
import { helper } from './utils';
import { Props } from './types';
```

### 导入方式

```typescript
// 默认导入
import React from 'react';

// 命名导入
import { useState, useEffect } from 'react';

// 类型导入
import type { UserData } from '@/types/user';

// 整体导入
import * as utils from './utils';
```

## 错误处理

### 错误类型

```typescript
// 自定义错误类
class AppError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode: number
  ) {
    super(message);
    this.name = 'AppError';
  }
}
```

### 错误处理模式

```typescript
// try-catch 模式
try {
  const result = await riskyOperation();
} catch (error) {
  if (error instanceof AppError) {
    // 处理应用错误
  } else {
    // 处理未知错误
  }
}

// Promise 错误处理
promise
  .then(result => {
    // 处理成功
  })
  .catch(error => {
    // 处理错误
  });
```

## 测试规范

### 测试文件结构

```typescript
describe('ComponentName', () => {
  describe('when condition', () => {
    it('should expected behavior', () => {
      // Arrange
      const input = 'test';

      // Act
      const result = functionUnderTest(input);

      // Assert
      expect(result).toBe('expected');
    });
  });
});
```

### 测试命名

```typescript
// 函数测试
describe('formatDate', () => {
  it('should format date to YYYY-MM-DD', () => {});
  it('should handle invalid date', () => {});
});

// 组件测试
describe('Button', () => {
  it('should render with text', () => {});
  it('should call onClick when clicked', () => {});
});
```

## 类型规范

### 类型定义

```typescript
// 接口定义
interface User {
  id: string;
  name: string;
  email: string;
}

// 类型别名
type UserList = User[];

// 泛型
interface ApiResponse<T> {
  data: T;
  status: number;
  message: string;
}
```

### 类型使用

```typescript
// 变量类型
const user: User = { id: '1', name: 'John', email: 'john@example.com' };

// 函数参数类型
function greet(user: User): string {
  return `Hello, ${user.name}!`;
`

// 返回值类型
function getUser(): User {
  // ...
}
```

## 性能规范

### 避免不必要的渲染

```typescript
// 使用 React.memo
const MemoizedComponent = React.memo(Component);

// 使用 useMemo
const memoizedValue = useMemo(() => computeExpensiveValue(a, b), [a, b]);

// 使用 useCallback
const memoizedCallback = useCallback(() => {
  doSomething(a, b);
}, [a, b]);
```

### 避免内存泄漏

```typescript
// 清理副作用
useEffect(() => {
  const subscription = subscribe();
  return () => subscription.unsubscribe();
}, []);

// 取消请求
useEffect(() => {
  const controller = new AbortController();
  fetch(url, { signal: controller.signal });
  return () => controller.abort();
}, [url]);
```

## 安全规范

### 输入验证

```typescript
// 验证用户输入
function validateInput(input: string): boolean {
  // 检查长度
  if (input.length > 100) return false;
  // 检查特殊字符
  if (/[<>\"'&]/.test(input)) return false;
  return true;
}
```

### 数据转义

```typescript
// 转义 HTML
function escapeHtml(str: string): string {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}
```

---

*最后更新: [日期]*
