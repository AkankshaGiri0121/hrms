import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';
import 'sign_up_screen.dart';
import '../../dashboard/view/main_dashboard.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  bool rememberMe = false;
  bool obscurePassword = true;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Staggered animation helper
  Widget _staggered(int index, Widget child) {
    final delay = index * 0.08;
    final end = (delay + 0.5).clamp(0.0, 1.0);
    final slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Interval(delay, end, curve: Curves.easeOutCubic),
    ));
    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Interval(delay, end, curve: Curves.easeOut),
      ),
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
    return Container(
      padding: EdgeInsets.only(
        left: Responsive.w(24),
        right: Responsive.w(24),
        top: Responsive.h(8),
        bottom: MediaQuery.of(context).viewInsets.bottom + Responsive.h(20),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(Responsive.r(30))),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Drag handle
            _staggered(0, Container(
              width: Responsive.w(40),
              height: Responsive.h(4),
              margin: EdgeInsets.only(bottom: Responsive.h(20)),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(Responsive.r(2)),
              ),
            )),

            // Logo icon
            _staggered(1, Container(
              padding: EdgeInsets.all(Responsive.w(14)),
              decoration: BoxDecoration(
                color: const Color(0xFF8C52FF).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.lock_open_rounded, 
                color: const Color(0xFF8C52FF), size: Responsive.w(28)),
            )),
            SizedBox(height: Responsive.h(16)),

            _staggered(2, Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: Responsive.sp(24),
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            )),
            SizedBox(height: Responsive.h(6)),
            _staggered(3, Text(
              'Sign in to continue to your workspace',
              style: TextStyle(
                  fontSize: Responsive.sp(13),
                  color: Colors.grey.shade500),
            )),
            SizedBox(height: Responsive.h(28)),

            _staggered(4, _buildTextField(
              label: 'Email Address',
              hint: 'you@company.com',
              prefixIcon: Icons.mail_outline_rounded,
            )),
            SizedBox(height: Responsive.h(18)),

            _staggered(5, _buildTextField(
              label: 'Password',
              hint: '••••••••',
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
            )),
            SizedBox(height: Responsive.h(12)),

            _staggered(6, Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: Responsive.w(22),
                      height: Responsive.w(22),
                      child: Checkbox(
                        value: rememberMe,
                        activeColor: const Color(0xFF8C52FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Responsive.r(4)),
                        ),
                        onChanged: (val) => setState(() => rememberMe = val!),
                      ),
                    ),
                    SizedBox(width: Responsive.w(6)),
                    Text('Remember me', style: TextStyle(
                        fontSize: Responsive.sp(12), color: Colors.grey.shade600)),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                  child: Text('Forgot Password?', style: TextStyle(
                      color: const Color(0xFF8C52FF), fontSize: Responsive.sp(12), fontWeight: FontWeight.w600)),
                ),
              ],
            )),
            SizedBox(height: Responsive.h(24)),

            _staggered(7, SizedBox(
              width: double.infinity,
              height: Responsive.h(52),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C52FF),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: const Color(0xFF8C52FF).withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Responsive.r(14)),
                  ),
                ),
                onPressed: () {
                  Get.back();
                  Get.offAll(() => const MainDashboard());
                },
                child: Text('Sign In', style: TextStyle(
                  fontSize: Responsive.sp(16), fontWeight: FontWeight.w700)),
              ),
            )),
            SizedBox(height: Responsive.h(24)),

            _staggered(8, Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Need a new workspace? ', style: TextStyle(
                    fontSize: Responsive.sp(12), color: Colors.grey.shade600)),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.to(() => const SignUpScreen(), transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 400));
                  },
                  child: Text('Start onboarding', style: TextStyle(
                    color: const Color(0xFF8C52FF), fontSize: Responsive.sp(12), fontWeight: FontWeight.w700)),
                ),
              ],
            )),
            SizedBox(height: Responsive.h(10)),
          ],
        ),
      ),
    );
  }


  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(
            fontSize: Responsive.sp(12), fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        SizedBox(height: Responsive.h(8)),
        TextField(
          obscureText: isPassword ? obscurePassword : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: Responsive.sp(14)),
            prefixIcon: Icon(prefixIcon, color: const Color(0xFF8C52FF), size: Responsive.w(20)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey.shade400, size: Responsive.w(20),
                    ),
                    onPressed: () => setState(() => obscurePassword = !obscurePassword),
                  )
                : null,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: EdgeInsets.symmetric(vertical: Responsive.h(16)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Responsive.r(12)),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Responsive.r(12)),
              borderSide: const BorderSide(color: Color(0xFF8C52FF), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}