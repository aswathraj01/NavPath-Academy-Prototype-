from django.contrib import admin
from .models import Enrollment


@admin.register(Enrollment)
class EnrollmentAdmin(admin.ModelAdmin):
    list_display = ('user', 'course', 'progress_percentage', 'date_enrolled', 'last_accessed')
    list_filter = ('course',)
    search_fields = ('user__username', 'user__email', 'course__title')
    readonly_fields = ('date_enrolled', 'last_accessed')
    date_hierarchy = 'date_enrolled'
