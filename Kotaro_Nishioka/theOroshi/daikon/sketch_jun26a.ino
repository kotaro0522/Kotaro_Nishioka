// 加速度センサ(KXM52)取得

// アナログ入力ポート
#define X 0 
#define Y 1
#define Z 2
// センサから取得したデータ（3軸分）
int valX = 0;
int valY = 0;
int valZ = 0;
// Porcessingに送信するデータ(3軸分）
int outX = 0;
int outY = 0;
int outZ = 0;
//送信開始用フラグ
int first = 1;

//初期化
void setup(){
  Serial.begin(9600); //シリアル接続開始
}  

//実行用無限ループ
void loop(){
  //加速度センサのアナログ入力ポートからデータを取得
  valX = analogRead(X);  
  valY = analogRead(Y);
  valZ = analogRead(Z);
  
  //0~1023の値を0~255に変換
  //（ただしセンサからの電圧の最大値が3.3Vなので3.3/5を掛ける）
  outX = map(valX, 0, 1023*3.3/5, 0, 255);
  outY = map(valY, 0, 1023*3.3/5, 0, 255);
  outZ = map(valZ, 0, 1023*3.3/5, 0, 255);
  
  if(Serial.available() > 0 || first == 1){//受信確認を受信したとき，または一番最初だけ
    //データの出力
    Serial.write(outX);
    Serial.write(outY);
    Serial.write(outZ);
    //受信確認データの読み込み
    Serial.read();
    //初回でないことを表す
    first = 0;
  }
  delay(10);
}
