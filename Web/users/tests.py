from django.test import TestCase, Client
from django.urls import reverse
from django.contrib.auth import get_user_model
from users.models import CustomUser, UserProfile
from core.models import Notification, Message, UserSettings, SupportTicket, FAQ
from courses.models import Category, Course, Lesson, LessonCompletion, MockTestResult
from enrollments.models import Enrollment

User = get_user_model()


class UserModelTests(TestCase):
    def test_create_user(self):
        user = User.objects.create_user(username='test@example.com', password='pass1234!')
        self.assertEqual(str(user), 'test@example.com')
        self.assertTrue(user.check_password('pass1234!'))

    def test_user_profile_auto_created_by_signal(self):
        user = User.objects.create_user(username='signal@test.com', password='pass1234!')
        self.assertTrue(UserProfile.objects.filter(user=user).exists())

    def test_user_profile_str(self):
        user = User.objects.create_user(username='profile@test.com', password='pass1234!')
        profile = UserProfile.objects.get(user=user)
        self.assertIn('profile@test.com', str(profile))


class AuthViewTests(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(
            username='auth@test.com', password='pass1234!', email='auth@test.com'
        )

    def test_register_view_get(self):
        response = self.client.get(reverse('register'))
        self.assertEqual(response.status_code, 200)

    def test_register_creates_user(self):
        response = self.client.post(reverse('register'), {
            'email': 'newuser@test.com',
            'password': 'newpass1234!',
            'name': 'New User',
        })
        self.assertEqual(response.status_code, 302)
        self.assertTrue(User.objects.filter(username='newuser@test.com').exists())

    def test_register_duplicate_email_fails(self):
        # First registration
        self.client.post(reverse('register'), {'email': 'dup@test.com', 'password': 'pass1!'})
        # Second registration with same email
        response = self.client.post(reverse('register'), {'email': 'dup@test.com', 'password': 'pass2!'})
        self.assertEqual(response.status_code, 200)  # stays on page with error

    def test_login_view_get(self):
        response = self.client.get(reverse('login'))
        self.assertEqual(response.status_code, 200)

    def test_login_valid_credentials(self):
        response = self.client.post(reverse('login'), {
            'username': 'auth@test.com',
            'password': 'pass1234!',
        })
        self.assertEqual(response.status_code, 302)
        self.assertRedirects(response, reverse('dashboard'))

    def test_login_invalid_credentials(self):
        response = self.client.post(reverse('login'), {
            'username': 'auth@test.com',
            'password': 'wrongpassword',
        })
        self.assertEqual(response.status_code, 200)

    def test_logout(self):
        self.client.login(username='auth@test.com', password='pass1234!')
        response = self.client.get(reverse('logout'))
        self.assertEqual(response.status_code, 302)


class DashboardViewTests(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = User.objects.create_user(username='dash@test.com', password='pass1234!')

    def test_dashboard_requires_login(self):
        response = self.client.get(reverse('dashboard'))
        self.assertEqual(response.status_code, 302)
        self.assertIn('/users/login/', response.url)

    def test_dashboard_authenticated(self):
        self.client.login(username='dash@test.com', password='pass1234!')
        response = self.client.get(reverse('dashboard'))
        self.assertEqual(response.status_code, 200)

    def test_progress_requires_login(self):
        response = self.client.get(reverse('progress'))
        self.assertEqual(response.status_code, 302)

    def test_progress_authenticated(self):
        self.client.login(username='dash@test.com', password='pass1234!')
        response = self.client.get(reverse('progress'))
        self.assertEqual(response.status_code, 200)

    def test_profile_get(self):
        self.client.login(username='dash@test.com', password='pass1234!')
        response = self.client.get(reverse('profile'))
        self.assertEqual(response.status_code, 200)

    def test_profile_update(self):
        self.client.login(username='dash@test.com', password='pass1234!')
        response = self.client.post(reverse('profile'), {
            'first_name': 'John',
            'last_name': 'Doe',
            'email': 'john@test.com',
        })
        self.assertEqual(response.status_code, 302)
        self.user.refresh_from_db()
        self.assertEqual(self.user.first_name, 'John')

    def test_notifications_view(self):
        self.client.login(username='dash@test.com', password='pass1234!')
        Notification.objects.create(user=self.user, title='Test Notif', message='Hello', notif_type='general')
        response = self.client.get(reverse('notifications'))
        self.assertEqual(response.status_code, 200)
        # Verify notification marked as read
        self.assertTrue(Notification.objects.filter(user=self.user, is_read=True).exists())

    def test_messages_view_creates_welcome_message(self):
        # Create a superuser to be the sender
        admin = User.objects.create_superuser(username='admin', password='admin123')
        self.client.login(username='dash@test.com', password='pass1234!')
        response = self.client.get(reverse('messages'))
        self.assertEqual(response.status_code, 200)
        self.assertTrue(Message.objects.filter(recipient=self.user).exists())

    def test_settings_get(self):
        self.client.login(username='dash@test.com', password='pass1234!')
        response = self.client.get(reverse('settings'))
        self.assertEqual(response.status_code, 200)

    def test_settings_update(self):
        self.client.login(username='dash@test.com', password='pass1234!')
        response = self.client.post(reverse('settings'), {
            'email_notifications': 'on',
            'dark_mode': 'on',
        })
        self.assertEqual(response.status_code, 302)
        settings_obj = UserSettings.objects.get(user=self.user)
        self.assertTrue(settings_obj.email_notifications)
        self.assertTrue(settings_obj.dark_mode)
        self.assertFalse(settings_obj.sms_notifications)

    def test_support_view(self):
        self.client.login(username='dash@test.com', password='pass1234!')
        response = self.client.get(reverse('support'))
        self.assertEqual(response.status_code, 200)

    def test_raise_ticket(self):
        self.client.login(username='dash@test.com', password='pass1234!')
        response = self.client.post(reverse('raise_ticket'), {
            'title': 'Test Issue',
            'description': 'Description of the issue.',
        })
        self.assertEqual(response.status_code, 302)
        self.assertTrue(SupportTicket.objects.filter(user=self.user, title='Test Issue').exists())

    def test_raise_ticket_missing_fields(self):
        self.client.login(username='dash@test.com', password='pass1234!')
        response = self.client.post(reverse('raise_ticket'), {'title': 'Only Title'})
        self.assertEqual(response.status_code, 302)
        self.assertFalse(SupportTicket.objects.filter(user=self.user).exists())

    def test_calendar_view(self):
        self.client.login(username='dash@test.com', password='pass1234!')
        response = self.client.get(reverse('calendar'))
        self.assertEqual(response.status_code, 200)

    def test_live_classes_view(self):
        self.client.login(username='dash@test.com', password='pass1234!')
        response = self.client.get(reverse('live_classes'))
        self.assertEqual(response.status_code, 200)
