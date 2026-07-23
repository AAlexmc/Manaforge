/// Guardar los ficheros del usuario sin poder perder lo que ya había.
///
/// Tres piezas que la colección y las carpetas ya usaban a mano y que aquí se
/// dicen una sola vez, porque los almacenes que NO las usaban (mazos, lista de
/// deseos, vistas hace poco, historial del valor) eran justo los que podían
/// perder datos:
///  - escribir por temporal + `rename`, que en el sistema de ficheros es
///    atómico: un corte a mitad deja el fichero anterior intacto;
///  - encolar los guardados, porque dos `writeAsString` a la vez sobre el
///    mismo fichero se entrelazan y dejan un JSON corrupto;
///  - apartar un fichero ilegible en vez de arrancar vacío y escribirle
///    encima, que es cómo un fichero a medias se convierte en pérdida total.
library;

import 'dart:io';

/// Contador de temporales. Que cada escritura use el SUYO: con un `.tmp` fijo,
/// dos guardados a la vez sobre el mismo fichero acababan con el segundo
/// renombrando algo que el primero ya se había llevado — el
/// `PathNotFoundException` que reventaba el Mercado al apuntar el valor del
/// día dos veces seguidas.
int _tmpSeq = 0;

/// Escribe [data] de forma que el contenido anterior nunca se pierde a
/// medias: primero un temporal, después un `rename` atómico.
Future<void> writeJsonFile(File file, String data) async {
  final tmp = File('${file.path}.${_tmpSeq++}.tmp');
  try {
    // primer arranque: la carpeta de datos puede no existir todavía
    await file.parent.create(recursive: true);
    await tmp.writeAsString(data, flush: true);
    await tmp.rename(file.path);
  } catch (_) {
    // que un fallo no deje el temporal tirado en la carpeta del usuario
    try {
      if (tmp.existsSync()) await tmp.delete();
    } catch (_) {/* ni eso: no hay más que hacer */}
    rethrow;
  }
}

/// Aparta un fichero que no se ha podido leer, con la extensión `.roto`. NO
/// se borra: son datos del usuario y se pueden rescatar a mano. Si tampoco se
/// puede renombrar, no hay más que hacer (y el almacén arrancará vacío).
Future<void> setAsideBroken(File file) async {
  try {
    await file.rename('${file.path}.roto');
  } catch (_) {/* sin permisos o fichero en uso: se deja como está */}
}

/// Cola de guardados de un almacén. Los `_save()` son fire-and-forget desde la
/// UI: sin cola, guardar 300 cartas lanza 300 escrituras a la vez sobre el
/// mismo fichero.
class SaveQueue {
  Future<void> _queue = Future.value();
  bool _pending = false;

  /// Encola una escritura. Si ya hay una esperando, no se encola otra: esa
  /// verá igualmente el estado FINAL, así que repetirla solo escribe el mismo
  /// JSON otra vez.
  void schedule(Future<void> Function() write) {
    if (_pending) return;
    _pending = true;
    _queue = _queue.then((_) {
      _pending = false;
      return write();
    }).catchError((Object _) {
      _pending = false; // la cola sigue viva aunque una escritura falle
    });
  }

  /// Espera a que la cola vacíe. Para los tests, que si no miran el fichero
  /// antes de que se haya escrito (y fallan solo en la máquina lenta).
  Future<void> get pending => _queue;
}
