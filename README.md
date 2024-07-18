[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

![](assets/readme/xinsight_logo_wide_smaller.png)

# X Insight

X Insight es un cliente multiplataforma no oficial y de código abierto para Indexa Capital.

Está desarrollado en [Flutter](https://flutter.dev/), y utiliza la [API oficial de Indexa Capital](https://indexacapital.com/en/api-rest-v1) para leer los datos de tu cuenta de forma segura.

Actualmente sólo está disponible para Android, dado que Apple ya no permite su publicación en el App Store.

<img src="assets/readme/screenshot_01_500.png" width=160/><img src="assets/readme/screenshot_02_500.png" width=160/><img src="assets/readme/screenshot_03_500.png" width=160/><img src="assets/readme/screenshot_04_500.png" width=160/><img src="assets/readme/screenshot_05_500.png" width=160/>

## Descargar
[![google_play_badge](assets/readme/google_play_badge_small.png)](https://play.google.com/store/apps/details?id=com.victormarino.indexax)

La versión de iOS ha sido retirada del App Store a petición de Apple. Espero poder volver a ofrecer la app de iOS a los usuarios europeos en el futuro a través de tiendas alternativas a la oficial.

## Privacidad y seguridad
X Insight no recoge ningún tipo de información sobre ti ni tu cuenta de Indexa. Al identificarte, los datos de tu cuenta se cargan en memoria para poder mostrarlos en pantalla, pero nunca se almacenan de forma persistente en tu dispositivo. Por tanto, desaparecen junto con el resto de la app cuando se cierra el proceso.

Si eliges recordar el token, éste se guardará en tu dispositivo de forma segura y encriptada mediante la librería [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage). Puedes eliminarlo en cualquier momento cerrando sesión en la app.

La API de Indexa sólo permite operaciones de lectura (métodos GET), por lo que X Insight no puede operar con tu cuenta ni modificarla de ninguna forma.

## Contribuir
Si quieres ayudar a mejorar X Insight, puedes:
- Proponer cambios o nuevas funcionalidades
- Trabajar en una propuesta existente y enviar un pull request
- Hacer una donación

Echa un ojo a la [página de issues](https://github.com/victor-marino/xinsight/issues)!

## Donar
X Insight es una app gratuita, sin anuncios ni monetización de ningún tipo, y siempre será así!

Si te gustaría apoyar su desarollo continuado (o simplemente darme las gracias), puedes invitarme a una cerveza en Ko-fi ;-)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/D1D1VS02X)
