
// Este código es para usar con el módulo RTC DS1302 + Teclado 4x4 + LCD i2c + MIC. ATMEGA + Zumbador
// Después de cablear los módulos, la pantalla LCD mostrará la fecha y hora predeterminadas o la configurada antes
// El objetivo de este proyecto es que puede configurar el módulo RTC desde el teclado, y asegurarse de que permanezca almacenado
// Luego muéstralo en la pantalla y luego podrás configurar tu alarma.

// Bibliotecas necesarias
#include <EEPROM.h>
#include <Keypad.h>
#include <Wire.h>
#include <virtuabotixRTC.h>
#include <LiquidCrystal_I2C.h>

#define I2C_ADDR 0x27 // LCD I2C 16x2
#define BACKLIGHT_PIN 3
#define En_pin 2
#define Rw_pin 1
#define Rs_pin 0
#define D4_pin 4
#define D5_pin 5
#define D6_pin 6
#define D7_pin 7
#define A0_pin A0

LiquidCrystal_I2C lcd(I2C_ADDR, En_pin, Rw_pin, Rs_pin, D4_pin, D5_pin, D6_pin, D7_pin);

virtuabotixRTC myRTC(2, 3, 4); // Cableado del RTC (CLK, DAT, RST) -- Si cambia el cableado, cambie los pines aquí también

const byte numRows = 4; // Total de filas en el teclado
const byte numCols = 4; // Total de columnas en el teclado

// mapa de teclas define la tecla presionada de acuerdo con la fila y las columnas tal como aparece en el teclado
char keymap[numRows][numCols] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'}
};

byte rowPins[numRows] = {12, 11, 10, 9}; // Filas 0 a 3 // si modifica sus pines, debería modificar esto también
byte colPins[numCols] = {8, 7, 6, 5}; // Columnas 0 a 3

int i1, i2, i3, i4;
char c1, c2, c3, c4, c5, c6;
char keypressed, keypressedx;

int A_hour = NULL;
int A_minute = NULL;
int T_hour = NULL;
int T_minute = NULL;
int AlarmIsActive = NULL;
int activator = 13;      // Definir pin para activar
int wateringTime = NULL;
int moisture = NULL;
int moistureLimit = NULL;
int soilSensorValue = NULL;

int cT = 0;
int lastRevision = 0;
int intervRev = NULL; // Cada 2 Minuto(s)
int initActivator = 0;

Keypad myKeypad = Keypad(makeKeymap(keymap), rowPins, colPins, numRows, numCols); // Definir el teclado

void setup() {
  A_hour = EEPROM.read(0);         // Lee el valor de la memoria eeprom en la dirección 0 y es asignado a la variable A_hour
  A_minute = EEPROM.read(1);       // Lee el valor de la memoria eeprom en la dirección 1 y es asignado a la variable A_minute
  AlarmIsActive = EEPROM.read(2);  // Lee el valor de la memoria eeprom en la dirección 2 y es asignado a la variable AlarmIsActive
  wateringTime = EEPROM.read(3);   // Lee el valor de la memoria eeprom en la dirección 3 y es asignado a la variable wateringTime
  moistureLimit = EEPROM.read(4);   // Lee el valor de la memoria eeprom en la dirección 4 y es asignado a la variable moistureLimit
  intervRev = wateringTime * 2;
  
  Serial.begin(9600);
  pinMode(activator, OUTPUT);
  digitalWrite(activator, LOW);     // Activador por defecto apagado
  lcd.begin (16, 2); // Inicializar la pantalla LCD
  lcd.setBacklightPin(BACKLIGHT_PIN, POSITIVE);
  lcd.setBacklight(HIGH);
  lcd.home();
  
  pinMode(A0_pin, INPUT);
}

void loop() {  
  // Mientras no se presione ninguna tecla, seguimos mostrando la fecha y la hora, estoy obligado a borrar la pantalla cada vez para que los números no se confundan
  while (keypressed == NO_KEY) {
    keypressed = myKeypad.getKey(); // Y debo agregar ese pequeño retraso para que la pantalla se muestre correctamente, de lo contrario no me funcionó
    lcd.clear();

    // Aquí, después de limpiar la pantalla LCD, tomamos el tiempo del módulo e imprimimos en la pantalla con las funciones habituales de la pantalla LCD
    myRTC.updateTime();
    cT = (myRTC.hours * 360) + (myRTC.minutes * 6); // Conteo rapido de minutos
    moisture = analogRead(A0_pin);
    soilSensorValue = map(moisture,0,1023,100,0); // Map Humedad

    if(moistureLimit != NULL && moistureLimit > 5){
      // Reset para un nuevo dia.
      if(myRTC.hours == 0 && myRTC.minutes == 0 && myRTC.seconds >= 0 && myRTC.seconds <= 2){
        lastRevision = cT;
        lcd.clear();
        lcd.setCursor(0, 0);
        lcd.print("Reiniciando");
        lcd.setCursor(0, 1);
        lcd.print("Revision Humedad");
        delay(100);
      }
  
      if(cT >= (lastRevision + (intervRev*6))){
        lastRevision = cT;
        lcd.clear();
        lcd.setCursor(0, 0);
        lcd.print("Humedad: " + String(zfill(soilSensorValue)) + "%");
        lcd.setCursor(0, 1);
        lcd.print("Med: " + String(zfill(1023 - moisture)) + "/1023");
        delay(2000);
  
        if(moistureLimit >= soilSensorValue && initActivator > 0){
          digitalWrite(activator, HIGH);     // Encender activador
          lcd.clear();
          lcd.setCursor(0, 0);
          lcd.print("Regando !!!"); // Mensaje para mostrar cuando se activa
          lcd.setCursor(0, 1);
          lcd.print("Espere por favor");
          delay(wateringTime * 60000);
          digitalWrite(activator, LOW);     // Apagar activador
        }
        initActivator = 1;
      }
    }
    
    
    if (myRTC.hours == A_hour && myRTC.minutes == A_minute && AlarmIsActive == 1 && myRTC.seconds >= 0 && myRTC.seconds <= 2) {
      digitalWrite(activator, HIGH);     // Encender activador
      lcd.clear();
      lcd.print("Regando !!!"); // Mensaje para mostrar cuando se activa
      delay(wateringTime * 60000);
      digitalWrite(activator, LOW);     // Apagar activador
    }
    
    keypressedx = NO_KEY;
    lcd.setCursor(0, 0);
    lcd.print(String(zfill(myRTC.dayofmonth)) + "/" + String(zfill(myRTC.month)) + "/" + String(zfill(myRTC.year)) + " - ");
    if(AlarmIsActive == 1){
      lcd.print(String(wateringTime));
    } else {
      lcd.print("0");
    }
    lcd.print("m");

    lcd.setCursor(0, 1);
    lcd.print(String(zfill(myRTC.hours)) + ":" + String(zfill(myRTC.minutes)) + ":" + String(zfill(myRTC.seconds)));
    
    if(AlarmIsActive == 1){
      lcd.print(" - " + String(zfill(A_hour)) + ":" + String(zfill(A_minute)));
    }
    delay(100);
  }

  // Como siempre verificamos la tecla presionada, solo procedemos a la configuración si presionamos "*"
  if (keypressed == '*') {
    lcd.clear();
    lcd.print(" Configuracion  ");
    delay(1000);
    lcd.clear();
    lcd.print("  Conf. Año  ");
    /*
        Para que pueda entender cómo funciona esto, primero nos muestra "configuración", luego imprime "Conf. Año" y ahora puede escribir su año normalmente (2-0-2-0)
        Pasa automáticamente a configurar el mes ... hasta que termine
        Todas las teclas del teclado se consideran caracteres (c), por lo que debemos convertirlas a int, eso es lo que hice y luego las almacenamos (i)
        Hacemos algunos cálculos y obtenemos el año, el mes ... como int para poder inyectarlos en el RTC; de lo contrario, no se compilará
        Meses como abril deberías escribir 04, 03 para marzo ... de lo contrario no pasará al siguiente parámetro
        La biblioteca RTC virtuabotix ya está configurada para no aceptar horas y fechas extrañas (45/17/1990) (58:90:70), y sí, las fechas antiguas se consideran errores
    */

    char keypressed2 = myKeypad.waitForKey();
    if (keypressed2 != NO_KEY && keypressed2 != '*' && keypressed2 != '#' && keypressed2 != 'A' && keypressed2 != 'B' && keypressed2 != 'C' && keypressed2 != 'D' ) {
      c1 = keypressed2;
      lcd.setCursor(0, 1);
      lcd.print(c1);
    }

    char      keypressed3 = myKeypad.waitForKey();
    if (keypressed3 != NO_KEY && keypressed3 != '*' && keypressed3 != '#' && keypressed3 != 'A' && keypressed3 != 'B' && keypressed3 != 'C' && keypressed3 != 'D' ) {
      c2 = keypressed3;
      lcd.setCursor(1, 1);
      lcd.print(c2);
    }

    char  keypressed4 = myKeypad.waitForKey();
    if (keypressed4 != NO_KEY && keypressed4 != '*' && keypressed4 != '#' && keypressed4 != 'A' && keypressed4 != 'B' && keypressed4 != 'C' && keypressed4 != 'D' ) {
      c3 = keypressed4;
      lcd.setCursor(2, 1);
      lcd.print(c3);
    }

    char   keypressed5 = myKeypad.waitForKey();
    if (keypressed5 != NO_KEY && keypressed5 != '*' && keypressed5 != '#' && keypressed5 != 'A' && keypressed5 != 'B' && keypressed5 != 'C' && keypressed5 != 'D' ) {
      c4 = keypressed5;
      lcd.setCursor(3, 1);
      lcd.print(c4);
    }

    i1 = (c1 - 48) * 1000; // las teclas presionadas se almacenan en caracteres, las convierto en int y luego hice una multiplicación para obtener el código como int de xxxx//
    i2 = (c2 - 48) * 100;
    i3 = (c3 - 48) * 10;
    i4 = c4 - 48;
    int N_year = i1 + i2 + i3 + i4;
    delay(500);
    lcd.clear();

    lcd.print("  Conf. Mes  "); // Almazar datos para el mes (2 Digitos)
    char keypressed6 = myKeypad.waitForKey();  // aquí todos los programas se detienen hasta que ingresa los dígitos y luego se compara con el código anterior
    if (keypressed6 != NO_KEY && keypressed6 != '*' && keypressed6 != '#' && keypressed6 != 'A' && keypressed6 != 'B' && keypressed6 != 'C' && keypressed6 != 'D' ) {
      c1 = keypressed6;
      lcd.setCursor(0, 1);
      lcd.print(c1);
    }

    char   keypressed7 = myKeypad.waitForKey();
    if (keypressed7 != NO_KEY && keypressed7 != '*' && keypressed7 != '#' && keypressed7 != 'A' && keypressed7 != 'B' && keypressed7 != 'C' && keypressed7 != 'D' ) {
      c2 = keypressed7;
      lcd.setCursor(1, 1);
      lcd.print(c2);
    }

    i1 = (c1 - 48) * 10;
    i2 = c2 - 48;
    int N_month = i1 + i2;
    delay(500);
    lcd.clear();

    lcd.print("  Conf. Dia  "); // Almazar datos para el dia (2 Digitos)
    char keypressed8 = myKeypad.waitForKey();  // aquí todos los programas se detienen hasta que ingresa los dígitos y luego se compara con el código anterior
    if (keypressed8 != NO_KEY && keypressed8 != '*' && keypressed8 != '#' && keypressed8 != 'A' && keypressed8 != 'B' && keypressed8 != 'C' && keypressed8 != 'D' ) {
      c1 = keypressed8;
      lcd.setCursor(0, 1);
      lcd.print(c1);
    }

    char keypressed9 = myKeypad.waitForKey();
    if (keypressed9 != NO_KEY && keypressed9 != '*' && keypressed9 != '#' && keypressed9 != 'A' && keypressed9 != 'B' && keypressed9 != 'C' && keypressed9 != 'D' ) {
      c2 = keypressed9;
      lcd.setCursor(1, 1);
      lcd.print(c2);
    }

    i1 = (c1 - 48) * 10;
    i2 = c2 - 48;
    int N_day = i1 + i2;
    delay(500);
    lcd.clear();

    lcd.print("  Conf. Hora  "); // Almazar datos para la hora (2 Digitos)
    char keypressed10 = myKeypad.waitForKey();  // aquí todos los programas se detienen hasta que ingresa los dígitos y luego se compara con el código anterior
    if (keypressed10 != NO_KEY && keypressed10 != '*' && keypressed10 != '#' && keypressed10 != 'A' && keypressed10 != 'B' && keypressed10 != 'C' && keypressed10 != 'D' ) {
      c1 = keypressed10;
      lcd.setCursor(0, 1);
      lcd.print(c1);
    }

    char   keypressed11 = myKeypad.waitForKey();
    if (keypressed11 != NO_KEY && keypressed11 != '*' && keypressed11 != '#' && keypressed11 != 'A' && keypressed11 != 'B' && keypressed11 != 'C' && keypressed11 != 'D' ) {
      c2 = keypressed11;
      lcd.setCursor(1, 1);
      lcd.print(c2);
    }

    i1 = (c1 - 48) * 10;
    i2 = c2 - 48;
    int N_hour = i1 + i2;
    delay(500);
    lcd.clear();

    lcd.print("  Conf. Min  "); // Almazar datos para los minutos (2 Digitos)
    char keypressed12 = myKeypad.waitForKey();  // here all programs are stopped until you enter the four digits then it gets compared to the code above
    if (keypressed12 != NO_KEY && keypressed12 != '*' && keypressed12 != '#' && keypressed12 != 'A' && keypressed12 != 'B' && keypressed12 != 'C' && keypressed12 != 'D' ) {
      c1 = keypressed12;
      lcd.setCursor(0, 1);
      lcd.print(c1);
    }

    char    keypressed13 = myKeypad.waitForKey();
    if (keypressed13 != NO_KEY && keypressed13 != '*' && keypressed13 != '#' && keypressed13 != 'A' && keypressed13 != 'B' && keypressed13 != 'C' && keypressed13 != 'D' ) {
      c2 = keypressed13;
      lcd.setCursor(1, 1);
      lcd.print(c2);
    }

    i1 = (c1 - 48) * 10;
    i2 = c2 - 48;
    int N_minutes = i1 + i2;
    delay(500);
    lcd.clear();

    /*
        Una vez que hayamos terminado de configurar la fecha y la hora, transferiremos los valores al módulo RTC
        los 22 significan segundos, también puedes agregar una configuración si lo deseas
        el "1" representa el día de la semana, mientras no lo muestre en la pantalla no lo cambio
    */
    myRTC.setDS1302Time(00, N_minutes, N_hour, 1, N_day, N_month, N_year);
    keypressed = NO_KEY; // la tecla "*" se almacena en "presionada la tecla == keypressed", por lo que elimino ese valor, de lo contrario me llevará a la configuración nuevamente
  } else if (keypressed == 'A') {
    lcd.clear();
    lcd.print(" Hora de Riego ");
    delay(1000);
    lcd.clear();
    lcd.print("  Config. Hora  ");

    char keypressed14 = myKeypad.waitForKey();  // aquí todos los programas se detienen hasta que ingresa los dígitos y luego se compara con el código anterior
    if (keypressed14 != NO_KEY && keypressed14 != '*' && keypressed14 != '#' && keypressed14 != 'A' && keypressed14 != 'B' && keypressed14 != 'C' && keypressed14 != 'D' ) {
      c1 = keypressed14;
      lcd.setCursor(0, 1);
      lcd.print(c1);
    }

    char   keypressed15 = myKeypad.waitForKey();
    if (keypressed15 != NO_KEY && keypressed15 != '*' && keypressed15 != '#' && keypressed15 != 'A' && keypressed15 != 'B' && keypressed15 != 'C' && keypressed15 != 'D' ) {
      c2 = keypressed15;
      lcd.setCursor(1, 1);
      lcd.print(c2);
    }

    i1 = (c1 - 48) * 10;
    i2 = c2 - 48;
    A_hour = i1 + i2;
    EEPROM.write(0, A_hour);
    delay(500);
    lcd.clear();

    lcd.print("  Config. Min  ");
    char keypressed16 = myKeypad.waitForKey();  // aquí todos los programas se detienen hasta que ingresa los dígitos y luego se compara con el código anterior
    if (keypressed16 != NO_KEY && keypressed16 != '*' && keypressed16 != '#' && keypressed16 != 'A' && keypressed16 != 'B' && keypressed16 != 'C' && keypressed16 != 'D' ) {
      c1 = keypressed16;
      lcd.setCursor(0, 1);
      lcd.print(c1);
    }

    char   keypressed17 = myKeypad.waitForKey();
    if (keypressed17 != NO_KEY && keypressed17 != '*' && keypressed17 != '#' && keypressed17 != 'A' && keypressed17 != 'B' && keypressed17 != 'C' && keypressed17 != 'D' ) {
      c2 = keypressed17;
      lcd.setCursor(1, 1);
      lcd.print(c2);
    }

    i1 = (c1 - 48) * 10;
    i2 = c2 - 48;
    A_minute = i1 + i2;
    EEPROM.write(1, A_minute);
    delay(500);
    lcd.clear();
    AlarmIsActive = 1;
    EEPROM.write(2, 1);
    keypressed = NO_KEY;
  } else if (keypressed == 'B') {
    lcd.clear();
    lcd.print(" R. Desactivado ");
    AlarmIsActive = 0;
    EEPROM.write(2, 0);
    keypressed = NO_KEY;
    delay(500);
  } else if (keypressed == 'C') {
    lcd.clear();
    lcd.print(" Tiempo de Riego ");
    delay(1000);
    lcd.clear();
    lcd.print("  Config. Hora  ");

    char keypressed18 = myKeypad.waitForKey();  // aquí todos los programas se detienen hasta que ingresa los dígitos y luego se compara con el código anterior
    if (keypressed18 != NO_KEY && keypressed18 != '*' && keypressed18 != '#' && keypressed18 != 'A' && keypressed18 != 'B' && keypressed18 != 'C' && keypressed18 != 'D' ) {
      c5 = keypressed18;
      lcd.setCursor(0, 1);
      lcd.print(c5);
    }

    char   keypressed19 = myKeypad.waitForKey();
    if (keypressed19 != NO_KEY && keypressed19 != '*' && keypressed19 != '#' && keypressed19 != 'A' && keypressed19 != 'B' && keypressed19 != 'C' && keypressed19 != 'D' ) {
      c6 = keypressed19;
      lcd.setCursor(1, 1);
      lcd.print(c6);
    }

    i1 = (c5 - 48) * 10;
    i2 = c6 - 48;
    int T_hour = i1 + i2;
    delay(500);
    lcd.clear();

    lcd.print("  Config. Min  ");
    char keypressed20 = myKeypad.waitForKey();  // aquí todos los programas se detienen hasta que ingresa los dígitos y luego se compara con el código anterior
    if (keypressed20 != NO_KEY && keypressed20 != '*' && keypressed20 != '#' && keypressed20 != 'A' && keypressed20 != 'B' && keypressed20 != 'C' && keypressed20 != 'D' ) {
      c5 = keypressed20;
      lcd.setCursor(0, 1);
      lcd.print(c5);
    }

    char   keypressed21 = myKeypad.waitForKey();
    if (keypressed21 != NO_KEY && keypressed21 != '*' && keypressed21 != '#' && keypressed21 != 'A' && keypressed21 != 'B' && keypressed21 != 'C' && keypressed21 != 'D' ) {
      c6 = keypressed21;
      lcd.setCursor(1, 1);
      lcd.print(c6);
    }

    i1 = (c5 - 48) * 10;
    i2 = c6 - 48;
    T_minute = i1 + i2;
    wateringTime = ((T_hour * 60) + T_minute);
    EEPROM.write(3, wateringTime);
    intervRev = wateringTime * 2;
    delay(500);
    lcd.clear();
    keypressed = NO_KEY;
  } else if (keypressed == 'D') {
    lcd.clear();
    lcd.print(" Limite de Humedad ");
    delay(1000);
    lcd.clear();
    lcd.print("Conf.Lim % 05-99");

    char keypressed22 = myKeypad.waitForKey();  // aquí todos los programas se detienen hasta que ingresa los dígitos y luego se compara con el código anterior
    if (keypressed22 != NO_KEY && keypressed22 != '*' && keypressed22 != '#' && keypressed22 != 'A' && keypressed22 != 'B' && keypressed22 != 'C' && keypressed22 != 'D' ) {
      c5 = keypressed22;
      lcd.setCursor(0, 1);
      lcd.print(c5);
    }

    char keypressed23 = myKeypad.waitForKey();
    if (keypressed23 != NO_KEY && keypressed23 != '*' && keypressed23 != '#' && keypressed23 != 'A' && keypressed23 != 'B' && keypressed23 != 'C' && keypressed23 != 'D' ) {
      c6 = keypressed23;
      lcd.setCursor(1, 1);
      lcd.print(c6);
    }

    i1 = (c5 - 48) * 10;
    i2 = c6 - 48;
    moistureLimit = i1 + i2;
    delay(500);
    lcd.clear();

    EEPROM.write(4, moistureLimit);
    delay(500);
    lcd.clear();
    keypressed = NO_KEY;
  } else if (keypressed == '#') {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Humedad: " + String(zfill(soilSensorValue)) + "%");
    lcd.setCursor(0, 1);
    lcd.print("Humedad Min: " + String(zfill(moistureLimit)) + "%");
    delay(2000);
    delay(500);
    lcd.clear();
    keypressed = NO_KEY;
  } 
  else {
    myRTC.updateTime();
    keypressed = NO_KEY;
  }
}

String zfill(int number){
  if(number >= 10){
    return String(number);
  } else {
    return "0" + String(number);
  }
}
