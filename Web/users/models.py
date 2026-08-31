from django.contrib.auth.models import AbstractUser
from django.db import models

class CustomUser(AbstractUser):
    # Add custom fields here if needed
    phone_number = models.CharField(max_length=20, blank=True)

    def __str__(self):
        return self.username

class UserProfile(models.Model):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE, related_name='profile')
    learning_hours = models.IntegerField(default=0)
    streak_days = models.IntegerField(default=0)
    mock_tests_taken = models.IntegerField(default=0)

    def __str__(self):
        return f"Profile for {self.user.username}"
