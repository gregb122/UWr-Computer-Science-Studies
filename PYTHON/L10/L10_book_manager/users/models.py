from django.db import models
from django.contrib.auth.models import AbstractUser
from books.models import Book


# Create your models here.
class CustomUser(AbstractUser):
    def __str__(self):
        return self.username

    books = models.ManyToManyField(to=Book, related_name="books")
