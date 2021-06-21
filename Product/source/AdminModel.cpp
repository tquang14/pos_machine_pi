#include <QDebug>
#include <QDate>

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

bool AdminModel::clearQuantityOfItemFromInventory(QString itemName)
{
    if (!m_dbStatus)
        return false;
    const QString queryStr = "UPDATE menu SET quantity = 0 WHERE name = '" + itemName +"'";
    return m_query->exec(queryStr);
}

bool AdminModel::updateItemInInventory(QString name, int quantity, QString expiredDate)
{
    if (!m_dbStatus)
        return false;
    const QString queryStr = "UPDATE menu SET quantity = '" + QString::number(quantity) + "' "
                           + ", expDate = '" + expiredDate + "' WHERE name = '" + name + "'";
//    qDebug() << queryStr;
    return m_query->exec(queryStr);
}

void AdminModel::initDB() {
    m_db = new QSqlDatabase();
    *m_db = QSqlDatabase::addDatabase(DB_TYPE);
    m_db->setDatabaseName(DB_NAME);
    m_dbStatus = m_db->open();
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
        //get the current datetime to caculate the item is expired or not
        auto currentDate = QDate::currentDate();
        const QString queryStr = "SELECT name, quantity, expDate FROM menu";
        m_query->exec(queryStr);
        while (m_query->next()) {
            QSqlRecord record = m_query->record();
            bool isExpired = currentDate > QDate::fromString( record.value(2).toString(), "dd'-'MM'-'yyyy" );
            m_inventory << inventory{record.value(0).toString(), record.value(1).toString(), record.value(2).toString(), isExpired};
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

QList<QString> AdminModel::getInventoryByName(QString name) {
    if (!m_dbStatus)
        return {};
    // DB will make sure name will be exclusive
    const QString queryStr = "SELECT quantity, expDate FROM menu WHERE name = '" + name + "'";
    QList<QString> dataOfItem;
    m_query->exec(queryStr);
    while (m_query->next()) {
        QSqlRecord record = m_query->record();
        dataOfItem << record.value(0).toString() << record.value(1).toString();
    }
    //TODO: update m_inventory array
    return dataOfItem;
}
