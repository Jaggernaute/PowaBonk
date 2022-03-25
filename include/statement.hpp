//
// Created by jaggernaute on 3/17/22.
//

#ifndef POWA_BONK_STATEMENT_HPP
#define POWA_BONK_STATEMENT_HPP

#include "Users.hpp"

static QList<Users> search_user(const QString& search_string) {
    QList<Users> list;
    SQL_API::instance();
    QSqlQuery query;

    QFile file(":/search-user.sql");
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Error opening file";
    }
    QTextStream in(&file);
    QString query_string = in.readAll();
    query.prepare(query_string);

    query.bindValue(":search_string", search_string);
    query.exec();
    query.next();

    Users user(
            query.value(1).toInt(),
            query.value(2).toString(),
            query.value(3).toString(),
            query.value(4).toString(),
            query.value(5).toString(),
            query.value(7).toDateTime()
    );
    list.append(user);
    return list;
};

static QList<Users> get_user(int id) {
    QList<Users> list;
    SQL_API::instance();
    QSqlQuery query;

    QFile file(":/select-id.sql");
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Error opening file";
    }
    QTextStream in(&file);
    QString query_string = in.readAll();

    for(int i = 1; i <= id; i++) {
        query.prepare(query_string);
        query.bindValue(":id", i);
        query.exec();
        query.next();

        Users user(
                query.value("id").toInt(),
                query.value("prenom").toString(),
                query.value("nom").toString(),
                query.value("mail").toString(),
                query.value("idBadge").toString(),
                query.value("derniere-res").toDateTime()
        );
        list.append(user);
    }
    return list;
};

static bool connection(const QString& username, const QString& password) {
    SQL_API::instance();
    QSqlQuery query;

    QFile file(":/connection.sql");
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Error opening file";
        return false;
    }
    QTextStream in(&file);
    QString query_string = in.readAll();
    query.prepare(query_string);
    query.bindValue(":username", username);
    query.bindValue(":password", password);
    query.exec();
    query.next();

    if(query.value(0).toInt() == 0) {
        return false;
    }
    return true;
};

#endif //POWA_BONK_STATEMENT_HPP
