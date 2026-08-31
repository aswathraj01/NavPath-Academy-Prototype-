from django.contrib import admin
from .models import Category, Course, Lesson, StudyMaterial, MockTestQuestion, LessonCompletion, MockTestResult


class LessonInline(admin.TabularInline):
    model = Lesson
    extra = 0
    fields = ('order', 'title', 'duration', 'duration_minutes', 'video_url')
    ordering = ('order',)


class StudyMaterialInline(admin.TabularInline):
    model = StudyMaterial
    extra = 0
    fields = ('title', 'material_type', 'file_url', 'description')


class MockTestQuestionInline(admin.TabularInline):
    model = MockTestQuestion
    extra = 0
    fields = ('order', 'question', 'option_a', 'option_b', 'option_c', 'option_d', 'correct_answer')
    ordering = ('order',)


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('name', 'icon', 'slug', 'course_count')
    prepopulated_fields = {'slug': ('name',)}
    search_fields = ('name',)


@admin.register(Course)
class CourseAdmin(admin.ModelAdmin):
    list_display = ('title', 'category', 'is_free', 'price', 'rating', 'students_enrolled', 'lesson_count', 'created_at')
    list_filter = ('category', 'is_free')
    search_fields = ('title', 'description')
    list_editable = ('is_free', 'price', 'rating')
    inlines = [LessonInline, StudyMaterialInline, MockTestQuestionInline]


@admin.register(Lesson)
class LessonAdmin(admin.ModelAdmin):
    list_display = ('title', 'course', 'order', 'duration', 'duration_minutes')
    list_filter = ('course',)
    search_fields = ('title', 'course__title')
    ordering = ('course', 'order')


@admin.register(StudyMaterial)
class StudyMaterialAdmin(admin.ModelAdmin):
    list_display = ('title', 'course', 'material_type', 'created_at')
    list_filter = ('material_type', 'course')
    search_fields = ('title', 'course__title')


@admin.register(MockTestQuestion)
class MockTestQuestionAdmin(admin.ModelAdmin):
    list_display = ('course', 'order', 'question_short', 'correct_answer')
    list_filter = ('course',)
    search_fields = ('question', 'course__title')
    ordering = ('course', 'order')

    def question_short(self, obj):
        return obj.question[:60] + '...' if len(obj.question) > 60 else obj.question
    question_short.short_description = 'Question'


@admin.register(LessonCompletion)
class LessonCompletionAdmin(admin.ModelAdmin):
    list_display = ('user', 'lesson', 'completed_at')
    list_filter = ('lesson__course',)
    search_fields = ('user__username', 'lesson__title')


@admin.register(MockTestResult)
class MockTestResultAdmin(admin.ModelAdmin):
    list_display = ('user', 'course', 'score', 'total', 'percentage_display', 'taken_at')
    list_filter = ('course',)
    search_fields = ('user__username', 'course__title')

    def percentage_display(self, obj):
        return f"{obj.percentage()}%"
    percentage_display.short_description = 'Score %'
