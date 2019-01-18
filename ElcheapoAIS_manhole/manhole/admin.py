from django.contrib import admin
from .models import *

admin.site.register(Client)


class OutputInline(admin.StackedInline):
    model = Output

class ScriptAdmin(admin.ModelAdmin):
    list_display = ('client', 'ordering')
    inlines = [OutputInline]

admin.site.register(Script, ScriptAdmin)
