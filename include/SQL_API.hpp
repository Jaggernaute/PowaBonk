//
// Created by jaggernaute on 27/01/2022.
//
#pragma once

#define SQL_API_HPP
#ifdef SQL_API_HPP

#include <memory>
#include <QSqlDatabase>
#include <QFile>

class SQL_API {

    public:
        SQL_API(SQL_API const&) = delete;
        SQL_API& operator=(SQL_API const&) = delete;

        static std::shared_ptr<SQL_API> instance() {
            static std::shared_ptr<SQL_API> s { new SQL_API() };
            return s;
        }

    private:
        SQL_API() {
            QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
            QFile file(":/envfile");
            file.open(QIODevice::ReadOnly | QIODevice::Text);
            QTextStream in(&file);

            QString line = in.readLine();
            QStringList list = line.split("=");
            db.setHostName(list.at(1));

            line = in.readLine();
            list = line.split("=");
            db.setDatabaseName(list.at(1));

            line = in.readLine();
            list = line.split("=");
            db.setUserName(list.at(1));

            line = in.readLine();
            list = line.split("=");
            db.setPassword(list.at(1));

            file.close();
            db.open();
        }
};

#endif // SQL_API_HPP
