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
    m_db->close();
    delete m_query;
    delete m_db;
    QSqlDatabase::removeDatabase(CONNECTION_NAME);
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
            m_listItem << Item{record.value(0).toString(), record.value(1).toString(), record.value(2).toString(), record.value(3).toString()};
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
    if (m_dbStatus) {
        decreaseQuantityOfItemInDB(nameItem);
        return m_query->exec(queryStr);
    }
    return false;
}

void OrderModel::decreaseQuantityOfItemInDB(QVariantList orderList) {

    // loop throught the list and decrease each item one by one
    for (auto element : orderList) {
        QList <QVariant> list = element.toList();
        // get name of item to be decrease quantity
        const QString name = list[0].toString();
        // find this item in menu list
        auto result = std::find_if(
            m_listItem.begin(),
            m_listItem.end(),
            [&name](Item const& c) {
                return c.m_name == name;
            }
        );
        // if menu list contain this item, decrease it by 1
        //TODO: handle case this item not in menu list
        if (result != m_listItem.end()) {
            result->m_quantity = QString::number(result->m_quantity.toInt() - list[1].toInt());
//            auto quantity = result->m_quantity.toInt() - list[1].toInt();
            const QString queryStr = "UPDATE menu SET quantity = '" + result->m_quantity
                                   + "' WHERE name = '" + name + "'";
            m_query->exec(queryStr);
        }
    }
    emit onListItemChanged();
}
