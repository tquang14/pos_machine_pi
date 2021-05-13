#include <QDebug>

#include "../include/OrderModel.hpp"
#include "../include/ProjectConst.hpp"

OrderModel::OrderModel(QObject *parent)
            : QObject (parent)
{
    initDB();

    getMenuListFromDB();
}

OrderModel::~OrderModel() {
    delete m_query;
    delete m_db;
}

void OrderModel::initDB() {
    m_db = new QSqlDatabase();
    *m_db = QSqlDatabase::addDatabase(DB_TYPE);
    m_db->setDatabaseName(DB_NAME);
    m_dbStatus = m_db->open();
    qDebug() << "db status: " << m_dbStatus;
    m_query = new QSqlQuery();
}

QVariantList OrderModel::getListItem() const {
    QVariantList list;
    for (const Item &p : m_listItem) {
        list << QVariant::fromValue(p);
    }
    return list;
}

void OrderModel::getMenuListFromDB() {
    if (m_dbStatus) {
        const QString queryStr = "SELECT * FROM menu";
        m_query->exec(queryStr);
        while(m_query->next()) {
            QSqlRecord record = m_query->record();
            m_listItem << Item{record.value(0).toString(), record.value(1).toString(), record.value(2).toString()};
        }
    }
}

bool OrderModel::order(QVariantList nameItem, int totalMoney)
{
    QString receiptContent = "";
    for (auto p : nameItem) {
        QList <QVariant> list = p.toList();
        receiptContent += list[0].toString() + " x" + list[1].toString() + ", ";
    }
    // remove the last ", " because in the loop we add it
    receiptContent = receiptContent.left(receiptContent.lastIndexOf(", "));

    const QString queryStr = "INSERT INTO receipt (id, dishes, totalMoney) VALUES(NULL, '"
                           + receiptContent + "'," + "'" + QString::number(totalMoney) + "')";
    if (m_dbStatus)
        return m_query->exec(queryStr);
    return false;
}
