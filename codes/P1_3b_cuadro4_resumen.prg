' ============================================================
' PREGUNTA 1.3 - PARTE B: tabla-resumen del Cuadro 4
' (Efecto traspaso [FMOLS] + MCE lineal parsimonioso, las 9 tasas
' activas), siguiendo el mismo patron que CUADRO_3 en
' P1_2c_cuadro3_resumen.prg.
'
' *** IMPORTANTE: igual que CUADRO_3, esta tabla esta ESCRITA A
' MANO (hardcodeada), no calculada por formula dentro de este
' archivo. Los 9x8 numeros (efecto traspaso, alpha, theta0 y
' Promedio, cada uno con su fila de detalle) ya fueron validados
' uno por uno contra el output real de EViews en P1_3a -- esta
' tabla solo los consolida en un unico objeto tipo Cuadro 4 del
' paper, para exportar directo al .tex.
'
' PRERREQUISITO: haber corrido P1_3a completo (crea EQ_MCE_<serie>
' y EQ_FMOLS_<serie> para las 9 series).
'
' LEYENDA de la columna "Observacion":
'   "OK 6/6"  = alpha, su SE, su Prob, theta0, su SE y su Prob
'               (los 6 valores "primarios") calzan exacto, Y el
'               Promedio (meses) tambien calza exacto (no fue
'               parte de ningun filtro de busqueda -- es
'               confirmacion independiente).
'   "OK 7/7" / "OK 8/8" = igual que arriba, mas 1 o 2 valores
'               adicionales (theta1 de un rezago extra de dRP, o
'               la constante en R6) que tambien calzan exacto.
'   "Primarios OK, Promedio NO" = los 6 valores primarios calzan
'               exacto, pero el "Promedio (meses)" que resulta de
'               aplicarles la propia formula del paper NO
'               reproduce el numero impreso en el Cuadro 4 (ver
'               investigacion completa en P1_3a). Afecta a R5 y R8.
'   "NO REPLICABLE" = ni siquiera los valores primarios (alpha,
'               theta0) se pudieron reproducir pese a busqueda
'               exhaustiva con 8+ metodologias distintas; se probo
'               ademas que el Promedio publicado (8.3) es
'               matematicamente IMPOSIBLE dado el resto de valores
'               publicados de la propia fila. Afecta solo a R7 --
'               ver bloque completo de investigacion en P1_3a.
' ============================================================

table(11,6) CUADRO_4
CUADRO_4(1,1) = "Tasa activa"
CUADRO_4(1,2) = "Efecto traspaso (b1, FMOLS)"
CUADRO_4(1,3) = "Velocidad de ajuste (alpha, MCE)"
CUADRO_4(1,4) = "Efecto contemporaneo (theta0, MCE)"
CUADRO_4(1,5) = "Promedio (meses)"
CUADRO_4(1,6) = "Observacion"

CUADRO_4(2,1) = "R1 Preferencial 90d"
CUADRO_4(2,2) = 0.89
CUADRO_4(2,3) = -0.17
CUADRO_4(2,4) = 0.89
CUADRO_4(2,5) = 0.0
CUADRO_4(2,6) = "OK 6/6 (exacto)"

CUADRO_4(3,1) = "R2 Corporativa <=360d"
CUADRO_4(3,2) = 0.91
CUADRO_4(3,3) = -0.16
CUADRO_4(3,4) = 0.17
CUADRO_4(3,5) = 5.1
CUADRO_4(3,6) = "OK 6/6 (exacto)"

CUADRO_4(4,1) = "R3 Grandes Emp. <=360d"
CUADRO_4(4,2) = 0.98
CUADRO_4(4,3) = -0.16
CUADRO_4(4,4) = 0.01
CUADRO_4(4,5) = 6.3
CUADRO_4(4,6) = "OK 7/7 (exacto)"

CUADRO_4(5,1) = "R4 Medianas Emp. <=360d"
CUADRO_4(5,2) = 0.91
CUADRO_4(5,3) = -0.33
CUADRO_4(5,4) = 0.53
CUADRO_4(5,5) = 1.2
CUADRO_4(5,6) = "OK 7/7 (exacto)"

CUADRO_4(6,1) = "R5 Corporativa >360d"
CUADRO_4(6,2) = 0.39
CUADRO_4(6,3) = -0.06
CUADRO_4(6,4) = 0.03
CUADRO_4(6,5) = 16.9
CUADRO_4(6,6) = "Primarios OK 6/6; Promedio NO (paper: 7.0; IMPOSIBLE matematicamente, ver P1_3a; probable digito perdido de 17.0). CERRADO"

CUADRO_4(7,1) = "R6 Grandes Emp. >360d"
CUADRO_4(7,2) = 0.57
CUADRO_4(7,3) = -0.06
CUADRO_4(7,4) = 0.09
CUADRO_4(7,5) = 15.1
CUADRO_4(7,6) = "OK 8/8 (exacto, incluye constante significativa)"

CUADRO_4(8,1) = "R7 Medianas Emp. >360d"
CUADRO_4(8,2) = 0.36
CUADRO_4(8,3) = -0.03
CUADRO_4(8,4) = 0.14
CUADRO_4(8,5) = NA
CUADRO_4(8,6) = "NO REPLICABLE (paper: alpha=-0.04, theta0=0.38, Promedio=8.3; probado matematicamente imposible). CERRADO tras busqueda ampliada (beta1 flotante + hasta 6 rezagos extra)"

CUADRO_4(9,1) = "R8 TAMN"
CUADRO_4(9,2) = 1.44
CUADRO_4(9,3) = -0.02
CUADRO_4(9,4) = -0.23
CUADRO_4(9,5) = 55.8
CUADRO_4(9,6) = "Primarios OK 6/6; Promedio NO (paper: 69.2; matematicamente posible pero no encontrado, ni con b0 exacto de FMOLS). CERRADO"

CUADRO_4(10,1) = "R9 FTAMN"
CUADRO_4(10,2) = 1.33
CUADRO_4(10,3) = -0.21
CUADRO_4(10,4) = 0.03
CUADRO_4(10,5) = 4.6
CUADRO_4(10,6) = "OK 7/7 (exacto)"

CUADRO_4(11,1) = "TOTAL: 7/9 series 100% exactas (incl. Promedio); 2/9 (R5,R8) exactas en alpha/theta0 pero no en Promedio; 1/9 (R7) no replicable"
CUADRO_4(11,2) = NA
CUADRO_4(11,3) = NA
CUADRO_4(11,4) = NA
CUADRO_4(11,5) = NA
CUADRO_4(11,6) = ""

show CUADRO_4

' ============================================================
' RESUMEN FINAL:
'   - R1, R2, R3, R4, R6, R9 (6 de 9): replicadas 100% exactas,
'     incluyendo el Promedio (meses) derivado -- esta es la
'     confirmacion mas fuerte posible, porque el Promedio no fue
'     parte de ningun criterio de busqueda.
'   - R5, R8 (2 de 9): los 6 valores primarios del MCE (alpha y
'     theta0, con sus respectivos SE y Prob) calzan exactos, pero
'     el "Promedio (meses)" impreso en el paper no se puede
'     reproducir aplicando la propia formula del paper a sus
'     propios coeficientes publicados. Para R5 se probo
'     matematicamente que el 7.0 impreso es IMPOSIBLE dado el resto
'     de la fila (rango real: [13.99, 17.03]) -- prueba puramente
'     algebraica, no depende de la especificacion, asi que no hay
'     mas busqueda posible aqui. Para R8 el 69.2 SI es
'     matematicamente alcanzable (rango [46.2, 77.6]) pero no se
'     encontro, ni con el b0 exacto de FMOLS recien confirmado en
'     EViews real (C=11.66597) ni ampliando la busqueda hasta
'     rezago 14 (~275,000 combinaciones acumuladas en total entre
'     ambas sesiones).
'   - R7 (1 de 9): NO REPLICABLE. Ni siquiera alpha y theta0 (los
'     valores primarios) se pudieron reproducir, pese a 8+
'     metodologias de busqueda/estimacion independientes, incluyendo
'     una ronda final con beta1 flotante en todo su bracket de
'     redondeo combinado con hasta 6 rezagos extra (~14,700 modelos
'     adicionales) -- techo real de theta0 ~0.26, lejos del 0.38
'     publicado. Ademas se probo matematicamente que el Promedio
'     publicado (8.3) es imposible dado el resto de valores
'     publicados en la misma fila del Cuadro 4 del paper (el rango
'     matematico real es siempre negativo, [-1.73, -0.73]). Ver
'     investigacion completa (Pasos 1-8 + ronda final) en
'     P1_3a_cuadro4_mce_lineal.prg.
'   - Se busco tambien una fe de erratas/corrigendum publicado del
'     paper: ninguna busqueda web encontro referencia a correcciones,
'     y el PDF fuente en bcrp.gob.pe sigue bloqueado por proteccion
'     anti-bot (Incapsula) para verificacion directa.
'   - CONCLUSION: R5, R7 y R8 se dan por CERRADOS tras agotar todas
'     las vias razonables de investigacion (busqueda combinatoria con
'     datos exactos, motores nativos de EViews, pruebas formales de
'     imposibilidad matematica, y busqueda de fuentes externas).
' ============================================================
