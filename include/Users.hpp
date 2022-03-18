#ifndef PROJECT_ADMIN_INTERFACE_USERS_HPP
#define PROJECT_ADMIN_INTERFACE_USERS_HPP

#include <QDateTime>
#include <utility>
#include <QSqlQuery>
#include "SQL_API.hpp"

class Users {
    public:

        Users(
                int id,
              QString name,
              QString surname,
              QString email,
              QString id_badge,
              QDateTime last_reservation
              ) {
            this->id = id;
            this->name = std::move(name);
            this->surname = std::move(surname);
            this->email = std::move(email);
            this->id_badge = std::move(id_badge);
            this->last_reservation = std::move(last_reservation);
        };

        [[nodiscard]] int get_id() const { return id; };
        [[nodiscard]] QString get_name() const { return name; };
        [[nodiscard]] QString get_surname() const { return surname; };
        [[nodiscard]] QString get_email() const { return email; };
        [[nodiscard]] QString get_id_badge() const { return id_badge; };
        [[nodiscard]] QDateTime get_last_reservation() const { return last_reservation; };

    private:
        int id;
        QString name;
        QString surname;
        QString email;
        QString id_badge;
        QDateTime last_reservation;
};

#endif //PROJECT_ADMIN_INTERFACE_USERS_HPP