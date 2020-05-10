r(3, 1);
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
