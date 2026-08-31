from django.contrib import admin
from .models import Notification, Message, UserSettings, SupportTicket, FAQ, CalendarEvent


@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display = ('user', 'title', 'notif_type', 'is_read', 'created_at')
    list_filter = ('notif_type', 'is_read')
    search_fields = ('user__username', 'title', 'message')
    list_editable = ('is_read',)
    date_hierarchy = 'created_at'


@admin.register(Message)
class MessageAdmin(admin.ModelAdmin):
    list_display = ('sender', 'recipient', 'subject', 'is_read', 'sent_at')
    list_filter = ('is_read',)
    search_fields = ('sender__username', 'recipient__username', 'subject', 'body')
    date_hierarchy = 'sent_at'


@admin.register(UserSettings)
class UserSettingsAdmin(admin.ModelAdmin):
    list_display = ('user', 'email_notifications', 'sms_notifications', 'push_notifications', 'dark_mode', 'language')
    list_filter = ('dark_mode', 'email_notifications')
    search_fields = ('user__username',)


@admin.register(SupportTicket)
class SupportTicketAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'title', 'status', 'created_at')
    list_filter = ('status',)
    list_editable = ('status',)
    search_fields = ('user__username', 'title', 'description')
    date_hierarchy = 'created_at'


@admin.register(FAQ)
class FAQAdmin(admin.ModelAdmin):
    list_display = ('order', 'question_short', 'category')
    list_filter = ('category',)
    search_fields = ('question', 'answer')
    ordering = ('order',)

    def question_short(self, obj):
        return obj.question[:80] + '...' if len(obj.question) > 80 else obj.question
    question_short.short_description = 'Question'


@admin.register(CalendarEvent)
class CalendarEventAdmin(admin.ModelAdmin):
    list_display = ('title', 'user', 'event_type', 'date')
    list_filter = ('event_type',)
    search_fields = ('title', 'user__username')
    date_hierarchy = 'date'
