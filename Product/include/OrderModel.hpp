#ifndef ORDERMODEL_H
#define ORDERMODEL_H

#include <QObject>
#include <QString>
#include <QVector>
#include <QVariant>
struct Item {
Q_GADGET
    Q_PROPERTY(QString image MEMBER m_image)
    Q_PROPERTY(QString name MEMBER m_name)
    Q_PROPERTY(QString price MEMBER m_price)
public:
    QString m_image;
    QString m_name;
    QString m_price;
};

class OrderModel : public QObject {

Q_OBJECT
    Q_PROPERTY(QVariantList listItem READ getListItem)

public:
    explicit OrderModel(QObject *parent = nullptr);
    QVariantList getListItem() const;
private:
    QVector<Item> m_listItem;
};

#endif
