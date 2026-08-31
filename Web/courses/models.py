from django.db import models
from django.conf import settings


class Category(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    icon = models.CharField(max_length=10, blank=True, help_text="Emoji or icon class")
    slug = models.SlugField(unique=True, blank=True)

    def __str__(self):
        return self.name

    def course_count(self):
        return self.courses.count()


class Course(models.Model):
    title = models.CharField(max_length=200)
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='courses')
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    is_free = models.BooleanField(default=True)
    thumbnail_icon = models.CharField(max_length=10, default="⚓")
    duration = models.CharField(max_length=50, blank=True, default="12 Weeks")
    created_at = models.DateTimeField(auto_now_add=True)
    rating = models.DecimalField(max_digits=3, decimal_places=1, default=4.8)
    students_enrolled = models.IntegerField(default=0)

    def __str__(self):
        return self.title

    def lesson_count(self):
        return self.lessons.count()


class Lesson(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='lessons')
    title = models.CharField(max_length=200)
    order = models.PositiveIntegerField(default=0)
    video_url = models.URLField(blank=True, help_text="Demo MP4 URL for the player")
    duration = models.CharField(max_length=50, blank=True, default="10:00")
    duration_minutes = models.IntegerField(default=10)
    description = models.TextField(blank=True)

    class Meta:
        ordering = ['order']

    def __str__(self):
        return f"{self.course.title} - {self.title}"


class StudyMaterial(models.Model):
    TYPE_CHOICES = [
        ('pdf', 'PDF'),
        ('note', 'Note'),
        ('video', 'Video Link'),
        ('doc', 'Document'),
    ]
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='study_materials')
    title = models.CharField(max_length=200)
    material_type = models.CharField(max_length=10, choices=TYPE_CHOICES, default='pdf')
    file_url = models.URLField(blank=True)
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.course.title} - {self.title}"


class MockTestQuestion(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='mock_questions')
    question = models.TextField()
    option_a = models.CharField(max_length=300)
    option_b = models.CharField(max_length=300)
    option_c = models.CharField(max_length=300)
    option_d = models.CharField(max_length=300)
    correct_answer = models.CharField(max_length=1, choices=[('A','A'),('B','B'),('C','C'),('D','D')])
    explanation = models.TextField(blank=True)
    order = models.PositiveIntegerField(default=0)

    class Meta:
        ordering = ['order']

    def __str__(self):
        return f"{self.course.title} - Q{self.order}"

    @property
    def options_list(self):
        """Returns list of (value, label, text) tuples for template iteration."""
        return [
            ('A', 'A', self.option_a),
            ('B', 'B', self.option_b),
            ('C', 'C', self.option_c),
            ('D', 'D', self.option_d),
        ]



class LessonCompletion(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='lesson_completions')
    lesson = models.ForeignKey(Lesson, on_delete=models.CASCADE, related_name='completions')
    completed_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'lesson')

    def __str__(self):
        return f"{self.user} completed {self.lesson}"


class MockTestResult(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='test_results')
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='test_results')
    score = models.IntegerField(default=0)
    total = models.IntegerField(default=0)
    time_taken = models.CharField(max_length=20, blank=True)
    taken_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user} scored {self.score}/{self.total} in {self.course}"

    def percentage(self):
        return round((self.score / self.total) * 100) if self.total > 0 else 0
