import 'package:kijiweni_flutter/models/chat.dart';

/*Chat(this.message, this.chatImageUrl, this.chatThumbUrl, this.chatId,
      this.username, this.userId, this.userImageUrl, this.replyingTo);*/

Chat messageOne = new Chat(
    'Mambo',
    null,
    null,
    '00a',
    'Jack',
    '001',
    'https://pbs.twimg.com/profile_images/653700295395016708/WjGTnKGQ_400x400.png',
    null);
Chat messageTwo = new Chat(
    'Poa, niambie wanangu',
    null,
    null,
    '00b',
    'Mika',
    '002',
    'https://www.tarantino.info/wp-content/uploads/2018/06/hollywoodstill4-720x340.png',
    '00a');

Chat messageThree = new Chat(
    'aiseee have you seen this thing',
    'https://wiki.tarantino.info/images/thumb/Hatefulcanadabluray.jpg/400px-Hatefulcanadabluray.jpg',
    null,
    '00c',
    'Jack',
    '001',
    'https://pbs.twimg.com/profile_images/653700295395016708/WjGTnKGQ_400x400.png',
    null);

Chat messageFour = new Chat(
    'wait, i keep confusing that one and the Denzel one...',
    'http://www.gstatic.com/tv/thumb/v22vodart/12541171/p12541171_v_v8_aa.jpg',
    null,
    '00d',
    'Mika',
    '002',
    'https://www.tarantino.info/wp-content/uploads/2018/06/hollywoodstill4-720x340.png',
    '00a');

List<Chat> messagesList = [messageOne, messageTwo, messageThree, messageFour];
