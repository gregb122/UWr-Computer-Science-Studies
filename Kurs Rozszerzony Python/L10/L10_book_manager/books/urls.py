from django.urls import path

from . import views

app_name = 'books'

urlpatterns = [
    path('', views.list_books, name='list_books'),
    path('book_new/', views.book_new, name='book_new'),
    path('book_rent/', views.book_rent, name='book_rent'),
    path('book_add/<int:book_id>/', views.book_add, name='book_add'),
    path('book_return/<int:book_id>/', views.book_return, name='book_return'),
]