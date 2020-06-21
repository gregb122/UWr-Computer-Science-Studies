from django.shortcuts import render, redirect
from .models import Book, Author
from users.models import CustomUser
from .forms import BookNewForm


# Create your views here.
def list_books(request):
    if request.user.is_authenticated:
        books = CustomUser.objects.get(id=request.user.id).books.all()
    else:
        books = Book.objects.all()
    return render(request, 'books/index.html', {"books": books})


def book_return(request, book_id):
    book = Book.objects.get(id=book_id)
    book.number_of_available_instances += 1
    user = CustomUser.objects.get(id=request.user.id)
    user.books.remove(book)
    user.save()
    book.save()
    return redirect('books:list_books')


def book_rent(request):
    books = Book.objects.all()
    return render(request, 'books/book_rent.html', {"books": books})


def book_add(request, book_id):
    book = Book.objects.get(id=book_id)
    book.number_of_available_instances -= 1
    user = CustomUser.objects.get(id=request.user.id)
    user.books.add(book)
    book.save()
    user.save()
    return redirect('books:list_books')


def book_new(request):
    if request.method == "POST":
        book_form = BookNewForm(request.POST)
        if book_form.is_valid():
            title = book_form.cleaned_data["title"]
            publication_year = book_form.cleaned_data["publication_year"]
            number_of_available_instances = 1
            first_name = book_form.cleaned_data["first_name"]
            last_name = book_form.cleaned_data["last_name"]
            authors = Author.objects.filter(first_name=first_name, last_name=last_name)
            if not authors:
                author = Author(first_name=first_name, last_name=last_name)
            else:
                author = authors.get(first_name=first_name, last_name=last_name)
            author.save()
            book = Book(author=author, title=title, publication_year=publication_year,
                        number_of_available_instances=number_of_available_instances)
            book.save()
            return redirect('books:book_rent')
    else:
        book_form = BookNewForm()
    return render(request, 'books/book_new.html', {"book_form": book_form})
