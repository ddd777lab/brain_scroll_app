import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/user_onboarding_service.dart';
import 'services/user_activity_service.dart';
import 'theme/app_colors.dart';
import 'pages/home_page.dart';        // 大世界
import 'pages/marketplace_page.dart'; // 论坛
import 'pages/messages_page.dart';    // 消息
import 'pages/profile_page.dart';     // 我
import 'pages/create_page.dart';      // 发布
import 'pages/onboarding/login_page.dart'; // 登录

void main() {
  runApp(const BrainScrollApp());
}

class BrainScrollApp extends StatelessWidget {
  const BrainScrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => OnboardingService()),
        ChangeNotifierProvider(create: (_) => UserActivityService()),
      ],
      child: MaterialApp(
        title: '口袋轻研',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.grey,
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primaryDark,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        home: const OnboardingWrapper(),
      ),
    );
  }
}

/// Onboarding 包装器：根据完成状态决定显示登录页还是主页
class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({super.key});

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  @override
  void initState() {
    super.initState();
    // 初始化持久化服务
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<OnboardingService>().init();
      await context.read<UserActivityService>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingService>();

    // 初始化未完成，显示白屏
    if (!onboarding.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 如果已完成 onboarding，显示主应用；否则显示登录页
    if (onboarding.hasCompletedOnboarding) {
      return const MainScaffold();
    }
    return const LoginPage();
  }
}

class AppState extends ChangeNotifier {
  int _currentIndex = 2; // 默认选中大世界（索引 2）

  int get currentIndex => _currentIndex;

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack 顺序对应底部导航：发布、论坛、大世界、消息、我
      // 但发布是弹窗，所以实际页面是：论坛、大世界、消息、我
      body: IndexedStack(
        index: context.watch<AppState>().currentIndex - 1, // 减 1 是因为发布按钮占索引 0
        children: const [
          MarketplacePage(),  // 0: 论坛（对应底部索引 1）
          HomePage(),         // 1: 大世界（对应底部索引 2）
          MessagesPage(),     // 2: 消息（对应底部索引 3）
          ProfilePage(),      // 3: 我（对应底部索引 4）
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: BottomNavigationBar(
          currentIndex: context.watch<AppState>().currentIndex,
          onTap: (index) {
            if (index == 0) {
              // 发布按钮（最左边），特殊处理
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatePage()),
              );
            } else if (index >= 1 && index <= 4) {
              context.read<AppState>().updateIndex(index);
            }
          },
          selectedFontSize: 12,
          unselectedFontSize: 11,
          items: [
            // 0: 发布
            BottomNavigationBarItem(
              icon: Icon(Icons.add, size: 26),
              label: '',
            ),
            // 1: 论坛
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined, size: 24),
              activeIcon: Icon(Icons.store, size: 26),
              label: '论坛',
            ),
            // 2: 大世界（使用 assets/images/world_map_icon.png，默认选中）
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: 0.6,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/world_map_icon.png',
                    width: 34,
                    height: 34,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.public, size: 32, color: Colors.grey),
                  ),
                ),
              ),
              activeIcon: ClipOval(
                child: Image.asset(
                  'assets/images/world_map_icon.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              label: '大世界',
            ),
            // 3: 消息
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined, size: 24),
              activeIcon: Icon(Icons.notifications, size: 26),
              label: '消息',
            ),
            // 4: 我
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 24),
              activeIcon: Icon(Icons.person, size: 26),
              label: '我',
            ),
          ],
        ),
      ),
    );
  }
}
