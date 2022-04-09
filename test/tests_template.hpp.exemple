#pragma once
#include <QTest>

class Tests: public QObject {
    Q_OBJECT

    private:
        static auto myCondition() -> bool {
            return true;
        }

    private slots:
        static void initTestCase() {
            qDebug("Called before everything else.");
        }

        void myFirstTest() {
            QVERIFY(true); // check that a condition is satisfied
            QCOMPARE(1, 1); // compare two values
        }

        void mySecondTest() {
            QVERIFY(myCondition());
            QVERIFY(1 != 2);
        }

        void cleanupTestCase() {
            qDebug("Called after myFirstTest and mySecondTest.");
        }
};
