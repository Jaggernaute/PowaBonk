//
// Created by jaggernaute on 2/24/22.
//

#include <QSqlQuery>
#include <QCryptographicHash>
#include "statement.hpp"

#pragma once

class Login_handler {
public:
    struct Credentials {
        QString username, password;
    };

    static auto sql_request(const Credentials& credentials)
        -> bool {

        QString password_hash = QCryptographicHash::hash(
                credentials.password.toUtf8(),
                QCryptographicHash::Sha512
                ).toHex();

        bool set_logged_in = false;

        if (connection(credentials.username, password_hash)) {
            qDebug() << "login success";
            set_logged_in = true;
        }
        return set_logged_in;
    };
};