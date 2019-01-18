from django.contrib import admin
from django.urls import path
import manhole.views

urlpatterns = [
    path('<str:client>', manhole.views.script, name='script'),
    path('<str:client>/<int:ordering>', manhole.views.output, name='output')
]
