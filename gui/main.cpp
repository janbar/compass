#include <QtGlobal>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QtQuickControls2>
#include <QTranslator>
#include <QDebug>
#include <QDir>
#include <QProcess>
#include <QPixmap>
#include <QIcon>

#define ORG_NAME          "io.github.janbar"
#define APP_NAME          "compass"
#define APP_DISPLAY_NAME  "Compass"
#define APP_TR_NAME       "compass"
#ifdef Q_OS_ANDROID
#define APP_ID            ORG_NAME "." APP_NAME
#else
#define APP_ID            APP_NAME
#endif

#include "signalhandler.h"
#include "platformextras.h"
#include "plugin.h"

#ifndef APP_VERSION
#define APP_VERSION "Undefined"
#endif

#define COMPASS_MODULE "Compass"

void setupApp(QGuiApplication& app);
void prepareTranslator(QGuiApplication& app, const QString& translationPath, const QString& translationPrefix, const QLocale& locale);
void doExit(int code);

int main(int argc, char *argv[])
{
    int ret = 0;

    QGuiApplication::setApplicationName(APP_NAME);
    QGuiApplication::setApplicationDisplayName(APP_DISPLAY_NAME);
    QGuiApplication::setOrganizationName(ORG_NAME);
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    setupApp(app);

    // register the generic compass
    qmlRegisterType<BuiltInCompass>(COMPASS_MODULE, 1, 0, "Sensor");
    QScopedPointer<BuiltInSensorPlugin> sensor(new BuiltInSensorPlugin());
    sensor->registerSensors();

    QSettings settings;
    QString style = QQuickStyle::name();
    if (!style.isEmpty())
        settings.setValue("style", style);
    else
    {
        if (settings.value("style").isNull())
        {
#if defined(Q_OS_ANDROID)
            QQuickStyle::setStyle("Material");
#else
            QQuickStyle::setStyle("Material");
#endif
            settings.setValue("style", QQuickStyle::name());
        }
        QQuickStyle::setStyle(settings.value("style").toString());
    }

    QScopedPointer<QQmlApplicationEngine> engine(new QQmlApplicationEngine);
    // bind version string
    engine->rootContext()->setContextProperty("VersionString", QString(APP_VERSION));
    // bind arguments
    engine->rootContext()->setContextProperty("ApplicationArguments", app.arguments());
    // bind SCALE_FACTOR
    engine->rootContext()->setContextProperty("ScreenScaleFactor", QVariant(app.primaryScreen()->devicePixelRatio()));
    // bind Android flag
#if defined(Q_OS_ANDROID)
    engine->rootContext()->setContextProperty("Android", QVariant(true));
#else
    engine->rootContext()->setContextProperty("Android", QVariant(false));
#endif
    // select and bind styles available and known to work
    QStringList availableStyles;
#if defined(Q_OS_ANDROID)
    availableStyles.append("Material");
#else
    availableStyles.append("Material");
#endif
    engine->rootContext()->setContextProperty("AvailableStyles", availableStyles);

    // handle signal exit(int) issued by the qml instance
    QObject::connect(engine.data(), &QQmlApplicationEngine::exit, doExit);

    engine->load(QUrl("qrc:/main.qml"));
    if (engine->rootObjects().isEmpty()) {
        qWarning() << "Failed to load QML";
        return -1;
    }

    ret = app.exec();
    return ret;
}

void setupApp(QGuiApplication& app) {

    SignalHandler *sh = new SignalHandler(&app);
    sh->catchSignal(SIGHUP);
    sh->catchSignal(SIGALRM);

    // set translators
    QLocale locale = QLocale::system();
    prepareTranslator(app, QString(":/i18n"), QString(APP_TR_NAME), locale);
#ifdef Q_OS_MAC
    QDir appDir(app.applicationDirPath());
    if (appDir.cdUp() && appDir.cd("Resources/translations"))
      prepareTranslator(app, appDir.absolutePath(), "qt", locale);
#elif defined(Q_OS_ANDROID)
    prepareTranslator(app, "assets:/translations", "qt", locale);
#endif
    app.setWindowIcon(QIcon(QPixmap(":/images/osmin.png")));
}

void prepareTranslator(QGuiApplication& app, const QString& translationPath, const QString& translationPrefix, const QLocale& locale)
{
    QTranslator * translator = new QTranslator();
    if (!translator->load(locale, translationPrefix, QString("_"), translationPath))
    {
        qWarning() << "no file found for translations '"+ translationPath + "/" + translationPrefix + "_" + locale.name().left(2) + ".qm' (using default).";
    }
    else
    {
        qInfo() << "using file '"+ translationPath + "/" + translationPrefix + "_" + locale.name().left(2) + ".qm ' for translations.";
        app.installTranslator(translator);
    }
}

void doExit(int code)
{
#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
  if (code == 16)
  {
    // loop a short time to flush setting changes
    QTime syncTime = QTime::currentTime().addSecs(1);
    while (QTime::currentTime() < syncTime)
      QCoreApplication::processEvents(QEventLoop::ExcludeUserInputEvents, 100);

    QStringList args = QCoreApplication::arguments();
    args.removeFirst();
    QProcess::startDetached(QCoreApplication::applicationFilePath(), args);
  }
#else
  (void)code;
#endif
  QCoreApplication::quit();
}
