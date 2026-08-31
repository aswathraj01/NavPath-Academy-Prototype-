from django.test import TestCase, Client
from django.urls import reverse
from django.contrib.auth import get_user_model
from core.models import Message, Notification, UserSettings, SupportTicket, FAQ, CalendarEvent
import datetime

User = get_user_model()


class CoreModelTests(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(username='core@test.com', password='pass1234!')

    def test_notification_str(self):
        notif = Notification.objects.create(
            user=self.user, title='Hello', message='World', notif_type='general'
        )
        self.assertIn('core@test.com', str(notif))
        self.assertIn('Hello', str(notif))

    def test_message_str_with_subject(self):
        admin = User.objects.create_user(username='admin@test.com', password='pass1234!')
        msg = Message.objects.create(
            sender=admin, recipient=self.user,
            subject='Welcome', body='Hello there!'
        )
        self.assertIn('Welcome', str(msg))

    def test_message_str_fallback_to_body(self):
        admin = User.objects.create_user(username='admin2@test.com', password='pass1234!')
        msg = Message.objects.create(
            sender=admin, recipient=self.user,
            subject='', body='Hello there!'
        )
        self.assertIn('Hello there!', str(msg))

    def test_user_settings_defaults(self):
        settings = UserSettings.objects.create(user=self.user)
        self.assertTrue(settings.email_notifications)
        self.assertTrue(settings.sms_notifications)
        self.assertTrue(settings.push_notifications)
        self.assertFalse(settings.dark_mode)
        self.assertEqual(settings.language, 'English')

    def test_support_ticket_str(self):
        ticket = SupportTicket.objects.create(user=self.user, title='Issue 1', description='D')
        self.assertIn('Issue 1', str(ticket))
        self.assertEqual(ticket.status, 'open')

    def test_faq_ordering(self):
        FAQ.objects.create(question='Q2', answer='A2', order=2)
        FAQ.objects.create(question='Q1', answer='A1', order=1)
        faqs = list(FAQ.objects.all())
        self.assertEqual(faqs[0].question, 'Q1')

    def test_calendar_event_str(self):
        event = CalendarEvent.objects.create(
            user=self.user, title='Study Day',
            event_type='streak', date=datetime.date.today()
        )
        self.assertIn('Study Day', str(event))


class CoreViewTests(TestCase):
    def test_home_view(self):
        response = self.client.get(reverse('home'))
        self.assertEqual(response.status_code, 200)

    def test_about_view(self):
        response = self.client.get(reverse('about'))
        self.assertEqual(response.status_code, 200)

    def test_public_support_view(self):
        response = self.client.get(reverse('public_support'))
        self.assertEqual(response.status_code, 200)
