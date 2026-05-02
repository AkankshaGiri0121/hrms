import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_task_screen.dart';

class TaskMenuScreen extends StatelessWidget {
  const TaskMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8C52FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            onPressed: () {
              Get.to(() => const CreateTaskScreen(), transition: Transition.rightToLeft);
            },
            child: const Text('Create Task', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8C52FF),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                  ),
                  padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Challenges Awaiting', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                              child: const Icon(Icons.close, color: Colors.white, size: 20),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text('Let\'s tackle your to do list', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),

                Positioned(
                  top: 150,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Summary of Your Work', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('Your current task progress', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildSummaryBox('Total Tasks', '5', Icons.tag, const Color(0xFF8C52FF)),
                              const SizedBox(width: 12),
                              _buildSummaryBox('In Progress', '2', Icons.access_time, Colors.orange),
                              const SizedBox(width: 12),
                              _buildSummaryBox('Done', '1', Icons.check_circle, Colors.green),
                              const SizedBox(width: 12),
                              _buildSummaryBox('High', '1', Icons.warning, Colors.red),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 80),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFilterChip('All', '3', false),
                  _buildFilterChip('In Progress', '2', true),
                  _buildFilterChip('Finish', '2', false),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildTaskCard('Wiring Dashboard Analytics', 0.6),
                  _buildTaskCard('API Dashboard Analytics Integration', 0.8),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBox(String title, String count, IconData icon, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 8),
          Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String count, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8C52FF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
          const SizedBox(width: 6),
          CircleAvatar(
            radius: 10,
            backgroundColor: isSelected ? Colors.white24 : Colors.grey.shade200,
            child: Text(count, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 10)),
          )
        ],
      ),
    );
  }

  Widget _buildTaskCard(String title, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flash_on, color: Color(0xFF8C52FF)),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  CircleAvatar(radius: 4, backgroundColor: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  const Text('In Progress', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ]),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.star, size: 10, color: Colors.red),
                  const SizedBox(width: 4),
                  const Text('High', style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold)),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade200, color: const Color(0xFF8C52FF), minHeight: 6, borderRadius: BorderRadius.circular(10)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 60,
                height: 24,
                child: Stack(
                  children: const [
                    Positioned(left: 0, child: CircleAvatar(radius: 12, backgroundColor: Colors.blueAccent)),
                    Positioned(left: 14, child: CircleAvatar(radius: 12, backgroundColor: Colors.orangeAccent)),
                    Positioned(left: 28, child: CircleAvatar(radius: 12, backgroundColor: Colors.pinkAccent)),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Text('27 Sept', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(width: 12),
                  const Icon(Icons.chat_bubble_outline, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Text('2', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}