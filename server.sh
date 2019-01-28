#! /bin/bash

cd ElcheapoAIS_manhole

if ! [ -e db.sqlite3 ]; then
  python3 manage.py migrate
  echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'admin@myproject.com', 'password')" |
    python3 manage.py shell
fi

python3 manage.py runserver 0.0.0.0:8000
