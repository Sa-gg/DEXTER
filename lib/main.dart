import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const TanimTapApp());
}

class TanimTapApp extends StatelessWidget {
  const TanimTapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TanimTap',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2ECC71),
        brightness: Brightness.light,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge:
            TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.5),
        displayMedium:
            TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.25),
        headlineLarge: TextStyle(fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontWeight: FontWeight.w500),
        titleLarge: TextStyle(fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(letterSpacing: 0.15),
        bodyMedium: TextStyle(letterSpacing: 0.25),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2ECC71),
        brightness: Brightness.dark,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge:
            TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.5),
        displayMedium:
            TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.25),
        headlineLarge: TextStyle(fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontWeight: FontWeight.w500),
        titleLarge: TextStyle(fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(letterSpacing: 0.15),
        bodyMedium: TextStyle(letterSpacing: 0.25),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _startAnimations();
  }

  void _startAnimations() {
    // Start animations immediately without delays for testing compatibility
    if (mounted) {
      _fadeController.forward();
      _slideController.forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0F1419),
                    const Color(0xFF1B2328),
                  ]
                : [
                    const Color(0xFFF0F9FF),
                    const Color(0xFFE0F2FE),
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        // Logo
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.eco,
                            size: 60,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Title
                        Text(
                          'TanimTap',
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontSize: 48,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          'grow mindfully, impact daily',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Description
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Turn everyday eco-actions into a thriving digital forest. Every small step counts.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Get Started Button
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const MainScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                  opacity: animation, child: child);
                            },
                            transitionDuration:
                                const Duration(milliseconds: 300),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Start Growing',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomeScreen(onTabChanged: _onTabTapped),
          TreeProgressScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.forest_outlined),
            selectedIcon: Icon(Icons.forest),
            label: 'Forest',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChanged;

  const HomeScreen({super.key, required this.onTabChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.eco,
                                        color: theme.colorScheme.onPrimary,
                                        size: 36,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Welcome back! 🌱',
                                              style: theme
                                                  .textTheme.headlineSmall
                                                  ?.copyWith(
                                                color:
                                                    theme.colorScheme.onPrimary,
                                                fontWeight: FontWeight.w700,
                                                fontSize:
                                                    constraints.maxWidth < 300
                                                        ? 16
                                                        : 20,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Let\'s grow something amazing today',
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: theme
                                                    .colorScheme.onPrimary
                                                    .withOpacity(0.9),
                                                fontSize:
                                                    constraints.maxWidth < 300
                                                        ? 11
                                                        : 13,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Weekly Streak Tracker
                                  _buildWeeklyStreak(
                                      theme, constraints.maxWidth < 350),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                title: Container(), // Empty title when collapsed
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Quick Actions
                  _buildSectionTitle('Quick Actions', theme),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          'Start Challenge',
                          Icons.flash_on,
                          theme.colorScheme.primary,
                          () => _startDailyChallenge(),
                          theme,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionCard(
                          'View Progress',
                          Icons.trending_up,
                          theme.colorScheme.secondary,
                          () => _viewProgress(),
                          theme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const SizedBox(height: 32),

                  // Feature Navigation Cards
                  _buildSectionTitle('Explore Features', theme),
                  const SizedBox(height: 16),
                  _buildFeatureGrid(theme),

                  const SizedBox(height: 32),

                  // Impact Cards
                  _buildSectionTitle('Your Impact', theme),
                  const SizedBox(height: 16),
                  _buildImpactCard(
                    'Trees Grown',
                    '12',
                    'This month',
                    Icons.forest,
                    theme,
                  ),
                  const SizedBox(height: 12),
                  _buildImpactCard(
                    'CO₂ Saved',
                    '45kg',
                    'Total impact',
                    Icons.air,
                    theme,
                  ),
                  const SizedBox(height: 12),
                  _buildImpactCard(
                    'Daily Streak',
                    '7 days',
                    'Keep it up!',
                    Icons.local_fire_department,
                    theme,
                  ),

                  const SizedBox(height: 32),

                  // Today's Eco Habits
                  _buildSectionTitle('Today\'s Habits', theme),
                  const SizedBox(height: 16),
                  _buildCompactHabitsCard(theme),

                  const SizedBox(height: 32),

                  // Eco Tips
                  _buildSectionTitle('Eco Tips', theme),
                  const SizedBox(height: 16),
                  _buildEcoTipCard(
                    'Did you know?',
                    'A single tree can absorb about 48 pounds of CO₂ per year! 🌳',
                    theme,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color,
      VoidCallback onTap, ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImpactCard(String title, String value, String subtitle,
      IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcoTipCard(String title, String content, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                'Eco Habits',
                'Track your daily habits',
                Icons.eco,
                Colors.green,
                () => _navigateToHabits(),
                theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                'Donate Trees',
                'Plant real trees',
                Icons.forest,
                Colors.orange,
                () => _navigateToDonation(),
                theme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                'Rankings',
                'See your ranking',
                Icons.emoji_events,
                Colors.purple,
                () => _navigateToLeaderboard(),
                theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                'Commitments',
                'Make eco pledges',
                Icons.add_circle,
                Colors.blue,
                () => _navigateToCommitments(),
                theme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String title, String subtitle, IconData icon,
      Color color, VoidCallback onTap, ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToHabits() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HabitTrackerScreen()),
    );
  }

  void _navigateToDonation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DonationScreen()),
    );
  }

  void _navigateToLeaderboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
    );
  }

  void _navigateToCommitments() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CommitmentScreen()),
    );
  }

  Widget _buildCompactHabitsCard(ThemeData theme) {
    final habits = [
      {'name': 'Use reusable bottle', 'completed': true, 'icon': '💧'},
      {'name': 'Walk instead of drive', 'completed': false, 'icon': '🚶'},
      {'name': 'Recycle properly', 'completed': true, 'icon': '♻️'},
    ];

    int completedCount = habits.where((h) => h['completed'] == true).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Habits',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$completedCount/${habits.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...habits
              .map((habit) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              habit['completed'] =
                                  !(habit['completed'] as bool);
                            });
                            HapticFeedback.lightImpact();
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: habit['completed'] as bool
                                  ? Colors.green
                                  : Colors.transparent,
                              border: Border.all(
                                color: habit['completed'] as bool
                                    ? Colors.green
                                    : theme.colorScheme.outline,
                                width: 2,
                              ),
                            ),
                            child: habit['completed'] as bool
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 12)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          habit['icon'] as String,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            habit['name'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              decoration: habit['completed'] as bool
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: habit['completed'] as bool
                                  ? theme.colorScheme.onSurface.withOpacity(0.6)
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  // Weekly streak data - true means completed that day
  final List<Map<String, dynamic>> _weeklyStreak = [
    {'day': 'Mon', 'completed': true},
    {'day': 'Tue', 'completed': true},
    {'day': 'Wed', 'completed': true},
    {'day': 'Thu', 'completed': false}, // Today - not completed yet
    {'day': 'Fri', 'completed': false},
    {'day': 'Sat', 'completed': false},
    {'day': 'Sun', 'completed': false},
  ];

  Widget _buildWeeklyStreak(ThemeData theme, bool isCompact) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onPrimary.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Streak info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange[400],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '3 Day Streak',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Keep it up! 🔥',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Week dots
          Row(
            children: _weeklyStreak.asMap().entries.map((entry) {
              final dayData = entry.value;
              final isCompleted = dayData['completed'] as bool;
              final dayName = dayData['day'] as String;
              final isToday = dayName == 'Thu';

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.orange[400]
                            : isToday
                                ? theme.colorScheme.onPrimary.withOpacity(0.4)
                                : theme.colorScheme.onPrimary.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: isToday && !isCompleted
                            ? Border.all(
                                color: theme.colorScheme.onPrimary
                                    .withOpacity(0.6),
                                width: 1,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      dayName.substring(0, 1),
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary
                            .withOpacity(isCompleted ? 0.9 : 0.6),
                        fontSize: 7,
                        fontWeight:
                            isCompleted ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _startDailyChallenge() {
    // Navigate to habit tracker for daily eco challenges
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HabitTrackerScreen(),
      ),
    );
  }

  void _viewProgress() {
    // Navigate to the Forest tab to view tree progress
    widget.onTabChanged(1); // Index 1 is the Forest tab
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Check your tree growing progress! 🌳'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDonationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.volunteer_activism, color: Colors.green[600]),
              const SizedBox(width: 8),
              const Text('Plant Real Trees'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your donation helps plant real trees around the world! Choose an amount to contribute:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDonationButton('\$5', 5.0),
                  _buildDonationButton('\$10', 10.0),
                  _buildDonationButton('\$25', 25.0),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDonationButton('\$50', 50.0),
                  _buildDonationButton('\$100', 100.0),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Maybe Later'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDonationButton(String label, double amount) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        // Donation processing removed
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
  }

  void _completeEcoHabit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.eco, color: Colors.white),
            const SizedBox(width: 8),
            const Text('Eco habit completed! Keep up the great work! 🌱'),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.lightGreen[600],
      ),
    );

    // In production, this would track real eco habits
    // For demo, we'll simulate a habit completion
  }
}

class TreeProgressScreen extends StatefulWidget {
  const TreeProgressScreen({super.key});

  @override
  State<TreeProgressScreen> createState() => _TreeProgressScreenState();
}

class _TreeProgressScreenState extends State<TreeProgressScreen>
    with TickerProviderStateMixin {
  late AnimationController _treeGrowthController;
  late Animation<double> _treeGrowthAnimation;
  late AnimationController _particleController;
  late Animation<double> _particleAnimation;
  late AnimationController _weatherController;
  late Animation<double> _weatherAnimation;
  int _treeLevel = 3;
  int _totalTaps = 120;
  DateTime? _lastTapTime;
  bool _isShowingSnackBar = false;
  String _currentSeason =
      'day'; // day, night, morning-sakura, morning-autumn, morning-rainy, morning-winter
  int _seasonIndex = 0; // Index to cycle through seasons automatically
  String _currentWeather = 'sunny'; // sunny, cloudy, rainy, snowy, sakura
  bool _isDayTime = true;
  List<Map<String, double>> _rainParticles = [];
  List<Map<String, double>> _seasonalParticles = [];

  // Achievement System Variables
  double _totalDonations = 0.0; // Total money donated for tree planting
  int _consistencyStreak = 0; // Days of consistent eco habits
  DateTime? _lastHabitDate; // Last date user completed eco habits
  List<String> _unlockedBadges = []; // List of earned badge IDs
  List<String> _unlockedAssets = []; // List of unlocked forest assets
  Map<String, bool> _achievements = {}; // Achievement completion status

  // Tree type tracking system
  Map<String, int> _treeTypeCount = {
    'tap': 0, // Trees from tapping
    'donation': 0, // Trees from donations
    'event': 0, // Trees from events
    'streak': 0, // Trees from consistency streaks
    'golden': 0, // Special golden trees
    'sakura': 0, // Limited sakura trees
    'ancient': 0, // Rare ancient trees
    'crystal': 0, // Limited crystal trees
    'rainbow': 0, // Rainbow trees from seasonal achievements
  };
  List<Map<String, dynamic>> _forestTrees =
      []; // Individual tree data with types

  // Achievement definitions
  static const List<Map<String, dynamic>> _achievementList = [
    {
      'id': 'first_donation',
      'title': 'Tree Planter',
      'description': 'Make your first donation to plant real trees',
      'requirement': 'donation_amount',
      'target': 5.0,
      'reward': 'badge',
      'rewardData': {
        'badge': 'tree_planter',
        'asset': 'golden_sapling',
        'treeType': 'donation'
      },
      'icon': Icons.volunteer_activism,
    },
    {
      'id': 'generous_donor',
      'title': 'Forest Guardian',
      'description': 'Donate \$50 or more for tree planting',
      'requirement': 'donation_amount',
      'target': 50.0,
      'reward': 'special_tree',
      'rewardData': {
        'theme': 'golden_forest',
        'badge': 'forest_guardian',
        'treeType': 'golden'
      },
      'icon': Icons.forest,
    },
    {
      'id': 'major_contributor',
      'title': 'Earth Hero',
      'description': 'Donate \$100 or more for environmental causes',
      'requirement': 'donation_amount',
      'target': 100.0,
      'reward': 'special_asset',
      'rewardData': {
        'asset': 'rainbow_trees',
        'badge': 'earth_hero',
        'treeType': 'ancient'
      },
      'icon': Icons.public,
    },
    {
      'id': 'habit_starter',
      'title': 'Eco Beginner',
      'description': 'Complete eco habits for 3 consecutive days',
      'requirement': 'consistency_streak',
      'target': 3,
      'reward': 'badge',
      'rewardData': {
        'badge': 'eco_beginner',
        'asset': 'flower_patch',
        'treeType': 'streak'
      },
      'icon': Icons.eco,
    },
    {
      'id': 'habit_master',
      'title': 'Green Champion',
      'description': 'Maintain eco habits for 7 consecutive days',
      'requirement': 'consistency_streak',
      'target': 7,
      'reward': 'special_tree',
      'rewardData': {
        'theme': 'spring_meadow',
        'badge': 'green_champion',
        'treeType': 'streak'
      },
      'icon': Icons.emoji_events,
    },
    {
      'id': 'eco_legend',
      'title': 'Sustainability Legend',
      'description': 'Keep eco habits for 30 consecutive days',
      'requirement': 'consistency_streak',
      'target': 30,
      'reward': 'special_asset',
      'rewardData': {
        'asset': 'ancient_oak',
        'badge': 'eco_legend',
        'treeType': 'rainbow'
      },
      'icon': Icons.stars,
    },
    {
      'id': 'tree_collector',
      'title': 'Tree Collector',
      'description': 'Grow 50 trees in your forest',
      'requirement': 'tree_count',
      'target': 50,
      'reward': 'asset',
      'rewardData': {'asset': 'mystical_grove', 'treeType': 'golden'},
      'icon': Icons.park,
    },
    {
      'id': 'tap_master',
      'title': 'Tap Master',
      'description': 'Plant 25 trees by tapping',
      'requirement': 'tap_trees',
      'target': 25,
      'reward': 'special_tree',
      'rewardData': {'badge': 'tap_master', 'treeType': 'crystal'},
      'icon': Icons.touch_app,
    },
    {
      'id': 'event_participant',
      'title': 'Event Participant',
      'description': 'Join a tree planting event',
      'requirement': 'events',
      'target': 1,
      'reward': 'limited_tree',
      'rewardData': {'badge': 'event_badge', 'treeType': 'sakura'},
      'icon': Icons.celebration,
    },
    {
      'id': 'seasonal_master',
      'title': 'Seasonal Master',
      'description': 'Experience all 6 forest seasons',
      'requirement': 'seasonal_experience',
      'target': 6,
      'reward': 'rainbow_tree',
      'rewardData': {'badge': 'seasonal_master', 'treeType': 'rainbow'},
      'icon': Icons.wb_twilight,
    },
    {
      'id': 'earth_week_special',
      'title': 'Earth Week Champion',
      'description': 'Limited time achievement during Earth Week!',
      'requirement': 'limited_time',
      'target': 1,
      'reward': 'crystal_tree',
      'rewardData': {'badge': 'earth_week', 'treeType': 'crystal'},
      'icon': Icons.diamond,
      'timeLimit': true,
    },
  ];

  Widget _buildTreeCollectionShowcase(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tree Collection',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '5/12 Types',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tree Type Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 0.85,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _buildTreeTypeCard('Tap Trees', Icons.park, Colors.green[400]!,
                    '25', 'Tap to grow', true, theme),
                _buildTreeTypeCard('Donation Trees', Icons.volunteer_activism,
                    Colors.green[600]!, '8', 'Donate \$5+', true, theme),
                _buildTreeTypeCard('Golden Trees', Icons.auto_awesome,
                    Colors.amber, '3', 'Donate \$50+', true, theme),
                _buildTreeTypeCard('Ancient Trees', Icons.forest,
                    Colors.brown[800]!, '1', 'Donate \$100+', true, theme),
                _buildTreeTypeCard('Streak Trees', Icons.eco, Colors.teal, '12',
                    '3+ day streak', true, theme),
                _buildTreeTypeCard('Sakura Trees', Icons.local_florist,
                    Colors.pink[300]!, '0', 'Join events', false, theme),
                _buildTreeTypeCard('Crystal Trees', Icons.diamond, Colors.cyan,
                    '0', 'Earth Week only', false, theme),
                _buildTreeTypeCard('Rainbow Trees', Icons.gradient,
                    Colors.purple, '0', 'All seasons', false, theme),
                _buildTreeTypeCard('Legendary Trees', Icons.stars,
                    Colors.amber[700]!, '0', '30+ day streak', false, theme),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Achievement Progress
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Achievements',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                _buildAchievementProgressCard(
                    'Sakura Trees',
                    'Join a tree planting event',
                    Icons.local_florist,
                    Colors.pink[300]!,
                    0.0,
                    theme),
                const SizedBox(height: 6),
                _buildAchievementProgressCard(
                    'Crystal Trees',
                    'Available during Earth Week (April 15-22)',
                    Icons.diamond,
                    Colors.cyan,
                    0.0,
                    theme),
                const SizedBox(height: 6),
                _buildAchievementProgressCard(
                    'Rainbow Trees',
                    'Experience all 6 seasons',
                    Icons.gradient,
                    Colors.purple,
                    0.4,
                    theme),
                const SizedBox(height: 6),
                _buildAchievementProgressCard(
                    'Legendary Trees',
                    '30-day streak (Current: 8 days)',
                    Icons.stars,
                    Colors.amber[700]!,
                    0.27,
                    theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeTypeCard(String name, IconData icon, Color color,
      String count, String requirement, bool unlocked, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: unlocked
            ? theme.colorScheme.surface
            : theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked
              ? color.withOpacity(0.3)
              : theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect for special trees
              if (unlocked &&
                  (name.contains('Golden') || name.contains('Crystal')))
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              Icon(
                icon,
                size: 28,
                color: unlocked
                    ? color
                    : theme.colorScheme.outline.withOpacity(0.5),
              ),
              if (!unlocked)
                Icon(
                  Icons.lock,
                  size: 16,
                  color: theme.colorScheme.outline,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: unlocked
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          if (unlocked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          const SizedBox(height: 2),
          Text(
            requirement,
            style: TextStyle(
              fontSize: 8,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementProgressCard(String title, String description,
      IconData icon, Color color, double progress, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 3,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  double _getTreeSizeForType(String type) {
    switch (type) {
      case 'golden':
        return 35.0;
      case 'ancient':
        return 40.0;
      case 'crystal':
        return 30.0;
      case 'sakura':
        return 25.0;
      case 'rainbow':
        return 32.0;
      case 'donation':
        return 28.0;
      case 'event':
        return 26.0;
      case 'streak':
        return 24.0;
      default:
        return 20.0; // tap trees
    }
  }

  Color _getTreeColorForType(String type) {
    switch (type) {
      case 'golden':
        return Colors.amber;
      case 'ancient':
        return Colors.brown[800]!;
      case 'crystal':
        return Colors.cyan;
      case 'sakura':
        return Colors.pink[300]!;
      case 'rainbow':
        return Colors.purple;
      case 'donation':
        return Colors.green[600]!;
      case 'event':
        return Colors.lightGreen;
      case 'streak':
        return Colors.teal;
      default:
        return Colors.green[400]!;
    }
  }

  Map<String, dynamic> _getTreeSpecialEffects(String type) {
    switch (type) {
      case 'golden':
        return {'glow': true, 'particles': 'gold'};
      case 'crystal':
        return {'shine': true, 'particles': 'sparkle'};
      case 'rainbow':
        return {'colorShift': true, 'particles': 'rainbow'};
      case 'ancient':
        return {'thick': true, 'branches': 'extra'};
      case 'sakura':
        return {'petals': true, 'particles': 'pink'};
      default:
        return {};
    }
  }

  // Get season-based icon for Level stat card
  IconData get _currentSeasonIcon {
    switch (_currentSeason) {
      case 'day':
        return Icons.wb_sunny;
      case 'night':
        return Icons.nightlight_round;
      case 'morning-sakura':
        return Icons.local_florist;
      case 'morning-autumn':
        return Icons.eco;
      case 'morning-rainy':
        return Icons.grain;
      case 'morning-winter':
        return Icons.ac_unit;
      default:
        return Icons.trending_up;
    }
  }

  // Determine day/night based on current season
  bool get isCurrentlyDayTime => !_currentSeason.startsWith('night');

  @override
  void initState() {
    super.initState();
    _treeGrowthController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _treeGrowthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _treeGrowthController, curve: Curves.easeInOut),
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _weatherController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _weatherAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _weatherController, curve: Curves.easeInOut),
    );

    _treeGrowthController.forward();
    _particleController.repeat();
    _weatherController.repeat();

    // Initialize rain particles (80 for dense coverage)
    _initializeRainParticles();
    // Initialize seasonal particles
    _initializeSeasonalParticles();

    // Simulate weather and day/night changes
    _simulateEnvironment();
  }

  @override
  void dispose() {
    _treeGrowthController.dispose();
    _particleController.dispose();
    _weatherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.only(left: 24, right: 24, bottom: 16),
              title: LayoutBuilder(
                builder: (context, constraints) {
                  // Adjust layout based on available space
                  final isCollapsed = constraints.maxHeight <= 80;

                  if (isCollapsed) {
                    // Simple title when collapsed
                    return Text(
                      'Your Forest',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    );
                  }

                  // Full layout when expanded
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Forest',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tap to grow 🌳',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.1),
                      theme.colorScheme.secondary.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 80.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Enhanced Forest Visualization
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isCurrentlyDayTime
                          ? [
                              Colors.lightBlue[100]!.withOpacity(0.3),
                              theme.colorScheme.surface,
                            ]
                          : [
                              Colors.indigo[900]!.withOpacity(0.4),
                              Colors.indigo[800]!.withOpacity(0.2),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // Sky with weather effects
                        _buildSkyBackground(theme),
                        // Floating particles (leaves, sparkles)
                        _buildFloatingParticles(),
                        // Forest Grid
                        AnimatedBuilder(
                          animation: _treeGrowthAnimation,
                          builder: (context, child) =>
                              _buildEnhancedForestGrid(theme),
                        ),
                        // Weather overlay
                        _buildWeatherEffects(),
                        // Day/Night indicator
                        Positioned(
                          top: 16,
                          left: 16,
                          child: _buildTimeIndicator(theme),
                        ),
                        // Share Button
                        Positioned(
                          top:
                              55, // Moved down for better spacing with tree count indicator
                          right: 16,
                          child: _buildShareButton(theme),
                        ),
                        // Interactive elements info
                        Positioned(
                          bottom: 25, // Moved closer to bottom
                          left: 20,
                          child: _buildForestStats(theme),
                        ),
                        // Enhanced Tap to Grow Button
                        Positioned(
                          bottom: 15,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: _tapTree,
                              onLongPress: _triggerSpecialEffect,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.touch_app,
                                      color: theme.colorScheme.onPrimary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Grow Forest',
                                      style: TextStyle(
                                        color: theme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Progress Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Level',
                        _treeLevel.toString(),
                        _currentSeasonIcon,
                        theme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Trees',
                        _getTreeCount().toString(),
                        Icons.forest,
                        theme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Next Level',
                        '${200 - (_totalTaps % 200)}',
                        Icons.flag,
                        theme,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Tree Collection Showcase
                _buildTreeCollectionShowcase(theme),

                const SizedBox(height: 24),

                // Progress Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress to Level ${_treeLevel + 1}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: (_totalTaps % 200) / 200,
                        backgroundColor: theme.colorScheme.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_totalTaps % 200} / 200 taps',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Achievement Grid
                Text(
                  'Achievements',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildAchievementCard(
                        'First Tap', Icons.touch_app, true, theme),
                    _buildAchievementCard(
                        'Green Thumb', Icons.eco, true, theme),
                    _buildAchievementCard(
                        'Tree Hugger', Icons.forest, _treeLevel >= 3, theme),
                    _buildAchievementCard(
                        'Eco Warrior', Icons.shield, false, theme),
                    _buildAchievementCard('Nature Love', Icons.favorite,
                        _totalTaps >= 100, theme),
                    _buildAchievementCard(
                        'Consistent', Icons.schedule, false, theme),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
      String title, IconData icon, bool achieved, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: achieved
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: achieved
              ? theme.colorScheme.primary.withOpacity(0.3)
              : theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: achieved
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.3),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: achieved
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.5),
              fontWeight: achieved ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _simulateEnvironment() {
    // Season controls day/night appearance - no separate timer needed

    // Change seasons every 5 seconds for demo
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        final seasons = [
          'day',
          'night',
          'morning-sakura',
          'morning-autumn',
          'morning-rainy',
          'morning-winter'
        ];
        setState(() {
          _seasonIndex = (_seasonIndex + 1) % seasons.length;
          _currentSeason = seasons[_seasonIndex];
          // Reinitialize particles when season changes
          _initializeSeasonalParticles();
          _initializeRainParticles();
        });
      }
    });

    // Continuous particle updates for smooth falling motion
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          // Update rain particles continuously
          for (var particle in _rainParticles) {
            particle['y'] =
                particle['y']! + particle['speed']! * 8; // Faster rain
            if (particle['y']! > 400) {
              particle['y'] = -30.0;
              particle['x'] =
                  15 + math.Random().nextDouble() * 350; // Match tree area
              particle['speed'] =
                  0.8 + math.Random().nextDouble() * 1.2; // Faster speeds
            }
          }

          // Update seasonal particles continuously
          for (var particle in _seasonalParticles) {
            particle['y'] =
                particle['y']! + particle['speed']! * 6; // Faster falling
            particle['rotation'] =
                particle['rotation']! + 0.05; // Faster rotation
            if (particle['y']! > 400) {
              // Reset higher up
              particle['y'] = -30.0;
              particle['x'] =
                  15 + math.Random().nextDouble() * 350; // Match tree area
              particle['speed'] =
                  0.6 + math.Random().nextDouble() * 1.0; // Faster speeds
            }
          }
        });
      }
    });
  }

  Widget _buildSkyBackground(ThemeData theme) {
    return Container(
      height: 25,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _isDayTime
              ? [
                  Colors.lightBlue[200]!,
                  Colors.lightBlue[50]!,
                ]
              : [
                  Colors.indigo[900]!,
                  Colors.indigo[700]!,
                ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        List<Widget> particles = [];

        // Show particles based on current season
        switch (_currentSeason) {
          case 'morning-sakura':
            particles.addAll(_buildSakuraPetals());
            break;
          case 'morning-autumn':
            particles.addAll(_buildAutumnLeaves());
            break;
          case 'morning-rainy':
            particles.addAll(_buildZigzagRainDrops());
            break;
          case 'morning-winter':
            particles.addAll(_buildWinterSnow());
            break;
          case 'day':
          case 'night':
            // No objects falling during day or night
            break;
        }

        return Stack(
          children: [
            ...particles,
            // Add seasonal icon in top-right corner
            _buildSeasonalIcon(),
          ],
        );
      },
    );
  }

  Widget _buildSeasonalIcon() {
    IconData seasonIcon;
    Color seasonColor;
    String seasonName;

    switch (_currentSeason) {
      case 'day':
        seasonIcon = Icons.wb_sunny;
        seasonColor = Colors.orange[400]!;
        seasonName = 'Day';
        break;
      case 'morning-sakura':
        seasonIcon = Icons.local_florist;
        seasonColor = Colors.pink[400]!;
        seasonName = 'Sakura Morning';
        break;
      case 'morning-autumn':
        seasonIcon = Icons.eco;
        seasonColor = Colors.orange[600]!;
        seasonName = 'Autumn Morning';
        break;
      case 'morning-rainy':
        seasonIcon = Icons.grain;
        seasonColor = Colors.blue[600]!;
        seasonName = 'Rainy Morning';
        break;
      case 'morning-winter':
        seasonIcon = Icons.ac_unit;
        seasonColor = Colors.blue[300]!;
        seasonName = 'Winter Morning';
        break;
      case 'night':
        seasonIcon = Icons.nightlight_round;
        seasonColor = Colors.indigo[400]!;
        seasonName = 'Night';
        break;
      default:
        seasonIcon = Icons.eco;
        seasonColor = Colors.green[400]!;
        seasonName = 'Nature';
    }

    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: seasonColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              seasonIcon,
              color: seasonColor,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              seasonName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSakuraPetals() {
    return _seasonalParticles.map((particle) {
      return Positioned(
        left: particle['x']!,
        top: particle['y']!,
        child: Transform.rotate(
          angle: particle['rotation']!,
          child: Icon(
            Icons.local_florist,
            color: ([
                      Colors.pink[200],
                      Colors.white,
                      Colors.pink[100]
                    ][particle['x']!.toInt() % 3] ??
                    Colors.pink)
                .withOpacity(0.9),
            size: 6 + (particle['size']! * 4), // Smaller sakura petals
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildSpringPetals() {
    return _seasonalParticles.map((particle) {
      return Positioned(
        left: particle['x']!,
        top: particle['y']!,
        child: Transform.rotate(
          angle: particle['rotation']!,
          child: Icon(
            Icons.local_florist,
            color: ([
                      Colors.pink[200],
                      Colors.white,
                      Colors.pink[100]
                    ][particle['x']!.toInt() % 3] ??
                    Colors.pink)
                .withOpacity(0.8),
            size: 8 + (particle['size']! * 6),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildSummerSparkles() {
    return _seasonalParticles.map((particle) {
      return Positioned(
        left: particle['x']!,
        top: particle['y']!,
        child: Transform.rotate(
          angle: particle['rotation']!,
          child: Icon(
            Icons.star,
            color: ([
                      Colors.yellow[300],
                      Colors.orange[200],
                      Colors.amber[200]
                    ][particle['x']!.toInt() % 3] ??
                    Colors.yellow)
                .withOpacity(0.6),
            size: 6 + (particle['size']! * 4),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildAutumnLeaves() {
    return _seasonalParticles.map((particle) {
      return Positioned(
        left: particle['x']!,
        top: particle['y']!,
        child: Transform.rotate(
          angle: particle['rotation']!,
          child: Icon(
            Icons.eco,
            color: ([
                      Colors.orange[400],
                      Colors.red[400],
                      Colors.brown[400]
                    ][particle['x']!.toInt() % 3] ??
                    Colors.orange)
                .withOpacity(0.8),
            size: 8 + (particle['size']! * 6),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildWinterSnow() {
    return _seasonalParticles.map((particle) {
      return Positioned(
        left: particle['x']!,
        top: particle['y']!,
        child: Icon(
          Icons.ac_unit,
          color: Colors.white.withOpacity(0.8),
          size: 6 + (particle['size']! * 4),
        ),
      );
    }).toList();
  }

  List<Widget> _buildZigzagRainDrops() {
    return _rainParticles.map((particle) {
      return Positioned(
        left: particle['x']!,
        top: particle['y']!,
        child: Container(
          width: 2,
          height: 8 + (particle['speed']! * 4),
          decoration: BoxDecoration(
            color: Colors.blue[300]!.withOpacity(0.7),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildAutumnLeavesDuplicate() {
    return _seasonalParticles.map((particle) {
      return Positioned(
        left: particle['x']!,
        top: particle['y']!,
        child: Transform.rotate(
          angle: particle['rotation']!,
          child: Icon(
            Icons.eco,
            color: ([
                      Colors.orange[400],
                      Colors.red[400],
                      Colors.brown[400]
                    ][particle['x']!.toInt() % 3] ??
                    Colors.orange)
                .withOpacity(0.8),
            size: 8 + (particle['size']! * 6),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildRainDrops() {
    return _rainParticles.map((particle) {
      return Positioned(
        left: particle['x']!,
        top: particle['y']!,
        child: Container(
          width: 2,
          height: 8 + (particle['speed']! * 4),
          decoration: BoxDecoration(
            color: Colors.blue[300]!.withOpacity(0.6),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    }).toList();
  }

  void _initializeRainParticles() {
    _rainParticles.clear();
    // Create 80 rain particles for good coverage without lag
    for (int i = 0; i < 80; i++) {
      _rainParticles.add({
        'x': 15 +
            math.Random().nextDouble() * 350, // Match tree positioning area
        'y': math.Random().nextDouble() * 200 - 50,
        'speed': 0.8 + math.Random().nextDouble() * 1.2, // Faster rain
        'initialY': math.Random().nextDouble() * 200 - 50,
      });
    }
  }

  void _initializeSeasonalParticles() {
    _seasonalParticles.clear();
    // Create 35 seasonal particles for better visibility
    for (int i = 0; i < 35; i++) {
      _seasonalParticles.add({
        'x': 15 +
            math.Random().nextDouble() * 350, // Match tree positioning area
        'y': math.Random().nextDouble() * 200 - 50,
        'speed': 0.6 + math.Random().nextDouble() * 1.0, // Faster falling speed
        'rotation': math.Random().nextDouble() * 2 * math.pi,
        'size': 0.4 + math.Random().nextDouble() * 0.8, // Better size range
        'initialY': math.Random().nextDouble() * 200 - 50,
      });
    }
  }

  Widget _buildEnhancedForestGrid(ThemeData theme) {
    final treeCount = _getTreeCount();

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Scattered tree positioning for natural look
          SizedBox(
            height: 160, // Reduced height to fit better
            child: Stack(
              children: List.generate(treeCount, (index) {
                // Create scattered positions based on tree index
                final positions = [
                  Offset(25, 5),
                  Offset(110, 12),
                  Offset(200, 8),
                  Offset(40, 40),
                  Offset(140, 48),
                  Offset(230, 35),
                  Offset(15, 75),
                  Offset(170, 82),
                  Offset(260, 70),
                  Offset(70, 110),
                  Offset(190, 118),
                  Offset(280, 105),
                ];

                if (index >= positions.length) {
                  // Generate additional positions for higher tree counts
                  final x = (index * 73.5 + 25) % 350;
                  final y = ((index ~/ 3) * 35 + 5 + (index % 7) * 10) %
                      140; // Reduced spacing
                  return Positioned(
                    left: x,
                    top: y.toDouble(),
                    child: _buildEnhancedSingleTree(theme, index),
                  );
                }

                return Positioned(
                  left: positions[index].dx,
                  top: positions[index].dy,
                  child: _buildEnhancedSingleTree(theme, index),
                );
              }),
            ),
          ),
          const SizedBox(height: 10), // Reduced spacing
          // Weather status display
          _buildWeatherStatus(theme),
          const SizedBox(height: 10), // Reduced spacing
        ],
      ),
    );
  }

  Widget _buildEnhancedSingleTree(ThemeData theme, int treeIndex) {
    // Determine tree type based on forest trees if available
    String treeType = 'tap'; // default
    Color treeColor = Colors.green[400 + ((treeIndex % 4) * 100)]!;
    double treeSize =
        20.0 + ((_treeLevel - (treeIndex ~/ 3)) * 3).clamp(0, 12).toDouble();
    IconData treeIcon = Icons.park;

    // Use specific tree data if available
    if (treeIndex < _forestTrees.length) {
      final treeData = _forestTrees[treeIndex];
      treeType = treeData['type'] ?? 'tap';
      treeColor = _getTreeColorForType(treeType);
      treeSize = _getTreeSizeForType(treeType);

      // Special icons for different tree types
      switch (treeType) {
        case 'golden':
          treeIcon = Icons.park;
          break;
        case 'ancient':
          treeIcon = Icons.forest;
          break;
        case 'crystal':
          treeIcon = Icons.diamond;
          break;
        case 'sakura':
          treeIcon = Icons.local_florist;
          break;
        case 'rainbow':
          treeIcon = Icons.park;
          break;
        default:
          treeIcon = Icons.park;
      }
    }

    // Add realistic bending to some trees
    final bendAngle = (treeIndex % 5 == 0)
        ? 0.1
        : (treeIndex % 7 == 0)
            ? -0.15
            : (treeIndex % 3 == 0)
                ? 0.08
                : 0.0;

    return AnimatedBuilder(
      animation: _weatherAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            (_currentSeason == 'rainy' ? 2 : 1) *
                math.sin(_weatherAnimation.value * 2 * 3.14159) *
                2,
            0,
          ),
          child: Transform.scale(
            scale: math.max(0.1, _treeGrowthAnimation.value) *
                (1.0 + 0.1 * math.sin(_weatherAnimation.value * 2 * 3.14159)),
            child: Transform.rotate(
              angle: bendAngle, // Apply realistic bending
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Special glow effect for golden trees
                      if (treeType == 'golden')
                        Container(
                          width: treeSize + 8,
                          height: treeSize + 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      // Special sparkle effect for crystal trees
                      if (treeType == 'crystal')
                        Container(
                          width: treeSize + 4,
                          height: treeSize + 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.cyan.withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      Icon(
                        treeIcon,
                        size: treeSize,
                        color: treeColor,
                      ),
                      // Rainbow animation for rainbow trees
                      if (treeType == 'rainbow')
                        AnimatedBuilder(
                          animation: _weatherAnimation,
                          builder: (context, child) {
                            return Icon(
                              treeIcon,
                              size: treeSize,
                              color: HSVColor.fromAHSV(
                                1.0,
                                (_weatherAnimation.value * 360) % 360,
                                0.8,
                                0.9,
                              ).toColor(),
                            );
                          },
                        ),
                      if (_currentSeason == 'rainy')
                        ...List.generate(
                            3,
                            (i) => Positioned(
                                  top: -10 + i * 3,
                                  left: -5 + i * 2,
                                  child: Icon(
                                    Icons.water_drop,
                                    size: 4,
                                    color: Colors.blue[400],
                                  ),
                                )),
                    ],
                  ),
                  Container(
                    width: 4,
                    height: 8, // Much shorter trunk
                    decoration: BoxDecoration(
                      color: Colors.brown[600],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeatherEffects() {
    if (_currentWeather == 'rainy') {
      return AnimatedBuilder(
        animation: _weatherAnimation,
        builder: (context, child) {
          return Stack(
            children: List.generate(20, (index) {
              final offset = (_weatherAnimation.value * 500 + index * 25) % 500;
              return Positioned(
                left: (index * 20.0) % 300,
                top: offset - 100,
                child: Container(
                  width: 2,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.blue[300]!.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              );
            }),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTimeIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isCurrentlyDayTime ? Icons.wb_sunny : Icons.nightlight_round,
        color: isCurrentlyDayTime ? Colors.yellow[600] : Colors.blue[200],
        size: 16,
      ),
    );
  }

  Widget _buildWeatherIndicator(ThemeData theme) {
    IconData weatherIcon;
    Color weatherColor;

    switch (_currentWeather) {
      case 'sunny':
        weatherIcon = Icons.wb_sunny;
        weatherColor = Colors.orange;
        break;
      case 'cloudy':
        weatherIcon = Icons.cloud;
        weatherColor = Colors.grey;
        break;
      case 'rainy':
        weatherIcon = Icons.water_drop;
        weatherColor = Colors.blue;
        break;
      default:
        weatherIcon = Icons.wb_sunny;
        weatherColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        weatherIcon,
        color: weatherColor,
        size: 16,
      ),
    );
  }

  Widget _buildWeatherStatus(ThemeData theme) {
    String statusText;
    IconData statusIcon;
    Color statusColor;

    switch (_currentSeason) {
      case 'morning-sakura':
        statusText = 'Sakura morning - Beautiful cherry blossoms drift down';
        statusIcon = Icons.local_florist;
        statusColor = Colors.pink[400]!;
        break;
      case 'morning-autumn':
        statusText = 'Autumn morning - Colorful leaves dance in the breeze';
        statusIcon = Icons.eco;
        statusColor = Colors.orange[600]!;
        break;
      case 'morning-rainy':
        statusText = 'Rainy morning - Zigzag raindrops nourish the forest';
        statusIcon = Icons.grain;
        statusColor = Colors.blue[600]!;
        break;
      case 'morning-winter':
        statusText = 'Winter morning - Soft snowflakes blanket the trees';
        statusIcon = Icons.ac_unit;
        statusColor = Colors.blue[300]!;
        break;
      case 'day':
        statusText = 'Clear sunny day - Perfect peaceful weather';
        statusIcon = Icons.wb_sunny;
        statusColor = Colors.orange[400]!;
        break;
      case 'night':
        statusText = 'Peaceful starry night - Forest rests quietly';
        statusIcon = Icons.nightlight_round;
        statusColor = Colors.indigo[400]!;
        break;
      default:
        statusText = 'Perfect weather for tree growth';
        statusIcon = Icons.eco;
        statusColor = Colors.green[400]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8), // Reduced padding
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8), // Smaller border radius
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 16, // Smaller icon
          ),
          const SizedBox(width: 6), // Reduced spacing
          Flexible(
            child: Text(
              statusText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w500,
                fontSize: 11, // Smaller text
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForestStats(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.forest,
            color: Colors.green[400],
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            '${_getTreeCount()} Trees',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _triggerSpecialEffect() {
    // Long press for special effects
    setState(() {
      _currentSeason = 'sunny';
      _isDayTime = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🌞 Perfect weather for your forest! '),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _tapTree() {
    final now = DateTime.now();

    // Prevent rapid tapping and multiple snackbars
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!).inMilliseconds < 300) {
      return;
    }

    _lastTapTime = now;

    HapticFeedback.mediumImpact();
    setState(() {
      _totalTaps++;
      // Simple tree tap without type management

      if (_totalTaps % 200 == 0) {
        _treeLevel++;
        _showLevelUpDialog();
      }
    });

    // Check for tree count achievements
    _checkAchievements();

    _treeGrowthController.reset();
    _treeGrowthController.forward();

    // Only show snackbar if one isn't already showing
    if (!_isShowingSnackBar) {
      _isShowingSnackBar = true;

      final treeCount = _getTreeCount();
      final messages = [
        'Your forest is thriving! 🌱',
        'Trees are growing strong! 🌳',
        'Nature loves your care! 🍃',
        'Keep the forest growing! 🌿',
        'Amazing forest progress! 🌲',
      ];

      // Clear any existing snackbars first
      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.forest, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      treeCount > 1
                          ? '${messages[_totalTaps % messages.length]} ($treeCount trees)'
                          : messages[_totalTaps % messages.length],
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 1200),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green[600],
            ),
          )
          .closed
          .then((_) {
        // Reset the flag when snackbar is closed
        if (mounted) {
          _isShowingSnackBar = false;
        }
      });
    }
  }

  // Achievement System Methods
  void _checkAchievements() {
    for (final achievement in _achievementList) {
      final id = achievement['id'] as String;

      // Skip if already achieved
      if (_achievements[id] == true) continue;

      // Check time-limited achievements
      if (achievement['timeLimit'] == true) {
        DateTime now = DateTime.now();
        // Example: Earth Week (April 15-22)
        if (now.month != 4 || now.day < 15 || now.day > 22) {
          continue; // Not during Earth Week
        }
      }

      bool shouldUnlock = false;
      final requirement = achievement['requirement'] as String;
      final target = achievement['target'];

      switch (requirement) {
        case 'donation_amount':
          shouldUnlock = _totalDonations >= target;
          break;
        case 'consistency_streak':
          shouldUnlock = _consistencyStreak >= target;
          break;
        case 'tree_count':
          shouldUnlock = _getTreeCount() >= target;
          break;
        case 'tap_trees':
          shouldUnlock = (_treeTypeCount['tap'] ?? 0) >= target;
          break;
        case 'events':
          shouldUnlock = (_treeTypeCount['event'] ?? 0) >= target;
          break;
        case 'seasonal_experience':
          // Check if user has experienced all seasons (simplified)
          shouldUnlock = _totalTaps >= 1000; // Approximate season experience
          break;
        case 'limited_time':
          shouldUnlock = true; // Will be triggered by special events
          break;
      }

      if (shouldUnlock) {
        _unlockAchievement(achievement);
      }
    }
  }

  void _unlockAchievement(Map<String, dynamic> achievement) {
    final id = achievement['id'] as String;
    final rewardData = achievement['rewardData'] as Map<String, dynamic>;

    setState(() {
      _achievements[id] = true;

      // Add badge if included
      if (rewardData.containsKey('badge')) {
        final badge = rewardData['badge'] as String;
        if (!_unlockedBadges.contains(badge)) {
          _unlockedBadges.add(badge);
        }
      }

      // Add asset if included
      if (rewardData.containsKey('asset')) {
        final asset = rewardData['asset'] as String;
        if (!_unlockedAssets.contains(asset)) {
          _unlockedAssets.add(asset);
        }
      }

      // Add special tree if specified
      // Tree management disabled for demo
    });

    _showAchievementDialog(achievement);
  }

  void _showAchievementDialog(Map<String, dynamic> achievement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                achievement['icon'] as IconData,
                size: 60,
                color: Colors.amber,
              ),
              const SizedBox(height: 16),
              Text(
                'Achievement Unlocked!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                achievement['title'] as String,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                achievement['description'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              _buildRewardInfo(
                  achievement['rewardData'] as Map<String, dynamic>),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Awesome!'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRewardInfo(Map<String, dynamic> rewardData) {
    List<Widget> rewards = [];

    if (rewardData.containsKey('badge')) {
      rewards.add(
        Chip(
          avatar: const Icon(Icons.military_tech, size: 16),
          label: Text('Badge: ${rewardData['badge']}'),
          backgroundColor: Colors.amber[100],
        ),
      );
    }

    if (rewardData.containsKey('asset')) {
      rewards.add(
        Chip(
          avatar: const Icon(Icons.auto_awesome, size: 16),
          label: Text('Asset: ${rewardData['asset']}'),
          backgroundColor: Colors.green[100],
        ),
      );
    }

    if (rewardData.containsKey('theme')) {
      rewards.add(
        Chip(
          avatar: const Icon(Icons.palette, size: 16),
          label: Text('Theme: ${rewardData['theme']}'),
          backgroundColor: Colors.purple[100],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      children: rewards,
    );
  }

  void _addDonation(double amount) {
    setState(() {
      _totalDonations += amount;
    });
    _checkAchievements();
  }

  void _completeEcoHabit() {
    final today = DateTime.now();

    if (_lastHabitDate != null) {
      final daysDifference = today.difference(_lastHabitDate!).inDays;

      if (daysDifference == 1) {
        // Consecutive day
        setState(() {
          _consistencyStreak++;
          _lastHabitDate = today;
          // Tree management disabled for demo
        });
      } else if (daysDifference == 0) {
        // Same day, no change needed
        return;
      } else {
        // Streak broken
        setState(() {
          _consistencyStreak = 1;
          _lastHabitDate = today;
          // Tree management disabled for demo
        });
      }
    } else {
      // First time
      setState(() {
        _consistencyStreak = 1;
        _lastHabitDate = today;
        // Tree management disabled for demo
      });
    }

    _checkAchievements();
  }

  void _participateInEvent() {
    setState(() {
      // Tree management disabled for demo
    });
    _checkAchievements();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event participation recorded! Special tree added 🎪'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildForestGrid(ThemeData theme) {
    final treeCount = _getTreeCount();

    return SizedBox(
      width: double.infinity,
      height: 160, // Fixed height to prevent overflow
      child: Stack(
        children: List.generate(treeCount, (index) {
          // Generate truly scattered positions using different seeds
          final random =
              math.Random(index * 13 + 27); // Different seed for variety
          final left = 15.0 + random.nextDouble() * 290; // Random X position
          final top = 5.0 +
              random.nextDouble() * 100; // Random Y position with more space

          // Add some clustering effects for natural look
          final clusterRandom = math.Random(index * 7 + 15);
          final clusterOffset = clusterRandom.nextDouble() * 30 - 15;

          return Positioned(
            left: (left + clusterOffset).clamp(10.0, 310.0),
            top: (top + clusterOffset * 0.5).clamp(5.0, 120.0),
            child: _buildSingleTree(theme, index),
          );
        }),
      ),
    );
  }

  Widget _buildSingleTree(ThemeData theme, int treeIndex) {
    final baseSize = 16.0 +
        (treeIndex % 3) * 4.0; // Much smaller varied tree sizes (16-24px)
    final treeSize =
        baseSize + (_treeLevel * 1).clamp(0, 8).toDouble(); // Limited growth
    final treeColor = Colors.green[300 + ((treeIndex % 5) * 100)];

    return Transform.scale(
      scale: _treeGrowthAnimation.value,
      child: SizedBox(
        height: 32, // Constrain total height to prevent overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.park,
              size: treeSize,
              color: treeColor,
            ),
            Container(
              width: 3,
              height: 6, // Much smaller trunk
              decoration: BoxDecoration(
                color: Colors.brown[600],
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton(ThemeData theme) {
    return GestureDetector(
      onTap: _shareForest,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.secondary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.share,
          color: theme.colorScheme.onSecondary,
          size: 20,
        ),
      ),
    );
  }

  int _getTreeCount() {
    // Trees multiply based on level: Level 1 = 1 tree, Level 2 = 3 trees, etc.
    if (_treeLevel == 0) return 0;
    return ((_treeLevel - 1) * 3 + 1).clamp(1, 12);
  }

  void _shareForest() {
    final theme = Theme.of(context);
    final treeCount = _getTreeCount();
    final shareText = "🌳 Check out my virtual forest! 🌳\n\n"
        "🌱 Level: $_treeLevel\n"
        "🌲 Trees: $treeCount\n"
        "🎯 Total Growth: $_totalTaps taps\n\n"
        "Join me in growing a sustainable future! 🌍\n\n"
        "#EcoWarrior #SustainableLiving #TanimTap #GreenFuture";

    // Show share dialog with Facebook option
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.share, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Share Your Forest'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share your amazing forest progress:',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                shareText,
                style: theme.textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Choose sharing option:',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _shareToFacebook(shareText);
            },
            icon: Icon(Icons.facebook, color: Colors.blue[700]),
            label: const Text('Facebook'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue[700],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _copyToClipboard(shareText);
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  void _shareToFacebook(String text) {
    // In a real app, you would use the Facebook SDK or url_launcher
    // For now, we'll show instructions and copy the text
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.facebook, color: Colors.blue[700]),
            const SizedBox(width: 8),
            const Text('Share to Facebook'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your forest progress has been copied! 📋',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'To share on Facebook:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '1. Open Facebook app or website\n'
              '2. Create a new post\n'
              '3. Paste your forest progress\n'
              '4. Add a photo of your achievement!\n'
              '5. Post to inspire your friends! 🌱',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.blue[600], size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Tip: Tag friends to join the eco challenge!',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
            ),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );

    // Copy to clipboard
    _copyToClipboard(text);
  }

  void _copyToClipboard(String text) {
    // In a real app, you'd use Clipboard.setData(ClipboardData(text: text))
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forest progress copied! Share it on social media! 📱'),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLevelUpDialog() {
    final treeCount = _getTreeCount();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber),
            SizedBox(width: 8),
            Text('Forest Expanded!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🎉 Congratulations! Your forest reached level $_treeLevel!'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.forest, color: Colors.green[600], size: 24),
                      const SizedBox(width: 8),
                      Text(
                        '$treeCount Trees Growing!',
                        style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Share your forest growth and inspire others!',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _shareForest();
            },
            child: const Text('Share Progress'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }
}

class CommitmentScreen extends StatefulWidget {
  const CommitmentScreen({super.key});

  @override
  State<CommitmentScreen> createState() => _CommitmentScreenState();
}

class _CommitmentScreenState extends State<CommitmentScreen>
    with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _pledgeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _submitController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _submitController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pledgeController.dispose();
    _submitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Make a Commitment',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: const SafeArea(
                  child: Center(
                    child: Icon(
                      Icons.eco,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Motivational Text
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.1),
                        theme.colorScheme.secondary.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '🌱 Every small action counts',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your commitment helps build a sustainable future. Share your eco-pledge and watch your virtual tree grow!',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tell us about yourself',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                          hintText: 'Enter your name',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Pledge Field
                      TextFormField(
                        controller: _pledgeController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Your Eco-Pledge',
                          hintText:
                              'I commit to... (e.g., using a reusable water bottle, planting herbs, reducing plastic use)',
                          prefixIcon: const Icon(Icons.eco),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please share your eco-commitment';
                          }
                          if (value.trim().length < 10) {
                            return 'Please provide more details about your commitment';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isSubmitting ? null : _submitPledge,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  'Plant My Commitment 🌱',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Info Text
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your commitment helps inspire others and contributes to our collective environmental impact.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitPledge() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    HapticFeedback.lightImpact();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber, size: 28),
            SizedBox(width: 8),
            Text('Commitment Planted! 🌱'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thank you, ${_nameController.text}!'),
            const SizedBox(height: 8),
            Text(
              'Your eco-pledge: "${_pledgeController.text}" has been recorded.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
                'Your virtual tree is now growing! Check the Forest tab to see your progress.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _nameController.clear();
              _pledgeController.clear();
            },
            child: const Text('Continue Growing!'),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Column(
                              children: [
                                // Profile Picture at the top
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.colorScheme.onPrimary
                                          .withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius:
                                        constraints.maxWidth < 300 ? 24 : 28,
                                    backgroundColor: theme.colorScheme.onPrimary
                                        .withOpacity(0.15),
                                    child: Icon(
                                      Icons.person,
                                      size:
                                          constraints.maxWidth < 300 ? 24 : 28,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // User info centered below
                                Column(
                                  children: [
                                    Text(
                                      'Eco Warrior',
                                      style: theme.textTheme.headlineMedium
                                          ?.copyWith(
                                        color: theme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: constraints.maxWidth < 300
                                            ? 18
                                            : null,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.eco,
                                          size: 16,
                                          color: theme.colorScheme.onPrimary
                                              .withOpacity(0.9),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Level 15 • Nature Lover',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: theme.colorScheme.onPrimary
                                                .withOpacity(0.9),
                                            fontSize: constraints.maxWidth < 300
                                                ? 12
                                                : null,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Enhanced Stats Overview
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn('Trees', '12', Icons.forest, theme),
                          _buildStatColumn(
                              'Days', '15', Icons.calendar_today, theme),
                          _buildStatColumn('CO₂', '45kg', Icons.air, theme),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn(
                              'Rank', '#15', Icons.leaderboard, theme),
                          _buildStatColumn('Donated', '₱1,250',
                              Icons.volunteer_activism, theme),
                          _buildStatColumn('Habits', '5/5', Icons.eco, theme),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Donation Impact
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.1),
                        theme.colorScheme.secondary.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.forest,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Real World Impact',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your donations have planted 25 real trees!',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This has removed approximately 500kg of CO₂ from the atmosphere and provided habitat for wildlife.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Recent Activity
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Activity',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildActivityItem(
                        '🌳',
                        'Donated ₱250 for tree planting',
                        '2 days ago',
                        theme,
                      ),
                      _buildActivityItem(
                        '💚',
                        'Completed 5 eco habits today',
                        '1 day ago',
                        theme,
                      ),
                      _buildActivityItem(
                        '🏆',
                        'Moved up 3 ranks on leaderboard',
                        '3 days ago',
                        theme,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Menu Items
                _buildMenuSection(
                    'Account',
                    [
                      _buildMenuItem(Icons.person, 'Edit Profile', () {}),
                      _buildMenuItem(
                          Icons.notifications, 'Notifications', () {}),
                      _buildMenuItem(
                          Icons.security, 'Privacy & Security', () {}),
                    ],
                    theme),

                const SizedBox(height: 16),

                _buildMenuSection(
                    'App',
                    [
                      _buildMenuItem(Icons.palette, 'Theme', () {}),
                      _buildMenuItem(Icons.language, 'Language', () {}),
                      _buildMenuItem(Icons.help, 'Help & Support', () {}),
                    ],
                    theme),

                const SizedBox(height: 16),

                _buildMenuSection(
                    'Community',
                    [
                      _buildMenuItem(Icons.share, 'Share App', () {}),
                      _buildMenuItem(Icons.star, 'Rate Us', () {}),
                      _buildMenuItem(Icons.feedback, 'Feedback', () {}),
                    ],
                    theme),

                const SizedBox(height: 32),

                // About
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About TanimTap',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'TanimTap inspires eco-friendly habits through gamification. Every action counts towards a greener future. 🌱',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Version 1.0.0',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      String emoji, String title, String time, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
      String label, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Habit Tracker Screen
class HabitTrackerScreen extends StatefulWidget {
  const HabitTrackerScreen({super.key});

  @override
  State<HabitTrackerScreen> createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  List<Map<String, dynamic>> habits = [
    {
      'name': 'Use reusable water bottle',
      'streak': 15,
      'completed': true,
      'impact': 'Saved 45 plastic bottles'
    },
    {
      'name': 'Walk/bike instead of drive',
      'streak': 8,
      'completed': false,
      'impact': 'Reduced 12kg CO₂'
    },
    {
      'name': 'Eat plant-based meals',
      'streak': 22,
      'completed': true,
      'impact': 'Saved 66kg CO₂'
    },
    {
      'name': 'Turn off lights when leaving',
      'streak': 12,
      'completed': true,
      'impact': 'Saved 24kWh energy'
    },
    {
      'name': 'Recycle properly',
      'streak': 18,
      'completed': false,
      'impact': 'Diverted 8kg from landfill'
    },
  ];

  // Progress data for the last 7 days (completion percentages)
  List<double> weeklyProgress = [0.8, 0.6, 1.0, 0.4, 0.8, 0.6, 0.8];
  List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  int get totalStreakDays {
    if (habits.isEmpty) return 0;
    return habits.fold(
        0, (sum, habit) => sum + ((habit['streak'] as int?) ?? 0));
  }

  double get completionRate {
    if (habits.isEmpty) return 0.0;
    final completedCount = habits.where((h) => h['completed'] == true).length;
    return completedCount / habits.length;
  }

  void _toggleHabitCompletion(int index) {
    if (index < 0 || index >= habits.length) return;

    setState(() {
      habits[index]['completed'] = !(habits[index]['completed'] ?? false);

      // Update today's progress (last item in weeklyProgress)
      if (weeklyProgress.isNotEmpty) {
        weeklyProgress[weeklyProgress.length - 1] = completionRate;
      }

      // Update streak
      if (habits[index]['completed'] == true) {
        habits[index]['streak'] = (habits[index]['streak'] ?? 0) + 1;
      } else {
        // Don't decrease streak immediately, but in real app you might want to
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        title: Column(
          children: [
            Text(
              'Eco Habits',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            Text(
              'Build sustainable habits 🌱',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddHabitDialog(),
            icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsCards(),
            const SizedBox(height: 24),
            _buildProgressChart(),
            const SizedBox(height: 24),
            _buildHabitsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Current Streak',
            '${totalStreakDays} days',
            Icons.local_fire_department,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Completion Rate',
            '${(completionRate * 100).toInt()}%',
            Icons.check_circle,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[50]!, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green[100]!, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[400]!, Colors.green[600]!],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Weekly Journey',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[100]!, Colors.green[50]!],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green[200]!, width: 0.5),
                ),
                child: Text(
                  '${(weeklyProgress.reduce((a, b) => a + b) / weeklyProgress.length * 100).toInt()}% avg',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 90, // Further reduced from 100 to 90
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(weeklyProgress.length, (index) {
                if (index >= weeklyProgress.length) return const SizedBox();

                final progress = weeklyProgress[index].clamp(0.0, 1.0);
                final isToday = index == weeklyProgress.length - 1;
                final dayLabel = index < weekDays.length
                    ? weekDays[index].substring(0, 1)
                    : 'D';

                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize:
                          MainAxisSize.min, // Important to prevent overflow
                      children: [
                        // Progress value
                        Text(
                          '${(progress * 100).toInt()}',
                          style: TextStyle(
                            fontSize: 9, // Further reduced from 10
                            fontWeight: FontWeight.w600,
                            color:
                                isToday ? Colors.green[700] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 3), // Further reduced from 4
                        // Modern eco progress bar
                        AnimatedContainer(
                          duration:
                              Duration(milliseconds: 1000 + (index * 150)),
                          curve: Curves.easeOutQuart,
                          height: (50 * progress).clamp(4.0, 50.0),
                          width: 16,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isToday
                                  ? [
                                      Colors.green[400]!,
                                      Colors.green[600]!,
                                      Colors.green[500]!
                                    ]
                                  : progress > 0.8
                                      ? [Colors.green[300]!, Colors.green[500]!]
                                      : progress > 0.5
                                          ? [
                                              Colors.amber[300]!,
                                              Colors.orange[400]!
                                            ]
                                          : [
                                              Colors.grey[300]!,
                                              Colors.grey[400]!
                                            ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: isToday ? [0.0, 0.5, 1.0] : [0.0, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: progress > 0.5
                                ? [
                                    BoxShadow(
                                      color: (isToday
                                              ? Colors.green
                                              : progress > 0.8
                                                  ? Colors.green
                                                  : Colors.amber)
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4), // Further reduced from 6
                        // Modern day indicator
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            gradient: isToday
                                ? LinearGradient(
                                    colors: [
                                      Colors.green[100]!,
                                      Colors.green[50]!
                                    ],
                                  )
                                : null,
                            color: !isToday ? Colors.transparent : null,
                            shape: BoxShape.circle,
                            border: isToday
                                ? Border.all(
                                    color: Colors.green[300]!,
                                    width: 1.5,
                                  )
                                : null,
                            boxShadow: isToday
                                ? [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              dayLabel,
                              style: TextStyle(
                                fontSize: 9, // Further reduced from 10
                                fontWeight:
                                    isToday ? FontWeight.w600 : FontWeight.w500,
                                color: isToday
                                    ? Colors.green[700]
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16), // Reduced from 20
          // Modern eco stats
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[50]!, Colors.white],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green[100]!, width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                    'Streak', '$totalStreakDays days', Colors.green[600]!),
                Container(
                  width: 1,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[100]!, Colors.green[200]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                _buildStatItem('Rate', '${(completionRate * 100).toInt()}%',
                    Colors.amber[600]!),
                Container(
                  width: 1,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[100]!, Colors.green[200]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                _buildStatItem('Habits', '${habits.length}', Colors.blue[600]!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2), width: 0.5),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildHabitsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Habits',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...habits.asMap().entries.map((entry) {
          final index = entry.key;
          final habit = entry.value;
          return _buildHabitCard(habit, index);
        }).toList(),
      ],
    );
  }

  Widget _buildHabitCard(Map<String, dynamic> habit, int index) {
    final isCompleted = habit['completed'] ?? false;
    final streakDays = habit['streak'] ?? 0;
    final habitName = habit['name'] ?? 'Unknown Habit';
    final habitImpact = habit['impact'] ?? 'No impact data';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withOpacity(0.3)
              : Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _toggleHabitCompletion(index);
              HapticFeedback.lightImpact();
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? Colors.green : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? Colors.green
                      : Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habitName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$streakDays day streak • $habitImpact',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.local_fire_department,
            color: Colors.orange,
            size: 20,
          ),
        ],
      ),
    );
  }

  void _showAddHabitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Habit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Environmental Impact',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add habit logic here
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

// Donation Screen
class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  int selectedAmount = 50;
  List<int> quickAmounts = [25, 50, 100, 250, 500];
  String selectedPaymentMethod = 'GCash';
  List<String> paymentMethods = ['GCash', 'PayMaya', 'Bank Transfer'];

  int totalDonated = 1250;
  int treesPlanted = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        title: Column(
          children: [
            Text(
              'Plant Real Trees',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            Text(
              'Make a real impact 🌳',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImpactCard(),
            const SizedBox(height: 24),
            _buildDonationAmountCard(),
            const SizedBox(height: 24),
            _buildPaymentMethodCard(),
            const SizedBox(height: 24),
            _buildDonateButton(),
            const SizedBox(height: 24),
            _buildDonationHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.forest,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your Impact So Far',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildImpactStat(
                    '₱$totalDonated', 'Total Donated', Icons.payments),
              ),
              Expanded(
                child: _buildImpactStat(
                    '$treesPlanted', 'Trees Planted', Icons.eco),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '₱50 = 1 Tree Planted • Every donation goes directly to verified tree planting organizations',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactStat(String value, String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
      ],
    );
  }

  Widget _buildDonationAmountCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Donation Amount',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                quickAmounts.map((amount) => _buildAmountChip(amount)).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Custom Amount',
              prefixText: '₱',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            onChanged: (value) {
              final amount = int.tryParse(value);
              if (amount != null) {
                setState(() {
                  selectedAmount = amount;
                });
              }
            },
          ),
          const SizedBox(height: 12),
          Text(
            'This will plant ${(selectedAmount / 50).floor()} tree${(selectedAmount / 50).floor() != 1 ? 's' : ''}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountChip(int amount) {
    final isSelected = selectedAmount == amount;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAmount = amount;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Text(
          '₱$amount',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ...paymentMethods
              .map((method) => _buildPaymentMethodTile(method))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(String method) {
    final isSelected = selectedPaymentMethod == method;
    IconData icon;
    switch (method) {
      case 'GCash':
        icon = Icons.phone_android;
        break;
      case 'PayMaya':
        icon = Icons.credit_card;
        break;
      default:
        icon = Icons.account_balance;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                method,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _processDonation(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Donate ₱$selectedAmount',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDonationHistory() {
    final donations = [
      {'amount': 100, 'date': '2024-10-01', 'trees': 2},
      {'amount': 250, 'date': '2024-09-15', 'trees': 5},
      {'amount': 500, 'date': '2024-09-01', 'trees': 10},
      {'amount': 150, 'date': '2024-08-20', 'trees': 3},
      {'amount': 250, 'date': '2024-08-05', 'trees': 5},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Donation History',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ...donations
              .take(3)
              .map((donation) => _buildDonationHistoryItem(donation))
              .toList(),
          if (donations.length > 3)
            TextButton(
              onPressed: () {
                // Show full history
              },
              child: const Text('View All'),
            ),
        ],
      ),
    );
  }

  Widget _buildDonationHistoryItem(Map<String, dynamic> donation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.eco,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₱${donation['amount']} • ${donation['trees']} tree${donation['trees'] != 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  DateTime.parse(donation['date']).toString().split(' ')[0],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Planted',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _processDonation() {
    // Show donation processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Processing your donation...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );

    // Simulate processing delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      _showDonationSuccess();
    });
  }

  void _showDonationSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Thank You!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your ₱$selectedAmount donation will plant ${(selectedAmount / 50).floor()} tree${(selectedAmount / 50).floor() != 1 ? 's' : ''}!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                totalDonated += selectedAmount;
                treesPlanted += (selectedAmount / 50).floor();
              });
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

// Leaderboard Screen
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int currentUserRank = 15;

  List<Map<String, dynamic>> globalLeaderboard = [
    {
      'name': 'EcoWarrior2024',
      'score': 2450,
      'level': 'Forest Guardian',
      'avatar': '🌳'
    },
    {
      'name': 'GreenThumb',
      'score': 2120,
      'level': 'Tree Hugger',
      'avatar': '🌿'
    },
    {
      'name': 'PlantLover',
      'score': 1980,
      'level': 'Nature Friend',
      'avatar': '🍃'
    },
    {'name': 'EcoChamp', 'score': 1850, 'level': 'Green Hero', 'avatar': '🌱'},
    {
      'name': 'TreePlanter',
      'score': 1720,
      'level': 'Seed Starter',
      'avatar': '🌾'
    },
    {
      'name': 'NatureFan',
      'score': 1650,
      'level': 'Eco Enthusiast',
      'avatar': '🌲'
    },
    {
      'name': 'GreenLife',
      'score': 1520,
      'level': 'Nature Lover',
      'avatar': '🌿'
    },
    {
      'name': 'EcoMinded',
      'score': 1450,
      'level': 'Green Friend',
      'avatar': '🍀'
    },
    {
      'name': 'PlantBased',
      'score': 1380,
      'level': 'Eco Helper',
      'avatar': '🌱'
    },
    {
      'name': 'TreeLover',
      'score': 1290,
      'level': 'Nature Helper',
      'avatar': '🌳'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Rankings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
          tabs: const [
            Tab(text: 'Global'),
            Tab(text: 'Friends'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildUserRankCard(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGlobalLeaderboard(),
                _buildFriendsLeaderboard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRankCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '🌱',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Rank',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
                Text(
                  '#$currentUserRank',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Text(
                  '1,250 points • Nature Lover',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'This Week',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
              ),
              Text(
                '+150 pts',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalLeaderboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildProgressChart(),
          const SizedBox(height: 24),
          ...globalLeaderboard.asMap().entries.map((entry) {
            final index = entry.key;
            final user = entry.value;
            return _buildLeaderboardItem(user, index + 1);
          }).toList(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFriendsLeaderboard() {
    final friendsLeaderboard = [
      {'name': 'You', 'score': 1250, 'level': 'Nature Lover', 'avatar': '🌱'},
      {
        'name': 'Sarah M.',
        'score': 1180,
        'level': 'Eco Helper',
        'avatar': '🌿'
      },
      {
        'name': 'Mike R.',
        'score': 950,
        'level': 'Green Friend',
        'avatar': '🍃'
      },
      {
        'name': 'Anna K.',
        'score': 820,
        'level': 'Tree Starter',
        'avatar': '🌾'
      },
      {
        'name': 'John D.',
        'score': 650,
        'level': 'Seed Planter',
        'avatar': '🌳'
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 16),
          ...friendsLeaderboard.asMap().entries.map((entry) {
            final index = entry.key;
            final user = entry.value;
            return _buildLeaderboardItem(user, index + 1,
                isCurrentUser: user['name'] == 'You');
          }).toList(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProgressChart() {
    // Get top 5 performers for the chart
    final topPerformers = globalLeaderboard.take(5).toList();
    final maxScore =
        topPerformers.isNotEmpty ? topPerformers.first['score'] : 1000;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[50]!, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green[100]!, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Performers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[900],
                  letterSpacing: -0.8,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'This Week',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 65, // Further reduced to fit content
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(topPerformers.length, (index) {
                final user = topPerformers[index];
                final score = user['score'] as int;
                final name = user['name'] as String;
                final avatar = user['avatar'] as String;
                final progress = score / maxScore;
                final rank = index + 1;

                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 2), // Reduced margin
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Clean score display
                        Text(
                          '${(score / 1000).toStringAsFixed(1)}k',
                          style: TextStyle(
                            fontSize: 9, // Reduced font size
                            fontWeight: FontWeight.w600,
                            color:
                                rank == 1 ? Colors.grey[900] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 1), // Reduced from 2
                        // Modern eco champion bar
                        AnimatedContainer(
                          duration:
                              Duration(milliseconds: 1200 + (index * 200)),
                          curve: Curves.easeOutQuart,
                          height: (18 * progress)
                              .clamp(3.0, 18.0), // Reduced max height
                          width: 12, // Reduced width
                          decoration: BoxDecoration(
                            color: rank == 1
                                ? Colors.grey[900]
                                : rank == 2
                                    ? Colors.grey[700]
                                    : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 1), // Further reduced
                        // Clean avatar
                        Container(
                          width: 14, // Reduced size
                          height: 14, // Reduced size
                          decoration: BoxDecoration(
                            color:
                                rank == 1 ? Colors.grey[100] : Colors.grey[50],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: rank == 1
                                  ? Colors.grey[300]!
                                  : Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              avatar,
                              style:
                                  const TextStyle(fontSize: 7), // Reduced font
                            ),
                          ),
                        ),
                        const SizedBox(height: 1), // Reduced from 2
                        // Clean name
                        Text(
                          name.length > 5 ? '${name.substring(0, 5)}.' : name,
                          style: TextStyle(
                            fontSize: 8, // Reduced font size
                            fontWeight:
                                rank == 1 ? FontWeight.w600 : FontWeight.w400,
                            color:
                                rank == 1 ? Colors.grey[900] : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          // Clean legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Performance Score',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> user, int rank,
      {bool isCurrentUser = false}) {
    Color? backgroundColor;
    Color? borderColor;

    if (rank <= 3) {
      switch (rank) {
        case 1:
          backgroundColor = Colors.amber.withOpacity(0.1);
          borderColor = Colors.amber;
          break;
        case 2:
          backgroundColor = Colors.grey.withOpacity(0.1);
          borderColor = Colors.grey;
          break;
        case 3:
          backgroundColor = Colors.orange.withOpacity(0.1);
          borderColor = Colors.orange;
          break;
      }
    } else if (isCurrentUser) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
      borderColor = Theme.of(context).colorScheme.primary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ??
            Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ??
              Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: borderColor != null ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? (rank == 1
                      ? Colors.amber
                      : rank == 2
                          ? Colors.grey
                          : Colors.orange)
                  : Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: rank <= 3
                  ? Icon(
                      rank == 1
                          ? Icons.emoji_events
                          : rank == 2
                              ? Icons.workspace_premium
                              : Icons.military_tech,
                      color: Colors.white,
                      size: 20,
                    )
                  : Text(
                      '$rank',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user['avatar'],
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isCurrentUser
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                ),
                Text(
                  user['level'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user['score']}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCurrentUser
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
              ),
              Text(
                'points',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
