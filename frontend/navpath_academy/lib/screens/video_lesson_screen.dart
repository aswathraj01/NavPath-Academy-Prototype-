import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'study_materials_screen.dart';

class VideoLessonScreen extends StatefulWidget {
  final Course course;
  final int lessonIndex;
  const VideoLessonScreen({super.key, required this.course, this.lessonIndex = 0});

  @override
  State<VideoLessonScreen> createState() => _VideoLessonScreenState();
}

class _VideoLessonScreenState extends State<VideoLessonScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _sliderValue = 0.4;

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
            title: Text('← ${course.title}',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Video player placeholder ───────────────────────────────
                Container(
                  width: double.infinity,
                  height: 220,
                  color: AppColors.primary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded, size: 36, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 3,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                                thumbColor: Colors.white,
                                overlayColor: Colors.white.withValues(alpha: 0.2),
                              ),
                              child: Slider(
                                value: _sliderValue,
                                onChanged: (v) => setState(() => _sliderValue = v),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('14:23', style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
                                  Text('34:12', style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Physics — Motion & Navigation, Lesson 5',
                          style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text('IMU CET Foundation · Unit 2 of 8',
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 14),

                      // Mark complete CTA
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Mark complete →',
                              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tabs
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: AppColors.divider))),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.textSecondary,
                          indicatorColor: AppColors.primary,
                          indicatorWeight: 2.5,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                          unselectedLabelStyle: GoogleFonts.inter(fontSize: 13),
                          tabs: const [
                            Tab(text: 'Overview'),
                            Tab(text: 'Notes'),
                            Tab(text: 'Discussion (48)'),
                            Tab(text: 'Downloads'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'This lesson covers relative motion, velocity vectors and how they apply to ship navigation and course-plotting. You\'ll work through real IMU CET numerical problems and understand how to plot courses on a chart.',
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.6),
                      ),
                      const SizedBox(height: 20),

                      // Unit lessons
                      Text('UNIT 2 · MOTION & NAVIGATION',
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5)),
                      const SizedBox(height: 10),
                      ...[
                        {'num': '1', 'title': 'Introduction', 'dur': '04:18', 'done': true},
                        {'num': '2', 'title': 'Relative Motion', 'dur': '06:32', 'done': true},
                        {'num': '3', 'title': 'Velocity Vectors', 'dur': '09:22', 'done': true},
                        {'num': '4', 'title': 'Navigation Basics', 'dur': '07:40', 'done': true},
                        {'num': '5', 'title': 'Motion & Navigation', 'dur': '14:22', 'done': false},
                        {'num': '6', 'title': 'Course Plotting', 'dur': '08:15', 'done': false},
                        {'num': '7', 'title': 'Quick Recap', 'dur': '05:00', 'done': false},
                      ].map((l) => _LessonRow(l)),
                      const SizedBox(height: 20),

                      Text('THIS LESSON INCLUDES',
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5)),
                      const SizedBox(height: 10),
                      ...[
                        'Lesson notes (PDF)',
                        'Vector diagrams (slides)',
                        '5-question quick check',
                      ].map((item) => GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) => StudyMaterialsScreen(course: course))),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.description_outlined, size: 18, color: AppColors.accent),
                                  const SizedBox(width: 10),
                                  Text(item, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                                  const Spacer(),
                                  const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textHint),
                                ],
                              ),
                            ),
                          )),
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

class _LessonRow extends StatelessWidget {
  final Map<String, dynamic> data;
  const _LessonRow(this.data);

  @override
  Widget build(BuildContext context) {
    final bool done = data['done'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: done ? AppColors.success.withValues(alpha: 0.3) : AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              size: 18, color: done ? AppColors.success : AppColors.textHint),
          const SizedBox(width: 12),
          Expanded(
            child: Text('${data['num']}  ${data['title']}',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: done ? FontWeight.w500 : FontWeight.w400,
                    color: done ? AppColors.textPrimary : AppColors.textSecondary)),
          ),
          Text(data['dur'] as String,
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
