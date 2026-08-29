import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'test_results_screen.dart';

class MockTestScreen extends StatefulWidget {
  final Course course;
  const MockTestScreen({super.key, required this.course});

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  int _currentQuestion = 1;
  int? _selectedOption;
  final List<int?> _answers = List.filled(5, null);

  int get _totalQuestions => sampleQuestions.length;
  MockQuestion get _question => sampleQuestions[_currentQuestion - 1];

  void _selectOption(int index) => setState(() => _selectedOption = index);

  void _next() {
    _answers[_currentQuestion - 1] = _selectedOption;
    if (_currentQuestion < _totalQuestions) {
      setState(() {
        _currentQuestion++;
        _selectedOption = _answers[_currentQuestion - 1];
      });
    } else {
      _answers[_currentQuestion - 1] = _selectedOption;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => TestResultsScreen(course: widget.course, answers: _answers)));
    }
  }

  void _prev() {
    if (_currentQuestion > 1) {
      _answers[_currentQuestion - 1] = _selectedOption;
      setState(() {
        _currentQuestion--;
        _selectedOption = _answers[_currentQuestion - 1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentQuestion == _totalQuestions;
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header row ────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Unit 2 Quick Check',
                            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text('Motion & Navigation',
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_outlined, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text('04:12',
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Question progress ─────────────────────────────────────────
              Text('Question $_currentQuestion of $_totalQuestions',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _currentQuestion / _totalQuestions,
                  backgroundColor: AppColors.progressBg,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 5,
                ),
              ),
              const SizedBox(height: 24),

              // ── Question text ─────────────────────────────────────────────
              Text(_question.question,
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.5)),
              const SizedBox(height: 24),

              // ── Options ───────────────────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  itemCount: _question.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final bool selected = _selectedOption == i;
                    final String letter = ['A', 'B', 'C', 'D'][i];
                    return GestureDetector(
                      onTap: () => _selectOption(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary.withValues(alpha: 0.06) : AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected ? AppColors.primary : AppColors.inputBorder,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: selected ? AppColors.primary : AppColors.progressBg,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(letter,
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: selected ? Colors.white : AppColors.textSecondary)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(_question.options[i],
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                                      color: selected ? AppColors.primary : AppColors.textPrimary)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── Navigation buttons ────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: _currentQuestion > 1 ? _prev : null,
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: Text('Previous', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
                    style: TextButton.styleFrom(foregroundColor: AppColors.textPrimary),
                  ),
                  ElevatedButton.icon(
                    onPressed: _selectedOption != null ? _next : null,
                    icon: Text(
                      isLast ? 'Submit' : 'Next question',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    label: const Icon(Icons.arrow_forward_rounded, size: 18),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
