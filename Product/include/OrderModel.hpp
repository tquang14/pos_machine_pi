#ifndef ORDERMODEL_H
#define ORDERMODEL_H

#include <QObject>
#include <QString>
#include <QVector>
#include <QVariant>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>

struct Item {
Q_GADGET
    Q_PROPERTY(QString image MEMBER m_image)
    Q_PROPERTY(QString name MEMBER m_name)
    Q_PROPERTY(QString price MEMBER m_price)
    Q_PROPERTY(QString quantity MEMBER m_quantity)
public:
    QString m_image;
    QString m_name;
    QString m_price;
    QString m_quantity;
};

class OrderModel : public QObject {

Q_OBJECT
    Q_PROPERTY(QVariantList listItem READ getListItem NOTIFY onListItemChanged)

public:
    //!
    //! \brief constructor
    //! \param parent
    //!
    explicit OrderModel(QObject *parent = nullptr);

    //!
    //! \brief destructor
    //!
    ~OrderModel();

public slots:
    //!
    //! \brief order
    //! \param orderList
    //!

    bool order(QVariantList nameItem, int totalMoney);

signals:
    //!
    //! \brief onListItemChanged
    //!
    void onListItemChanged();

private:
    //!
    //! \brief decreaseQuantityOfItemInDB
    //! \param orderList
    //!
    void decreaseQuantityOfItemInDB(QVariantList orderList);

    //!
    //! \brief initDB
    //!
    void initDB();

    //!
    //! \brief getListItem
    //! \return list of all item
    //!
    QVariantList getListItem() const;

    //!
    //! \brief getMenuListFromDB
    //!
    void getMenuListFromDB();

    //!
    //! \brief m_listItem
    //!
    QVector<Item> m_listItem;

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
