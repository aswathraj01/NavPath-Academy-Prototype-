import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../state/enrollment_state.dart';

class CheckoutScreen extends StatefulWidget {
  final Course course;
  const CheckoutScreen({super.key, required this.course});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPayment = 0;
  final _nameCtrl = TextEditingController(text: 'Aswath');
  final _phoneCtrl = TextEditingController(text: '+91 00000 XXXXX');
  final _emailCtrl = TextEditingController(text: 'aswath@example.com');

  final List<_PaymentOption> _paymentOptions = const [
    _PaymentOption(icon: Icons.account_balance_wallet_outlined, label: 'UPI — Google Pay/PhonePe/Paytm'),
    _PaymentOption(icon: Icons.credit_card_outlined, label: 'Credit/Debit Card'),
    _PaymentOption(icon: Icons.account_balance_outlined, label: 'Net Banking'),
    _PaymentOption(icon: Icons.schedule_outlined, label: 'EMI (3/6 months, no-cost)'),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Complete your enrolment',
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('IMU CET 2027 Complete Foundation Course',
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 20),

            // ── Payment methods ──────────────────────────────────────────────
            _SectionTitle('Payment Method'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: _paymentOptions.asMap().entries.map((e) {
                  final bool selected = _selectedPayment == e.key;
                  final bool isLast = e.key == _paymentOptions.length - 1;
                  return Column(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _selectedPayment = e.key),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          child: Row(
                            children: [
                              Radio<int>(
                                value: e.key,
                                groupValue: _selectedPayment,
                                onChanged: (v) => setState(() => _selectedPayment = v!),
                                activeColor: AppColors.primary,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              const SizedBox(width: 8),
                              Icon(e.value.icon, size: 20, color: selected ? AppColors.primary : AppColors.textSecondary),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(e.value.label,
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                                        color: selected ? AppColors.primary : AppColors.textPrimary)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isLast) const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // ── Billing details ──────────────────────────────────────────────
            _SectionTitle('Billing Details'),
            const SizedBox(height: 10),
            _BillingField(label: 'Full Name', controller: _nameCtrl),
            const SizedBox(height: 12),
            _BillingField(label: 'Phone', controller: _phoneCtrl, keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            _BillingField(label: 'Email', controller: _emailCtrl, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),

            // ── Order summary ────────────────────────────────────────────────
            _SectionTitle('Order Summary'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  _OrderRow('Course fee', 'FREE'),
                  const SizedBox(height: 8),
                  _OrderRow('Launch discount', 'FREE'),
                  const SizedBox(height: 8),
                  _OrderRow('GST (18%)', 'FREE (Incl.)'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: AppColors.divider),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total payable',
                          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      Text('FREE',
                          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Pay CTA ──────────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Register enrollment
                  EnrollmentState.instance.enroll(widget.course.id);
                  // Show success snackbar, then pop back to Course Details
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                          const SizedBox(width: 10),
                          Text('Successfully enrolled!',
                              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                        ],
                      ),
                      backgroundColor: AppColors.success,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text('Pay & enrol',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 12),

            // Razorpay disclaimer
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline_rounded, size: 12, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text('Secured by Razorpay · 256-bit encryption',
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.textHint)),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      );
}

class _BillingField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  const _BillingField({required this.label, required this.controller, this.keyboardType});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(label: Text(label)),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final String label;
  final String value;
  const _OrderRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
        Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.success)),
      ],
    );
  }
}

class _PaymentOption {
  final IconData icon;
  final String label;
  const _PaymentOption({required this.icon, required this.label});
}
