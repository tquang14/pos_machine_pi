#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlRecord>
//project import
#include "Product/include/OrderModel.hpp"
int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<OrderModel>("com.OrderModel", 1, 0, "OrderModel");
    const QUrl url(QStringLiteral("qrc:/views/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
//    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
//    db.setDatabaseName("../db/datn.db");
//    bool ok = db.open();
//    qDebug() << "test database ok: " << ok;
//    QSqlQuery query;
//    QString queryString = "SELECT * FROM test";

//    query.exec(queryString);

//    while (query.next()) {
//        QSqlRecord record = query.record();
//        qDebug() << "Date : " << record.value(0).toString();
//    }
    return app.exec();
}
