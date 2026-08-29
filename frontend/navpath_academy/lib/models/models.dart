class Course {
  final String id;
  final String initials;
  final String tag;
  final String title;
  final String description;
  final double rating;
  final int reviewCount;
  final bool isFree;
  final String? badge; // 'Bestseller', 'New', 'Popular'
  final String duration;
  final int lessonCount;
  final int mockTestCount;
  final String language;
  final List<Lesson> curriculum;

  const Course({
    required this.id,
    required this.initials,
    required this.tag,
    required this.title,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.isFree,
    this.badge,
    required this.duration,
    required this.lessonCount,
    required this.mockTestCount,
    required this.language,
    this.curriculum = const [],
  });
}

class Lesson {
  final int number;
  final String title;
  final String duration;
  final bool isLocked;

  const Lesson({
    required this.number,
    required this.title,
    required this.duration,
    this.isLocked = false,
  });
}

class MockQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const MockQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class StudyMaterial {
  final String icon;
  final String name;
  final String size;
  final String date;

  const StudyMaterial({
    required this.icon,
    required this.name,
    required this.size,
    required this.date,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final String type; // 'alert', 'message', 'update'

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
    this.type = 'update',
  });
}


// ─── Sample data ─────────────────────────────────────────────────────────────

final List<Course> sampleCourses = [
  Course(
    id: 'imu-cet-2027',
    initials: 'IC',
    tag: 'IMU CET FOUNDATION',
    title: 'IMU CET 2027 Complete Foundation Course',
    description:
        'A structured, exam-focused programme covering Physics, Chemistry, Mathematics and English for IMU CET 2027 — with weekly mock tests and doubt-clearing sessions led by serving and retired Merchant Navy officers.',
    rating: 4.8,
    reviewCount: 2440,
    isFree: true,
    badge: 'Bestseller',
    duration: '6 months',
    lessonCount: 86,
    mockTestCount: 24,
    language: 'English-Malaysian',
    curriculum: [
      Lesson(number: 1, title: 'Kinematics & Vectors', duration: '12:46', isLocked: false),
      Lesson(number: 2, title: 'Motion & Navigation', duration: '18:28', isLocked: false),
      Lesson(number: 3, title: 'Ship Stability', duration: '14:14', isLocked: true),
      Lesson(number: 4, title: 'Marine Meteorology', duration: '21:04', isLocked: true),
      Lesson(number: 5, title: 'Seamanship Basics', duration: '16:38', isLocked: true),
    ],
  ),
  Course(
    id: 'imu-cet-repeaters',
    initials: 'IR',
    tag: 'IMU CET FOUNDATION',
    title: 'IMU CET Repeaters — Rank Booster',
    description: 'Intensive crash course for IMU CET repeaters targeting top ranks.',
    rating: 4.6,
    reviewCount: 980,
    isFree: true,
    badge: 'New',
    duration: '3 months',
    lessonCount: 42,
    mockTestCount: 18,
    language: 'English',
    curriculum: [],
  ),
  Course(
    id: 'merchant-navy',
    initials: 'MN',
    tag: 'IMU CET FOUNDATION',
    title: 'Merchant Navy Career Preparation',
    description: 'Complete guide to merchant navy career paths and entrance exams.',
    rating: 4.9,
    reviewCount: 1200,
    isFree: true,
    badge: 'Popular',
    duration: '4 months',
    lessonCount: 60,
    mockTestCount: 20,
    language: 'English',
    curriculum: [],
  ),
  Course(
    id: 'dns-prep',
    initials: 'DN',
    tag: 'IMU CET FOUNDATION',
    title: 'DNS Entrance Preparation',
    description: 'Diploma in Nautical Science entrance exam preparation course.',
    rating: 4.5,
    reviewCount: 560,
    isFree: true,
    badge: null,
    duration: '5 months',
    lessonCount: 70,
    mockTestCount: 22,
    language: 'English',
    curriculum: [],
  ),
  Course(
    id: 'mock-pack',
    initials: 'MT',
    tag: 'IMU CET FOUNDATION',
    title: 'IMU CET Full Mock Test Pack',
    description: '120+ full-length mock tests with detailed analytics and answers.',
    rating: 4.8,
    reviewCount: 3200,
    isFree: true,
    badge: 'Popular',
    duration: 'Lifetime',
    lessonCount: 0,
    mockTestCount: 120,
    language: 'English',
    curriculum: [],
  ),
  Course(
    id: 'physics-crash',
    initials: 'IC',
    tag: 'IMU CET FOUNDATION',
    title: 'Physics & Mathematics Crash Course',
    description: 'Fast-track Physics and Maths revision for last-minute IMU CET preparation.',
    rating: 4.7,
    reviewCount: 890,
    isFree: true,
    badge: null,
    duration: '6 weeks',
    lessonCount: 30,
    mockTestCount: 10,
    language: 'English',
    curriculum: [],
  ),
];

final List<MockQuestion> sampleQuestions = [
  MockQuestion(
    question:
        'A ship steams due North at 12 knots while a current sets it East at 5 knots. What is the resultant speed over ground (approx.)?',
    options: ['13 knots', '17 knots', '7 knots', '12 knots'],
    correctIndex: 0,
  ),
  MockQuestion(
    question: 'Which of the following is NOT a principle of ship stability?',
    options: ['Centre of gravity', 'Metacentre', "Bernoulli's theorem", 'Righting lever'],
    correctIndex: 2,
  ),
  MockQuestion(
    question: 'The unit of force in the SI system is:',
    options: ['Dyne', 'Newton', 'Joule', 'Pascal'],
    correctIndex: 1,
  ),
  MockQuestion(
    question: 'Deviation of a magnetic compass is caused by:',
    options: ["Earth's magnetic field", "Ship's own magnetism", 'Variation', 'True North'],
    correctIndex: 1,
  ),
  MockQuestion(
    question: 'A vessel\'s displacement is 5000 tonnes and TPC is 25. How much cargo must be loaded to reduce freeboard by 10 cm?',
    options: ['250 tonnes', '2500 tonnes', '500 tonnes', '25 tonnes'],
    correctIndex: 0,
  ),
];

final List<StudyMaterial> sampleMaterials = [
  StudyMaterial(icon: 'pdf', name: 'Lesson 5 notes.pdf', size: '2.4MB', date: '3 days ago'),
  StudyMaterial(icon: 'slides', name: 'Vector diagrams.pdf', size: '1MB', date: '3 days ago'),
  StudyMaterial(icon: 'pdf', name: 'Unit 2 formula sheet.pdf', size: '641KB', date: '1 week ago'),
  StudyMaterial(icon: 'pdf', name: 'Practice problems Set 5.pdf', size: '890KB', date: '1 week ago'),
];

final List<AppNotification> sampleNotifications = [
  AppNotification(
    id: '1',
    title: 'New Mock Test Available',
    message: 'IMU CET Full Mock Test 12 is now available. Take it now to check your preparation.',
    time: '2 hours ago',
    isRead: false,
    type: 'alert',
  ),
  AppNotification(
    id: '2',
    title: 'Lesson Unlocked',
    message: 'Ship Stability lesson is now unlocked in your IMU CET Foundation course.',
    time: '5 hours ago',
    isRead: false,
    type: 'update',
  ),
  AppNotification(
    id: '3',
    title: 'Daily Streak Maintained! 🔥',
    message: 'You have maintained your 4-day streak. Keep it up!',
    time: '1 day ago',
    isRead: true,
    type: 'message',
  ),
  AppNotification(
    id: '4',
    title: 'Live Doubt Clearing Session',
    message: 'Join the live doubt clearing session for Physics at 6 PM today.',
    time: '1 day ago',
    isRead: true,
    type: 'alert',
  ),
];

