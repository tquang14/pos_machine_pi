#ifndef SERVERSOCKET_H
#define SERVERSOCKET_H

#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>
//Singleton
class serverSocket : public QObject
{
    Q_OBJECT
private:
    explicit serverSocket(QObject *parent = nullptr);

signals:

public:
    // destructor
    ~serverSocket();
    //!
    //! \brief getServerInstance
    //! \return instance of this singleton class
    //!
    static serverSocket& getServerInstance();

public slots:
    //!
    //! \brief newConnection
    //!
    void newConnection();

    //!
    //! \brief transferDataToClient
    //! \return
    //!
    void transferDataToClient(const QString mess);

private:
    QTcpServer *m_server;

    QTcpSocket *m_socket;
};

#endif // SERVERSOCKET_H
