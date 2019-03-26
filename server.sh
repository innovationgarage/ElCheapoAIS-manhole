#! /bin/bash

cd /ElcheapoAIS_manhole/ElcheapoAIS_manhole

if ! [ -e database/db.sqlite3 ]; then
  python3 manage.py migrate
  echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'admin@myproject.com', 'password')" |
      python3 manage.py shell
else
  python3 manage.py migrate
fi

python3 manage.py runserver 0.0.0.0:8000
