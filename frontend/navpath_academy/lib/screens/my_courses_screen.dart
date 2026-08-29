import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../state/enrollment_state.dart';
import 'course_detail_screen.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            title: Text('NavPath',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
            actions: [
              IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: ValueListenableBuilder<Set<String>>(
              valueListenable: EnrollmentState.instance.enrolledIds,
              builder: (context, enrolledIds, _) {
                // Filter courses to only those that are enrolled
                final enrolled = sampleCourses
                    .where((c) => enrolledIds.contains(c.id))
                    .toList();

                final progressValues = {
                  'imu-cet-2027': 0.68,
                  'imu-cet-repeaters': 0.32,
                  'merchant-navy': 0.10,
                  'dns-prep': 0.05,
                  'mock-pack': 0.80,
                  'physics-crash': 0.45,
                };
                final lessonsCompleted = {
                  'imu-cet-2027': 58,
                  'imu-cet-repeaters': 14,
                  'merchant-navy': 6,
                  'dns-prep': 3,
                  'mock-pack': 96,
                  'physics-crash': 13,
                };
                final avatarColors = [
                  AppColors.thumbnailBg1,
                  AppColors.thumbnailBg2,
                  AppColors.thumbnailBg3,
                  const Color(0xFFD1FAE5),
                  const Color(0xFFFDE68A),
                  AppColors.thumbnailBg1,
                ];

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Courses',
                          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(
                        enrolled.isEmpty
                            ? 'No courses enrolled yet'
                            : '${enrolled.length} active enrolment${enrolled.length == 1 ? '' : 's'}',
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),

                      if (enrolled.isEmpty)
                        // ── Empty state ─────────────────────────────────────
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.school_outlined, size: 40, color: AppColors.primary),
                                ),
                                const SizedBox(height: 16),
                                Text('No courses yet',
                                    style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                const SizedBox(height: 6),
                                Text('Enrol in a course to start learning',
                                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        )
                      else
                        // ── Enrolled course cards ───────────────────────────
                        ...enrolled.asMap().entries.map((e) {
                          final course = e.value;
                          final progress = progressValues[course.id] ?? 0.0;
                          final completed = lessonsCompleted[course.id] ?? 0;
                          final color = avatarColors[
                              sampleCourses.indexOf(course) % avatarColors.length];

                          return GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course))),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Avatar
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      course.initials,
                                      style: GoogleFonts.inter(
                                          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(course.tag,
                                                  style: GoogleFonts.inter(
                                                      fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                                            ),
                                            // Enrolled badge
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: AppColors.success.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text('Enrolled',
                                                  style: GoogleFonts.inter(
                                                      fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.success)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(course.title,
                                            style: GoogleFonts.inter(
                                                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 10),
                                        // Progress bar
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            backgroundColor: AppColors.progressBg,
                                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                            minHeight: 6,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('${(progress * 100).round()}% complete',
                                                style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
                                            if (course.lessonCount > 0)
                                              Text('$completed / ${course.lessonCount} lessons',
                                                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
