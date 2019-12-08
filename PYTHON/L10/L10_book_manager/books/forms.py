from django import forms


class BookNewForm(forms.Form):
    title = forms.CharField(max_length=200, label="Tytuł")
    publication_year = forms.IntegerField(label="Rok wydania")
    first_name = forms.CharField(max_length=100, label="Imię autora")
    last_name = forms.CharField(max_length=100, label="Nazwisko autora")
