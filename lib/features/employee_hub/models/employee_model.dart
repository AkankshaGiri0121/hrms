class EmployeeModel {
  final String id;
  final String clockStatus;
  final String name;
  final String title;
  final String department;
  final String office;
  final String joinDate;
  final String salary;
  final String manager;
  final String email;
  final bool hasImage;

  const EmployeeModel({
    required this.id,
    required this.clockStatus,
    required this.name,
    required this.title,
    required this.department,
    required this.office,
    required this.joinDate,
    required this.salary,
    required this.manager,
    required this.email,
    this.hasImage = false,
  });

  String get initials {
    if (name.isEmpty) return '?';
    List<String> parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }
}
