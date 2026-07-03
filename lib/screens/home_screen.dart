import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/state_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeState _currentState = HomeState.normal;
  int _currentNavIndex = 0;

  // Local assets paths loaded from assets/images
  final String _imgSleepingBaby = 'assets/images/home&offline.png';
  final String _imgBabyCarrier = 'assets/images/checkin.png';
  final String _imgFirstTime1 = 'assets/images/firsttime1.png';
  final String _imgFirstTime2 = 'assets/images/firsttime2.png';

  // Interactive state variables for tabs
  String? _selectedMood;
  final TextEditingController _journalController = TextEditingController();
  final TextEditingController _newQuestionController = TextEditingController();
  String _selectedCommunityCategory = 'All';
  String _selectedLibraryCategory = 'All';
  Map<String, dynamic>? _activeReadGuide;
  bool _remindersEnabled = true;

  // Mutable community posts list
  late final List<Map<String, dynamic>> _communityPosts = [
    {
      'author': 'Marcus asked a question.',
      'timeAgo': '2 dads • 35 minutes ago',
      'avatarText': 'M',
      'quote': 'Slept through tonight\'s feed. Felt like winning.',
      'category': 'Sleep',
      'likes': 12,
      'liked': false,
    },
    {
      'author': 'David shared a thought.',
      'timeAgo': '5 dads • 2 hours ago',
      'avatarText': 'D',
      'quote': 'The first smile makes all the sleepless hours worth it.',
      'category': 'Relationships',
      'likes': 24,
      'liked': false,
    },
    {
      'author': 'Liam asked a question.',
      'timeAgo': '1 dad • 4 hours ago',
      'avatarText': 'L',
      'quote': 'How early did you start using a baby carrier?',
      'category': 'First-Time',
      'likes': 8,
      'liked': false,
    },
  ];

  // Guides list with contents for the library read feature
  final List<Map<String, dynamic>> _guidesList = [
    {
      'title': 'The first sleepless month',
      'description': 'A short read on what no one tells you.',
      'tag': 'GUIDE • 6 MIN',
      'imageUrl': 'assets/images/home&offline.png',
      'category': 'Sleep',
      'content': 'Sleep deprivation in the first month is a badge of honor, but it is also a serious test of endurance. Remember to take shifts with your partner. A solid 4-hour stretch of uninterrupted sleep does wonders for your mental state. Be patient with each other, and know that it gets better as your baby\'s sleep cycles mature around month 3.\n\nEstablishing a flexible routine rather than a rigid schedule can relieve a lot of pressure. Try to sleep when the baby sleeps, and don\'t hesitate to accept help from family and friends when offered.',
    },
    {
      'title': 'You can love it and still struggle',
      'description': 'Navigating the complex emotions of new fatherhood.',
      'tag': 'GUIDE • 4 MIN',
      'imageUrl': 'assets/images/checkin.png',
      'category': 'Relationships',
      'content': 'It\'s completely normal to feel overwhelmed, anxious, or even resentful at times. Acknowledging these feelings doesn\'t mean you love your child any less. Talk to your partner or peer group. Sharing the load and talking it out is the best way to prevent burnout.\n\nRemember that postpartum changes affect both parents. Giving yourself grace and having open, honest conversations with your partner about your feelings is key to navigating this transition together.',
    },
    {
      'title': 'How to be there when you don\'t know how',
      'description': 'Practical ways to support your partner and bond with your baby.',
      'tag': 'PAID GUIDE',
      'imageUrl': 'assets/images/firsttime1.png',
      'category': 'Guides',
      'content': 'Sometimes, just being present is enough. Take over household chores, hold the baby after feeding so your partner can rest, and master the art of the swaddle. Your confidence will grow with practice, and your partner will appreciate the support.\n\nBonding with your newborn takes time. Simple activities like skin-to-skin contact, reading aloud, or taking the baby for a walk in a carrier can help build that special connection while giving your partner a much-needed break.',
      'isPaid': true,
    },
    {
      'title': 'First-time dads talking it out',
      'description': 'A recording of a peer support session.',
      'tag': 'FREE',
      'imageUrl': 'assets/images/firsttime2.png',
      'category': 'First-Time',
      'content': 'In this session, five first-time fathers share their honest experiences, from diaper blowouts to baby blues. Hear their real stories and realize that you\'re not alone on this journey.\n\nThey discuss the shift in identity, how relationships change after the baby arrives, and finding moments of quiet amidst the chaos. Tapping into peer support can be incredibly affirming and helpful.',
      'isPaid': false,
    },
  ];

  @override
  void dispose() {
    _journalController.dispose();
    _newQuestionController.dispose();
    super.dispose();
  }

  // Helper image builder to elegantly render local assets
  Widget _buildImageWidget(String path, {required BoxFit fit}) {
    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        color: AppColors.background,
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textTertiary,
          size: 28,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Top Custom Header (Logo and square avatar)
                _buildHeader(),

                // Offline Warning Banner (Page 29)
                if (_currentState == HomeState.offline) _buildOfflineBanner(),

                // Main content switcher
                Expanded(
                  child: _buildTabContent(),
                ),
              ],
            ),
          ),

          // Floating State Selector for interactive review - visible only on Home tab
          if (_currentNavIndex == 0)
            StateSelector(
              currentState: _currentState,
              onStateChanged: (state) {
                setState(() {
                  _currentState = state;
                });
              },
            ),

          // Full Screen Guide Reader Overlay
          if (_activeReadGuide != null) _buildReadGuideOverlay(),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }

  // --- TAB CONTENT SELECTOR ---
  Widget _buildTabContent() {
    switch (_currentNavIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildCheckInTab();
      case 2:
        return _buildCommunityTab();
      case 3:
        return _buildLibraryTab();
      case 4:
        return _buildSettingsTab();
      default:
        return _buildHomeTab();
    }
  }

  // --- TAB 0: HOME VIEW ---
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Hero
            _buildGreetingHero(),
            const SizedBox(height: 32),

            // Layout states
            ..._buildStateContent(),

            // Spacing at the bottom to avoid overlapping with floating switch
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: CHECK-IN VIEW (SMILEY ICON) ---
  Widget _buildCheckInTab() {
    final moods = ['Calm', 'Energized', 'Excited', 'Tired', 'Overwhelmed'];
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: AppStyles.greetingTitle(context),
                children: const [
                  TextSpan(text: 'Daily '),
                  TextSpan(
                    text: 'Check-in',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'take a moment to reflect.',
              style: AppStyles.greetingSubtitle(context),
            ),
            const SizedBox(height: 32),

            Text('HOW ARE YOU FEELING?', style: AppStyles.sectionHeader(context)),
            const SizedBox(height: 12),

            // Mood grid
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: moods.map((mood) {
                final isSelected = _selectedMood == mood;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = mood;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.textPrimary : Colors.white,
                      border: Border.all(
                        color: isSelected ? AppColors.textPrimary : AppColors.border,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      mood,
                      style: GoogleFonts.workSans(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            Text('JOURNAL ENTRY', style: AppStyles.sectionHeader(context)),
            const SizedBox(height: 12),

            // Journal Input
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _journalController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'How was sleep last night? How is the baby? Write anything...',
                  border: InputBorder.none,
                ),
                style: AppStyles.bodyText(context),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            GestureDetector(
              onTap: () {
                if (_selectedMood == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please select a mood first.',
                        style: GoogleFonts.workSans(color: Colors.white),
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                setState(() {
                  _currentState = HomeState.checkInDone;
                  _currentNavIndex = 0; // Route back to home
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Check-in completed successfully!',
                      style: GoogleFonts.workSans(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    backgroundColor: AppColors.textPrimary,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Submit Check-in',
                      style: GoogleFonts.workSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: COMMUNITY VIEW (PEOPLE ICON) ---
  Widget _buildCommunityTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: AppStyles.greetingTitle(context),
                  children: const [
                    TextSpan(text: 'Dads '),
                    TextSpan(
                      text: 'Community',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'you are not alone.',
                style: AppStyles.greetingSubtitle(context),
              ),
              const SizedBox(height: 24),

              // Post Question bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newQuestionController,
                        decoration: const InputDecoration(
                          hintText: 'Ask a question or share a tip...',
                          border: InputBorder.none,
                        ),
                        style: AppStyles.bodyText(context),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: AppColors.textPrimary),
                      onPressed: () {
                        if (_newQuestionController.text.trim().isNotEmpty) {
                          setState(() {
                            _communityPosts.insert(0, {
                              'author': 'You shared a thought.',
                              'timeAgo': 'Just now',
                              'avatarText': 'Y',
                              'quote': _newQuestionController.text.trim(),
                              'category': 'All',
                              'likes': 0,
                              'liked': false,
                            });
                            _newQuestionController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Filter category selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: ['All', 'Sleep', 'Relationships', 'First-Time'].map((category) {
                    final isSelected = _selectedCommunityCategory == category;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCommunityCategory = category;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.textPrimary : Colors.white,
                          border: Border.all(
                            color: isSelected ? AppColors.textPrimary : AppColors.border,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category,
                          style: GoogleFonts.workSans(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),

        // Community Feed List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            itemCount: _communityPosts.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final post = _communityPosts[index];
              if (_selectedCommunityCategory != 'All' && post['category'] != _selectedCommunityCategory) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildCommunityCard(
                  author: post['author'],
                  timeAgo: post['timeAgo'],
                  avatarText: post['avatarText'],
                  quote: post['quote'],
                  likes: post['likes'],
                  liked: post['liked'],
                  onLike: () {
                    setState(() {
                      final isLiked = post['liked'] as bool;
                      post['liked'] = !isLiked;
                      post['likes'] = (post['likes'] as int) + (isLiked ? -1 : 1);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- TAB 3: LIBRARY VIEW (BOOK ICON) ---
  Widget _buildLibraryTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: AppStyles.greetingTitle(context),
                  children: const [
                    TextSpan(text: 'Dall '),
                    TextSpan(
                      text: 'Library',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'learn and grow daily.',
                style: AppStyles.greetingSubtitle(context),
              ),
              const SizedBox(height: 24),

              // Filter category selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: ['All', 'Sleep', 'Relationships', 'Guides', 'First-Time'].map((category) {
                    final isSelected = _selectedLibraryCategory == category;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLibraryCategory = category;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.textPrimary : Colors.white,
                          border: Border.all(
                            color: isSelected ? AppColors.textPrimary : AppColors.border,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category,
                          style: GoogleFonts.workSans(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),

        // Library Guides List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            itemCount: _guidesList.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final guide = _guidesList[index];
              if (_selectedLibraryCategory != 'All' && guide['category'] != _selectedLibraryCategory) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: _buildGuideColumnCard(
                  title: guide['title'] ?? '',
                  description: guide['description'] ?? '',
                  imageUrl: guide['imageUrl'] ?? '',
                  badgeText: guide['tag'],
                  isPaid: guide['isPaid'],
                  onTap: () {
                    setState(() {
                      _activeReadGuide = guide;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- TAB 4: SETTINGS VIEW (SLIDERS ICON) ---
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: AppStyles.greetingTitle(context),
                children: const [
                  TextSpan(text: 'Your '),
                  TextSpan(
                    text: 'Profile',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'tailor your experience.',
              style: AppStyles.greetingSubtitle(context),
            ),
            const SizedBox(height: 32),

            // Profile user header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFF131313),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'H',
                      style: GoogleFonts.workSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Harsh Patel',
                        style: GoogleFonts.newsreader(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Father since June 2026',
                        style: AppStyles.metaText(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text('PREFERENCES', style: AppStyles.sectionHeader(context)),
            const SizedBox(height: 12),

            // Preferences Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildToggleRow(
                    title: 'Daily Reflection Reminders',
                    description: 'Receive a quiet nudge to check-in.',
                    value: _remindersEnabled,
                    onChanged: (val) {
                      setState(() {
                        _remindersEnabled = val;
                      });
                    },
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  _buildToggleRow(
                    title: 'Offline Simulation Mode',
                    description: 'Simulate lost connectivity banner.',
                    value: _currentState == HomeState.offline,
                    onChanged: (val) {
                      setState(() {
                        _currentState = val ? HomeState.offline : HomeState.normal;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text('DEMO SETUP', style: AppStyles.sectionHeader(context)),
            const SizedBox(height: 12),

            // Actions Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildActionRow(
                    title: 'Reset Demo State',
                    description: 'Revert check-in to onboarding status.',
                    icon: Icons.refresh_rounded,
                    onTap: () {
                      setState(() {
                        _currentState = HomeState.firstTime;
                        _selectedMood = null;
                        _journalController.clear();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Demo state reset to Onboarding!',
                            style: GoogleFonts.workSans(color: Colors.white),
                          ),
                          backgroundColor: AppColors.textPrimary,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  _buildActionRow(
                    title: 'About Dall App',
                    description: 'Version 1.0.0 • Clean & Minimal',
                    icon: Icons.info_outline_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.workSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppStyles.bodyText(context).copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: AppColors.accentGold,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      title: Text(
        title,
        style: GoogleFonts.workSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        description,
        style: AppStyles.bodyText(context).copyWith(fontSize: 12),
      ),
      leading: Icon(icon, color: AppColors.textSecondary),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }

  // --- READ GUIDE OVERLAY ---
  Widget _buildReadGuideOverlay() {
    if (_activeReadGuide == null) return const SizedBox.shrink();

    final guide = _activeReadGuide!;
    final title = guide['title'] ?? '';
    final imageUrl = guide['imageUrl'] ?? '';
    final tag = guide['tag'] ?? '';
    final content = guide['content'] ?? '';

    return Container(
      color: Colors.black54,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.only(top: 60),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Guide Header Image
                    SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: _buildImageWidget(imageUrl, fit: BoxFit.cover),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tag.toUpperCase(),
                            style: AppStyles.sectionHeader(context),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            title,
                            style: AppStyles.greetingTitle(context).copyWith(fontSize: 28),
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: AppColors.border),
                          const SizedBox(height: 20),
                          Text(
                            content,
                            style: AppStyles.bodyText(context).copyWith(
                              fontSize: 16,
                              height: 1.6,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 100), // padding at bottom
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Close button
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _activeReadGuide = null;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HEADER WIDGET ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // "Dall" Logo in Serif Bold/Medium style
          Text(
            'Dall',
            style: GoogleFonts.newsreader(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          // User Avatar - Square black box matching Figma design
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF131313), // Pure off-black
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              'H',
              style: GoogleFonts.workSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- OFFLINE BANNER WIDGET (Page 29) ---
  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      color: AppColors.offlineBanner,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        children: [
          const Icon(
            Icons.signal_wifi_off_rounded,
            color: AppColors.iconColor,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "You're offline. Showing what we already have...",
              style: AppStyles.bodyTextPrimary(context).copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- GREETING HERO WIDGET ---
  Widget _buildGreetingHero() {
    String greetingText = 'Morning, ';
    String nameText = 'Harsh.';
    String subtitleText = "it's a quiet one.";

    if (_currentState == HomeState.checkInDone) {
      greetingText = 'Evening, ';
      nameText = 'Harsh.';
      subtitleText = 'good work today.';
    } else if (_currentState == HomeState.firstTime) {
      greetingText = 'Welcome, ';
      nameText = 'Harsh.';
      subtitleText = 'glad you came.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppStyles.greetingTitle(context),
            children: [
              TextSpan(text: greetingText),
              TextSpan(
                text: nameText,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitleText,
          style: AppStyles.greetingSubtitle(context),
        ),
      ],
    );
  }

  // --- STATE CONTENT GENERATOR ---
  List<Widget> _buildStateContent() {
    switch (_currentState) {
      case HomeState.normal:
      case HomeState.offline:
        return _buildNormalStateContent();
      case HomeState.checkInDone:
        return _buildDoneStateContent();
      case HomeState.firstTime:
        return _buildFirstTimeStateContent();
    }
  }

  // --- PAGE 26: NORMAL STATE CONTENT ---
  List<Widget> _buildNormalStateContent() {
    return [
      // SECTION: THIS WEEK
      Text('THIS WEEK', style: AppStyles.sectionHeader(context)),
      const SizedBox(height: 12),
      _buildActionCard(
        title: 'Five *quiet* minutes.',
        description: 'Your weekly check-in is ready when you are. No pressure to do it now.',
        actionText: 'Begin',
        onTap: () {
          setState(() {
            _currentNavIndex = 1; // Navigates to Check-in Tab
          });
        },
      ),
      const SizedBox(height: 32),

      // SECTION: THIS WEEK'S GUIDE
      Text("THIS WEEK'S GUIDE", style: AppStyles.sectionHeader(context)),
      const SizedBox(height: 12),
      _buildGuideColumnCard(
        title: 'The first sleepless month',
        description: 'A short read on what no one tells you. 6 min.',
        imageUrl: _imgSleepingBaby,
        onTap: () {
          setState(() {
            _activeReadGuide = _guidesList[0];
          });
        },
      ),
    ];
  }

  // --- PAGE 27: CHECK-IN DONE STATE CONTENT ---
  List<Widget> _buildDoneStateContent() {
    return [
      // SECTION: THIS WEEK
      Text('THIS WEEK', style: AppStyles.sectionHeader(context)),
      const SizedBox(height: 12),
      _buildActionCard(
        title: 'Done for this *week.*',
        description: "Next one's ready Sunday. We'll keep things quiet until then.",
        hasCheckIcon: true,
      ),
      const SizedBox(height: 32),

      // SECTION: PICK UP WHERE YOU LEFT OFF
      Text('PICK UP WHERE YOU LEFT OFF', style: AppStyles.sectionHeader(context)),
      const SizedBox(height: 12),
      _buildFullImageCard(
        title: 'You can love it and still struggle',
        tag: 'GUIDE • 4 MIN',
        imageUrl: _imgBabyCarrier,
        onTap: () {
          setState(() {
            _activeReadGuide = _guidesList[1];
          });
        },
      ),
      const SizedBox(height: 32),

      // SECTION: FROM YOUR COMMUNITY
      Text('FROM YOUR COMMUNITY', style: AppStyles.sectionHeader(context)),
      const SizedBox(height: 12),
      _buildCommunityCard(
        author: 'Marcus asked a question.',
        timeAgo: '2 dads • 35 minutes ago',
        avatarText: 'M',
        quote: 'Slept through tonight\'s feed. Felt like winning.',
        likes: 12,
        liked: false,
        onLike: () {
          setState(() {
            _currentNavIndex = 2; // Routes to Community feed
          });
        },
      ),
    ];
  }

  // --- PAGE 28: FIRST TIME STATE CONTENT ---
  List<Widget> _buildFirstTimeStateContent() {
    return [
      // SECTION: START HERE
      Text('START HERE', style: AppStyles.sectionHeader(context)),
      const SizedBox(height: 12),
      _buildActionCard(
        title: 'Your first check-in.',
        description: "Let's check in on how you're feeling today.",
        actionText: 'Begin',
        onTap: () {
          setState(() {
            _currentNavIndex = 1; // Navigates to Check-in tab
          });
        },
      ),
      const SizedBox(height: 32),

      // SECTION: THIS WEEK'S GUIDE
      Text("THIS WEEK'S GUIDE", style: AppStyles.sectionHeader(context)),
      const SizedBox(height: 12),
      _buildFullImageCard(
        title: 'How to be there when you don\'t know how',
        tag: 'PAID GUIDE',
        imageUrl: _imgFirstTime1,
        isPaid: true,
        onTap: () {
          setState(() {
            _activeReadGuide = _guidesList[2];
          });
        },
      ),
      const SizedBox(height: 32),

      // SECTION: FROM YOUR GUIDES
      Text('FROM YOUR GUIDES', style: AppStyles.sectionHeader(context)),
      const SizedBox(height: 12),
      _buildFullImageCard(
        title: 'First-time dads talking it out',
        tag: 'FREE',
        imageUrl: _imgFirstTime2,
        isPaid: false,
        onTap: () {
          setState(() {
            _activeReadGuide = _guidesList[3];
          });
        },
      ),
    ];
  }

  // --- CARD BUILDERS ---

  Widget _buildActionCard({
    required String title,
    required String description,
    String? actionText,
    bool hasCheckIcon = false,
    VoidCallback? onTap,
  }) {
    List<TextSpan> spans = [];
    final parts = title.split('*');
    for (int i = 0; i < parts.length; i++) {
      final isItalic = i % 2 != 0;
      spans.add(
        TextSpan(
          text: parts[i],
          style: isItalic ? const TextStyle(fontStyle: FontStyle.italic) : null,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasCheckIcon) ...[
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0, top: 2.0),
                    child: Icon(
                      Icons.check,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ],
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppStyles.cardTitle(context),
                      children: spans,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppStyles.bodyText(context),
            ),
            if (actionText != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    actionText,
                    style: AppStyles.bodyTextPrimary(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward,
                    color: AppColors.textPrimary,
                    size: 16,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGuideColumnCard({
    required String title,
    required String description,
    required String imageUrl,
    String? badgeText,
    bool? isPaid,
    VoidCallback? onTap,
  }) {
    final isLocal = imageUrl.startsWith('assets/');
    if (isLocal) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
              width: 1.0,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildImageWidget(
            imageUrl,
            fit: BoxFit.fitWidth,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
            width: 1.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: _buildImageWidget(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isPaid != null)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isPaid ? AppColors.accentGold : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isPaid ? 'PAID GUIDE' : 'FREE',
                        style: AppStyles.badgeText(context).copyWith(
                          color: isPaid ? Colors.black : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (badgeText != null && isPaid == null) ...[
                    Text(
                      badgeText.toUpperCase(),
                      style: AppStyles.metaText(context).copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    title,
                    style: AppStyles.cardTitle(context),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: AppStyles.bodyText(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullImageCard({
    required String title,
    required String tag,
    required String imageUrl,
    bool? isPaid,
    VoidCallback? onTap,
  }) {
    final isLocal = imageUrl.startsWith('assets/');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
            width: 1.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImageWidget(
              imageUrl,
              fit: BoxFit.cover,
            ),
            if (!isLocal) ...[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.05),
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
              if (isPaid != null)
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isPaid ? AppColors.accentGold : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isPaid ? 'PAID GUIDE' : 'FREE',
                      style: AppStyles.badgeText(context).copyWith(
                        color: isPaid ? Colors.black : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isPaid == null) ...[
                      Text(
                        tag.toUpperCase(),
                        style: AppStyles.metaText(context).copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    Text(
                      title,
                      style: AppStyles.overlayCardTitle(context),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityCard({
    required String author,
    required String timeAgo,
    required String avatarText,
    required String quote,
    required int likes,
    required bool liked,
    required VoidCallback onLike,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.communityQuoteBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF131313),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              avatarText,
              style: GoogleFonts.workSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author,
                  style: AppStyles.bodyTextPrimary(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '"$quote"',
                  style: GoogleFonts.workSans(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeAgo,
                      style: AppStyles.metaText(context),
                    ),
                    GestureDetector(
                      onTap: onLike,
                      child: Row(
                        children: [
                          Icon(
                            liked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                            size: 16,
                            color: liked ? Colors.red : AppColors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$likes',
                            style: AppStyles.metaText(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
