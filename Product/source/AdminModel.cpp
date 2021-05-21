#include <QDebug>

#include "../include/AdminModel.hpp"
#include "../include/ProjectConst.hpp"

AdminModel::AdminModel(QObject *parent)
            : QObject (parent)
{
    initDB();
    getAllReceiptFromDB();
    getInventoryFromDB();
}

AdminModel::~AdminModel() {
    m_db->close();
    delete m_query;
    delete m_db;
    QSqlDatabase::removeDatabase(CONNECTION_NAME);
}

void AdminModel::initDB() {
    m_db = new QSqlDatabase();
    *m_db = QSqlDatabase::addDatabase(DB_TYPE);
    m_db->setDatabaseName(DB_NAME);
    m_dbStatus = m_db->open();
    qDebug() << "db status: " << m_dbStatus;
    m_query = new QSqlQuery();
}


void AdminModel::getAllReceiptFromDB() {
    if (m_dbStatus) {
        const QString queryStr = "SELECT * FROM receipt";
        m_query->exec(queryStr);
        while (m_query->next()) {
            QSqlRecord record = m_query->record();
            m_listReceipt << receipt{record.value(0).toString(), record.value(1).toString(), record.value(2).toString(), record.value(3).toString()};
        }
    }
}

void AdminModel::getInventoryFromDB() {
    if (m_dbStatus) {
        const QString queryStr = "SELECT name, quantity, expDate FROM menu";
        m_query->exec(queryStr);
        while (m_query->next()) {
            QSqlRecord record = m_query->record();
            m_inventory << inventory{record.value(0).toString(), record.value(1).toString(), record.value(2).toString()};
        }
    }
}

QVariantList AdminModel::getListReceipt() const {
    QVariantList list;
    for (const receipt &p : m_listReceipt) {
        list << QVariant::fromValue(p);
    }
    return list;
}

QVariantList AdminModel::getInventory() const {
    QVariantList list;
    for (const inventory &p : m_inventory) {
        list << QVariant::fromValue(p);
    }
    return list;
}
