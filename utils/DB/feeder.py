import os
import hashlib
import random
import secrets
from typing import Dict, Optional

import mysql.connector


class DB:
    __conn_info_slots = ('DBNAME', 'HOST', 'PASSWORD', 'USERNAME')

    def __init__(self):
        connection_info = self.get_connection_info()
        if not connection_info:
            return

        try:
            self.connection = mysql.connector.connect(
                host=connection_info.get('HOST'),
                user=connection_info.get('USERNAME'),
                password=connection_info.get('PASSWORD'),
                database=connection_info.get('DBNAME')
            )

        except mysql.connector.Error:
            self.connection = None
            print(
                'Connection info is not complete, please check your config file'
                ' and make sure it has all key from the .env.example file'
            )
            return

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.connection:
            self.connection.close()

    @staticmethod
    def get_connection_info() -> Optional[Dict[str, str]]:
        """Get connection info from env file."""
        try:
            with open('../../resources/.env') as f:
                file_content = f.read()
        except FileNotFoundError:
            print(
                'Please create a .env file with the following contents:'
                '\nDB_HOST=<host>\nDB_USER=<user>'
            )
            return None

        return dict(line.split('=') for line in file_content.splitlines())

    def insert_user(self, first_name, last_name, badge, email, password, derniere_res):
        """Insert a user into the database."""
        cursor = self.connection.cursor()
        cursor.execute(
            'INSERT INTO utilisateurs(nom, prenom, mail, idBadge, password, `derniere-res`)'
            'VALUES (%s, %s, %s, %s, %s, %s)',
            (first_name, last_name, badge, email, password, derniere_res)
        )
        self.connection.commit()


def sanitize_name(name: str) -> str:
    return name.replace("'", " ").replace('"', ' ').strip()


def main():
    os.system('ruby gen.rb')

    with open('first_name_file') as f:
        firstnames = map(sanitize_name, f.read().splitlines()[:30])

    with open('last_name_file') as f:
        lastnames = map(sanitize_name, f.read().splitlines()[:30])

    with open('date_file') as f:
        dates = f.read().splitlines()[:30]

    with DB() as db:
        for c, (firstname, lastname, dates) in enumerate(zip(firstnames, lastnames, dates)):
            mail = f"{firstname}.{lastname}@gmail.com"
            password = secrets.token_hex(16)

            print(f"{mail} => {password}")

            db.insert_user(
                first_name=firstname,

                last_name=lastname,
                badge=random.randint(1, 100000),
                email=mail,
                password=hashlib.sha512(password.encode('utf-8')).hexdigest(),
                derniere_res=dates
            )


if __name__ == '__main__':
    main()
