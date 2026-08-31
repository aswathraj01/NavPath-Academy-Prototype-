from django.test import TestCase, Client
from django.urls import reverse
from django.contrib.auth import get_user_model
from courses.models import Category, Course, Lesson, LessonCompletion, MockTestQuestion, MockTestResult, StudyMaterial
from enrollments.models import Enrollment
from core.models import FAQ, UserSettings

User = get_user_model()


class CourseModelTests(TestCase):
    def setUp(self):
        self.category = Category.objects.create(
            name='Test Category', icon='T', slug='test-category'
        )
        self.course = Course.objects.create(
            title='Test Course',
            category=self.category,
            description='A test course',
            price=0.00,
            is_free=True,
        )
        self.lesson1 = Lesson.objects.create(
            course=self.course, title='Lesson 1', order=1, duration_minutes=10
        )
        self.lesson2 = Lesson.objects.create(
            course=self.course, title='Lesson 2', order=2, duration_minutes=15
        )

    def test_category_str(self):
        self.assertEqual(str(self.category), 'Test Category')

    def test_category_course_count(self):
        self.assertEqual(self.category.course_count(), 1)

    def test_course_str(self):
        self.assertEqual(str(self.course), 'Test Course')

    def test_course_lesson_count(self):
        self.assertEqual(self.course.lesson_count(), 2)

    def test_lesson_ordering(self):
        lessons = list(self.course.lessons.all())
        self.assertEqual(lessons[0].order, 1)
        self.assertEqual(lessons[1].order, 2)

    def test_mock_test_result_percentage(self):
        user = User.objects.create_user(username='testuser', password='pass1234!')
        result = MockTestResult.objects.create(user=user, course=self.course, score=8, total=10)
        self.assertEqual(result.percentage(), 80)

    def test_mock_test_result_zero_total(self):
        user = User.objects.create_user(username='testuser2', password='pass1234!')
        result = MockTestResult.objects.create(user=user, course=self.course, score=0, total=0)
        self.assertEqual(result.percentage(), 0)


class CourseViewTests(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(username='viewuser@test.com', password='pass1234!')
        self.category = Category.objects.create(name='Nav', icon='N', slug='nav')
        self.course = Course.objects.create(
            title='Nav Course', category=self.category, description='Desc', is_free=True
        )
        self.lesson = Lesson.objects.create(
            course=self.course, title='Intro', order=1, duration_minutes=10
        )

    def test_course_list_public(self):
        response = self.client.get(reverse('courses:list'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Nav Course')

    def test_course_detail_public(self):
        response = self.client.get(reverse('courses:detail', kwargs={'pk': self.course.pk}))
        # Verify the view returns 200 and the correct course object is in context
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.context['course'], self.course)

    def test_course_detail_404(self):
        response = self.client.get(reverse('courses:detail', kwargs={'pk': 9999}))
        self.assertEqual(response.status_code, 404)

    def test_my_courses_requires_login(self):
        response = self.client.get(reverse('courses:my_courses'))
        self.assertEqual(response.status_code, 302)
        self.assertIn('/users/login/', response.url)

    def test_my_courses_authenticated(self):
        self.client.login(username='viewuser@test.com', password='pass1234!')
        response = self.client.get(reverse('courses:my_courses'))
        self.assertEqual(response.status_code, 200)

    def test_course_player_requires_login(self):
        response = self.client.get(reverse('courses:course_player'))
        self.assertEqual(response.status_code, 302)

    def test_mock_tests_requires_login(self):
        response = self.client.get(reverse('courses:mock_tests'))
        self.assertEqual(response.status_code, 302)

    def test_study_materials_requires_login(self):
        response = self.client.get(reverse('courses:study_materials'))
        self.assertEqual(response.status_code, 302)

    def test_mark_lesson_complete(self):
        self.client.login(username='viewuser@test.com', password='pass1234!')
        Enrollment.objects.create(user=self.user, course=self.course)
        response = self.client.post(
            reverse('courses:mark_lesson_complete'),
            {'lesson_id': self.lesson.pk, 'course_id': self.course.pk}
        )
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertTrue(data['success'])
        self.assertEqual(data['progress'], 100)

    def test_mark_lesson_complete_requires_post(self):
        self.client.login(username='viewuser@test.com', password='pass1234!')
        response = self.client.get(reverse('courses:mark_lesson_complete'))
        self.assertEqual(response.status_code, 405)

    def test_submit_mock_test(self):
        self.client.login(username='viewuser@test.com', password='pass1234!')
        q = MockTestQuestion.objects.create(
            course=self.course, question='Q?',
            option_a='A', option_b='B', option_c='C', option_d='D',
            correct_answer='A', order=1
        )
        response = self.client.post(
            reverse('courses:submit_mock_test'),
            {'course_id': self.course.pk, f'q_{q.pk}': 'A'}
        )
        # View must render test_results.html with a 200 (no template crash)
        self.assertEqual(response.status_code, 200)
        # Pre-computed context variables must be present
        self.assertEqual(response.context['score'], 1)
        self.assertEqual(response.context['total'], 1)
        self.assertEqual(response.context['wrong'], 0)
        self.assertEqual(response.context['percentage'], 100)
        self.assertEqual(response.context['grade'], 'Excellent!')
        # DB record must be saved
        self.assertEqual(MockTestResult.objects.filter(user=self.user, course=self.course).count(), 1)


class LessonCompletionProgressTests(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(username='progress@test.com', password='pass1234!')
        self.category = Category.objects.create(name='Cat', icon='C', slug='cat')
        self.course = Course.objects.create(
            title='Progress Course', category=self.category, description='D', is_free=True
        )
        self.l1 = Lesson.objects.create(course=self.course, title='L1', order=1, duration_minutes=10)
        self.l2 = Lesson.objects.create(course=self.course, title='L2', order=2, duration_minutes=10)
        self.enrollment = Enrollment.objects.create(user=self.user, course=self.course)

    def test_progress_zero_at_start(self):
        self.enrollment.update_progress()
        self.assertEqual(self.enrollment.progress_percentage, 0)

    def test_progress_50_percent(self):
        LessonCompletion.objects.create(user=self.user, lesson=self.l1)
        self.enrollment.update_progress()
        self.assertEqual(self.enrollment.progress_percentage, 50)

    def test_progress_100_percent(self):
        LessonCompletion.objects.create(user=self.user, lesson=self.l1)
        LessonCompletion.objects.create(user=self.user, lesson=self.l2)
        self.enrollment.update_progress()
        self.assertEqual(self.enrollment.progress_percentage, 100)

    def test_lesson_completion_unique_together(self):
        LessonCompletion.objects.create(user=self.user, lesson=self.l1)
        # Second creation should use get_or_create — no exception
        obj, created = LessonCompletion.objects.get_or_create(user=self.user, lesson=self.l1)
        self.assertFalse(created)
