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

    query.prepare("select * from utilisateurs where `nom`          like :search_string\n"
              "                                         or `prenom`       like :search_string\n"
              "                                         or `mail`         like :search_string\n"
              "                                         or `idBadge`      like :search_string;");
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

    for(int i = 1; i <= id; i++) {
        query.prepare("SELECT * FROM utilisateurs WHERE id = :id");
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

#endif //POWA_BONK_STATEMENT_HPP
