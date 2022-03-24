#include <QApplication>
#include <QFile>

#include "src/Login_window.hpp"
#include "test/test_main.hpp"

int main(int argc, char *argv[]) {

    //run tests
    //test_main::all_tests();

    QApplication a(argc, argv);

    // set the icon
    QFile icon(":/icon.png");
    icon.open(QIODevice::ReadOnly);
    QByteArray bytes = icon.readAll();
    QPixmap pixmap;
    pixmap.loadFromData(bytes);
    icon.close();
    QApplication::setWindowIcon(pixmap);

    //link css file
    QFile styleSheet_file(":/style.css");
    styleSheet_file.open(QFile::ReadOnly);
    QString styleSheet = QLatin1String(styleSheet_file.readAll());
    a.setStyleSheet(styleSheet);

    Login_window w;
    w.show();

    return QApplication::exec();
}