/// Ediciones que SOLO existen en digital (Magic Online, Arena, Alchemy).
///
/// El escáner mira una carta FÍSICA sobre la mesa, así que ninguna de estas
/// puede ser la respuesta correcta — y sin embargo compiten: una reimpresión
/// digital suele llevar EL MISMO arte que la de papel, así que su huella es
/// idéntica y a veces gana el desempate. Eso es lo que hacía que un
/// "Implement of Examination" de Aether Revolt entrara en la colección como
/// Kaladesh Remastered, un set de Arena que no existe en cartón.
///
/// Lista sacada del campo `digital` de la API de Scryfall (22-07-2026, 61
/// sets). Vive aquí y no en la base descargable porque la base ya está
/// generada y en el ordenador de la gente; lo correcto a futuro es marcar la
/// bandera al construirla y quitar esta lista.
library;

const Set<String> kDigitalOnlySets = {
  'aa1', 'aa2', 'aa3', 'aa4', 'ajmp', 'akr', 'ana', 'anb',
  'ea1', 'ea2', 'ea3', 'ha1', 'ha2', 'ha3', 'ha4', 'ha5',
  'ha6', 'ha7', 'hbg', 'j21', 'klr', 'me1', 'me2', 'me3',
  'me4', 'oana', 'om1', 'omb', 'pa1', 'pana', 'past', 'pio',
  'pmoa', 'prm', 'psdg', 'pz1', 'pz2', 'sir', 'sis', 'td0',
  'td2', 'tpr', 'vma', 'xana', 'yblb', 'ybro', 'ydft', 'ydmu',
  'ydsk', 'yecl', 'yeoe', 'ylci', 'ymid', 'ymkm', 'yneo', 'yone',
  'yotj', 'ysnc', 'ysos', 'ytdm', 'ywoe',
};

/// ¿Esa edición existe solo en digital? El código llega en cualquier caja.
bool isDigitalOnlySet(String setCode) =>
    kDigitalOnlySets.contains(setCode.toLowerCase());
