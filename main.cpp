#include <QApplication>
#include <QFile>

#include "src/Login_window.hpp"
#include "test/tests_template.hpp"

auto main(int argc, char *argv[]) -> int {

    QApplication app(argc, argv);

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
    app.setStyleSheet(styleSheet);

    Login_window win;
    win.show();

    return QApplication::exec();
}