// Copyright (c) 2011-2013 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include "macdockiconhandler.h"
#include <objc/runtime.h>
#include <QImageWriter>
#include <QMenu>
#include <QBuffer>
#include <QWidget>

#undef slots
#include <Cocoa/Cocoa.h>

#if QT_VERSION < 0x050000
extern void qt_mac_set_dock_menu(QMenu *);
#endif

static MacDockIconHandler *s_instance = nullptr;

static bool dockClickHandler(id self, SEL _cmd, ...)
{
    Q_UNUSED(self);
    Q_UNUSED(_cmd);

    if (s_instance) {
        s_instance->handleDockIconClickEvent();
    }
    // Return NO (false) to suppress default OS X actions
    return false;
}

MacDockIconHandler* MacDockIconHandler::instance()
{
    if (!s_instance) {
        Class cls = NSClassFromString(@"NSApplication");
        id appInst = [cls performSelector:NSSelectorFromString(@"sharedApplication")];
        if (appInst) {
            id delegate = [appInst performSelector:NSSelectorFromString(@"delegate")];
            if (delegate) {
                Class delClass = object_getClass(delegate);
                SEL shouldHandle = NSSelectorFromString(@"applicationShouldHandleReopen:hasVisibleWindows:");
                if (class_getInstanceMethod(delClass, shouldHandle)) {
                    class_replaceMethod(delClass, shouldHandle, (IMP)dockClickHandler, "B@:");
                } else {
                    class_addMethod(delClass, shouldHandle, (IMP)dockClickHandler, "B@:");
                }
                s_instance = new MacDockIconHandler();
            }
        }
    }
    return s_instance;
}

void MacDockIconHandler::cleanup()
{
    delete s_instance;
    s_instance = nullptr;
}

MacDockIconHandler::MacDockIconHandler() : QObject()
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    this->m_dummyWidget = new QWidget();
    this->m_dockMenu = new QMenu(this->m_dummyWidget);
    this->setMainWindow(nullptr);
#if QT_VERSION < 0x050000
    qt_mac_set_dock_menu(this->m_dockMenu);
#elif QT_VERSION >= 0x050200
    this->m_dockMenu->setAsDockMenu();
#endif
    [pool release];
}

MacDockIconHandler::~MacDockIconHandler()
{
    delete this->m_dockMenu;
    delete this->m_dummyWidget;
    this->setMainWindow(nullptr);
}

QMenu *MacDockIconHandler::dockMenu()
{
    return this->m_dockMenu;
}

void MacDockIconHandler::setMainWindow(QMainWindow *window)
{
    this->mainWindow = window;
}

void MacDockIconHandler::setIcon(const QIcon &icon)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSImage *image = nil;
    if (icon.isNull()) {
        image = [[NSImage imageNamed:@"NSApplicationIcon"] retain];
    } else {
        QSize size = icon.actualSize(QSize(128, 128));
        QPixmap pixmap = icon.pixmap(size);

        QBuffer notificationBuffer;
        if (!pixmap.isNull() && notificationBuffer.open(QIODevice::ReadWrite)) {
            QImageWriter writer(&notificationBuffer, "PNG"); // Fixed typo: ¬ificationBuffer -> &notificationBuffer
            if (writer.write(pixmap.toImage())) {
                NSData* macImgData = [NSData dataWithBytes:notificationBuffer.buffer().data()
                                                  length:notificationBuffer.buffer().size()];
                image = [[NSImage alloc] initWithData:macImgData];
            }
        }

        if (!image) {
            image = [[NSImage imageNamed:@"NSApplicationIcon"] retain];
        }
    }

    [NSApp setApplicationIconImage:image];
    [image release];
    [pool release];
}

void MacDockIconHandler::handleDockIconClickEvent()
{
    if (this->mainWindow) {
        this->mainWindow->activateWindow();
        this->mainWindow->show();
    }
    Q_EMIT this->dockIconClicked();
}