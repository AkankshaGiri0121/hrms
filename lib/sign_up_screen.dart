import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main_dashboard.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isAgreed = false;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const Text('Capyngen HRMS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Register Using Your Credentials', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              _buildLabeledTextField(label: 'Company Name', hint: 'Enter Your Company Name'),
              const SizedBox(height: 16),
              _buildLabeledTextField(label: 'Workspace Subdomain (.capyngen.com)', hint: 'e.g. hrms.capyngen.com'),
              const SizedBox(height: 16),
              _buildDropdownField(label: 'Plan', hint: 'Free', items: ['Free', 'Pro', 'Enterprise']),
              const SizedBox(height: 16),
              _buildDropdownField(label: 'Industry', hint: 'Technology', items: ['Technology', 'Finance', 'Healthcare']),
              const SizedBox(height: 16),
              _buildDropdownField(label: 'Billing Cycle', hint: 'Monthly', items: ['Monthly', 'Annually']),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _buildLabeledTextField(label: 'Admin First Name', hint: '')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildLabeledTextField(label: 'Admin Last Name', hint: '')),
                ],
              ),
              const SizedBox(height: 16),
              _buildLabeledTextField(label: 'Work Email', hint: ''),
              const SizedBox(height: 16),

              Text('Phone Number', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('+91', style: TextStyle(fontSize: 14, color: Colors.black)),
                        const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey),
                        Container(height: 20, width: 1, color: Colors.grey.shade300, margin: const EdgeInsets.only(left: 8)),
                      ],
                    ),
                  ),
                  hintText: '+62 0000 0000 0000',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF8C52FF))),
                ),
              ),
              const SizedBox(height: 16),

              Text('Create Strong Password', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              TextField(
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF8C52FF))),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  SizedBox(
                    height: 24, width: 24,
                    child: Checkbox(
                      value: isAgreed,
                      activeColor: const Color(0xFF8C52FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (val) { setState(() { isAgreed = val!; }); },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'I agree with ',
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                        children: [
                          TextSpan(
                            text: 'terms & conditions',
                            style: const TextStyle(color: Color(0xFF8C52FF), fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              _showTermsBottomSheet(context);
                            },
                          ),
                          const TextSpan(text: ' and '),
                          const TextSpan(
                            text: 'privacy policy',
                            style: TextStyle(color: Color(0xFF8C52FF), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8C52FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: () {
                    if (isAgreed) {
                      Get.snackbar('Success', 'Registration completed!');
                      Get.offAll(() => const MainDashboard());

                    } else {
                      Get.snackbar('Error', 'Please agree to T&C');
                    }
                  },
                  child: const Text('Go To Workspace', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const SignInScreen());
                    },
                    child: const Text('Sign in here', style: TextStyle(color: Color(0xFF8C52FF), fontSize: 12, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const SizedBox(height: 20),
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
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF8C52FF))),
          ),
        )
      ],
    );
  }

  Widget _buildDropdownField({required String label, required String hint, required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF8C52FF))),
          ),
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF8C52FF)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {},
        )
      ],
    );
  }

  void _showTermsBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Terms & Conditions and\nPrivacy Policy', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'Terms and Conditions:\n'
                      'Acceptance: By using the Re-Dus app, you agree to comply with all applicable terms and conditions.\n\n'
                      'Usage: This app is for personal use only and may not be used for commercial purposes without permission.\n\n'
                      'Account: You are responsible for the security of your account and all activities that occur within it.\n\n'
                      'Content: You must not upload content that violates copyright, privacy, or applicable laws.\n\n'
                      'Changes: We reserve the right to change the terms and conditions at any time and will notify you of these changes through the app or via email.\n\n'
                      'Privacy Policy:\n'
                      'Data Collection: We collect personal data such as name, email, and location to process transactions and improve our services.\n\n'
                      'Data Usage: Your data is used for internal purposes such as account management, usage analysis, and service offerings.\n',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade800, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C52FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () {
                  setState(() { isAgreed = true; });
                  Get.back();
                },
                child: const Text('I Agree', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity, height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF8C52FF)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () {
                  setState(() { isAgreed = false; });
                  Get.back();
                },
                child: const Text('Decline', style: TextStyle(fontSize: 16, color: Color(0xFF8C52FF))),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }}