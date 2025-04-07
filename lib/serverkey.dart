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
            "private_key_id": "42c7a6496a9f5384e4f202fb40f083e446aa6424",
            "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCRo5/xKr24Rrwu\n81c64/mYwwX5y1Kb5joNS39sb0y0dQe1RV4d2rEYiYwl7qAkdRxVZdkyv9IaCcsG\ntK9RSi0szgDsJ1+JdVI16n3VrVm8WuKdTfi6IHxCZ9cpWzg0HvNLy2E8xRFvhd53\nDmSVkggzi82bgEBeP1fAd2i12txW7h7HhX93M+b4vnfJISZJFWO+WnfCaU9W1rV0\njyZS2ebz53LGKgWxl9adXpJGBG6OO0TP7k5GolT3mScDsKvApWY7+i2eUikZdwWJ\n/XtOOun3dVU4XO2gwrv45V8m0Ww/BvigwW0Mw3mSa6ecKQ1enuAtuxLtWo5IS894\nLonWPmlnAgMBAAECggEACK3RDrym0K/6b+vVc295hNZ+aSvqMNsv83Hf1pTtY8Wj\nn3RSTwIk0psDzJDjXzjRZu9qWaFfwmh5/lzPI8+BUK24FVqlUVo5+3eNZyns8pIR\n9iDa5TChZw2sH01N1KFRi19D3Ky7xMMcBklHyjgJIBVBO/aRH2yz7IbRKSExR0bT\nat9fjKS5/We3c6KS3okVUy99bGi3WQzTHmvbYXzkJssrtJEb7MZMwdQ1GLwaW+rQ\nKr1X5qHI6SX0cn5JrF0o+qTBFxICapmKaZ9urMbjGmADM/nTP+jQz44ncN0XZVl5\n4FyNFw4BsL4hLyH/j9rXA2TI/wahN7Z3B5hocnVTYQKBgQDJguap4TGn/jRrAyyr\n3Tu76agHmEpkJx+rmumnuu6nKymsbffPUnre4Y2ZQX/2yObWud3nDrAlJM1tqFfz\nfIeYHMGH9Mc/PuYWeupQoyK9V9WItjwdqn2aVBIiWvqU4YPByZTkzVz8fpPjarhA\nc1iBwSgNBO3Va1JqJ+gayuxUYQKBgQC5BR4aHa0fV8TCDr66Y7mtUb460IobSBZ3\nVT1qlBlrQ3W8qRhjBIsFjlPxlOhsXTHQmi0z3OMK01yc6YGLrt+LV0ABikT5WU6h\ncEsojpwIfTQhVDWkW1d4eK4z6cr1wDyzsD4q/3OMqWda+G8mI+pQgzOoN/WrgGha\nhuGVoNoSxwKBgQCwW0ucKWXX7HXboe+aiggZMSjJXNLeTA8/lFghX0w2KWRTb/qN\nC1ZVcXkHQ3fGd5TvH8PAz+4A0/Clo8s1YSsaSTBm2Cb4hwe/bNtcrylcJF7RQwvh\nurAqPKGSR6U+Xw98rfsNM13J7M1pHqEaZthy1qVCn6m2OjLqjPppWGb0gQKBgF6j\nIXyWRWFM0ZW5WRGZxPXEZBtNY/cEbolnjlyfmEjnXqe7jn/HaRzUaledpS0Ylkxv\nMEPg7jkxV6PjRKIgNrPdUx32jcVFSxUEjU0XdPRapnmNy0pgdmNmxyRCp9AAHoyC\nz6nKtF30oKtFfAT0RfwcwCWBSiYJLldvup+AgUstAoGAPzesF1ehdf28lOjpOvb5\nI81hMe/R2Oyrav2ac0auI8zGoD/DN6ac+SQkH3iRZ6SFYXW0NzSiWHDuRqAem553\n2m4Gsr3N+HC/vBr7ifZlQM0a9kKEuBbb1OV3XgO9e1IY7fu1h4nv7pshS6DexuRP\nX0Uu5gEDLZVzaYgg6bCcSZI=\n-----END PRIVATE KEY-----\n",
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