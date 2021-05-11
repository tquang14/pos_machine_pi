#include "../include/OrderModel.hpp"
#include "../include/ProjectConst.hpp"

#include <QDebug>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>

OrderModel::OrderModel(QObject *parent)
            : QObject (parent)
{
//    m_listItem << Item{"a", "b", "c"}
//               << Item{"a1", "b1", "c1"};
    getMenuListFromDB();
}

QVariantList OrderModel::getListItem() const {
    QVariantList list;
    for (const Item &p : m_listItem) {
        list << QVariant::fromValue(p);
    }
    return list;
}

void OrderModel::getMenuListFromDB() {
    QSqlDatabase db = QSqlDatabase::addDatabase(DB_TYPE);
    db.setDatabaseName(DB_NAME);
    bool ok = db.open();
    qDebug() << "connect to database at func: " << __FUNCTION__ << " : " << ok;
    if (ok) {
        const QString queryStr = "SELECT * FROM menu";
        QSqlQuery *query = new QSqlQuery();
        query->exec(queryStr);

        while(query->next()) {
            QSqlRecord record = query->record();
            m_listItem << Item{record.value(0).toString(), record.value(1).toString(), record.value(2).toString()};
        }
        delete query;
    }
}

void OrderModel::order(QVariantList nameItem)
{
    QList <QVariant> p = nameItem[0].toList();
    qDebug() << "aaaaaaaaaa " << p[0].toString();
}
