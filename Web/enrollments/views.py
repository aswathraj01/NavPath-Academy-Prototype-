from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import Enrollment
from courses.models import Course
from core.models import UserSettings


def checkout_view(request):
    course_id = request.GET.get('course', 1)
    course = Course.objects.filter(pk=course_id).first() or Course.objects.first()
    return render(request, 'enrollments/checkout.html', {'course': course})


@login_required
def enroll_action(request):
    if request.method == 'POST':
        course_id = request.POST.get('course_id')
        course = get_object_or_404(Course, pk=course_id)
        enrollment, created = Enrollment.objects.get_or_create(user=request.user, course=course)
        if created:
            messages.success(request, f"You've successfully enrolled in {course.title}!")
        else:
            messages.info(request, f"You're already enrolled in {course.title}.")
        return redirect('courses:course_player', )
    return redirect('courses:list')
