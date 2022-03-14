//
// Created by jaggernaute on 2/25/22.
//

#include "test_sql.hpp"

class test_main {
    public:
        static void all_tests() {
            init();

           test_sql::run_tests();

           cleanupTestCase();
       }

       static void init() {
               qDebug("                  _   _             _                  _   \n"
                      "  _   _   _ __   (_) | |_          | |_    ___   ___  | |_ \n"
                      " | | | | | '_ \\  | | | __|         | __|  / _ \\ / __| | __|\n"
                      " | |_| | | | | | | | | |_          | |_  |  __/ \\__ \\ | |_ \n"
                      "  \\__,_| |_| |_| |_|  \\__|  _____   \\__|  \\___| |___/  \\__|\n"
                      "                           |_____|                         ");
       }

    static void cleanupTestCase() {
        qDebug("\n");
        qDebug("> tests completed successfully");
        qDebug("> cleaning up");
    }
};