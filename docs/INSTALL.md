## Install Maria DB

Now you have to install and create the database.
You are going to install Maria DB, the implementation of MySQL for Arch Linux

```sh
pacman -S mariadb libmariadbclient mariadb-clients
```

After installation, you have to set some base configuration with this command.
```sh
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
```

As you guess, you need to start and enable the service.
```sh
systemctl start mysqldsystemctl start mysqld
systemctl enable mysqld
```
execute the seed file.
```sh
mysql -uroot -h127.0.0.1 < [powabonk-dir]/resources/seed.sql
```

you have to set the root password and some other configurations. You can do it with this command

```sh
mysql_secure_installation
```

## Clone the repository on your machine.
install git :  
```sh
pacman -S git
```
clone the repository:
```sh
git clone https://github.com/Jaggernaute/PowaBonk.git
```

## configure the environement :

```sh
cd PowaBonk/resources/
```
create the dot-env file :
```sh
cp ..env.example .env
```
set all the variables :
```sh
DBNAME=borne
TABLENAME=admins
USERNAME=[your username]
PASSWORD=[your password]
```
```sh
cd ../
```

## building the sources :
install the required packages :
```sh
pacman -S qt6-base-git ninja cmake
```
build and compile the sources :
```sh
make
 ```
   <!-- TODO: add the database / server deployement instructions  and move 
   everything to a DEPLOYEMENT.md-->
