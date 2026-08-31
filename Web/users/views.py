from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import AuthenticationForm
from django.contrib import messages
from django.http import JsonResponse
from django.views.decorators.http import require_POST
from .models import CustomUser
from core.models import Notification, Message, UserSettings, SupportTicket, FAQ, CalendarEvent
from courses.models import LessonCompletion, MockTestResult
from enrollments.models import Enrollment
import datetime


def login_view(request):
    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            return redirect('dashboard')
        else:
            messages.error(request, "Invalid username or password.")
    return render(request, 'users/login.html')


def register_view(request):
    if request.method == 'POST':
        email = request.POST.get('email')
        password = request.POST.get('password')
        name = request.POST.get('name')

        if email and password:
            try:
                user = CustomUser.objects.create_user(username=email, email=email, password=password)
                user.first_name = name or ''
                user.save()
                # Create default settings
                UserSettings.objects.get_or_create(user=user)
                login(request, user)
                return redirect('dashboard')
            except Exception as e:
                messages.error(request, "Registration failed or email already exists.")
    return render(request, 'users/register.html')


def logout_view(request):
    logout(request)
    return redirect('home')


@login_required
def dashboard_view(request):
    enrollments = Enrollment.objects.filter(user=request.user).select_related('course')
    for e in enrollments:
        e.update_progress()

    total_lessons_completed = LessonCompletion.objects.filter(user=request.user).count()
    total_tests = MockTestResult.objects.filter(user=request.user).count()
    avg_score = 0
    test_qs = MockTestResult.objects.filter(user=request.user)
    if test_qs.exists():
        avg_score = round(sum(t.percentage() for t in test_qs) / test_qs.count())

    # Calculate overall progress
    overall_progress = 0
    if enrollments.exists():
        overall_progress = round(sum(e.progress_percentage for e in enrollments) / enrollments.count())

    # Continue learning — most recently accessed
    continue_enrollment = enrollments.order_by('-last_accessed').first()
    continue_lesson = None
    if continue_enrollment:
        completed_ids = LessonCompletion.objects.filter(
            user=request.user, lesson__course=continue_enrollment.course
        ).values_list('lesson_id', flat=True)
        continue_lesson = continue_enrollment.course.lessons.exclude(id__in=completed_ids).first()
        if not continue_lesson:
            continue_lesson = continue_enrollment.course.lessons.first()

    return render(request, 'dashboard/dashboard.html', {
        'enrollments': enrollments,
        'total_lessons_completed': total_lessons_completed,
        'total_tests': total_tests,
        'avg_score': avg_score,
        'overall_progress': overall_progress,
        'continue_enrollment': continue_enrollment,
        'continue_lesson': continue_lesson,
        'active_page': 'dashboard',
    })


@login_required
def progress_view(request):
    enrollments = Enrollment.objects.filter(user=request.user).select_related('course')
    for e in enrollments:
        e.update_progress()

    total_lessons = LessonCompletion.objects.filter(user=request.user).count()
    test_results = MockTestResult.objects.filter(user=request.user).select_related('course')
    total_tests = test_results.count()
    avg_score = 0
    if total_tests > 0:
        avg_score = round(sum(t.percentage() for t in test_results) / total_tests)

    # Estimate learning hours (10 mins per lesson)
    learning_minutes = total_lessons * 10
    learning_hours = f"{learning_minutes // 60}h {learning_minutes % 60}m" if learning_minutes >= 60 else f"{learning_minutes}m"

    return render(request, 'dashboard/progress.html', {
        'enrollments': enrollments,
        'total_lessons': total_lessons,
        'total_tests': total_tests,
        'avg_score': avg_score,
        'learning_hours': learning_hours,
        'test_results': test_results[:5],
        'active_page': 'progress',
    })


@login_required
def profile_view(request):
    if request.method == 'POST':
        request.user.first_name = request.POST.get('first_name', '')
        request.user.last_name = request.POST.get('last_name', '')
        request.user.email = request.POST.get('email', request.user.email)
        request.user.save()
        messages.success(request, "Profile updated successfully!")
        return redirect('profile')

    return render(request, 'dashboard/profile.html', {
        'active_page': 'profile',
    })


@login_required
def notifications_view(request):
    notifs = Notification.objects.filter(user=request.user)
    # Mark all as read
    notifs.update(is_read=True)

    return render(request, 'dashboard/notifications.html', {
        'notifications': notifs,
        'active_page': 'notifications',
    })


@login_required
def messages_view(request):
    received = Message.objects.filter(recipient=request.user).select_related('sender')
    
    if not received.exists():
        admin_user = CustomUser.objects.filter(is_superuser=True).first()
        if not admin_user:
            admin_user = CustomUser.objects.first() # Fallback
            
        if admin_user:
            Message.objects.create(
                sender=admin_user,
                recipient=request.user,
                subject='Welcome to NavPath Academy',
                body='Welcome to NavPath Academy! If you have any questions or need support during your learning journey, feel free to raise a support ticket or reply here. Happy learning!'
            )
            received = Message.objects.filter(recipient=request.user).select_related('sender')

    return render(request, 'dashboard/messages.html', {
        'messages_list': received,
        'active_page': 'messages',
    })


@login_required
def settings_view(request):
    user_settings, _ = UserSettings.objects.get_or_create(user=request.user)

    if request.method == 'POST':
        user_settings.email_notifications = request.POST.get('email_notifications') == 'on'
        user_settings.sms_notifications = request.POST.get('sms_notifications') == 'on'
        user_settings.push_notifications = request.POST.get('push_notifications') == 'on'
        user_settings.dark_mode = request.POST.get('dark_mode') == 'on'
        user_settings.save()
        messages.success(request, "Settings saved!")
        return redirect('settings')

    return render(request, 'dashboard/settings.html', {
        'user_settings': user_settings,
        'active_page': 'settings',
    })


@login_required
def support_view(request):
    faqs = FAQ.objects.all()
    tickets = SupportTicket.objects.filter(user=request.user)
    return render(request, 'dashboard/support.html', {
        'faqs': faqs,
        'tickets': tickets,
        'active_page': 'support',
    })


@login_required
@require_POST
def raise_ticket_view(request):
    if request.method == 'POST':
        title = request.POST.get('title')
        description = request.POST.get('description')
        if title and description:
            SupportTicket.objects.create(
                user=request.user,
                title=title,
                description=description
            )
            messages.success(request, 'Your ticket has been submitted successfully. We will get back to you soon.')
            return redirect('support')
    messages.error(request, 'Please fill out both title and description.')
    return redirect('support')

@login_required
def calendar_view(request):
    return render(request, 'dashboard/calendar.html', {
        'active_page': 'calendar',
    })


@login_required
def live_classes_view(request):
    return render(request, 'dashboard/live_classes.html', {
        'active_page': 'live_classes',
    })
