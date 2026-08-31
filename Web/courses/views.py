from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.views.decorators.http import require_POST
from django.contrib import messages
from django.urls import reverse
from .models import Category, Course, Lesson, StudyMaterial, MockTestQuestion, LessonCompletion, MockTestResult
from enrollments.models import Enrollment


def course_list(request):
    categories = Category.objects.all()
    category_slug = request.GET.get('category', '')
    search = request.GET.get('search', '')

    courses = Course.objects.select_related('category').all()

    selected_category = None
    if category_slug:
        selected_category = Category.objects.filter(slug=category_slug).first()

    return render(request, 'courses/courses.html', {
        'courses': courses,
        'categories': categories,
        'selected_category': selected_category,
        'search': search,
    })


def course_categories(request):
    categories = Category.objects.all()
    return render(request, 'courses/categories.html', {'categories': categories})


def course_detail(request, pk):
    course = get_object_or_404(Course, pk=pk)
    lessons = course.lessons.all()
    study_materials = course.study_materials.all()

    is_enrolled = False
    completed_lessons = []
    if request.user.is_authenticated:
        is_enrolled = Enrollment.objects.filter(user=request.user, course=course).exists()
        completed_lessons = list(LessonCompletion.objects.filter(
            user=request.user, lesson__course=course
        ).values_list('lesson_id', flat=True))

    return render(request, 'courses/course_detail.html', {
        'course': course,
        'lessons': lessons,
        'study_materials': study_materials,
        'is_enrolled': is_enrolled,
        'completed_lessons': completed_lessons,
        'lesson_count': lessons.count(),
    })


@login_required
def my_courses_view(request):
    enrollments = Enrollment.objects.filter(user=request.user).select_related('course', 'course__category')
    # Refresh progress for all enrollments
    for enrollment in enrollments:
        enrollment.update_progress()

    return render(request, 'dashboard/my_courses.html', {
        'enrollments': enrollments,
        'active_page': 'my_courses',
    })


@login_required
def course_player_view(request):
    # Get the lesson to play from query param, default to first enrolled course
    lesson_id = request.GET.get('lesson')
    course_id = request.GET.get('course')

    course = None
    lesson = None
    lessons = []
    enrollment = None
    completed_lessons = []

    if course_id:
        course = get_object_or_404(Course, pk=course_id)
        lessons = course.lessons.all()
        enrollment = Enrollment.objects.filter(user=request.user, course=course).first()
        completed_lessons = list(LessonCompletion.objects.filter(
            user=request.user, lesson__course=course
        ).values_list('lesson_id', flat=True))

        if lesson_id:
            lesson = get_object_or_404(Lesson, pk=lesson_id, course=course)
        else:
            lesson = lessons.first()
    else:
        # Get first enrollment
        enrollment = Enrollment.objects.filter(user=request.user).select_related('course').first()
        if enrollment:
            course = enrollment.course
            lessons = course.lessons.all()
            completed_lessons = list(LessonCompletion.objects.filter(
                user=request.user, lesson__course=course
            ).values_list('lesson_id', flat=True))
            lesson = lessons.first()

    return render(request, 'dashboard/course_player.html', {
        'course': course,
        'lesson': lesson,
        'lessons': lessons,
        'enrollment': enrollment,
        'completed_lessons': completed_lessons,
        'active_page': 'my_courses',
    })


@login_required
@require_POST
def mark_lesson_complete(request):
    lesson_id = request.POST.get('lesson_id')
    course_id = request.POST.get('course_id')

    lesson = get_object_or_404(Lesson, pk=lesson_id)
    LessonCompletion.objects.get_or_create(user=request.user, lesson=lesson)

    # Update enrollment progress
    enrollment = Enrollment.objects.filter(user=request.user, course=lesson.course).first()
    if enrollment:
        new_progress = enrollment.update_progress()
    else:
        new_progress = 0

    # Get next lesson
    next_lesson = lesson.course.lessons.filter(order__gt=lesson.order).first()

    return JsonResponse({
        'success': True,
        'progress': new_progress,
        'next_lesson_id': next_lesson.id if next_lesson else None,
    })


@login_required
def mock_tests_view(request):
    # Only show courses the user is enrolled in
    enrolled_course_ids = Enrollment.objects.filter(user=request.user).values_list('course_id', flat=True)
    courses = Course.objects.filter(id__in=enrolled_course_ids)
    selected_course = None
    questions = []
    course_id = request.GET.get('course')

    if course_id:
        selected_course = get_object_or_404(Course, pk=course_id)
        questions = MockTestQuestion.objects.filter(course=selected_course)

    return render(request, 'dashboard/mock_tests.html', {
        'courses': courses,
        'selected_course': selected_course,
        'questions': questions,
        'active_page': 'mock_tests',
    })


@login_required
@require_POST
def submit_mock_test(request):
    course_id = request.POST.get('course_id')
    course = get_object_or_404(Course, pk=course_id)
    questions = MockTestQuestion.objects.filter(course=course)

    score = 0
    results = []
    for q in questions:
        user_answer = request.POST.get(f'q_{q.id}', '')
        is_correct = user_answer == q.correct_answer
        if is_correct:
            score += 1
        results.append({
            'question': q,
            'user_answer': user_answer,
            'is_correct': is_correct,
        })

    total_questions = questions.count()
    wrong = total_questions - score
    percentage = round((score / total_questions) * 100) if total_questions > 0 else 0
    if percentage >= 80:
        grade = 'Excellent!'
    elif percentage >= 60:
        grade = 'Good effort!'
    else:
        grade = 'Keep practising!'

    # Save result
    test_result = MockTestResult.objects.create(
        user=request.user,
        course=course,
        score=score,
        total=total_questions,
    )

    # Store result in session and redirect to results page
    request.session['last_test_result_id'] = test_result.id
    request.session['last_test_results'] = [
        {
            'question_id': r['question'].id,
            'user_answer': r['user_answer'],
            'is_correct': r['is_correct'],
        }
        for r in results
    ]
    request.session['last_test_meta'] = {
        'score': score,
        'total': total_questions,
        'wrong': wrong,
        'percentage': percentage,
        'grade': grade,
        'course_id': course.id,
        'course_title': course.title,
    }

    return redirect(reverse('courses:test_results'))


@login_required
def test_results_view(request):
    # Check if we have a fresh test result in session
    meta = request.session.pop('last_test_meta', None)
    session_results = request.session.pop('last_test_results', None)
    request.session.pop('last_test_result_id', None)

    if meta and session_results:
        # Reconstruct question objects for display
        question_ids = [r['question_id'] for r in session_results]
        questions_map = {q.id: q for q in MockTestQuestion.objects.filter(id__in=question_ids)}
        results = [
            {
                'question': questions_map[r['question_id']],
                'user_answer': r['user_answer'],
                'is_correct': r['is_correct'],
            }
            for r in session_results if r['question_id'] in questions_map
        ]
        course = get_object_or_404(Course, pk=meta['course_id'])
        return render(request, 'dashboard/test_results.html', {
            'course': course,
            'score': meta['score'],
            'total': meta['total'],
            'wrong': meta['wrong'],
            'percentage': meta['percentage'],
            'grade': meta['grade'],
            'results': results,
            'test_result': True,  # Truthy flag to trigger result view branch
            'active_page': 'mock_tests',
        })

    # No fresh result — show history
    history_results = MockTestResult.objects.filter(user=request.user).select_related('course').order_by('-taken_at')
    return render(request, 'dashboard/test_results.html', {
        'history_results': history_results,
        'active_page': 'mock_tests',
    })


@login_required
def study_materials_view(request):
    course_id = request.GET.get('course')
    selected_course = None
    materials = []
    courses = Course.objects.filter(enrollments__user=request.user)

    if course_id:
        selected_course = get_object_or_404(Course, pk=course_id)
        materials = StudyMaterial.objects.filter(course=selected_course)
    elif courses.exists():
        selected_course = courses.first()
        materials = StudyMaterial.objects.filter(course=selected_course)

    return render(request, 'dashboard/study_materials.html', {
        'courses': courses,
        'selected_course': selected_course,
        'materials': materials,
        'active_page': 'study_materials',
    })
