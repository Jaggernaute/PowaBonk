import mysql.connector

mydb = mysql.connector.connect(
    host="localhost",
    user="yourusername",
    password="yourpassword"
)

print(mydb)
mycursor = mydb.cursor()

mycursor.execute("CREATE DATABASE mydatabase")