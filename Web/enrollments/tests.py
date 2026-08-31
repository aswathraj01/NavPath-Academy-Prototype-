from django.test import TestCase, Client
from django.urls import reverse
from django.contrib.auth import get_user_model
from enrollments.models import Enrollment
from courses.models import Category, Course, Lesson, LessonCompletion

User = get_user_model()


class EnrollmentModelTests(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(username='enroll@test.com', password='pass1234!')
        self.category = Category.objects.create(name='Test Cat', icon='T', slug='test-cat')
        self.course = Course.objects.create(
            title='Enroll Course', category=self.category, description='D', is_free=True
        )
        self.l1 = Lesson.objects.create(course=self.course, title='L1', order=1, duration_minutes=10)
        self.l2 = Lesson.objects.create(course=self.course, title='L2', order=2, duration_minutes=15)
        self.enrollment = Enrollment.objects.create(user=self.user, course=self.course)

    def test_enrollment_str(self):
        self.assertIn('enroll@test.com', str(self.enrollment))

    def test_enrollment_unique_together(self):
        """Duplicate enrollment should return existing, not create new."""
        enrollment2, created = Enrollment.objects.get_or_create(user=self.user, course=self.course)
        self.assertFalse(created)
        self.assertEqual(Enrollment.objects.filter(user=self.user, course=self.course).count(), 1)

    def test_update_progress_no_completions(self):
        progress = self.enrollment.update_progress()
        self.assertEqual(progress, 0)

    def test_update_progress_partial(self):
        LessonCompletion.objects.create(user=self.user, lesson=self.l1)
        progress = self.enrollment.update_progress()
        self.assertEqual(progress, 50)

    def test_update_progress_complete(self):
        LessonCompletion.objects.create(user=self.user, lesson=self.l1)
        LessonCompletion.objects.create(user=self.user, lesson=self.l2)
        progress = self.enrollment.update_progress()
        self.assertEqual(progress, 100)

    def test_update_progress_no_lessons(self):
        """Course with no lessons should have 0% progress."""
        empty_course = Course.objects.create(
            title='Empty', category=self.category, description='D', is_free=True
        )
        empty_enrollment = Enrollment.objects.create(user=self.user, course=empty_course)
        progress = empty_enrollment.update_progress()
        self.assertEqual(progress, 0)


class EnrollmentViewTests(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(username='ev@test.com', password='pass1234!')
        self.category = Category.objects.create(name='Cat2', icon='C', slug='cat2')
        self.course = Course.objects.create(
            title='View Course', category=self.category, description='D', is_free=True
        )

    def test_enroll_requires_login(self):
        response = self.client.post(reverse('enroll_action'), {'course_id': self.course.pk})
        self.assertEqual(response.status_code, 302)
        self.assertIn('/users/login/', response.url)

    def test_enroll_creates_enrollment(self):
        self.client.login(username='ev@test.com', password='pass1234!')
        response = self.client.post(reverse('enroll_action'), {'course_id': self.course.pk})
        self.assertEqual(response.status_code, 302)
        self.assertTrue(Enrollment.objects.filter(user=self.user, course=self.course).exists())

    def test_enroll_duplicate_redirects(self):
        """Enrolling twice should not create a duplicate enrollment."""
        self.client.login(username='ev@test.com', password='pass1234!')
        self.client.post(reverse('enroll_action'), {'course_id': self.course.pk})
        self.client.post(reverse('enroll_action'), {'course_id': self.course.pk})
        self.assertEqual(Enrollment.objects.filter(user=self.user, course=self.course).count(), 1)

    def test_enroll_get_redirects(self):
        """GET to enroll action should redirect."""
        self.client.login(username='ev@test.com', password='pass1234!')
        response = self.client.get(reverse('enroll_action'))
        self.assertEqual(response.status_code, 302)

    def test_checkout_public(self):
        response = self.client.get(reverse('checkout') + f'?course={self.course.pk}')
        self.assertEqual(response.status_code, 200)
