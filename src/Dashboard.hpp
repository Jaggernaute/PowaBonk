//
// Created by jaggernaute on 3/10/22.
//

#ifndef PROJECT_ADMIN_INTERFACE_PANNEL_WINDOW_HPP
#define PROJECT_ADMIN_INTERFACE_PANNEL_WINDOW_HPP

#include <QMainWindow>
#include <QApplication>
#include "../include/Users.hpp"
#include "../include/statement.hpp"

class Dashboard: public QMainWindow {
    QMainWindow *window;
    QVBoxLayout *window_layout = new QVBoxLayout();
    QGridLayout *cards_layout = new QGridLayout();
    QWidget *cards_widget = new QWidget();
    QVBoxLayout *add_user_layout = new QVBoxLayout();
    QWidget *window_widget = new QWidget();

public:
    Dashboard(){
        window = new QMainWindow();
        window->setWindowTitle("Liste utilisateurs");
        window->resize(QApplication::screens()[0]->size());
        display_users();
        add_user();

        window_widget->setStyleSheet("color: #ffffff;");


        window_layout->addWidget(title_bar());
        window_layout->addWidget(cards_widget);
        window_layout->addLayout(add_user_layout);
        window_widget->setLayout(window_layout);

        set_connections();

        window->setCentralWidget(window_widget);
        window->show();
    }

    void display_users() {
        auto user_list = get_user(12);
        int row = 0;
        int col = 0;
        for(const auto& user: user_list){

            if (col == 4) {
                col = 0;
                row++;
            }
            if (row == 3) {
                return;
            }

            auto user_layout = new QVBoxLayout();

            auto user_name = new QLabel(user.get_name() + " " + user.get_surname());
            auto user_id = new QLabel("#" + QString::number(user.get_id()));
            auto user_email = new QLabel(user.get_email());
            auto user_id_badge = new QLabel(user.get_id_badge());
            auto user_last_reservation = new QLabel(user.get_last_reservation().toString());

            user_layout->addWidget(user_name);
            user_layout->addWidget(user_id);
            user_layout->addWidget(user_email);
            user_layout->addWidget(user_id_badge);
            user_layout->addWidget(user_last_reservation);

            auto card = new QWidget();
            card->setFixedSize(300,150);
            card->setStyleSheet("background-color: #1C2837;");
            card->setLayout(user_layout);

            cards_layout->addWidget(card, row, col);
            col++;
        }
        cards_widget->setLayout(cards_layout);
    }

    void add_user(){
        auto hlayout = new QHBoxLayout();

        auto name = new QLineEdit();
        name->setPlaceholderText("Prenom");
        name->setStyleSheet("background-color: #1C2535;");
        name->setStyleSheet("color: #9FA0B1");

        auto surname = new QLineEdit();
        surname->setPlaceholderText("Nom");
        surname->setStyleSheet("background-color: #1C2535;");
        surname->setStyleSheet("color: #9FA0B1");

        auto email = new QLineEdit();
        email->setPlaceholderText("Email");
        email->setStyleSheet("background-color: #1C2535;");
        email->setStyleSheet("color: #9FA0B1");

        auto id_badge = new QLineEdit();
        id_badge->setPlaceholderText("Badge");
        id_badge->setStyleSheet("background-color: #1C2535;");
        id_badge->setStyleSheet("color: #9FA0B1");

        auto add_button = new QPushButton("Ajouter");
        add_button->setStyleSheet("background-color: #1C2837; color: #F5F6F7;");
        add_button->setFixedSize(100,50);
        add_button->setFont(QFont("Arial", 12));
        add_button->setCursor(Qt::PointingHandCursor);
        add_button->setFocusPolicy(Qt::NoFocus);
        add_button->setFlat(true);
        add_button->setIcon(QIcon(":/icons/add.png"));
        add_button->setIconSize(QSize(20,20));
        add_button->setToolTip("Ajouter un utilisateur");

        hlayout->addWidget(surname);
        hlayout->addWidget(name);
        hlayout->addWidget(email);
        hlayout->addWidget(id_badge);
        hlayout->addWidget(add_button);



        auto title = new QLabel("Ajout client");
        title->setStyleSheet("color: #F5F6F7;");
        title->setFont(QFont("Arial", 18));

        add_user_layout->addWidget(title);
        add_user_layout->addLayout(hlayout);
    }

    QPushButton *search_button = new QPushButton("Rechercher");
    QLineEdit *search_bar = new QLineEdit();

    QWidget * title_bar(){
        auto *title = new QLabel("Tableau de bord");
        title->setFont(QFont("Montserrat", 36, QFont::Bold));

        auto *logo = new QPixmap(":/logo.png");
        logo->setMask(logo->createMaskFromColor(QColor(255, 255, 255)));
        auto *logo_label = new QLabel();
        logo_label->setPixmap(*logo);

        search_bar = new QLineEdit();
        auto *search_icon = new QPixmap(":/search.png");
        auto *search_icon_label = new QLabel();
        logo_label->setPixmap(search_icon->scaled(18,18));

        search_button->setText("Rechercher");
        search_button->setStyleSheet("background-color: #1C2837; color: #F5F6F7;");
        search_button->setFixedSize(100,50);
        search_button->setFont(QFont("Arial", 12));
        search_button->setCursor(Qt::PointingHandCursor);
        search_button->setFocusPolicy(Qt::NoFocus);
        search_button->setFlat(true);


        auto *search_layout = new QHBoxLayout();
        search_layout->addWidget(search_bar);
        search_layout->addWidget(search_icon_label);
        search_layout->addWidget(search_button);

        search_bar->setPlaceholderText("Rechercher");

        auto *title_layout = new QGridLayout();
        title_layout->addWidget(title,0 ,0);
        title_layout->addWidget(logo_label, 0, 2, 2, 1);
        title_layout->addLayout(search_layout, 0, 4);

        auto *title_widget = new QWidget();
        title_widget->setFixedHeight(50);
        title_widget->setLayout(title_layout);

        return  title_widget;
    }

    void set_connections(){
        connect(this->search_button, &QPushButton::clicked,  [this]{
            for(const auto& u : search_user(search_bar->text()).toList()){
                qDebug() << u.get_name();
                qDebug() << u.get_surname();
                qDebug() << u.get_email();
                qDebug() << u.get_id_badge();
                qDebug() << u.get_id();
                qDebug() << u.get_last_reservation();
            }
        });
    }
};

#endif
