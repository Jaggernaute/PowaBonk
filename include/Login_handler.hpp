//
// Created by jaggernaute on 2/24/22.
//

#include <QSqlQuery>
#include <QCryptographicHash>
#include "statement.hpp"

#pragma once

class Login_handler {
public:
    static auto sql_request(const QString &username, const QString &password) -> bool {

        QString password_hash = QCryptographicHash::hash(
                                password.toUtf8(),QCryptographicHash::Sha512
                                ).toHex();

        bool set_logged_in = false;

        if (connection(username, password_hash)) {
            qDebug() << "login success";
            set_logged_in = true;
        }
        return set_logged_in;
    };
};