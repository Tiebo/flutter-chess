# 路由系统文档 (Router System Documentation)

本文档详细介绍了项目中Go Router的实现方式、架构设计和后续开发指导。

## 目录
- [概述](#概述)
- [技术选型](#技术选型)
- [架构设计](#架构设计)
- [实现细节](#实现细节)
- [核心组件](#核心组件)
- [导航流程](#导航流程)
- [后续开发指导](#后续开发指导)
- [常见问题](#常见问题)

## 概述

本项目采用**Go Router**作为Flutter应用的路由管理解决方案，实现了：
- ✅ Tab间的直接切换（非push导航）
- ✅ 独立的stack导航页面
- ✅ 统一的返回按钮处理
- ✅ 类型安全的路由管理

## 技术选型

### 为什么选择Go Router？

| 特性 | Go Router | Navigator 2.0 | 传统Navigator |
|------|-----------|---------------|---------------|
| 声明式路由 | ✅ | ✅ | ❌ |
| URL支持 | ✅ | ✅ | ❌ |
| 类型安全 | ✅ | ⚠️ | ❌ |
| 学习成本 | 中 | 高 | 低 |
| 社区支持 | ✅ | ✅ | ✅ |

### 依赖版本
```yaml
go_router: ^14.0.0
```

## 架构设计

### 路由结构图
```
App Root (/)
├── MainPage (Tab容器)
│   ├── Tab: todo (/?tab=todo)
│   └── Tab: profile (/?tab=profile)
└── Settings Page (/settings) [Stack页面]
```

### 设计原则
1. **Tab导航**: 使用query参数实现直接切换，避免导航栈堆积
2. **Stack导航**: 独立页面使用push，可正常返回
3. **统一Header**: 公用组件处理返回逻辑
4. **类型安全**: 路由路径集中管理，避免硬编码

## 实现细节

### 1. 路由配置 (`lib/router/app_router.dart`)

```dart
class AppRouter {
  static const String main = '/';
  static const String settings = '/settings';

  static final GoRouter _router = GoRouter(
    initialLocation: main,
    routes: [
      GoRoute(
        path: main,
        builder: (context, state) {
          final tab = state.uri.queryParameters['tab'] ?? 'todo';
          return MainPage(initialTab: tab);
        },
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );

  static GoRouter get router => _router;
  
  static void goToTab(BuildContext context, String tab) {
    context.go('/?tab=$tab');
  }
}
```

**核心设计思路：**
- 使用query参数(`?tab=todo`)区分不同tab
- `goToTab`方法统一处理tab切换
- 路径常量化避免硬编码错误

### 2. 主页面实现 (`lib/pages/main_page.dart`)

```dart
class MainPage extends StatefulWidget {
  final String initialTab;
  const MainPage({super.key, required this.initialTab});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;
  
  final List<Widget> _pages = [
    const TodoPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab == 'profile' ? 1 : 0;
  }

  @override
  void didUpdateWidget(MainPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab) {
      setState(() {
        _currentIndex = widget.initialTab == 'profile' ? 1 : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          final tab = index == 1 ? 'profile' : 'todo';
          AppRouter.goToTab(context, tab);
        },
        items: [...],
      ),
    );
  }
}
```

**关键实现点：**
- `didUpdateWidget`监听路由参数变化
- `_pages`数组直接切换页面内容
- 避免了Navigator的push/pop操作

### 3. 公用Header组件 (`lib/widgets/common/common_header.dart`)

```dart
class CommonHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      leading: showBackButton && context.canPop()
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => context.pop(),
            )
          : null,
      actions: actions,
    );
  }
}
```

**智能返回处理：**
- `context.canPop()`检查是否可返回
- 避免"There is nothing to pop"错误
- 支持自定义返回逻辑

## 核心组件

### 1. AppRouter (路由管理器)
- **位置**: `lib/router/app_router.dart`
- **职责**: 路由配置、路径管理、导航方法
- **关键方法**: `goToTab()`, `router`

### 2. MainPage (Tab容器)
- **位置**: `lib/pages/main_page.dart`
- **职责**: Tab切换、底部导航、页面容器
- **关键状态**: `_currentIndex`, `initialTab`

### 3. CommonHeader (公用标题栏)
- **位置**: `lib/widgets/common/common_header.dart`
- **职责**: 统一返回逻辑、标题显示
- **关键方法**: `canPop()`检查

## 导航流程

### Tab切换流程
```
用户点击Tab → onTap回调 → AppRouter.goToTab() 
→ context.go('/?tab=xxx') → GoRouter重建MainPage 
→ didUpdateWidget触发 → setState更新_currentIndex 
→ 页面直接切换
```

### Stack页面导航
```
用户点击设置 → context.push('/settings') 
→ 推入新页面到导航栈 → 显示CommonHeader 
→ 点击返回 → context.pop() → 回到原页面
```

## 后续开发指导

### 添加新的Tab页面

1. **创建页面组件**
```dart
// lib/pages/new_tab_page.dart
class NewTabPage extends StatelessWidget {
  const NewTabPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('新Tab')),
      body: Center(child: Text('新Tab内容')),
    );
  }
}
```

2. **更新MainPage**
```dart
// 在_pages数组中添加
final List<Widget> _pages = [
  const TodoPage(),
  const ProfilePage(),
  const NewTabPage(), // 新增
];

// 在BottomNavigationBar中添加item
items: [
  BottomNavigationBarItem(
    icon: const Icon(Icons.list),
    label: l10n.todo,
  ),
  BottomNavigationBarItem(
    icon: const Icon(Icons.person),
    label: l10n.profile,
  ),
  BottomNavigationBarItem( // 新增
    icon: const Icon(Icons.new_releases),
    label: '新Tab',
  ),
],

// 更新onTap逻辑
onTap: (index) {
  String tab = 'todo';
  switch (index) {
    case 0: tab = 'todo'; break;
    case 1: tab = 'profile'; break;
    case 2: tab = 'new_tab'; break; // 新增
  }
  AppRouter.goToTab(context, tab);
},

// 更新初始化逻辑
@override
void initState() {
  super.initState();
  switch (widget.initialTab) {
    case 'profile': _currentIndex = 1; break;
    case 'new_tab': _currentIndex = 2; break; // 新增
    default: _currentIndex = 0;
  }
}
```

### 添加新的Stack页面

1. **在AppRouter中添加路由**
```dart
class AppRouter {
  static const String main = '/';
  static const String settings = '/settings';
  static const String newPage = '/new-page'; // 新增

  static final GoRouter _router = GoRouter(
    initialLocation: main,
    routes: [
      // 现有路由...
      GoRoute( // 新增
        path: newPage,
        builder: (context, state) => const NewStackPage(),
      ),
    ],
  );
}
```

2. **创建页面并使用CommonHeader**
```dart
class NewStackPage extends StatelessWidget {
  const NewStackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        title: '新页面',
      ),
      body: const Center(
        child: Text('新Stack页面内容'),
      ),
    );
  }
}
```

3. **在其他页面中导航**
```dart
// 使用push进入Stack页面
onTap: () => context.push(AppRouter.newPage),
```

### 传递参数的页面

1. **在路由中定义参数**
```dart
GoRoute(
  path: '/detail/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return DetailPage(id: id);
  },
),
```

2. **导航时传递参数**
```dart
context.push('/detail/123');
```

### 页面级权限控制

```dart
GoRoute(
  path: '/admin',
  builder: (context, state) => const AdminPage(),
  redirect: (context, state) {
    // 检查用户权限
    if (!UserService.isAdmin) {
      return '/login';
    }
    return null; // 允许访问
  },
),
```

## 最佳实践

### 1. 路由命名规范
```dart
// ✅ 使用kebab-case
static const String userProfile = '/user-profile';

// ❌ 避免驼峰命名
static const String userProfile = '/userProfile';
```

### 2. 参数传递
```dart
// ✅ 简单参数使用路径参数
context.push('/detail/$itemId');

// ✅ 复杂参数使用extra
context.push('/detail', extra: complexObject);

// ❌ 避免过长的查询参数
context.push('/detail?param1=xxx&param2=yyy&param3=zzz');
```

### 3. 错误处理
```dart
static final GoRouter _router = GoRouter(
  // ...
  errorBuilder: (context, state) => ErrorPage(
    error: state.error,
  ),
);
```

## 常见问题

### Q: Tab切换时为什么会有push动画？
A: 检查是否使用了`context.go()`而不是`context.push()`。Tab切换应该使用`AppRouter.goToTab()`。

### Q: 返回按钮点击时报"Nothing to pop"错误？
A: 使用`context.canPop()`检查是否可以返回，或者使用CommonHeader组件。

### Q: 如何保持Tab页面状态？
A: 在MainPage中使用`AutomaticKeepAliveClientMixin`或者状态管理（Provider/Bloc）。

```dart
class _TodoPageState extends State<TodoPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用
    return Scaffold(/* ... */);
  }
}
```

### Q: 如何处理深链接？
A: Go Router自动支持深链接，确保路由路径定义正确即可：

```dart
// 支持 myapp://host/settings
GoRoute(
  path: '/settings',
  builder: (context, state) => const SettingsPage(),
),
```

## 性能优化建议

1. **懒加载页面**
```dart
GoRoute(
  path: '/heavy-page',
  builder: (context, state) => const HeavyPage(),
  // 或者
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: const HeavyPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  },
),
```

2. **避免不必要的重建**
```dart
// 使用const构造函数
const TodoPage()
// 而不是
TodoPage()
```

3. **预加载关键页面**
```dart
// 在应用启动时预热路由
GoRouter.of(context).go('/preload');
GoRouter.of(context).pop();
```

---

**文档版本**: 1.0  
**最后更新**: 2024-12-06  
**维护者**: Development Team  

如有问题，请参考[Go Router官方文档](https://pub.dev/packages/go_router)或联系开发团队。