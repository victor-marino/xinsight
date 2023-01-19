[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

![](assets/images/indexax_logo_wide_smaller.png)

# Indexa X

Indexa X es un cliente multiplataforma no oficial para Indexa Capital.

Está desarrollado en [Flutter](https://flutter.dev/), y utiliza la [API oficial de Indexa Capital](https://indexacapital.com/en/api-rest-v1) para leer los datos de tu cuenta de forma segura.

Actualmente está disponible para Android y iOS.

## Descargar
[![google_play_badge](assets/images/google_play_badge_small.png)](https://play.google.com/store/apps/details?id=com.victormarino.indexax)  [![app_store_badge](assets/images/app_store_badge_small.png)](https://apps.apple.com/es/app/indexa-x/id1637446036)


## Privacidad y seguridad
Indexa X no recoge ningún tipo de información sobre ti ni tu cuenta de Indexa. Al identificarte, los datos de tu cuenta se cargan en memoria para poder mostrarlos en pantalla, pero nunca se almacenan de forma persistente en tu dispositivo. Por tanto, desaparecen junto con el resto de la app cuando se cierra el proceso.

Si eliges recordar el token, éste se guardará en tu dispositivo de forma segura y encriptada mediante la librería [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage). Puedes eliminarlo en cualquier momento cerrando sesión en la app.

La API de Indexa sólo permite operaciones de lectura (métodos GET), por lo que Indexa X no puede operar con tu cuenta ni modificarla de ninguna forma.

## Contribuir
Si quieres ayudar a mejorar Indexa X, puedes:
- Proponer cambios o nuevas funcionalidades
- Trabajar en una propuesta existente y enviar un pull request

Echa un ojo a la [página de issues](https://github.com/victor-marino/indexax/issues)!