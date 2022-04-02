//
// Created by jaggernaute on 3/31/22.
//

#ifndef POWA_BONK_HASH_TESTS_HPP
#define POWA_BONK_HASH_TESTS_HPP

#pragma once

#include <QTest>
#include <QCryptographicHash>

class Hash_tests: public QObject {
    Q_OBJECT

private slots:

    [[maybe_unused]] static void initTestCase() {
        qDebug("\n"
                     "██╗  ██╗ █████╗ ███████╗██╗  ██╗     ████████╗███████╗███████╗████████╗███████╗\n"
                     "██║  ██║██╔══██╗██╔════╝██║  ██║     ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██╔════╝\n"
                     "███████║███████║███████╗███████║        ██║   █████╗  ███████╗   ██║   ███████╗\n"
                     "██╔══██║██╔══██║╚════██║██╔══██║        ██║   ██╔══╝  ╚════██║   ██║   ╚════██║\n"
                     "██║  ██║██║  ██║███████║██║  ██║███████╗██║   ███████╗███████║   ██║   ███████║\n"
                     "╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚══════╝\n"
                     "");
    }

    [[maybe_unused]] static void string_hashing_Sha512() {
        QString test_string = "Hello World!";
        QString hash = QCryptographicHash::hash(
                test_string.toUtf8(),QCryptographicHash::Sha512
        ).toHex();

        QVERIFY(hash != "861844d6704e8573fec34d967e20bcfe"
                        "f3d424cf48be04e6dc08f2bd58c72974"
                        "3371015ead891cc3cf1c9d34b49264b5"
                        "10751b1ff9e537937bc46b5d6ff4ecc8");
    }
};

QTEST_MAIN(Hash_tests)

#endif //POWA_BONK_HASH_TESTS_HPP
