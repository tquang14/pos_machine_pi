#include <QApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDesktopWidget>
#include <QQmlContext>
//project import
#include "Product/include/OrderModel.hpp"
#include "Product/include/AdminModel.hpp"
int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<OrderModel>("com.OrderModel", 1, 0, "OrderModel");
    qmlRegisterType<AdminModel>("com.AdminModel", 1, 0, "AdminModel");
    const QUrl url(QStringLiteral("qrc:/views/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    //get screen resolution and set it to qml
    QDesktopWidget widget;
    QRect mainScreenSize = widget.availableGeometry(widget.primaryScreen());

    QVector<QQmlContext::PropertyPair> screenResolution;// = new QVector<QQmlContext::PropertyPair>() ;

    screenResolution.append({"SCREEN_WIDTH", mainScreenSize.width()});
    screenResolution.append({"SCREEN_HEIGHT", mainScreenSize.height()});

    engine.rootContext()->setContextProperties(screenResolution);

    engine.load(url);

    return app.exec();
}
