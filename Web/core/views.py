from django.shortcuts import render
from courses.models import Category, Course
from core.models import FAQ


def home(request):
    categories = Category.objects.all()
    return render(request, 'core/home.html', {'top_categories': categories})


def about(request):
    instructors = [
        {'name': 'Capt. Robin C George', 'initials': 'RG', 'title': 'Master Mariner, AFNI | Founder', 'bio': 'More than three decades of distinguished service in the global shipping industry. Commanded VLGCs and LPG tankers.'},
        {'name': 'Capt. Priya Nair', 'initials': 'PN', 'title': 'Navigation Expert', 'bio': 'Former Navigation Officer with 12 years at sea. Specialises in COLREGS and chart work for Deck Officers.'},
        {'name': 'Eng. Suresh Kumar', 'initials': 'SK', 'title': 'Chief Engineer & Engine Educator', 'bio': 'Retired Chief Engineer from a leading MNC shipping company. Expert in Marine Engineering and Thermodynamics.'},
    ]
    return render(request, 'core/about.html', {'instructors': instructors})


def public_support(request):
    faqs = FAQ.objects.all()
    return render(request, 'core/public_support.html', {'faqs': faqs})
