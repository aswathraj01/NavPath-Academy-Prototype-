import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController(text: 'Aswath');
  final _emailCtrl = TextEditingController(text: 'aswath@example.com');
  final _phoneCtrl = TextEditingController(text: '+91 0000000000');
  final _locationCtrl = TextEditingController(text: 'Kerala, India');
  final _dobCtrl = TextEditingController(text: '01 Jan 2004');
  final _bioCtrl = TextEditingController(
      text: 'Title ');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _locationCtrl.dispose();
    _dobCtrl.dispose();
    _bioCtrl.dispose();
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
        title: Text('Edit Profile',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Avatar section ─────────────────────────────────────────────
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.thumbnailBg1,
              child: Text('AM',
                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: Text('Change Photo',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent)),
            ),
            const SizedBox(height: 20),

            // ── Form fields ────────────────────────────────────────────────
            _ProfileField(label: 'Full Name', controller: _nameCtrl),
            const SizedBox(height: 14),
            _ProfileField(label: 'Email', controller: _emailCtrl, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 14),
            _ProfileField(label: 'Phone Number', controller: _phoneCtrl, keyboardType: TextInputType.phone),
            const SizedBox(height: 14),
            _ProfileField(label: 'Location', controller: _locationCtrl),
            const SizedBox(height: 14),
            _ProfileField(label: 'Date of Birth', controller: _dobCtrl),
            const SizedBox(height: 14),
            TextField(
              controller: _bioCtrl,
              maxLines: 3,
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
              decoration: const InputDecoration(labelText: 'Bio (Optional)'),
            ),
            const SizedBox(height: 28),

            // ── Save CTA ───────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Save Changes',
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _ProfileField({required this.label, required this.controller, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(labelText: label),
    );
  }
}
