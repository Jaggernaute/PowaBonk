//
// Created by jaggernaute on 3/17/22.
//

#ifndef POWA_BONK_STATEMENT_HPP
#define POWA_BONK_STATEMENT_HPP

#include "Users.hpp"

static auto search_user(const QString& search_string) -> QList<Users> {
    QList<Users> list;
    SQL_API::instance();
    QSqlQuery query;
    QString query_string;

    QFile file(":/search-user.sql");
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Error opening file";
    }

    query_string = file.readAll();

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

/**
 * @brief The get_user method
 *
 * This class is used to store the information of a statement.
 *
 * @param int usr_count - The number of users to return.
 *
 * @return QList<Users> - A list of users.
 *
 * @author jaggernaute
 */
static auto get_user(int usr_count) -> QList<Users> {
    QList<Users> list;
    SQL_API::instance();
    QSqlQuery query;
    QString query_string;

    QFile file(":/select-users.sql");
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Error opening file";
    }


    query_string = file.readAll();

    for(int i = 1; i <= usr_count; i++) {
        query.prepare(query_string);
        query.exec();
        query.next();

        if(query.next()) {
            break;
        }

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
