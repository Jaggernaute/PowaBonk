//
// Created by jaggernaute on 3/31/22.
//

#ifndef POWA_BONK_SQL_TESTS_HPP
#define POWA_BONK_SQL_TESTS_HPP

#include <QTest>
#include <QtSql/QSqlDatabase>

class SQL_tests: public QObject
{
Q_OBJECT

private slots:

    [[maybe_unused]] static void initTestCase() {
        qDebug("\n"
                     "███████╗ ██████╗ ██╗          ████████╗███████╗███████╗████████╗███████╗\n"
                     "██╔════╝██╔═══██╗██║          ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██╔════╝\n"
                     "███████╗██║   ██║██║             ██║   █████╗  ███████╗   ██║   ███████╗\n"
                     "╚════██║██║▄▄ ██║██║             ██║   ██╔══╝  ╚════██║   ██║   ╚════██║\n"
                     "███████║╚██████╔╝███████╗███████╗██║   ███████╗███████║   ██║   ███████║\n"
                     "╚══════╝ ╚══▀▀═╝ ╚══════╝╚══════╝╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚══════╝\n"
                      "");
    }

    [[maybe_unused]] static void open_env_file() {
        QVERIFY(QFile::exists(":/envfile"));
    }

    [[maybe_unused]] static void connection_test() {
        QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
        QFile file(":/envfile");
        if(file.open(QIODevice::ReadOnly | QIODevice::Text)){
            QTextStream in(&file);

            QString line = in.readLine();
            QStringList list = line.split("=");
            db.setHostName(list.at(1));
            qDebug() << "hostname: " << list.at(1);

            line = in.readLine();
            list = line.split("=");
            db.setDatabaseName(list.at(1));
            qDebug() << "database: " << list.at(1);

            line = in.readLine();
            list = line.split("=");
            db.setUserName(list.at(1));
            qDebug() << "username: " << list.at(1);

            line = in.readLine();
            list = line.split("=");
            db.setPassword(list.at(1));
            qDebug() << "password: " << list.at(1);

            file.close();
            db.open();
        }

    }

};

QTEST_MAIN(SQL_tests)

#endif //POWA_BONK_SQL_TESTS_HPP
