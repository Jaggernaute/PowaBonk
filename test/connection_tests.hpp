//
// Created by jaggernaute on 4/1/22.
//

#ifndef POWA_BONK_CONNECTION_TESTS_HPP
#define POWA_BONK_CONNECTION_TESTS_HPP

#include <QTest>

class Connection_tests: public QObject {
Q_OBJECT

private slots:
    static void initTestCase() {
        qDebug("Dummy test to be able to compile");
    }
};

QTEST_MAIN(Connection_tests)

#endif //POWA_BONK_CONNECTION_TESTS_HPP
