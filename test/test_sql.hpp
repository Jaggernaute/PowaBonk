//
// Created by jaggernaute on 3/3/22.
//

#include <QtTest>
#include <QSqlDatabase>

class test_sql {

public:
    static void run_tests() {
        initTestCase();
        test_file();
        test_connection();
    }

private slots:

    static void initTestCase() {
        qDebug() << "  ____     ___    _           \n"
                    " / ___|   / _ \\  | |        _ \n"
                    " \\___ \\  | | | | | |       (_)\n"
                    "  ___) | | |_| | | |___     _ \n"
                    " |____/   \\__\\_\\ |_____|   (_)\n"
                    "                              ";
    }

    static void test_file() {
        qDebug() << "]------------------------[.env file 1: ]-----------------------[";
        qDebug() << "> Testing env file";

        QFile env(":/envfile");
        env.open(QIODevice::ReadOnly);
        if (!env.isOpen()) {
            qDebug() << "> Could not open env file";
            return;
        } else
            qDebug() << "> Env file opened correctly";

        QString env_file = env.readAll();
        if (env_file.isEmpty()) {
            qDebug() << "> Could not read env file";
            return;
        } else
            qDebug() << "> Env file read correctly";

        QStringList env_list = env_file.split("\n");
        if (env_list.isEmpty()) {
            qDebug() << "> Could not split env file";
            return;
        } else
            qDebug() << "> Env file split correctly";

        bool loop = true;
        for (const QString &str: env_list) {
            QStringList env_pair = str.split("=");
            if (env_pair.size() != 2) {
                qDebug() << "> Could not split env pair";
                return;
            } else if (loop)qDebug() << "> Env pair split correctly";

            if (env_pair.size() == 2) {
                qputenv(env_pair[0].toStdString().c_str(),
                        env_pair[1].toStdString().c_str());
                if (env_pair[1].isEmpty() || env_pair[0].isEmpty()) {
                    qDebug() << "> Could not set env pair";
                    return;
                } else if (loop)
                    qDebug() << "> Env pair set correctly \n"
                                "\n> env pairs :";
                qDebug() << "-" << env_pair[0] << "=" << env_pair[1];
            }
            loop = false;
        }
        qDebug() << "\n";
    };

    static void test_connection() {
        qDebug() << "]------------------------[DB connection 2: ]-----------------------[";
        qDebug() << "> Testing connection";

        bool connected = false;
        QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
        QFile file(":/envfile");
        file.open(QIODevice::ReadOnly | QIODevice::Text);
        QTextStream in(&file);

        QString line = in.readLine();
        QStringList list = line.split("=");
        db.setHostName(list.at(1));
        qDebug() << "Database: hostname: " << list.at(1);

        line = in.readLine();
        list = line.split("=");
        db.setDatabaseName(list.at(1));
        qDebug() << "Database: database name: " << list.at(1);

        line = in.readLine();
        list = line.split("=");
        db.setUserName(list.at(1));
        qDebug() << "Database: username: " << list.at(1);

        line = in.readLine();
        list = line.split("=");
        db.setPassword(list.at(1));
        qDebug() << "Database: password: " << list.at(1);

        file.close();

        if (db.open()) {
            connected = true;
            qDebug() << "> Connection successful";
        } else {
            qDebug() << "Error: connection with database fail";
        }


        if (connected) {
            qDebug() << "> Database: connection ok";
        } else {
            qDebug() << "> Database: connection fail";
        }

        db.close();
        QSqlDatabase::removeDatabase("QMYSQL");
        QSqlDatabase::defaultConnection = "QMYSQL";
        QSqlDatabase::removeDatabase(QSqlDatabase::defaultConnection);
    };
};