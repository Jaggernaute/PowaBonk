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

        static QList<Users> get_user_by_name(const QString& name) {
            QList<Users> list;
            SQL_API::instance();
            QSqlQuery query;

            query.prepare("SELECT * FROM utilisateurs WHERE name = :name");
            query.bindValue(":name", name);
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
            return list;
        };

        static QList<Users> get_user_by_email(const QString& email) {
            QList<Users> list;
            SQL_API::instance();
            QSqlQuery query;

            query.prepare("SELECT * FROM utilisateurs WHERE email = :email");
            query.bindValue(":email", email);
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
            return list;
        };

        static QList<Users> get_user_by_id_badge(const QString& id_badge) {
            QList<Users> list;
            SQL_API::instance();
            QSqlQuery query;

            query.prepare("SELECT * FROM utilisateurs WHERE id_badge = :id_badge");
            query.bindValue(":id_badge", id_badge);
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
            return list;
        };

        static QList<Users> get_user_by_last_reservation(const QDateTime& last_reservation) {
            QList<Users> list;
            SQL_API::instance();
            QSqlQuery query;

            query.prepare("SELECT * FROM utilisateurs WHERE last_reservation = :last_reservation");
            query.bindValue(":last_reservation", last_reservation);
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
            return list;
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