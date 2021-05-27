#ifndef ADMINMODEL_H
#define ADMINMODEL_H

#include <QObject>
#include <QString>
#include <QVector>
#include <QVariant>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>

struct receipt {
Q_GADGET
    Q_PROPERTY(QString ID MEMBER m_ID)
    Q_PROPERTY(QString content MEMBER m_content)
    Q_PROPERTY(QString dateTime MEMBER m_dateTime)
    Q_PROPERTY(QString price MEMBER m_price)
public:
    QString m_ID;
    QString m_content;
    QString m_dateTime;
    QString m_price;
};

struct inventory {
    Q_GADGET
        Q_PROPERTY(QString name MEMBER m_name)
        Q_PROPERTY(QString quantity MEMBER m_quantity)
        Q_PROPERTY(QString expDate MEMBER m_expDate)
        Q_PROPERTY(bool isExpired MEMBER m_isExpired)
    public:
        QString m_name;
        QString m_quantity;
        QString m_expDate;
        bool m_isExpired;
};

class AdminModel : public QObject {

Q_OBJECT
    Q_PROPERTY(QVariantList listReceipt READ getListReceipt)
    Q_PROPERTY(QVariantList inventory READ getInventory)

public:
    //!
    //! \brief constructor
    //! \param parent
    //!
    explicit AdminModel(QObject *parent = nullptr);

    //!
    //! \brief destructor
    //!
    ~AdminModel();
private:
    //!
    //! \brief initDB
    //!
    void initDB();

    //!
    //! \brief getListReceipt
    //! \return list of all receipt
    //!
    QVariantList getListReceipt() const;

    //!
    //! \brief getInventory
    //! \return list contain all item in inventory
    //!
    QVariantList getInventory() const;

    //!
    //! \brief getAllReceiptFromDB
    //!
    void getAllReceiptFromDB();

    //!
    //! \brief getInventoryFromDB
    //!
    void getInventoryFromDB();

    //!
    //! \brief m_listReceipt
    //!
    QVector<receipt> m_listReceipt;

    //!
    //! \brief m_inventory
    //!
    QVector<inventory> m_inventory;

    //!
    //! \brief m_db
    //!
    QSqlDatabase *m_db;

    //!
    //! \brief m_dbStatus
    //!
    bool m_dbStatus;

    //!
    //! \brief m_query
    //!
    QSqlQuery *m_query;
};

#endif
