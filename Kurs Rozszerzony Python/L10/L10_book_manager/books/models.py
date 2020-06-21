from django.db import models


class Author(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)


# Create your models here.
class Book(models.Model):
    author = models.ForeignKey(to=Author, on_delete=models.CASCADE, related_name="author")
    title = models.CharField(max_length=200)
    publication_year = models.IntegerField()
    number_of_available_instances = models.IntegerField()
