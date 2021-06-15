#include "../include/serversocket.h"

serverSocket::serverSocket(QObject *parent) : QObject(parent), m_socket(nullptr)
{
    m_server = new QTcpServer(this);
    connect(m_server, SIGNAL(newConnection()), this, SLOT(newConnection()));
    if(!m_server->listen(QHostAddress::Any, 1234))
    {
        qDebug() << "Server could not start!";
    }
    else
    {
        qDebug() << "Server started!";
    }
}

serverSocket::~serverSocket()
{
    delete m_server;
    m_server = nullptr;
    m_socket->close();
    m_socket = nullptr;
}

void serverSocket::newConnection()
{
    m_socket = m_server->nextPendingConnection();
}

void serverSocket::transferDataToClient(const QString mess)
{
    if (m_socket) {
        m_socket->write(mess.toLatin1());
        m_socket->flush();
        m_socket->waitForBytesWritten(1000);
    }
}

serverSocket& serverSocket::getServerInstance()
{
    static serverSocket instance;
    return instance;
}
