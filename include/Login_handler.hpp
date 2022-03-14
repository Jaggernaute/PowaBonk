//
// Created by jaggernaute on 2/24/22.
//

#include <QSqlQuery>
#include <QCryptographicHash>
#include "SQL_API.hpp"


class Login_handler {
public:
    static bool sql_request(const QString &username, const QString &password) {

        QString password_hash = QCryptographicHash::hash(password.toUtf8(),QCryptographicHash::Sha512).toHex();

        bool set_logged_in = false;
        SQL_API::instance();

        QSqlQuery query;
        query.prepare("SELECT EXISTS (SELECT * FROM admins WHERE username = :username AND password = :password)");
        query.bindValue(":username", username);
        query.bindValue(":password", password_hash);
        query.exec();

        if (query.next()) {
            if (query.value(0).toBool()) {
                qDebug() << "login success";
                set_logged_in = true;
            }
        }
        return set_logged_in;
    };
};