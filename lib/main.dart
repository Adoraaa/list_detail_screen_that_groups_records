import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

// --- 1. GÖREV MODELİ ---
enum TaskPriority { low, medium, high }

class Task {
  final String id;
  String title;
  String? subtitle;
  String date;
  TaskPriority priority;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.subtitle,
    required this.date,
    required this.priority,
    this.isCompleted = false,
  });
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: const Color(0xFF6E28D9),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        dividerColor: Colors.transparent,
      ),
      home: const TaskDashboardScreen(),
    );
  }
}

class TaskDashboardScreen extends StatefulWidget {
  const TaskDashboardScreen({super.key});

  @override
  State<TaskDashboardScreen> createState() => _TaskDashboardScreenState();
}

class _TaskDashboardScreenState extends State<TaskDashboardScreen> {
  // --- 2. BAŞLANGIÇ VERİLERİ ---
  List<Task> tasks = [
    Task(
      id: '1',
      title: 'Proje sunumunu hazırla',
      subtitle: 'Q2 planlaması için sunum slaytlarını oluştur',
      date: '3 Mayıs',
      priority: TaskPriority.high,
      isCompleted: false,
    ),
    Task(
      id: '2',
      title: 'API dokümantasyonunu güncelle',
      subtitle: 'Yeni endpoint\'ler için README\'yi düzenle',
      date: '5 Mayıs',
      priority: TaskPriority.medium,
      isCompleted: false,
    ),
    Task(
      id: '3',
      title: 'Code review yap',
      subtitle: 'Auth modülü PR\'ını incele',
      date: 'Bugün',
      priority: TaskPriority.high,
      isCompleted: false,
    ),
    Task(
      id: '4',
      title: 'UI component library\'yi güncelle',
      subtitle: 'Material UI 7.3.5 versiyonuna yükselt',
      date: '10 Mayıs',
      priority: TaskPriority.low,
      isCompleted: false,
    ),
    Task(
      id: '5',
      title: 'Haftalık toplantıya katıl',
      date: '1 Mayıs',
      priority: TaskPriority.medium,
      isCompleted: true,
    ),
    Task(
      id: '6',
      title: 'Test coverage raporunu kontrol et',
      subtitle: 'Coverage %80\'in üzerinde mi?',
      date: '30 Nisan',
      priority: TaskPriority.low,
      isCompleted: true,
    ),
    Task(
      id: '7',
      title: 'Database backup\'ını al',
      date: '29 Nisan',
      priority: TaskPriority.high,
      isCompleted: true,
    ),
  ];

  List<Task> get activeTasks => tasks.where((t) => !t.isCompleted).toList();
  List<Task> get completedTasks => tasks.where((t) => t.isCompleted).toList();

  @override
  Widget build(BuildContext context) {
    int totalTasks = tasks.length;
    int completedCount = completedTasks.length;
    double progress = totalTasks == 0 ? 0.0 : completedCount / totalTasks;
    int progressPercentage = (progress * 100).round();

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(
            progress,
            progressPercentage,
            totalTasks,
            completedCount,
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildTaskGroup(
                  title: 'Aktif Görevler',
                  tasks: activeTasks,
                  iconColor: const Color(0xFF6E28D9),
                  iconBgColor: const Color(0xFFEBE4FF),
                  initiallyExpanded: true,
                ),
                const SizedBox(height: 16),
                _buildTaskGroup(
                  title: 'Tamamlanan Görevler',
                  tasks: completedTasks,
                  iconColor: const Color(0xFF10B981),
                  iconBgColor: const Color(0xFFD1FAE5),
                  initiallyExpanded: true,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskBottomSheet(context),
        backgroundColor: const Color(0xFF6E28D9),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- 3. BİRLEŞTİRİLMİŞ MODAL POPUP (EKLEME & DÜZENLEME) ---
  void _showTaskBottomSheet(BuildContext context, {Task? existingTask}) {
    bool isEditing = existingTask != null;
    String taskTitle = isEditing ? existingTask.title : '';
    TaskPriority selectedPriority = isEditing
        ? existingTask.priority
        : TaskPriority.medium;

    final TextEditingController textController = TextEditingController(
      text: taskTitle,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 32,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEditing ? 'Görevi Düzenle' : 'Hızlı Ekle',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Görev',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: textController,
                    autofocus: true,
                    onChanged: (value) => taskTitle = value,
                    decoration: InputDecoration(
                      hintText: 'Görev başlığı girin...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF6E28D9)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF6E28D9),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF6E28D9),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Öncelik',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildPriorityButton(
                        'Düşük',
                        TaskPriority.low,
                        selectedPriority,
                        () => setModalState(
                          () => selectedPriority = TaskPriority.low,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildPriorityButton(
                        'Orta',
                        TaskPriority.medium,
                        selectedPriority,
                        () => setModalState(
                          () => selectedPriority = TaskPriority.medium,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildPriorityButton(
                        'Yüksek',
                        TaskPriority.high,
                        selectedPriority,
                        () => setModalState(
                          () => selectedPriority = TaskPriority.high,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        isEditing ? Icons.save : Icons.send,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        isEditing ? 'Güncelle' : 'Ekle',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6E28D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (taskTitle.trim().isNotEmpty) {
                          setState(() {
                            if (isEditing) {
                              existingTask.title = taskTitle;
                              existingTask.priority = selectedPriority;
                            } else {
                              tasks.insert(
                                0,
                                Task(
                                  id: DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                                  title: taskTitle,
                                  date: 'Bugün',
                                  priority: selectedPriority,
                                ),
                              );
                            }
                          });
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPriorityButton(
    String text,
    TaskPriority priority,
    TaskPriority currentSelected,
    VoidCallback onTap,
  ) {
    bool isSelected = priority == currentSelected;
    Color bgColor = const Color(0xFFF3F4F6);
    if (isSelected) {
      if (priority == TaskPriority.low) bgColor = const Color(0xFF10B981);
      if (priority == TaskPriority.medium) bgColor = const Color(0xFFF59E0B);
      if (priority == TaskPriority.high) bgColor = const Color(0xFFEF4444);
    }

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // --- 4. GÖREV KARTLARI VE LİSTELERİ ---
  Widget _buildTaskGroup({
    required String title,
    required List<Task> tasks,
    required Color iconColor,
    required Color iconBgColor,
    required bool initiallyExpanded,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          '${tasks.length} görev',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: iconColor, width: 2),
            ),
          ),
        ),
        children: tasks.map((task) => _buildTaskCard(task)).toList(),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    Color priorityColor;
    switch (task.priority) {
      case TaskPriority.high:
        priorityColor = const Color(0xFFEF4444);
        break;
      case TaskPriority.medium:
        priorityColor = const Color(0xFFF59E0B);
        break;
      case TaskPriority.low:
        priorityColor = const Color(0xFF10B981);
        break;
    }

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() => tasks.removeWhere((t) => t.id == task.id));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: GestureDetector(
            onTap: () => setState(() => task.isCompleted = !task.isCompleted),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isCompleted
                      ? const Color(0xFF10B981)
                      : Colors.grey.shade400,
                  width: 2,
                ),
                color: task.isCompleted
                    ? const Color(0xFF10B981)
                    : Colors.transparent,
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: task.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: task.isCompleted ? Colors.grey : Colors.black87,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  task.subtitle!,
                  style: TextStyle(
                    color: task.isCompleted
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    fontSize: 13,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task.date,
                  style: const TextStyle(
                    color: Color(0xFF6366F1),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: priorityColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    _showTaskBottomSheet(context, existingTask: task),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 5. ÜST BİLGİ (HEADER) - DİNAMİK TARİHLİ YENİ VERSİYON ---
  Widget _buildHeader(
    double progress,
    int progressPercentage,
    int totalTasks,
    int completedTasks,
  ) {
    // Anlık tarihi alma ve biçimlendirme
    DateTime now = DateTime.now();
    List<String> months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    String currentMonthName = months[now.month - 1]; // Örn: 'Mayıs'

    String formattedCurrentDate =
        '${now.day} $currentMonthName ${now.year}'; // Örn: '2 Mayıs 2026'
    String subtitleText =
        '$currentMonthName ${now.year} - Sprint 12'; // Örn: 'Mayıs 2026 - Sprint 12'

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
      decoration: const BoxDecoration(color: Color(0xFF7C3AED)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconButton(Icons.arrow_back),
              _buildIconButton(Icons.more_vert),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Sprint Görevleri',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          // DİNAMİK ALT BAŞLIK
          Text(
            subtitleText,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 6),
              // DİNAMİK GÜNÜN TARİHİ
              Text(
                formattedCurrentDate,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(width: 20),

              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                '$completedTasks/$totalTasks tamamlandı',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '%$progressPercentage tamamlandı',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}
