//
// Created by jaggernaute on 2/22/22.

#include <QWidget>
#include <QApplication>
#include <QPalette>
#include <QLabel>
#include <QLineEdit>
#include <QPushButton>
#include <QGridLayout>
#include <QDialog>
#include <QMessageBox>
#include <QCloseEvent>

#include "../include/Login_handler.hpp"
#include "Dashboard.hpp"

class Login_window: public QWidget {
    Q_OBJECT

    public:
        QLineEdit   *username_input{};
        QLineEdit   *password_input{};
        QPushButton *login_button{};
        QPushButton *cancel_button{};
        QVBoxLayout *v_layout{};
        QHBoxLayout *button_layout{};
        QPixmap *logo{};
        QLabel *logo_label{};

        /**
         * Constructor
         * @param parent
         * @return nothing
         */
        explicit Login_window(){
            this->setWindowTitle("Login");
            this->resize(QApplication::screens()[0]->size());
            this->setWindowIcon(QIcon(":/icons/IE.png"));

            create_ui();
            layout_setup();
            set_style();
            set_connections();
        }

        /**
         * @brief create_ui() <br>
         * @brief creates the UI elements
         * @author jaggernaute
         */
        void create_ui() {

            logo = new QPixmap(":/logo.png");
            logo_label = new QLabel();
            logo_label->setPixmap(*logo);

            username_input = new QLineEdit();
            username_input->setPlaceholderText("Username");
            username_input->setFont(QFont("Montserrat", 18, QFont::Bold));

            // set the size of the username input
            username_input->setFixedSize(0.66*logo_label->width(), 49);


            password_input = new QLineEdit();
            password_input->setPlaceholderText("Password");
            password_input->setFont(QFont("Montserrat", 18, QFont::Bold));
            password_input->setEchoMode(QLineEdit::Password);
            password_input->setFixedSize(0.66*logo_label->width(), 49);

            login_button = new QPushButton("Connexion");
            login_button->setFixedSize(this->width()/13, 49);
            login_button->setObjectName("login-button");
            cancel_button = new QPushButton("Annuler");
            cancel_button->setFixedSize(this->width()/15, 49);
            cancel_button->setObjectName("quit-button");
        }

        /**
         * layout_setup() <br>
         * Sets up the layout
         * @return void
         * @see create_ui()
         */
        void layout_setup() {
            button_layout = new QHBoxLayout();
            button_layout->addWidget(cancel_button);
            button_layout->addWidget(login_button);
            button_layout->setSpacing(122);

            v_layout = new QVBoxLayout();

            v_layout->addWidget(logo_label);
            v_layout->addWidget(username_input);
            v_layout->addWidget(password_input);
            v_layout->addLayout(button_layout);

            v_layout->setSpacing(60);
            v_layout->setAlignment(Qt::AlignCenter);
            v_layout->setObjectName("v-layout");

            this->setLayout(v_layout);
        }

        /**
         * set_style() <br>
         * Sets the style of the UI elements
         * @return void
         * @see create_ui()
         */
         void set_style() {
            QPixmap bkgnd(":/bg.png");
            bkgnd = bkgnd.scaled(this->size());
            QPalette palette;
            palette.setBrush(QPalette::Window, bkgnd);
            this->setPalette(palette);

         }

        /**
         * set_connections() <br>
         * Sets up the connections
         * @return void
         * @see create_ui()
         */
        void set_connections(){
            connect(
                    login_button,
                    SIGNAL(clicked()),
                    this,
                    SLOT(login_button_clicked())
            );
            connect(
                    cancel_button,
                    SIGNAL(clicked()),
                    this,
                    SLOT(cancel_button_clicked())
            );
        }

        ~Login_window() override = default;

    private slots:

        /**
         * login_button_clicked() <br>
         * Handles the login button being clicked
         * @return void
         * @see set_connections()
         */
        void login_button_clicked() {
            if( username_input->text().isEmpty() ||
                password_input->text().isEmpty() ) {
                QMessageBox::warning(this,
                                     "Error",
                                     "Please enter a username and password");
                return;
            }

            QString username = username_input->text();
            QString password = password_input->text();

            if(Login_handler::sql_request(username, password)){
                new Dashboard();
                this->close();
            }
            else{
                QMessageBox::warning(
                        this,
                        "Login Failed",
                        "Username or password is incorrect",
                        QMessageBox::Ok
                );
            }
        }

        /**
         * cancel_button_clicked() <br>
         * Handles the cancel button being clicked
         * @return void
         * @see set_connections()
         */
        void cancel_button_clicked() const {
            username_input->clear();
            password_input->clear();
        }

    void keyPressEvent(QKeyEvent *event) override {
        if(event->key() == Qt::Key_Enter || event->key() == Qt::Key_Return) {
            login_button_clicked();
        }
    }
};
