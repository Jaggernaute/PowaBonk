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

        [[nodiscard]] auto get_id() const -> int {
            return id;
        };
        [[nodiscard]] auto get_name() const -> QString {
            return name;
        };
        [[nodiscard]] auto get_surname() const -> QString {
            return surname;
        };
        [[nodiscard]] auto get_email() const -> QString {
            return email;
        };
        [[nodiscard]] auto get_id_badge() const -> QString {
            return id_badge;
        };
        [[nodiscard]] auto get_last_reservation() const -> QDateTime {
            return last_reservation;
        };

    private:
        int id;
        QString name;
        QString surname;
        QString email;
        QString id_badge;
        QDateTime last_reservation;
};

#endif //PROJECT_ADMIN_INTERFACE_USERS_HPP