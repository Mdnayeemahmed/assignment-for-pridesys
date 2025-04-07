import 'package:googleapis_auth/auth_io.dart';

class get_server_key {
  Future<String> server_token() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(
            {
              "type": "service_account",
              "project_id": "assignment-6b580",
              // "private_key_id": "4ab7a7625eea74de8bcfcb877e5938d356231cc6",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDVIkfgIVOs4qPg\natTKLjzxEQdeyKAy9B+9gk5WQPsapSkXt7MjNB3i97sCXjhQ/H/46QyMYSTML4jq\n/kNJDIx+oKEMbx04Vcty/YRAoGA4s4A6qIakGeOSMI9UhaLKMAE6XtKfxVrMSslH\nhRcUrh8nw0VytTwcKhGdEMTQGWaQOdr8rIUyxWdkPs38K2BOKUuY+3QFvzKoEDBc\n74W9sBRI16Joz87HZug0BnEWwGML6QeWg0PYfMMUNb4tY49t6glGlL4vIFfevg5t\nxKmX3/9oqoVzaF2rgwN5JvCXWhNOMok6MF4qsjQcpYpRjnf+N1LHMT7Or4T3v1cp\nzDBf01ojAgMBAAECggEAAKhXBNSb5HtCh2CGmlhJxqVtzcrcRUWTJeUibSOzYqHc\nN/8dTC0bln97K6B//fssp4DyKypPKcFPyjtq/u1NL0RuZ5Jql0NOGfzsQCLLVgFy\n+NT1ei+8qWia8jQDWSpZJp8nEs64eMuv37E3OmobHU1Ku1x4L5uo0do8ytBfpgkP\n0aiyePKasR9ichcjtNP2Ju5+mAjJj8QG8GjK5QqtVuxgYGUlmbWSPWRvHssYiSAi\n4Ve4wYpx3gXhsyijyG88woq8tpHvW69FUifPaLwfr82s4kLf9d0UNl2Fgc8sFNY3\nR04ji+cs9TbuZYL4sSTYYEsxJXlDa4XKnyL0Nb7fAQKBgQDyYrFVZhryibfZ+sQp\nDEAOYcofpU1xgJgENvWnwH8HTlo8DajfPplsNzYObTfDlqiK+tvwHoJ7nL6h+xfk\nIs/jeLjN+QU7rYBonREL0i/VykqWLVu+tICJjuOoRlXMGYEYYK2aPAOSwNkec3vb\n3fRC1P2FRLN0fvEUISQmW19MowKBgQDhGvk/cSiB3DPwXZeVfpi9++GpSzK1kNIv\nJAlvSnUwbY49HjltDsoA+KtGA6hdV4jmGT7gsBnrt5ffX7KMTp8XpnzpvsfktqX3\nEFiA+a6druG5KoBQCjRDavrFff0Sx280rzOyaFLjtpb6oFQwHEpA5NJwh7GAKETW\nPh2ZNfsUgQKBgQCSSeKBikiFTX07AFBX/d7DT13wT5I4CMa29Hy7LED+pdlsGUps\nwplSaNglSOG5GDrM9q67c46JEIc1uBgpRqF1xqyzE7KG3CZ9/R4Gpmrce2Uc0m9m\n4AYb/7ODIkAyGMqDbgYY6lO1xNLFwClm/8SmeWoxfs9YZi0WWxI4XDleRQKBgFns\nMI1LYucdVBI9EQTDIbkjGa5LP+KQC6aROsOedtn1qdB4dnA+bCufKqw5YdSH10Qz\n6Y5QSsqC+MResjCiZ6NG+rdVYvzWic38VZ6QH1UWO02A0OkoamBUKAEkpygNSzs8\nkeY/Dn2wvvc3fOoLIw5xWi9hxWJws67x+Vju23IBAoGAY4O1nu89ccqglGSMuuhn\nGGc0Us7UMSxfDppct5X9MQsslNFJW9Pbx3Lj7A5vT7eLQFNq97IDI4Z/ZiSoqCI7\nDAZvalVX0Qc1/ry8G6z633hCubq62YyYUpd/xIsq1PqdFyVfb4eP88lb/POdjchG\nTtwaVA7mZ505ucFt1HmIzJQ=\n-----END PRIVATE KEY-----\n",
              "client_email": "firebase-adminsdk-fbsvc@assignment-6b580.iam.gserviceaccount.com",
              "client_id": "109538639157792468218",
              "auth_uri": "https://accounts.google.com/o/oauth2/auth",
              "token_uri": "https://oauth2.googleapis.com/token",
              "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
              "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40assignment-6b580.iam.gserviceaccount.com",
              "universe_domain": "googleapis.com"
            }

        ),
        scopes);
    final accessserverkey = client.credentials.accessToken.data;
    return accessserverkey;
  }
}