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

class AdminModel : public QObject {

Q_OBJECT
    Q_PROPERTY(QVariantList listReceipt READ getListReceipt)

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
    //! \brief getAllReceiptFromDB
    //!
    void getAllReceiptFromDB();

    //!
    //! \brief m_listReceipt
    //!
    QVector<receipt> m_listReceipt;

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
