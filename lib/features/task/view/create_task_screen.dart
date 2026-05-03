import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  // Selections store karne ke variables
  String selectedAssignee = '';
  String selectedPriority = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 16),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text('Create New Task', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, -5))]),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC4A4FF), // Lighter purple for initial state
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            onPressed: () {
              _showConfirmationSheet(); // Submit pe confirmation puchenge
            },
            child: const Text('Create Task', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attachments
            const Text('Attachment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text('Format should be in .pdf .jpeg .png less than 5MB', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildAttachmentBox(Icons.upload_file, 'Upload Attachments')),
                const SizedBox(width: 16),
                Expanded(child: _buildAttachmentBox(Icons.link, 'Add Links/URLs')),
              ],
            ),
            const SizedBox(height: 20),

            // Form Fields
            _buildInputField('Task Name', 'Enter Task Name', Icons.task),
            const SizedBox(height: 16),

            const Text('Task Description', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter Task Description',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),
            const SizedBox(height: 16),

            _buildInputField('Client Name', 'Enter Client Name', Icons.person_outline),
            const SizedBox(height: 16),

            _buildDropdownField('Project', 'Select Project', Icons.layers),
            const SizedBox(height: 16),

            _buildDropdownField('Difficulty', 'Select Difficulty', Icons.adjust),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showSelectionSheet('Assign To', 'Who will finish this task', ['Ivankov - Sr Front End Developer', 'Brahm - Mid Front End Developer', 'Alice - Sr Front End Developer', 'Jeane - Jr Front End Developer', 'Claudia - Jr Front End Developer'], true),
                    child: _buildDropdownField('Assign To', selectedAssignee.isEmpty ? 'Select' : selectedAssignee.split(' - ')[0], Icons.person_add_alt),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: _buildDropdownField('Created By', 'Select', Icons.person)),
              ],
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: () => _showSelectionSheet('Priority', 'Select the priority', ['Low', 'Medium', 'High'], false),
              child: _buildDropdownField('Priority', selectedPriority.isEmpty ? 'Select Priority' : selectedPriority, Icons.stacked_bar_chart),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(child: _buildDropdownField('Start Date', 'Select', Icons.calendar_month, isDate: true)),
                const SizedBox(width: 16),
                Expanded(child: _buildDropdownField('Due Date', 'Select', Icons.calendar_today, isDate: true)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Form Helper Widgets ---
  Widget _buildAttachmentBox(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: const Color(0xFFC4A4FF), style: BorderStyle.solid), // Ideally dotted, solid for simplicity
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF8C52FF)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(icon, color: const Color(0xFF8C52FF), size: 20),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF8C52FF))),
          ),
        )
      ],
    );
  }

  Widget _buildDropdownField(String label, String hint, IconData icon, {bool isDate = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF8C52FF), size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(hint, style: TextStyle(color: hint.contains('Select') ? Colors.grey.shade400 : Colors.black87, fontSize: 14), overflow: TextOverflow.ellipsis)),
              Icon(isDate ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_down, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ],
    );
  }

  // --- Bottom Sheets Logic ---

  // 1. Assign To / Priority Selection Sheet
  void _showSelectionSheet(String title, String subtitle, List<String> options, bool isAssignee) {
    String tempSelection = isAssignee ? selectedAssignee : selectedPriority;

    Get.bottomSheet(
      StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                  const SizedBox(height: 20),

                  // Options List
                  ...options.map((option) {
                    bool isSelected = tempSelection == option;
                    return GestureDetector(
                      onTap: () {
                        setSheetState(() { tempSelection = option; });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: isSelected ? const Color(0xFF8C52FF) : Colors.grey.shade300, width: isSelected ? 1.5 : 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(option, style: TextStyle(color: isSelected ? const Color(0xFF8C52FF) : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? const Color(0xFF8C52FF) : Colors.grey.shade300, size: 20),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 20),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: const BorderSide(color: Color(0xFF8C52FF)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                          onPressed: () => Get.back(),
                          child: const Text('Cancel', style: TextStyle(color: Color(0xFF8C52FF), fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: const Color(0xFF8C52FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                          onPressed: () {
                            setState(() {
                              if (isAssignee) selectedAssignee = tempSelection;
                              else selectedPriority = tempSelection;
                            });
                            Get.back(); // Close sheet
                          },
                          child: const Text('Select', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
      ),
      isScrollControlled: true,
    );
  }

  // 2. Confirmation Sheet (Double Check)
  void _showConfirmationSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Overlapping Icon Style
            Transform.translate(
              offset: const Offset(0, -50),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF8C52FF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: const Color(0xFF8C52FF).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 10))],
                ),
                child: const Icon(Icons.assignment, color: Colors.white, size: 40),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Column(
                children: [
                  const Text('Create New Task', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('Double-check your task details to ensure everything\nis correct. Do you want to proceed?', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity, height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8C52FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      onPressed: () {
                        Get.back(); // Close confirmation
                        _showSuccessSheet(); // Open success
                      },
                      child: const Text('Yes, Proceed Now', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity, height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF8C52FF)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      onPressed: () => Get.back(),
                      child: const Text('No, Let me check', style: TextStyle(color: Color(0xFF8C52FF), fontSize: 16)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 3. Success Sheet (Task Created)
  void _showSuccessSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: const Offset(0, -50),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF8C52FF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: const Color(0xFF8C52FF).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 10))],
                ),
                child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 40),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Column(
                children: [
                  const Text('Task Has Been Created!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('Congratulations! Task has been created! view your\ntask in the task management', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity, height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8C52FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      onPressed: () {
                        Get.back(); // Close sheet
                        Get.back(); // Wapas Task Menu pe jane ke liye
                      },
                      child: const Text('View Task Management', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      isDismissible: false, // Taaki bina button dabaye band na ho
    );
  }
}