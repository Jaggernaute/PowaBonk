//
// Created by jaggernaute on 6/7/22.
//

#include "../../include/SQL_API.hpp"
#include <QSqlQuery>
#include <QDebug>

auto seed() -> void {
    SQL_API::instance();
    QSqlQuery query;
    QString query_string;

    QFile file(":/seed.sql");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Error opening file";
    }

    query_string = file.readAll();
    query.prepare(query_string);
    query.exec();
}