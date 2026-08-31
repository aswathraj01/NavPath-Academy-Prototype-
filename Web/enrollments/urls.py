from django.urls import path
from . import views

urlpatterns = [
    path('checkout/', views.checkout_view, name='checkout'),
    path('enroll/', views.enroll_action, name='enroll_action'),
]
