import 'package:firebase_auth/firebase_auth.dart';//firebase kimlik doğrulama paketini projeye dahil eder

class AuthService{
  final FirebaseAuth _auth=FirebaseAuth.instance;//firebasein authentication servislerine erişim sağlar

  Future<void>signInAnonymouslyIfNeeded() async{//Eğer kullanıcı zaten giriş yapmışsa tekrar giriş yapma, ama hiç giriş yapmadıysa anonim giriş oluştur.
    if(_auth.currentUser==null){//şu anda kullanıcı oturumu var mı diye kontrol ediyor,varsa giriş yapmaz,yoksa anonim kullanıcı oluşturur
      await _auth.signInAnonymously();//Firebase’e anonim giriş isteği gönderir.Firebase bu kullanıcıya özel bir uid (benzersiz kimlik) oluşturur.
    }
  }
  String get uid =>_auth.currentUser!.uid;//Bana şu anda oturum açmış kullanıcının UID’sini ver”

  User? get currentUser =>_auth.currentUser;
}