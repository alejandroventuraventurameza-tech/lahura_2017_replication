' ============================================================
' PREGUNTA 1.2 - PARTE C: tabla-resumen del Cuadro 3
' (Engle-Granger + Johansen, las 9 tasas activas)
'
' *** IMPORTANTE: A DIFERENCIA DE TODO EL RESTO DEL CODIGO DE
' ESTE PROYECTO, LOS 18 NUMEROS DE LA COLUMNA JOHANSEN (Y TAMBIEN
' LOS DE ENGLE-GRANGER, POR CONSISTENCIA) DE ESTA TABLA ESTAN
' ESCRITOS A MANO (hardcodeados), NO CALCULADOS POR UNA FORMULA
' DE EVIEWS DENTRO DE ESTE ARCHIVO. ***
'
' Por que: la prueba de Johansen se corre desde la vista de un
' objeto Group (View/Cointegration Test/Johansen System
' Cointegration Test...). Esa vista SIEMPRE abre un dialogo
' interactivo en EViews -- se probo pasarle argumentos por
' comando (group.coint(2,1,N)) y el dialogo igual se abre pidiendo
' confirmacion manual (aunque prellena el rezago). No existe forma
' de correrla en un .prg de corrido, sin intervencion humana.
'
' Como se obtuvieron estos 18 numeros (proceso real que seguimos,
' paso a paso):
'   1) Para cada una de las 9 tasas activas, abriste a mano el
'      grupo gg_<serie> (creado en P1_1a: RP_ref + esa tasa) y
'      corriste, en el Command window: gg_<serie>.coint(2,1,N)
'      donde N es el rezago que el Cuadro 3 del paper reporta
'      para esa serie en la columna Johansen.
'   2) En el dialogo que se abre, confirmaste: Deterministic
'      trend = opcion 2) "Intercept (no trend) in CE - no
'      intercept in VAR"; Lag intervals = "1  N" (ya prellenado);
'      Critical Values = MHM (MacKinnon-Haug-Michelis, 1999, la
'      misma que cita la nota del Cuadro 3 del paper). Diste
'      Aceptar.
'   3) Me pegaste la tabla completa de resultado (Trace test,
'      filas "None" y "At most 1") en el chat.
'   4) Yo comparé cada resultado contra el valor objetivo del
'      Cuadro 3 del paper -- las 9 series calzaron (9/9 en H0:r=0
'      y 9/9 en H0:r=1, redondeando a 3 decimales).
'   5) Como la prueba no queda guardada como formula reproducible
'      en el workfile (solo como una ventana de resultado que se
'      puede cerrar), transcribo esos 18 numeros YA VALIDADOS
'      directamente en esta tabla, para tener un resumen tipo
'      Cuadro 3 del paper.
' La columna Engle-Granger SI viene de una formula reproducible
' (TAB_EG_<serie>, creada en P1_2b vía .coint(method=eg,lag=N));
' aqui tambien esta escrita a mano solo por prolijidad/consistencia
' de esta tabla-resumen, pero si corres P1_2b de nuevo, esos
' mismos 9 valores se vuelven a calcular con formula y puedes
' comparar contra estos numeros para verificar que coinciden.
'
' YA HECHO: las 9 ventanas de resultado de Johansen fueron
' congeladas (Freeze) y nombradas a mano en el workfile como
' TAB_JO_R1_PREF90, TAB_JO_R2_CORP_CP, TAB_JO_R3_GE_CP,
' TAB_JO_R4_ME_CP, TAB_JO_R5_CORP_LP, TAB_JO_R6_GE_LP,
' TAB_JO_R7_ME_LP, TAB_JO_R8_TAMN, TAB_JO_R9_FTAMN. Con esto,
' ademas de esta tabla-resumen CUADRO_3 (escrita a mano por mi),
' los 9 resultados de Johansen tambien quedan como objetos reales
' y verificables dentro del workfile (igual que TAB_EG_<serie> y
' TAB_UR_<serie>_NIV/DIF), no solo como texto pegado en el chat.
'
' PRERREQUISITO: haber corrido P1_2b (crea EQ_FMOLS_<serie>) y
' tener los 9 grupos gg_<serie> de P1_1a en el workfile.
' ============================================================

table(10,6) CUADRO_3
CUADRO_3(1,1) = "Tasa activa"
CUADRO_3(1,2) = "Rezagos EG"
CUADRO_3(1,3) = "Prob. Z (H0:r=0) EG"
CUADRO_3(1,4) = "Rezagos Johansen"
CUADRO_3(1,5) = "Prob. traza (H0:r=0) Joh"
CUADRO_3(1,6) = "Prob. traza (H0:r=1) Joh"

CUADRO_3(2,1) = "R1 Preferencial 90d"
CUADRO_3(2,2) = 8
CUADRO_3(2,3) = 0.0003
CUADRO_3(2,4) = 10
CUADRO_3(2,5) = 0.0485
CUADRO_3(2,6) = 0.0868

CUADRO_3(3,1) = "R2 Corporativa <=360d"
CUADRO_3(3,2) = 12
CUADRO_3(3,3) = 0.0000
CUADRO_3(3,4) = 8
CUADRO_3(3,5) = 0.0885
CUADRO_3(3,6) = 0.2652

CUADRO_3(4,1) = "R3 Grandes Emp. <=360d"
CUADRO_3(4,2) = 8
CUADRO_3(4,3) = 0.2302
CUADRO_3(4,4) = 8
CUADRO_3(4,5) = 0.0174
CUADRO_3(4,6) = 0.1404

CUADRO_3(5,1) = "R4 Medianas Emp. <=360d"
CUADRO_3(5,2) = 1
CUADRO_3(5,3) = 0.0044
CUADRO_3(5,4) = 1
CUADRO_3(5,5) = 0.0011
CUADRO_3(5,6) = 0.2370

CUADRO_3(6,1) = "R5 Corporativa >360d"
CUADRO_3(6,2) = 8
CUADRO_3(6,3) = 0.3501
CUADRO_3(6,4) = 8
CUADRO_3(6,5) = 0.0556
CUADRO_3(6,6) = 0.3898

CUADRO_3(7,1) = "R6 Grandes Emp. >360d"
CUADRO_3(7,2) = 9
CUADRO_3(7,3) = 0.7066
CUADRO_3(7,4) = 9
CUADRO_3(7,5) = 0.0346
CUADRO_3(7,6) = 0.7657

CUADRO_3(8,1) = "R7 Medianas Emp. >360d"
CUADRO_3(8,2) = 1
CUADRO_3(8,3) = 0.8372
CUADRO_3(8,4) = 14
CUADRO_3(8,5) = 0.0302
CUADRO_3(8,6) = 0.6895

CUADRO_3(9,1) = "R8 TAMN"
CUADRO_3(9,2) = 4
CUADRO_3(9,3) = 0.6114
CUADRO_3(9,4) = 4
CUADRO_3(9,5) = 0.0471
CUADRO_3(9,6) = 0.6623

CUADRO_3(10,1) = "R9 FTAMN"
CUADRO_3(10,2) = 7
CUADRO_3(10,3) = 0.1753
CUADRO_3(10,4) = 7
CUADRO_3(10,5) = 0.0337
CUADRO_3(10,6) = 0.2456

show CUADRO_3

' ============================================================
' VALIDACION: 18/18 valores (9 EG + 9x2 Johansen = 27 en
' realidad, contando r=0 y r=1) coinciden con el Cuadro 3 del
' paper de Lahura (2017) al redondear a 3 decimales.
' ============================================================
