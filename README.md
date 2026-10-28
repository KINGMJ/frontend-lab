# Frontend Lab
> 从基础知识、组件实验到完整产品：一个以 React + TypeScript 和 Flutter + Dart 为核心的前端与跨平台应用工程实验室。


## 项目简介
`frontend-lab` 是一个长期维护的学习与实践仓库，不是单一产品，也不是零散 Demo 的集合。它围绕一条可验证的实践路径组织内容：

**基础知识（Fundamentals） → 独立实验（Playground） → 完整案例（Projects） → 总结与沉淀（Docs）**

当前目标：

- 重新掌握现代 React 开发：组件设计、Hooks、表单、路由、状态管理、数据获取及工程化。
- 系统学习 Flutter：Dart、Widget、布局、导航、状态管理、网络请求和移动端能力。
- 比较跨端实现思路：让同一个业务场景分别落地在 React Web 与 Flutter Mobile，理解两种框架的取舍。
- 完成真实产品：以个人记账应用 pocket-ledger 作为首个综合案例，打通界面、业务、API、数据与交付。


## 仓库结构
以下为推荐的目标结构。按学习进度逐步创建目录，无需一开始生成全部脚手架。

```text
frontend-lab/
├── README.md
├── docs/
│   ├── learning-roadmap.md       # 学习路线与阶段目标
│   └── notes/                   # 跨专题学习总结和工程决策
├── fundamentals/               # 语言与基础知识
│   ├── javascript/
│   ├── typescript/
│   └── dart/
├── playground/                 # 可独立运行的技术专题实验
│   ├── react/
│   │   ├── 01-components/
│   │   ├── 02-hooks/
│   │   ├── 03-forms/
│   │   ├── 04-routing/
│   │   ├── 05-state-management/
│   │   └── 06-data-visualization/
│   └── flutter/
│       ├── 01-widgets/
│       ├── 02-layout/
│       ├── 03-navigation/
│       ├── 04-state-management/
│       ├── 05-networking/
│       └── 06-animations/
├── projects/                   # 完整业务案例
│   └── pocket-ledger/
│       ├── web/                # React + TypeScript
│       ├── mobile/             # Flutter + Dart
│       ├── server/             # Go + PostgreSQL（后续阶段）
│       └── docs/               # 需求、原型、API、架构记录
└── shared/                     # 可选：经过验证后再抽取公共资源
    ├── design-tokens/
    └── api-contracts/
```

### 各目录职责

```md
| 目录 | 目的 | 内容边界 |
| --- | --- | --- |
| `fundamentals/` | 复习语言及基础原理 | 聚焦一个概念的最小示例 |
| `playground/react/` | 练习 React 与 Web 交互 | 可独立运行的组件、Hooks、表单等实验 |
| `playground/flutter/` | 练习 Flutter 与移动端交互 | Widget、布局、状态、动画等实验 |
| `projects/` | 从需求到交付完成真实应用 | 业务代码、测试、构建与部署 |
| `docs/` | 积累可迁移的学习和工程经验 | 路线图、技术笔记、决策与复盘 |
| `shared/` | 沉淀可复用资源（按需） | 设计令牌、API 契约等；不强行共享不同框架的 UI |
```

> 组织原则：实验代码与正式产品代码相互独立。不要直接让 projects/ 依赖 playground/；真正稳定且具备复用价值的内容再提炼到适当的公共包。

## 技术栈

```md
| 领域 | 初步选型 | 核心学习内容 |
| --- | --- | --- |
| React Web | React、TypeScript、Vite | 组件、Hooks、路由、表单与渲染机制 |
| Web UI | Tailwind CSS、shadcn/ui | 样式组织、组件复用、响应式布局 |
| Web 数据层 | TanStack Query、Zustand（按需） | 服务端状态与客户端状态的区分 |
| Flutter | Dart、Flutter、Material 3 | Widget 树、布局约束、生命周期 |
| Flutter 状态和导航 | Riverpod、go_router | 响应式状态、异步数据和路由 |
| Flutter 网络 | Dio（按需） | API 访问、错误处理 |
| 服务端（案例阶段） | Go、PostgreSQL、OpenAPI | 业务建模、接口契约和数据一致性 |
```

技术选型是学习基线，不是强制依赖清单；引入库之前先理解其解决的问题。前期可以使用 Mock 数据，不急于搭建完整后端。


## 学习与实践方式
每个专题尽量完成以下闭环：
1. 理解：说明问题、核心概念、适用场景。
2. 实验：独立写出最小可运行示例，观察不同写法的表现。
3. 验证：覆盖典型交互、边界条件与必要测试。
4. 迁移：把已掌握的能力应用到 pocket-ledger 的真实功能。
5. 总结：记录设计选择、踩坑与 React / Flutter 实现差异。
推荐的实验目录约定（根据专题复杂度灵活调整）：

```text
playground/react/03-forms/
├── README.md          # 学习目标、关键概念、运行方式
├── src/               # 示例实现
├── exercises/         # 自主练习（可选）
└── notes.md           # 实验观察和复盘（可选）
```

不必为每个小知识点创建独立工程；相近主题可共享一个 Vite / Flutter 示例工程，通过页面或示例入口切换。优先保证能运行、能理解、能复现。


## 开发原则
1. 先组件、后产品：先在 Playground 学会基础技术，再在完整案例中应用。
2. 先最小闭环、后扩展功能：不以功能数量代替学习质量。
3. 两个客户端共享业务规则和接口契约，不强求共享 UI 代码。
4. 先理解、再借助 AI 提速：核心组件、状态流与架构决策应能独立解释；AI 辅助代码审查、测试与重复工作。
5. 优先可运行的实例：文档说明对应代码如何启动、验证及复现。
6. 避免提前抽象：在出现明确复用需求前，不引入复杂 Monorepo 工具或公共包。

## 当前进度
- [x] 确定仓库定位与目录规划
- [x] 确定第一个实践项目：Pocket Ledger
- [ ] 初始化 React Playground
- [ ] 初始化 Flutter Playground
- [ ] 编写 docs/learning-roadmap.md
- [ ] 确定 Pocket Ledger MVP 页面与数据模型
- [ ] 完成第一个 React 组件实验
- [ ] 完成第一个 Flutter Widget 实验

## 参考资源
- [React 官方文档](https://react.dev/)
- [TypeScript 官方文档](https://www.typescriptlang.org/docs/)
- [Flutter 官方文档](https://docs.flutter.dev/)
- [Dart 官方文档](https://dart.dev/guides)
- [Vite 官方文档](https://vite.dev/)
- [Mobbin：产品交互参考](https://mobbin.com/)
- [Dribbble：界面视觉参考](https://dribbble.com/)

