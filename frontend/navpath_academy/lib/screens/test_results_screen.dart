import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class TestResultsScreen extends StatelessWidget {
  final Course course;
  final List<int?> answers;

  const TestResultsScreen({super.key, required this.course, required this.answers});

  @override
  Widget build(BuildContext context) {
    int correct = 0;
    for (int i = 0; i < answers.length; i++) {
      if (answers[i] == sampleQuestions[i].correctIndex) correct++;
    }
    final int total = sampleQuestions.length;
    final int score = ((correct / total) * 100).round();
    final String grade = score >= 80 ? 'Nicely charted.' : score >= 60 ? 'Good effort!' : 'Keep practicing!';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Test Results', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Score card ─────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A2463), Color(0xFF1E3FBF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Text('$score%',
                      style: GoogleFonts.inter(fontSize: 52, fontWeight: FontWeight.w800, color: Colors.white)),
                  Text('SCORE', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.7), letterSpacing: 1.5)),
                  const SizedBox(height: 10),
                  Text(grade, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('$correct of $total correct',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Stats row ──────────────────────────────────────────────────
            Row(
              children: [
                Expanded(child: _StatChip(label: 'Correct', value: '$correct', color: AppColors.success)),
                const SizedBox(width: 10),
                Expanded(child: _StatChip(label: 'Incorrect', value: '${total - correct}', color: AppColors.error)),
                const SizedBox(width: 10),
                Expanded(child: _StatChip(label: 'Time', value: '3:48', color: AppColors.accent)),
              ],
            ),
            const SizedBox(height: 20),

            // ── Answer review ──────────────────────────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Answer Review',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ),
            const SizedBox(height: 10),
            ...sampleQuestions.asMap().entries.map((e) {
              final int qIndex = e.key;
              final question = e.value;
              final userAnswer = answers[qIndex];
              final bool isCorrect = userAnswer == question.correctIndex;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCorrect ? AppColors.success.withValues(alpha: 0.4) : AppColors.error.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          size: 18,
                          color: isCorrect ? AppColors.success : AppColors.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Q${qIndex + 1}. ${question.question}',
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary, height: 1.5)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (userAnswer != null)
                      _AnswerRow(
                        label: 'Your answer',
                        value: question.options[userAnswer],
                        color: isCorrect ? AppColors.success : AppColors.error,
                      ),
                    if (!isCorrect) ...[
                      const SizedBox(height: 4),
                      _AnswerRow(
                        label: 'Correct answer',
                        value: question.options[question.correctIndex],
                        color: AppColors.success,
                      ),
                    ],
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // ── Action buttons ─────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Back to lesson', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
                child: Text('Back to dashboard', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _AnswerRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _AnswerRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ',
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        Expanded(
          child: Text(value,
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ),
      ],
    );
  }
}
