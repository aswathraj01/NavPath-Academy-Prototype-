import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/course_card.dart';
import '../widgets/stat_card.dart';
import 'course_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            title: Text('NavPath',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
            actions: [
              IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
              IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.thumbnailBg1,
                  child: Text('AS', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Welcome card ───────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0A2463), Color(0xFF1E3FBF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Welcome back, Aswath ',
                                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                            const Text('⚓', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('4-day IMU CET streak 🔥',
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text("Take today's mock test",
                              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Stats grid ─────────────────────────────────────────────
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                    children: const [
                      StatCard(value: '68%', label: 'Overall progress', subLabel: '↑ 6% this week'),
                      StatCard(value: '142', label: 'Mock tests taken', subLabel: 'Rank 312/4,890'),
                      StatCard(value: '7.4', label: 'Avg. score /10', subLabel: '↑ 0.6 vs last week'),
                      StatCard(value: '4', label: 'Day streak', subLabel: 'Best: 21 days'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Continue where you left off ────────────────────────────
                  _SectionHeader('CONTINUE WHERE YOU LEFT OFF'),
                  const SizedBox(height: 10),
                  _ContinueLearningCard(),
                  const SizedBox(height: 20),

                  // ── Browse by category ─────────────────────────────────────
                  _SectionHeader('Browse by category'),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.0,
                    children: [
                      _CategoryTile(icon: '🎓', title: 'IMU CET', subtitle: '38 courses', color: const Color(0xFFEEF2FF)),
                      _CategoryTile(icon: '⚓', title: 'Merchant Navy', subtitle: '21 courses', color: const Color(0xFFEEF2FF)),
                      _CategoryTile(icon: '🎯', title: 'DNS Prep', subtitle: '14 courses', color: const Color(0xFFEEF2FF)),
                      _CategoryTile(icon: '📝', title: 'Mock Tests', subtitle: '100+ tests', color: const Color(0xFFEEF2FF)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Recommended for you ────────────────────────────────────
                  _SectionHeader('Recommended for you'),
                  const SizedBox(height: 10),
                  ...sampleCourses.take(3).map((c) => CourseCard(
                        initials: c.initials,
                        tag: c.tag,
                        title: c.title,
                        rating: c.rating,
                        isFree: c.isFree,
                        badge: c.badge,
                        avatarColor: AppColors.thumbnailBg1,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => CourseDetailScreen(course: c))),
                      )),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// ─── Continue learning card ───────────────────────────────────────────────────
class _ContinueLearningCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A2463), Color(0xFF1E3FBF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CONTINUE WHERE YOU LEFT OFF',
              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.7), letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Text('Physics — Motion & Navigation, Lesson 5',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 4),
          Text('IMU CET Foundation · 12 min remaining',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.75))),
          const SizedBox(height: 14),
          // Progress dots
          Row(
            children: List.generate(8, (i) => Container(
              width: i == 4 ? 20 : 8,
              height: 8,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: i <= 4 ? Colors.white : Colors.white.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(4),
              ),
            )),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => CourseDetailScreen(course: sampleCourses[0]))),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Resume lesson →',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

// ─── Category tile ────────────────────────────────────────────────────────────
class _CategoryTile extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;

  const _CategoryTile({required this.icon, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
