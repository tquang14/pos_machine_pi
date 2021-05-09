#include "../include/OrderModel.hpp"

OrderModel::OrderModel(QObject *parent)
            : QObject (parent)
{
    m_listItem << Item{"a", "b", "c"}
               << Item{"a1", "b1", "c1"};
}

QVariantList OrderModel::getListItem() const {
    QVariantList list;
    for (const Item &p : m_listItem) {
        list << QVariant::fromValue(p);
    }
    return list;
}
