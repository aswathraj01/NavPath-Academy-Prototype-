from django.db import models
from django.conf import settings


class Enrollment(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='enrollments')
    course = models.ForeignKey('courses.Course', on_delete=models.CASCADE, related_name='enrollments')
    progress_percentage = models.IntegerField(default=0)
    date_enrolled = models.DateTimeField(auto_now_add=True)
    last_accessed = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('user', 'course')

    def __str__(self):
        return f"{self.user} enrolled in {self.course}"

    def update_progress(self):
        """Recalculate progress based on lesson completions."""
        from courses.models import LessonCompletion
        total_lessons = self.course.lessons.count()
        if total_lessons == 0:
            self.progress_percentage = 0
        else:
            completed = LessonCompletion.objects.filter(
                user=self.user,
                lesson__course=self.course
            ).count()
            self.progress_percentage = round((completed / total_lessons) * 100)
        self.save()
        return self.progress_percentage
