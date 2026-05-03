import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';
import '../../dashboard/view/main_dashboard.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  bool isAgreed = false;
  bool obscurePassword = true;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _staggered(int index, Widget child) {
    final delay = (index * 0.06).clamp(0.0, 0.7);
    final end = (delay + 0.4).clamp(0.0, 1.0);
    final slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Interval(delay, end, curve: Curves.easeOutCubic)),
    );
    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Interval(delay, end, curve: Curves.easeOut)),
    );
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, _) => Opacity(
        opacity: fadeAnim.value,
        child: SlideTransition(position: slideAnim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.w(24),
            vertical: Responsive.h(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              _staggered(0, IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded, size: Responsive.w(20)),
                onPressed: () => Get.back(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )),
              SizedBox(height: Responsive.h(16)),

              // Header
              _staggered(1, Center(
                child: Container(
                  padding: EdgeInsets.all(Responsive.w(14)),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8C52FF).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.business_rounded,
                      color: const Color(0xFF8C52FF), size: Responsive.w(28)),
                ),
              )),
              SizedBox(height: Responsive.h(16)),

              _staggered(2, Center(
                child: Text('HRMS Capyngen',
                    style: TextStyle(fontSize: Responsive.sp(22), fontWeight: FontWeight.w800)),
              )),
              SizedBox(height: Responsive.h(4)),
              _staggered(3, Center(
                child: Text('Create your workspace',
                    style: TextStyle(fontSize: Responsive.sp(13), color: Colors.grey.shade500)),
              )),
              SizedBox(height: Responsive.h(28)),

              // Form fields
              _staggered(4, _buildLabeledTextField(label: 'Company Name', hint: 'Enter Your Company Name')),
              SizedBox(height: Responsive.h(14)),
              _staggered(5, _buildLabeledTextField(label: 'Workspace Subdomain (.capyngen.com)', hint: 'e.g. hrms.capyngen.com')),
              SizedBox(height: Responsive.h(14)),
              _staggered(6, _buildDropdownField(label: 'Plan', hint: 'Free', items: ['Free', 'Pro', 'Enterprise'])),
              SizedBox(height: Responsive.h(14)),
              _staggered(7, _buildDropdownField(label: 'Industry', hint: 'Technology', items: ['Technology', 'Finance', 'Healthcare'])),
              SizedBox(height: Responsive.h(14)),
              _staggered(8, _buildDropdownField(label: 'Billing Cycle', hint: 'Monthly', items: ['Monthly', 'Annually'])),
              SizedBox(height: Responsive.h(14)),

              _staggered(9, Row(
                children: [
                  Expanded(child: _buildLabeledTextField(label: 'Admin First Name', hint: '')),
                  SizedBox(width: Responsive.w(16)),
                  Expanded(child: _buildLabeledTextField(label: 'Admin Last Name', hint: '')),
                ],
              )),
              SizedBox(height: Responsive.h(14)),
              _staggered(10, _buildLabeledTextField(label: 'Work Email', hint: 'admin@company.com')),
              SizedBox(height: Responsive.h(14)),

              _staggered(11, _buildPhoneField()),
              SizedBox(height: Responsive.h(14)),
              _staggered(12, _buildPasswordField()),
              SizedBox(height: Responsive.h(20)),

              // Terms
              _staggered(13, Row(
                children: [
                  SizedBox(
                    height: Responsive.w(22),
                    width: Responsive.w(22),
                    child: Checkbox(
                      value: isAgreed,
                      activeColor: const Color(0xFF8C52FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(4))),
                      onChanged: (val) => setState(() => isAgreed = val!),
                    ),
                  ),
                  SizedBox(width: Responsive.w(8)),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'I agree with ',
                        style: TextStyle(fontSize: Responsive.sp(12), color: Colors.grey.shade600),
                        children: [
                          TextSpan(
                            text: 'terms & conditions',
                            style: TextStyle(color: const Color(0xFF8C52FF), fontWeight: FontWeight.w600, fontSize: Responsive.sp(12)),
                            recognizer: TapGestureRecognizer()..onTap = () => _showTermsBottomSheet(context),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'privacy policy',
                            style: TextStyle(color: const Color(0xFF8C52FF), fontWeight: FontWeight.w600, fontSize: Responsive.sp(12)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
              SizedBox(height: Responsive.h(24)),

              // Submit
              _staggered(14, SizedBox(
                width: double.infinity,
                height: Responsive.h(52),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8C52FF),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: const Color(0xFF8C52FF).withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(14))),
                  ),
                  onPressed: () {
                    if (isAgreed) {
                      Get.snackbar('Success', 'Registration completed!');
                      Get.offAll(() => const MainDashboard());
                    } else {
                      Get.snackbar('Error', 'Please agree to T&C');
                    }
                  },
                  child: Text('Go To Workspace', style: TextStyle(
                      fontSize: Responsive.sp(16), fontWeight: FontWeight.w700)),
                ),
              )),
              SizedBox(height: Responsive.h(20)),

              _staggered(15, Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: TextStyle(
                      fontSize: Responsive.sp(12), color: Colors.grey.shade600)),
                  GestureDetector(
                    onTap: () => Get.to(() => const SignInScreen()),
                    child: Text('Sign in here', style: TextStyle(
                        color: const Color(0xFF8C52FF), fontSize: Responsive.sp(12), fontWeight: FontWeight.w700)),
                  ),
                ],
              )),
              SizedBox(height: Responsive.h(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        SizedBox(height: Responsive.h(8)),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: Responsive.sp(14)),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: EdgeInsets.symmetric(vertical: Responsive.h(16), horizontal: Responsive.w(14)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(Responsive.r(12)), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Responsive.r(12)), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Responsive.r(12)), borderSide: const BorderSide(color: Color(0xFF8C52FF), width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label, required String hint, required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        SizedBox(height: Responsive.h(8)),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: EdgeInsets.symmetric(vertical: Responsive.h(16), horizontal: Responsive.w(14)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(Responsive.r(12)), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Responsive.r(12)), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Responsive.r(12)), borderSide: const BorderSide(color: Color(0xFF8C52FF), width: 1.5)),
          ),
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade400, fontSize: Responsive.sp(14))),
          icon: Icon(Icons.keyboard_arrow_down, color: const Color(0xFF8C52FF), size: Responsive.w(22)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {},
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Phone Number', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        SizedBox(height: Responsive.h(8)),
        TextField(
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(12)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('+91', style: TextStyle(fontSize: Responsive.sp(14), color: Colors.black)),
                  Icon(Icons.keyboard_arrow_down, size: Responsive.w(20), color: Colors.grey),
                  Container(height: Responsive.h(20), width: 1, color: Colors.grey.shade300, margin: EdgeInsets.only(left: Responsive.w(8))),
                ],
              ),
            ),
            hintText: '+91 0000 0000 00',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: Responsive.sp(14)),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: EdgeInsets.symmetric(vertical: Responsive.h(16), horizontal: Responsive.w(12)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(Responsive.r(12)), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Responsive.r(12)), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Responsive.r(12)), borderSide: const BorderSide(color: Color(0xFF8C52FF), width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Create Strong Password', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        SizedBox(height: Responsive.h(8)),
        TextField(
          obscureText: obscurePassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            suffixIcon: IconButton(
              icon: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.grey.shade400, size: Responsive.w(20)),
              onPressed: () => setState(() => obscurePassword = !obscurePassword),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: Responsive.h(16), horizontal: Responsive.w(14)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(Responsive.r(12)), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Responsive.r(12)), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Responsive.r(12)), borderSide: const BorderSide(color: Color(0xFF8C52FF), width: 1.5)),
          ),
        ),
      ],
    );
  }

  void _showTermsBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.all(Responsive.w(24)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(Responsive.r(30))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Terms & Conditions and\nPrivacy Policy', textAlign: TextAlign.center,
                style: TextStyle(fontSize: Responsive.sp(20), fontWeight: FontWeight.bold)),
            SizedBox(height: Responsive.h(20)),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'Terms and Conditions:\n'
                  'Acceptance: By using the HRMS Capyngen app, you agree to comply with all applicable terms and conditions.\n\n'
                  'Usage: This app is for personal use only and may not be used for commercial purposes without permission.\n\n'
                  'Account: You are responsible for the security of your account and all activities that occur within it.\n\n'
                  'Content: You must not upload content that violates copyright, privacy, or applicable laws.\n\n'
                  'Changes: We reserve the right to change the terms and conditions at any time and will notify you of these changes through the app or via email.\n\n'
                  'Privacy Policy:\n'
                  'Data Collection: We collect personal data such as name, email, and location to process transactions and improve our services.\n\n'
                  'Data Usage: Your data is used for internal purposes such as account management, usage analysis, and service offerings.\n',
                  style: TextStyle(fontSize: Responsive.sp(12), color: Colors.grey.shade800, height: 1.5),
                ),
              ),
            ),
            SizedBox(height: Responsive.h(20)),
            SizedBox(
              width: double.infinity,
              height: Responsive.h(50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C52FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(25))),
                ),
                onPressed: () { setState(() => isAgreed = true); Get.back(); },
                child: Text('I Agree', style: TextStyle(fontSize: Responsive.sp(16), color: Colors.white)),
              ),
            ),
            SizedBox(height: Responsive.h(12)),
            SizedBox(
              width: double.infinity,
              height: Responsive.h(50),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF8C52FF)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(25))),
                ),
                onPressed: () { setState(() => isAgreed = false); Get.back(); },
                child: Text('Decline', style: TextStyle(fontSize: Responsive.sp(16), color: const Color(0xFF8C52FF))),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }
}