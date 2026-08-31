from django.core.management.base import BaseCommand
from django.utils.text import slugify
from courses.models import Category, Course, Lesson, StudyMaterial, MockTestQuestion
from core.models import FAQ, Notification, CalendarEvent
from django.contrib.auth import get_user_model
import datetime

User = get_user_model()

CATEGORIES = [
    {
        'name': 'IMU CET',
        'icon': '◉',
        'description': 'Complete preparation for IMU Common Entrance Test 2027.',
        'courses': [
            {'title': 'IMU CET 2027 Complete Preparation', 'icon': '⚓', 'desc': 'Full syllabus coverage for IMU CET 2027 including Physics, Chemistry, Math and GA.'},
            {'title': 'IMU CET Physics Masterclass', 'icon': '⚡', 'desc': 'Deep dive into Physics concepts tested in IMU CET with 500+ practice questions.'},
            {'title': 'IMU CET Mathematics Bootcamp', 'icon': '📐', 'desc': 'Algebra, Calculus, Geometry and Trigonometry for IMU CET aspirants.'},
            {'title': 'IMU CET General Awareness', 'icon': '🌐', 'desc': 'Current affairs, maritime GK and reasoning for IMU CET General Awareness section.'},
        ]
    },
    {
        'name': 'IMU CET Repeaters',
        'icon': '✧',
        'description': 'Comprehensive preparation for IMU CET repeaters aiming to improve scores.',
        'courses': [
            {'title': 'IMU CET Repeaters Crash Course', 'icon': '🎯', 'desc': 'Fast-track revision for students who appeared before and need a score boost.'},
            {'title': 'IMU CET Chemistry Intensive', 'icon': '🧪', 'desc': 'Focused Chemistry preparation covering all topics from the IMU CET syllabus.'},
            {'title': 'IMU CET Mock Test Series', 'icon': '📝', 'desc': '25 full-length mock tests modelled on actual IMU CET exam pattern.'},
            {'title': 'IMU CET Previous Year Papers', 'icon': '📋', 'desc': 'Solved papers from 2018-2026 with detailed explanations for every question.'},
        ]
    },
    {
        'name': 'Merchant Navy Deck',
        'icon': '⚓',
        'description': 'Deck Officer preparation programs for Merchant Navy careers.',
        'courses': [
            {'title': 'Merchant Navy Deck Officer Course', 'icon': '🚢', 'desc': 'Complete preparation for Deck Officer sponsorship exams including navigation and seamanship.'},
            {'title': 'Navigation & Watchkeeping', 'icon': '🧭', 'desc': 'Master celestial navigation, chart work and COLREGS for officer of the watch duties.'},
            {'title': 'Maritime Safety & STCW', 'icon': '🛟', 'desc': 'STCW competency training, fire fighting, survival craft and medical first aid.'},
            {'title': 'Deck Officer Interview Prep', 'icon': '💼', 'desc': 'HR and technical interview preparation for leading shipping company sponsorships.'},
        ]
    },
    {
        'name': 'Merchant Navy Engine',
        'icon': '⚙',
        'description': 'Engine Officer training for Merchant Navy aspirants.',
        'courses': [
            {'title': 'Engine Officer Complete Course', 'icon': '🔧', 'desc': 'Comprehensive Marine Engineering preparation for Engine Officer sponsorship.'},
            {'title': 'Thermodynamics & Heat Engines', 'icon': '🌡', 'desc': 'In-depth study of marine diesel engines, boilers, and thermodynamic principles.'},
            {'title': 'Electrical & Electronics for Marine', 'icon': '⚡', 'desc': 'Marine electrical systems, automation and electronics for engineers.'},
            {'title': 'Engine Officer Sponsorship Prep', 'icon': '🏆', 'desc': 'Top shipping company sponsorship tests preparation with mock interviews.'},
        ]
    },
    {
        'name': 'DNS Program',
        'icon': '▤',
        'description': 'Diploma in Nautical Science complete preparation program.',
        'courses': [
            {'title': 'DNS Complete Preparation', 'icon': '🎓', 'desc': 'All-in-one DNS preparation covering all subjects from IMU affiliated institutes.'},
            {'title': 'DNS Mathematics & Science', 'icon': '🔬', 'desc': 'Foundation and advanced mathematics and science for DNS program students.'},
            {'title': 'DNS English & Communication', 'icon': '📖', 'desc': 'Maritime English, communication skills and report writing for DNS students.'},
            {'title': 'DNS Interview & GD Preparation', 'icon': '🎤', 'desc': 'Group discussion and interview preparation for DNS program admissions.'},
        ]
    },
    {
        'name': 'Mock Tests',
        'icon': '✓',
        'description': 'All India Mock Test Series for maritime entrance exams.',
        'courses': [
            {'title': 'IMU CET All India Test Series', 'icon': '📊', 'desc': '25 full-length tests with detailed analysis and All India ranking system.'},
            {'title': 'Merchant Navy Aptitude Tests', 'icon': '🧠', 'desc': 'Aptitude and reasoning tests for various Merchant Navy sponsorship exams.'},
            {'title': 'DNS Entrance Mock Tests', 'icon': '✅', 'desc': 'Specialized mock tests for DNS program entrance at leading maritime institutes.'},
            {'title': 'Weekly Practice Tests', 'icon': '📅', 'desc': 'Weekly mini-tests covering rotating topics to keep your preparation sharp.'},
        ]
    },
]

LESSONS_TEMPLATE = [
    ('Introduction & Overview', 8),
    ('Core Concepts Part 1', 15),
    ('Core Concepts Part 2', 18),
    ('Advanced Topics', 22),
    ('Practice Problems', 12),
    ('Revision & Summary', 10),
]

DEMO_VIDEO = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'

MOCK_QUESTIONS_TEMPLATE = [
    {
        'q': 'A body of mass 2 kg is moving with a velocity of 5 m/s. What is its kinetic energy?',
        'a': '10 J', 'b': '25 J', 'c': '50 J', 'd': '100 J', 'ans': 'B',
        'exp': 'KE = ½mv² = ½ × 2 × 5² = 25 J'
    },
    {
        'q': 'Which of the following is NOT a COLREG rule?',
        'a': 'Rule 5 - Lookout', 'b': 'Rule 10 - Traffic Separation', 'c': 'Rule 15 - Crossing', 'd': 'Rule 20 - Engine Maintenance', 'ans': 'D',
        'exp': 'Rule 20 in COLREGS is about Application of Lights, not engine maintenance.'
    },
    {
        'q': 'The boiling point of water at standard pressure is:',
        'a': '90°C', 'b': '95°C', 'c': '100°C', 'd': '105°C', 'ans': 'C',
        'exp': 'Water boils at 100°C (212°F) at standard atmospheric pressure (1 atm).'
    },
    {
        'q': 'What does "STCW" stand for?',
        'a': 'Standards of Training, Certification and Watchkeeping',
        'b': 'Ship Traffic Control Worldwide',
        'c': 'Safety Training Code for Watchkeepers',
        'd': 'Standards of Technical Crew Work', 'ans': 'A',
        'exp': 'STCW stands for the International Convention on Standards of Training, Certification and Watchkeeping for Seafarers.'
    },
    {
        'q': 'The Plimsoll line on a ship indicates:',
        'a': 'Ship speed limit', 'b': 'Maximum safe loading level', 'c': 'Fuel level', 'd': 'Draft measurement', 'ans': 'B',
        'exp': 'The Plimsoll line (load line) shows the maximum depth to which a ship may be safely loaded.'
    },
]

FAQS = [
    ('How do I enroll in a course?', 'Click on any course and press "Enroll Now". Since all courses are free, you will be enrolled instantly.', 'General'),
    ('Can I access courses on mobile?', 'Yes! NavPath Academy is fully responsive and works on all devices including phones and tablets.', 'General'),
    ('How is my progress tracked?', 'Your progress is automatically updated as you complete each lesson. Mark a lesson as complete and your progress bar updates.', 'Courses'),
    ('How do mock tests work?', 'Select a course from the Mock Tests section, then attempt the questions. Your score and analysis will be shown after submission.', 'Mock Tests'),
    ('What is the duration of courses?', 'Course durations vary from 4 weeks to 12 weeks depending on the subject. All courses are self-paced.', 'Courses'),
    ('How do I contact support?', 'Use the Support section in your dashboard to raise a ticket, chat with a representative, or email us at support@navpathacademy.com', 'Support'),
    ('Are the courses free?', 'Yes! All courses on NavPath Academy are currently free for all registered students.', 'General'),
    ('How do I get a certificate?', 'Complete all lessons in a course to receive a digital certificate of completion. Certificates can be downloaded from your profile.', 'Courses'),
]


class Command(BaseCommand):
    help = 'Seed the database with sample categories, courses, lessons, and mock test questions.'

    def handle(self, *args, **kwargs):
        self.stdout.write('Seeding database...')

        # Clear existing data
        MockTestQuestion.objects.all().delete()
        StudyMaterial.objects.all().delete()
        Lesson.objects.all().delete()
        Course.objects.all().delete()
        Category.objects.all().delete()
        FAQ.objects.all().delete()

        total_courses = 0
        for cat_data in CATEGORIES:
            cat, _ = Category.objects.get_or_create(
                name=cat_data['name'],
                defaults={
                    'icon': cat_data['icon'],
                    'description': cat_data['description'],
                    'slug': slugify(cat_data['name']),
                }
            )

            for c_data in cat_data['courses']:
                course = Course.objects.create(
                    title=c_data['title'],
                    category=cat,
                    description=c_data['desc'],
                    thumbnail_icon=c_data['icon'],
                    price=0,
                    is_free=True,
                    duration='12 Weeks',
                    rating=4.8,
                    students_enrolled=0,
                )
                total_courses += 1

                # Create lessons
                for i, (lesson_title, dur_mins) in enumerate(LESSONS_TEMPLATE, 1):
                    Lesson.objects.create(
                        course=course,
                        title=lesson_title,
                        order=i,
                        video_url=DEMO_VIDEO,
                        duration=f"{dur_mins}:00",
                        duration_minutes=dur_mins,
                        description=f"Detailed study of {lesson_title} for {course.title}.",
                    )

                # Create study materials
                StudyMaterial.objects.create(course=course, title=f"{course.title} - Full Notes PDF", material_type='pdf', description='Comprehensive notes covering the full syllabus.')
                StudyMaterial.objects.create(course=course, title=f"{course.title} - Formula Sheet", material_type='pdf', description='Quick reference formula sheet for revision.')
                StudyMaterial.objects.create(course=course, title=f"Supplementary Reading Notes", material_type='note', description='Additional reading material and case studies.')

                # Create mock test questions
                for j, q in enumerate(MOCK_QUESTIONS_TEMPLATE, 1):
                    MockTestQuestion.objects.create(
                        course=course,
                        question=q['q'],
                        option_a=q['a'],
                        option_b=q['b'],
                        option_c=q['c'],
                        option_d=q['d'],
                        correct_answer=q['ans'],
                        explanation=q['exp'],
                        order=j,
                    )

        # Create FAQs
        for i, (q, a, cat) in enumerate(FAQS, 1):
            FAQ.objects.create(question=q, answer=a, order=i, category=cat)

        # Create sample notifications for any existing user
        try:
            first_user = User.objects.first()
            if first_user:
                Notification.objects.filter(user=first_user).delete()
                Notification.objects.create(user=first_user, title='New Mock Test Available', message='IMU CET Mock Test 02 is now available. Attempt it before Jan 15!', notif_type='test')
                Notification.objects.create(user=first_user, title='Live Class: Physics', message='Live class on "Motion & Navigation" is scheduled for tomorrow at 6 PM.', notif_type='class')
                Notification.objects.create(user=first_user, title='New Study Material', message='New PDF study material added in Mathematics course.', notif_type='material')
                Notification.objects.create(user=first_user, title='You scored 78% in Mock Test 01', message='Great performance! Check the detailed analysis in Test Results.', notif_type='score')
                Notification.objects.create(user=first_user, title='New Course Available', message='Engine Officer Complete Course is now live. Enroll for free!', notif_type='course')
        except Exception:
            pass

        self.stdout.write(self.style.SUCCESS(
            f'SUCCESS: Seeded {len(CATEGORIES)} categories, {total_courses} courses, {total_courses * len(LESSONS_TEMPLATE)} lessons, {len(FAQS)} FAQs.'
        ))
