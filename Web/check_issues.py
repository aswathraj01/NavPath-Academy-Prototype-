import django, os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'navpath_web.settings')
django.setup()

from django.test import RequestFactory, TestCase
from django.contrib.auth import get_user_model
from courses.models import Category, Course, Lesson, LessonCompletion, MockTestQuestion, MockTestResult, StudyMaterial
from enrollments.models import Enrollment
from core.models import Notification, Message, UserSettings, SupportTicket, FAQ, CalendarEvent
from django.urls import reverse

User = get_user_model()

issues = []
passes = []

# ---- Test 1: DB connection ----
try:
    from django.db import connection
    with connection.cursor() as cursor:
        cursor.execute("SELECT 1")
    passes.append("DB Connection: OK (PostgreSQL)")
except Exception as e:
    issues.append(f"DB Connection FAILED: {e}")

# ---- Test 2: Models data ----
try:
    c = Category.objects.count()
    passes.append(f"Categories: {c}")
except Exception as e:
    issues.append(f"Category query FAILED: {e}")

try:
    c = Course.objects.count()
    passes.append(f"Courses: {c}")
except Exception as e:
    issues.append(f"Course query FAILED: {e}")

try:
    c = Lesson.objects.count()
    passes.append(f"Lessons: {c}")
except Exception as e:
    issues.append(f"Lesson query FAILED: {e}")

# ---- Test 3: Message model subject field ----
try:
    msg_fields = [f.name for f in Message._meta.get_fields()]
    if 'subject' not in msg_fields:
        issues.append(f"BUG: Message model missing 'subject' field but users/views.py creates Message with subject=. Fields: {msg_fields}")
    else:
        passes.append("Message.subject: OK")
except Exception as e:
    issues.append(f"Message model check FAILED: {e}")

# ---- Test 4: Enrollment model ----
try:
    from enrollments.models import Enrollment
    fields = [f.name for f in Enrollment._meta.get_fields()]
    passes.append(f"Enrollment fields: {fields}")
except Exception as e:
    issues.append(f"Enrollment model FAILED: {e}")

# ---- Test 5: UserProfile auto-creation ----
try:
    from users.models import UserProfile
    passes.append("UserProfile model: OK")
except Exception as e:
    issues.append(f"UserProfile import FAILED: {e}")

# ---- Test 6: Course select_related works ----
try:
    courses = Course.objects.select_related('category').all()[:5]
    for c in courses:
        _ = c.category.name
    passes.append("Course.select_related(category): OK")
except Exception as e:
    issues.append(f"Course.select_related FAILED: {e}")

# ---- Test 7: lesson_count and course_count ----
try:
    cat = Category.objects.first()
    _ = cat.course_count()
    course = Course.objects.first()
    _ = course.lesson_count()
    passes.append("lesson_count() and course_count(): OK")
except Exception as e:
    issues.append(f"lesson_count/course_count FAILED: {e}")

# ---- Test 8: URL resolution ----
from django.urls import resolve, reverse, NoReverseMatch
url_tests = [
    ('home', [], {}),
    ('about', [], {}),
    ('login', [], {}),
    ('register', [], {}),
    ('logout', [], {}),
    ('dashboard', [], {}),
    ('progress', [], {}),
    ('profile', [], {}),
    ('notifications', [], {}),
    ('messages', [], {}),
    ('settings', [], {}),
    ('support', [], {}),
    ('raise_ticket', [], {}),
    ('calendar', [], {}),
    ('live_classes', [], {}),
    ('courses:list', [], {}),
    ('courses:categories', [], {}),
    ('courses:my_courses', [], {}),
    ('courses:course_player', [], {}),
    ('courses:mark_lesson_complete', [], {}),
    ('courses:mock_tests', [], {}),
    ('courses:submit_mock_test', [], {}),
    ('courses:test_results', [], {}),
    ('courses:study_materials', [], {}),
    ('courses:detail', [], {'pk': 1}),
    ('checkout', [], {}),
    ('enroll_action', [], {}),
]
for name, args, kwargs in url_tests:
    try:
        url = reverse(name, args=args, kwargs=kwargs)
        passes.append(f"URL '{name}': {url}")
    except NoReverseMatch as e:
        issues.append(f"URL MISSING '{name}': {e}")

# ---- Test 9: Settings completeness ----
from django.conf import settings
if not settings.DATABASES.get('default', {}).get('ENGINE', '').endswith('postgresql'):
    issues.append(f"DB Engine not PostgreSQL: {settings.DATABASES.get('default', {}).get('ENGINE')}")
else:
    passes.append(f"DB Engine: {settings.DATABASES['default']['ENGINE']}")

if settings.AUTH_USER_MODEL != 'users.CustomUser':
    issues.append(f"AUTH_USER_MODEL wrong: {settings.AUTH_USER_MODEL}")
else:
    passes.append(f"AUTH_USER_MODEL: {settings.AUTH_USER_MODEL}")

print("="*60)
print(f"PASSES ({len(passes)}):")
for p in passes:
    print(f"  [PASS] {p}")
print()
print(f"ISSUES ({len(issues)}):")
for i in issues:
    print(f"  [FAIL] {i}")
print("="*60)
