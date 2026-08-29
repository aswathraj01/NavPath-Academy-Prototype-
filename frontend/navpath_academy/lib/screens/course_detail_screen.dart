import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../state/enrollment_state.dart';
import 'checkout_screen.dart';
import 'video_lesson_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── AppBar ────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Back', style: GoogleFonts.inter(fontSize: 15, color: Colors.white)),
            actions: [
              IconButton(icon: const Icon(Icons.share_outlined, color: Colors.white), onPressed: () {}),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero card ─────────────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0A2463), Color(0xFF1E3FBF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(course.tag,
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.3)),
                      ),
                      const SizedBox(height: 10),
                      Text(course.title,
                          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(course.description,
                          style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withValues(alpha: 0.8), height: 1.5),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 16),
                      // Meta grid
                      Row(
                        children: [
                          _MetaItem(icon: Icons.schedule_rounded, label: 'Duration', value: course.duration),
                          const SizedBox(width: 20),
                          _MetaItem(icon: Icons.play_circle_outline_rounded, label: 'Lessons', value: '${course.lessonCount} videos'),
                          const SizedBox(width: 20),
                          _MetaItem(icon: Icons.assignment_outlined, label: 'Mock tests', value: '${course.mockTestCount} included'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _MetaItem(icon: Icons.language_rounded, label: 'Language', value: course.language),
                          const SizedBox(width: 20),
                          _MetaItem(icon: Icons.star_rounded, label: 'Rating', value: '${course.rating} (${course.reviewCount})'),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Pricing / Enrol section (reacts to enrollment) ─
                      ValueListenableBuilder<Set<String>>(
                        valueListenable: EnrollmentState.instance.enrolledIds,
                        builder: (context, enrolledIds, _) {
                          final bool enrolled = enrolledIds.contains(course.id);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('FREE',
                                      style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.primary)),
                                  const SizedBox(width: 12),
                                  if (!enrolled)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.error.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text('44% off — ends in 2 days',
                                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.error)),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.check_circle_rounded, size: 13, color: AppColors.success),
                                          const SizedBox(width: 4),
                                          Text('Enrolled',
                                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success)),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: enrolled
                                    ? ElevatedButton.icon(
                                        onPressed: () => Navigator.push(context,
                                            MaterialPageRoute(builder: (_) => VideoLessonScreen(course: course))),
                                        icon: const Icon(Icons.play_circle_fill_rounded, size: 20),
                                        label: Text('Go to course',
                                            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                                      )
                                    : ElevatedButton(
                                        onPressed: () => Navigator.push(context,
                                            MaterialPageRoute(builder: (_) => CheckoutScreen(course: course))),
                                        child: Text('Enrol now',
                                            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
                                      ),
                              ),
                              const SizedBox(height: 10),
                              if (!enrolled)
                                Center(
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text('Add to wishlist',
                                        style: GoogleFonts.inter(fontSize: 14, color: AppColors.accent, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),

                      // ── Features ───────────────────────────────────────
                      const Divider(height: 24, color: AppColors.divider),
                      ...[
                        'Lifetime access',
                        '28 mock tests',
                        'Downloadable materials',
                        'Certificate',
                        'Doubt-clearing forum',
                      ].map((f) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success),
                                const SizedBox(width: 10),
                                Text(f, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary)),
                              ],
                            ),
                          )),
                      const SizedBox(height: 16),

                      // ── Tabs ───────────────────────────────────────────
                      Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.divider)),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.textSecondary,
                          indicatorColor: AppColors.primary,
                          indicatorWeight: 2.5,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                          unselectedLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400),
                          tabs: const [
                            Tab(text: 'Curriculum'),
                            Tab(text: 'Overview'),
                            Tab(text: 'Instructors'),
                            Tab(text: 'Reviews (2,440)'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Curriculum list ────────────────────────────────
                      ...course.curriculum.asMap().entries.map((e) {
                        final lesson = e.value;
                        return GestureDetector(
                          onTap: () {
                            if (!lesson.isLocked) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => VideoLessonScreen(course: course, lessonIndex: e.key)));
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: lesson.isLocked ? AppColors.progressBg : AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${lesson.number}',
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: lesson.isLocked ? AppColors.textSecondary : Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(lesson.title,
                                      style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: lesson.isLocked ? AppColors.textSecondary : AppColors.textPrimary)),
                                ),
                                Text(lesson.duration,
                                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                                const SizedBox(width: 8),
                                Icon(
                                  lesson.isLocked ? Icons.lock_outline_rounded : Icons.play_circle_fill_rounded,
                                  size: 18,
                                  color: lesson.isLocked ? AppColors.textHint : AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: Colors.white.withValues(alpha: 0.7)),
            const SizedBox(width: 4),
            Text(label, style: GoogleFonts.inter(fontSize: 10, color: Colors.white.withValues(alpha: 0.7))),
          ],
        ),
        Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    );
  }
}
