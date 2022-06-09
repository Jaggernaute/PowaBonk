import random

import mysql.connector

# grab connection info from env file
import os
import sys


def get_connection_info():
    """
    Get connection info from env file
    """
    try:
        with open('../../resources/.env', 'r') as f:
            lines = f.readlines()
            for line in lines:
                if 'HOST' in line:
                    host = line.split('=')[1].strip()
                if 'USERNAME' in line:
                    user = line.split('=')[1].strip()
                if 'PASSWORD' in line:
                    password = line.split('=')[1].strip()
                if 'DBNAME' in line:
                    db = line.split('=')[1].strip()
    except FileNotFoundError:
        print('Please create a .env file with the following contents:')
        print('DB_HOST=<host>')
        print('DB_USER=<user>')
    return [host, user, password, db]


mydb = mysql.connector.connect(
    host=get_connection_info()[0],
    user=get_connection_info()[1],
    password=get_connection_info()[2],
    database=get_connection_info()[3]
)

print(mydb)
my_cursor = mydb.cursor()

os.system('ruby gen.rb')

# select 30 random name and first name from names.txt
with open('first_name_file', 'r') as f:
    first_names = f.readlines()

with open('last_name_file', 'r') as f:
    last_names = f.readlines()

for i in range(30):
    sanitized_first_name = first_names[i].replace("'", " ").replace('"', ' ').strip()
    sanitized_last_name = last_names[i].replace("'", " ").replace('"', ' ').strip()
    mail = first_names[i].strip() + '.' + last_names[i].strip() + '@gmail.com'
    id_badge = random.randint(1, 100000)
    password_val = ''.join(random.choices('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', k=10))
    sql = f"INSERT INTO utilisateurs (nom, prenom, mail, idBadge, password) VALUES ('{sanitized_first_name}', '{sanitized_last_name}', '{mail}', '{id_badge}', '{password_val}')"
    my_cursor.execute(sql)
    mydb.commit()
