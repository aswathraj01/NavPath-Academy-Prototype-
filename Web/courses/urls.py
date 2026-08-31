from django.urls import path
from . import views

app_name = 'courses'

urlpatterns = [
    path('', views.course_list, name='list'),
    path('categories/', views.course_categories, name='categories'),
    path('my-courses/', views.my_courses_view, name='my_courses'),
    path('player/', views.course_player_view, name='course_player'),
    path('mark-complete/', views.mark_lesson_complete, name='mark_lesson_complete'),
    path('mock-tests/', views.mock_tests_view, name='mock_tests'),
    path('mock-tests/submit/', views.submit_mock_test, name='submit_mock_test'),
    path('test-results/', views.test_results_view, name='test_results'),
    path('study-materials/', views.study_materials_view, name='study_materials'),
    path('<int:pk>/', views.course_detail, name='detail'),
]
