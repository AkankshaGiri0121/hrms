class DepartmentModel {
  final String name;
  final String head;
  final int headcount;
  final double performance;
  final int openings;
  final String recentActivity;

  const DepartmentModel({
    required this.name,
    required this.head,
    required this.headcount,
    required this.performance,
    required this.openings,
    required this.recentActivity,
  });
}

class DesignationModel {
  final String title;
  final String department;

  const DesignationModel({
    required this.title,
    required this.department,
  });
}
