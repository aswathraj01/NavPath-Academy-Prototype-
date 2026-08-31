from django.urls import path
from . import views

urlpatterns = [
    path('login/', views.login_view, name='login'),
    path('register/', views.register_view, name='register'),
    path('logout/', views.logout_view, name='logout'),
    path('dashboard/', views.dashboard_view, name='dashboard'),
    path('progress/', views.progress_view, name='progress'),
    path('profile/', views.profile_view, name='profile'),
    path('notifications/', views.notifications_view, name='notifications'),
    path('messages/', views.messages_view, name='messages'),
    path('settings/', views.settings_view, name='settings'),
    path('support/', views.support_view, name='support'),
    path('raise-ticket/', views.raise_ticket_view, name='raise_ticket'),
    path('calendar/', views.calendar_view, name='calendar'),
    path('live-classes/', views.live_classes_view, name='live_classes'),
]
