//
// Created by jaggernaute on 3/31/22.
//

#ifndef POWA_BONK_SQL_TESTS_HPP
#define POWA_BONK_SQL_TESTS_HPP

#include <QTest>

class SQL_tests: public QObject
{
Q_OBJECT

private slots:

    [[maybe_unused]] static void initTestCase() {
        qDebug("\n"
                     "███████╗ ██████╗ ██╗          ████████╗███████╗███████╗████████╗███████╗\n"
                     "██╔════╝██╔═══██╗██║          ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██╔════╝\n"
                     "███████╗██║   ██║██║             ██║   █████╗  ███████╗   ██║   ███████╗\n"
                     "╚════██║██║▄▄ ██║██║             ██║   ██╔══╝  ╚════██║   ██║   ╚════██║\n"
                     "███████║╚██████╔╝███████╗███████╗██║   ███████╗███████║   ██║   ███████║\n"
                     "╚══════╝ ╚══▀▀═╝ ╚══════╝╚══════╝╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚══════╝\n"
                      "");
    }

    [[maybe_unused]] static void open_env_file() {
        QVERIFY(QFile::exists(":/envfile"));
    }

};

QTEST_MAIN(SQL_tests)

#endif //POWA_BONK_SQL_TESTS_HPP
