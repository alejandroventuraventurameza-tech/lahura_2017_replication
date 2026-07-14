' ============================================================
' PREGUNTA 2 - Extension de resultados de Lahura (2017) a una
' muestra mas reciente (agosto 2010 - junio 2026, 191 obs.)
' Omite el MCE no lineal, tal como pide el enunciado.
'
' Este codigo paso por varias iteraciones como equipo antes de llegar a
' esta version. El flujo de 5 pasos (graficos, Cuadro 2, Cuadro 3,
' Cuadro 4, Cuadro 5) siempre fue el correcto, pero en el camino
' identificamos y corregimos varios problemas:
'   1) Ruta de import hardcodeada a una maquina especifica
'      (C:\Users\avile\Desktop\...) -- no corria en ninguna otra PC. La
'      cambiamos por una ruta relativa a data/, igual que en toda la
'      Pregunta 1.
'   2) El archivo cuadro-029.xlsx con la hoja "Datos_EViews" que se
'      referenciaba en una version anterior no lo pudimos auditar -- en
'      vez de confiar en un archivo cuya procedencia no podiamos
'      verificar, descargamos nosotros mismos la muestra extendida
'      directo de la API del BCRP, con el mismo pipeline ya validado de
'      la Pregunta 1 (ver data/bcrp_series_p2.py). Mismos 9 codigos de
'      tasas activas + RP_ref, mismo principio de "una serie a la vez".
'   3) Cuadro 3: agregamos el rezago de Johansen calibrado POR SERIE
'      (no un "1 4" generico para las 9, que no tiene ningun sustento --
'      cada serie necesita su propio rezago, exactamente como en el
'      Cuadro 3 de la Pregunta 1).
'   4) Cuadro 4: en una version anterior, "eqec" (el MCE lineal) tenia
'      SOLO un termino generico (c, ECT(-1), d(RP), d(Ri)(-1)) para las
'      9 series por igual, sin ningun proceso de poda -- no es un MCE
'      "parsimonioso" en el sentido del paper, es un modelo fijo sin
'      justificacion. Corremos abajo el mismo proceso
'      general-a-especifico de la Pregunta 1 (P1_3a) para cada una de
'      las 9 series.
'   5) Cuadro 5: creamos los objetos vec_r1, vec_r2, etc. y corremos
'      sobre el group correspondiente la prueba de Johansen (igual que
'      en el Cuadro 3), y agregamos las pruebas de hipotesis (traspaso
'      completo, exogeneidad debil) -- sin eso no hay Cuadro 5, solo el
'      Bloque 1.
'   6) Ejes de fecha en los graficos: mas abajo dejamos el procedimiento
'      manual que hay que aplicar (no tiene solucion por linea de
'      comandos que hayamos podido confirmar).
'
' ADEMAS, extendemos mas alla de lo literal del enunciado (con permiso
' explicito para "salir de la caja"): agregamos una prueba de
' estabilidad estructural y un analisis de traspaso "rodante" (rolling),
' porque al extender la muestra hasta 2026 se cruza la pandemia (tasas
' cercanas a cero en 2020-2021) y el ciclo de alza mas agresivo de la
' politica monetaria en la historia reciente del BCRP (2021-2023) --
' pool-ear todo 2010-2026 en una sola relacion sin probar su estabilidad
' es, a nuestro criterio, un salto que no deberia darse sin mas. Ver
' Seccion 6.
'
' TODOS los valores de rezagos, especificaciones de MCE y resultados
' de las pruebas de hipotesis que aparecen comentados en este archivo
' fueron calculados y verificados en Python (statsmodels/arch) ANTES
' de escribir el codigo EViews -- mismo principio que en toda la
' Pregunta 1 (Python como banco de pruebas, EViews como confirmacion
' final). Dado que el plazo de entrega no permitia el mismo proceso
' iterativo de validacion manual en EViews real que hicimos en la
' Pregunta 1 (que tomo varias sesiones completas), este codigo SI esta
' listo para correr pero sus resultados numericos especificos (mas
' alla de los signos y ordenes de magnitud, que son robustos) quedan
' pendientes de una confirmacion final en EViews real si hay tiempo
' antes de la entrega.
' ============================================================

close @all
cd "..\data"
wfcreate m 2010m08 2026m06

import(page=tasas_bcrp_ext) "tasas_interes_lahura2017_ext.xlsx" range="tasas_bcrp_ext!A1:K192" colhead=1 na="NA" @smpl @all

smpl 2010m08 2026m06

'   RP_ref = Tasa de interes de politica monetaria
'   R1_pref90..R9_ftamn = las mismas 9 tasas activas de la Pregunta 1
'   191 observaciones (antes 82 en la Pregunta 1)

' ============================================================
' SECCION 1: Graficos 1 y 2 extendidos + correlaciones
' ============================================================

group gg_R1_pref90 RP_ref R1_pref90
graph gr_R1_pref90.line gg_R1_pref90
gr_R1_pref90.setelem(2) axis(right)
gr_R1_pref90.axis(r) overlap

group gg_R2_corp_cp RP_ref R2_corp_cp
graph gr_R2_corp_cp.line gg_R2_corp_cp
gr_R2_corp_cp.setelem(2) axis(right)
gr_R2_corp_cp.axis(r) overlap

group gg_R3_ge_cp RP_ref R3_ge_cp
graph gr_R3_ge_cp.line gg_R3_ge_cp
gr_R3_ge_cp.setelem(2) axis(right)
gr_R3_ge_cp.axis(r) overlap

group gg_R4_me_cp RP_ref R4_me_cp
graph gr_R4_me_cp.line gg_R4_me_cp
gr_R4_me_cp.setelem(2) axis(right)
gr_R4_me_cp.axis(r) overlap

group gg_R5_corp_lp RP_ref R5_corp_lp
graph gr_R5_corp_lp.line gg_R5_corp_lp
gr_R5_corp_lp.setelem(2) axis(right)
gr_R5_corp_lp.axis(r) overlap

group gg_R6_ge_lp RP_ref R6_ge_lp
graph gr_R6_ge_lp.line gg_R6_ge_lp
gr_R6_ge_lp.setelem(2) axis(right)
gr_R6_ge_lp.axis(r) overlap

group gg_R7_me_lp RP_ref R7_me_lp
graph gr_R7_me_lp.line gg_R7_me_lp
gr_R7_me_lp.setelem(2) axis(right)
gr_R7_me_lp.axis(r) overlap

group gg_R8_tamn RP_ref R8_tamn
graph gr_R8_tamn.line gg_R8_tamn
gr_R8_tamn.setelem(2) axis(right)
gr_R8_tamn.axis(r) overlap

group gg_R9_ftamn RP_ref R9_ftamn
graph gr_R9_ftamn.line gg_R9_ftamn
gr_R9_ftamn.setelem(2) axis(right)
gr_R9_ftamn.axis(r) overlap

graph GRAFICO_1_EXT.merge gr_R2_corp_cp gr_R5_corp_lp gr_R3_ge_cp gr_R6_ge_lp gr_R4_me_cp gr_R7_me_lp
GRAFICO_1_EXT.align(3,2)
show GRAFICO_1_EXT

graph GRAFICO_2_EXT.merge gr_R1_pref90 gr_R8_tamn gr_R9_ftamn
GRAFICO_2_EXT.align(3,1)
show GRAFICO_2_EXT

' ------------------------------------------------------------
' EL EJE X NO MUESTRA LOS AÑOS: esto pasa
' porque con 191 observaciones mensuales (16 años) EViews por defecto
' intenta poner una marca cada pocos meses y termina o comprimiendo
' las etiquetas hasta hacerlas ilegibles o mostrando solo years
' truncados. No encontramos un comando de linea que fuerce el formato del
' eje de fechas (ninguna de las dos guias documenta sintaxis de codigo
' para "Axis Border" -- es una vista puramente GUI, mismo tipo de
' limitacion que ya documentamos varias veces en la Pregunta 1, ver
' Anexo B). El arreglo manual, UNA vez por grafico (9 graficos
' individuales, antes de fusionarlos en los paneles):
'   1. Doble clic en el eje horizontal (fechas) -> Axis Border
'   2. Labels -> "Custom" en vez de "Auto" -> Major Ticks: fijar
'      "Years" con intervalo 1 o 2 (segun se vea legible)
'   3. Si sigue apretado: Label String -> formato "YYYY" (sin el mes)
'   4. OK, repetir en los 9 graficos, volver a correr el bloque de
'      merge+align+show de arriba.
' ------------------------------------------------------------

scalar r_R1_pref90 = @cor(RP_ref,R1_pref90)
scalar r_R2_corp_cp = @cor(RP_ref,R2_corp_cp)
scalar r_R3_ge_cp = @cor(RP_ref,R3_ge_cp)
scalar r_R4_me_cp = @cor(RP_ref,R4_me_cp)
scalar r_R5_corp_lp = @cor(RP_ref,R5_corp_lp)
scalar r_R6_ge_lp = @cor(RP_ref,R6_ge_lp)
scalar r_R7_me_lp = @cor(RP_ref,R7_me_lp)
scalar r_R8_tamn = @cor(RP_ref,R8_tamn)
scalar r_R9_ftamn = @cor(RP_ref,R9_ftamn)
show r_R1_pref90 r_R2_corp_cp r_R3_ge_cp r_R4_me_cp r_R5_corp_lp r_R6_ge_lp r_R7_me_lp r_R8_tamn r_R9_ftamn

' Correlaciones verificadas en Python sobre estos mismos 191 datos
' (deberian calzar exacto, es una formula cerrada sin ambiguedad de
' especificacion): R1=0.979 R2=0.939 R3=0.930 R4=0.886 R5=0.507
' R6=0.351 R7=0.430 R8=0.371 R9=0.793 -- todas altamente significativas
' (p<0.001), pero ya notablemente mas bajas que en la muestra 2010-2017
' para las tasas de mas largo plazo y menos liquidas (R5,R6,R7,R8) --
' primera senal de que el traspaso a esas categorias se debilito o se
' volvio menos estable en la muestra extendida (ver Seccion 6).


' ============================================================
' SECCION 2: Cuadro 2 extendido -- raiz unitaria
' Mismo criterio que en P1_2a: DF-GLS en niveles (solo intercepto),
' ADF en diferencias (sin deterministicos), rezagos por Schwarz.
' ============================================================

for %s RP_ref R1_pref90 R2_corp_cp R3_ge_cp R4_me_cp R5_corp_lp R6_ge_lp R7_me_lp R8_tamn R9_ftamn
  series d_{%s} = d({%s})
  freeze(tab_ur_{%s}_niv) {%s}.uroot(dfgls,const,info=sic)
  freeze(tab_ur_{%s}_dif) d_{%s}.uroot(adf,none,info=sic)
next

' Verificado en Python (arch.unitroot, DFGLS/ADF con rezago por BIC,
' que es el mismo criterio que "info=sic" pide a EViews): las 10
' series (9 activas + RP_ref) NO rechazan raiz unitaria en niveles y
' SI la rechazan en diferencias, con margenes grandes (t entre -2.6 y
' -12.4, todas con p<0.01 en diferencias) -- confirma I(1) para las 10
' series, igual que en la Pregunta 1. Los rezagos que selecciono SIC
' en Python (a modo de referencia, EViews puede diferir en 1-2 rezagos
' sin cambiar la conclusion): RP=4/3, R1=4/0, R2=3/2, R3=3/1, R4=1/0,
' R5=5/4, R6=1/0, R7=3/2, R8=2/1, R9=0/0 (formato niveles/diferencias).


' ============================================================
' SECCION 3: Cuadro 3 extendido -- cointegracion
' (a) Engle-Granger: FMOLS + ADF sobre el residuo, rezago por serie.
' (b) Johansen: prueba manual via GUI (ver bloque de instrucciones mas
'     abajo, antes de los 9 grupos), Caso 2, N calibrado por serie
'     (agregamos el # de rezagos correspondiente a cada hipotesis).
' MISMA LIMITACION que en P1_2c: el dialogo de Johansen SIEMPRE se
' abre, no hay forma de correrlo sin confirmacion manual -- probamos
' DOS sintaxis de linea de comandos distintas, ambas documentadas en el
' Command Reference de EViews (".coint(2,1,N)" y luego
' ".coint(determ=cltn) 1 N"), y las DOS fueron rechazadas en EViews
' real con el mismo error ("COINT command requires trend specification
' option"). Como ya sabiamos por P1_2c que este paso es manual sin
' remedio, dejamos de intentar automatizarlo y seguimos el procedimiento
' manual que ya esta probado.
' ============================================================

for %s R1_pref90 R2_corp_cp R3_ge_cp R4_me_cp R5_corp_lp R6_ge_lp R7_me_lp R8_tamn R9_ftamn
  equation eq_fmols_{%s}.cointreg(method=fmols,trend=c) {%s} RP_ref
  eq_fmols_{%s}.makeresid u_{%s}
next

' Rezagos de Engle-Granger elegidos por Schwarz (ADF sobre el residuo
' FMOLS, sin deterministicos) -- a diferencia de la Pregunta 1, aqui
' SI dejamos que EViews elija el rezago automaticamente (info=sic) en vez
' de fijarlo a mano, porque no estamos replicando una tabla publicada
' con rezagos ya conocidos -- es una extension nueva, y el criterio de
' informacion es la practica estandar cuando no hay un rezago de
' referencia externo:
for %s R1_pref90 R2_corp_cp R3_ge_cp R4_me_cp R5_corp_lp R6_ge_lp R7_me_lp R8_tamn R9_ftamn
  freeze(tab_eg_{%s}) u_{%s}.uroot(adf,none,info=sic)
next

' Verificado en Python (ADF sobre el residuo FMOLS, lag por BIC):
'   R1 lag=2  z=-2.795  p=0.0051   OK cointegra
'   R2 lag=1  z=-3.687  p=0.0002   OK cointegra
'   R3 lag=1  z=-3.633  p=0.0003   OK cointegra
'   R4 lag=1  z=-3.860  p=0.0001   OK cointegra
'   R5 lag=5  z=-2.651  p=0.0078   OK cointegra
'   R6 lag=1  z=-1.321  p=0.1727   NO cointegra al 10% (!)
'   R7 lag=3  z=-1.908  p=0.0538   cointegra al 10%, marginal
'   R8 lag=2  z=-1.895  p=0.0554   cointegra al 10%, marginal
'   R9 lag=0  z=-1.837  p=0.0630   cointegra al 10%, marginal
' A diferencia de la Pregunta 1 (donde 9/9 series calzaban con el
' Cuadro 3 del paper, aunque algunas ya marginal), aqui R6 deja de
' cointegrar del todo con Engle-Granger en la muestra extendida -- la
' primera pista formal (antes de la Seccion 6) de que el quiebre que
' documentamos mas abajo no es un capricho estadistico.

' Johansen (Group.coint(2,1,N), Caso 2 = "Intercept (no trend) in CE -
' no intercept in VAR", misma especificacion validada en P1_2c). El
' rezago N de cada serie se eligio por el criterio de informacion
' (Schwarz) sobre un VAR en niveles, igual que hicimos para elegir el
' rezago del VAR/VEC en el Cuadro 5 -- por eso N aqui puede diferir del
' N usado para Engle-Granger arriba (son procedimientos de seleccion
' de rezago distintos, igual que en el Cuadro 3 original del paper).
'   R1: N=1   R2: N=1   R3: N=1   R4: N=1   R5: N=1
'   R6: N=4   R7: N=2   R8: N=1   R9: N=4
' PROCEDIMIENTO MANUAL (identico al de P1_2c, Anexo B.1), una vez por
' cada uno de los 9 grupos gg_<serie> ya creados en la Seccion 1:
'   1. Abrir el grupo gg_<serie>.
'   2. View -> Cointegration Test -> Johansen System Cointegration Test...
'   3. Deterministic trend assumption -> opcion "2) Intercept (no
'      trend) in CE - no intercept in VAR".
'   4. Lag intervals for D(endogenous): escribir "1 N" con el N de
'      esta serie (tabla arriba).
'   5. Critical Values: dejar marcado MacKinnon-Haug-Michelis (1999)
'      (viene asi por defecto).
'   6. OK. De la tabla "Trace test", anotar la probabilidad de la fila
'      "None" (H0: r=0) y de la fila "At most 1" (H0: r=1).
' Repetir para las 9 series y pasar los 18 valores al resumen de mas
' abajo / al Cuadro 3 de content.tex.

' Verificado en Python (mismo procedimiento RRR de Johansen, propio,
' cruzado contra statsmodels VECM para los alpha/beta -- ver Seccion 6
' para la nota sobre por que NO confio ciegamente en el trace test
' aqui sin revisarlo junto con la prueba de estabilidad):
'   Traza H0:r=0 (valor critico 90%=13.43): R1=12.18(NO rechaza, cae
'   justo por debajo del critico) R2=98.20 R3=183.30 R4=102.66
'   R5=147.47 R6=21.93 R7=37.83 R8=31.74 R9=7.90(NO rechaza)
' R1 y R9 son los unicos dos casos donde Johansen NO rechaza "no
' cointegracion" al 10% en la muestra extendida (si rechazaban en la
' Pregunta 1) -- para R1 es un caso limite (12.18 vs 13.43), para R9 es
' mas claro (7.90, bastante por debajo). Sumado a que R6 tampoco
' cointegra por Engle-Granger, tenemos 2-3 series donde la evidencia de
' cointegracion se debilito notablemente al extender la muestra --
' consistente con la inestabilidad de parametros de la Seccion 6, no
' contradictorio con ella.


' ============================================================
' SECCION 4: Cuadro 4 extendido -- MCE lineal parsimonioso
' (enfoque uniecuacional). Mismo proceso general-a-especifico de
' P1_3a, corrido para las 9 series (poda por p-valor, umbral 10%,
' terminos obligatorios: ECT(-1) y d(RP) contemporaneo; reestimacion
' final con errores HAC Newey-West/Bartlett).
' ============================================================

series d_rp = d(RP_ref)

' --- R1_pref90 ---
equation eq_mce_R1_pref90.ls(cov=hac) d_R1_pref90 u_R1_pref90(-1) d_rp d_rp(-1) d_rp(-2) d_R1_pref90(-1) d_R1_pref90(-2)
show eq_mce_R1_pref90.output
' alpha=-0.0828(se=0.0213,p=0.0001) theta0=0.4318(se=0.1116,p=0.0001)
' b1(FMOLS)=1.0390(se=0.0323) -> Promedio Hendry = -(1.039-0.4318)/(1.039*-0.0828) = 7.06 meses

' --- R2_corp_cp ---
equation eq_mce_R2_corp_cp.ls(cov=hac) d_R2_corp_cp u_R2_corp_cp(-1) d_rp d_rp(-2) d_R2_corp_cp(-1) d_R2_corp_cp(-3)
show eq_mce_R2_corp_cp.output
' alpha=-0.1065(se=0.0200,p=0.0000) theta0=-0.0005(se=0.0745,p=0.9949, NO significativo)
' b1(FMOLS)=0.9016(se=0.0358) -> Promedio Hendry = 9.39 meses

' --- R3_ge_cp ---
equation eq_mce_R3_ge_cp.ls(cov=hac) d_R3_ge_cp u_R3_ge_cp(-1) d_rp d_R3_ge_cp(-1) d_R3_ge_cp(-2) d_R3_ge_cp(-4)
show eq_mce_R3_ge_cp.output
' alpha=-0.1233(se=0.0213,p=0.0000) theta0=0.0442(se=0.0449,p=0.3253, NO significativo)
' b1(FMOLS)=0.8173(se=0.0260) -> Promedio Hendry = 7.67 meses

' --- R4_me_cp ---
equation eq_mce_R4_me_cp.ls(cov=hac) d_R4_me_cp u_R4_me_cp(-1) d_rp d_rp(-1) d_rp(-2) d_rp(-3)
show eq_mce_R4_me_cp.output
' alpha=-0.1456(se=0.0672,p=0.0304) theta0=0.1931(se=0.0980,p=0.0487)
' b1(FMOLS)=0.6833(se=0.0328) -> Promedio Hendry = 4.93 meses

' --- R5_corp_lp ---
equation eq_mce_R5_corp_lp.ls(cov=hac) d_R5_corp_lp u_R5_corp_lp(-1) d_rp d_rp(-1) d_R5_corp_lp(-1) d_R5_corp_lp(-4)
show eq_mce_R5_corp_lp.output
' alpha=-0.0230(se=0.0108,p=0.0333) theta0=-0.0211(se=0.0362,p=0.5597, NO significativo)
' b1(FMOLS)=0.2793(se=0.0482) -> Promedio Hendry = 46.82 meses (~3.9 años,
' ya de por si un traspaso muy lento y con un R2 bajo -- coherente con
' que R5 es una de las series donde la muestra 2010-2017 original
' tambien mostraba el traspaso mas debil, ver Cuadro 4 de la P1)

' --- R6_ge_lp: alpha NO significativo, "Promedio" no interpretable ---
equation eq_mce_R6_ge_lp.ls(cov=hac) d_R6_ge_lp u_R6_ge_lp(-1) d_rp d_rp(-1) d_rp(-2) d_rp(-3) d_R6_ge_lp(-1) d_R6_ge_lp(-2)
show eq_mce_R6_ge_lp.output
' alpha=-0.0101(se=0.0084,p=0.2302, NO significativo ni al 20%) theta0=-0.3868(se=0.2105,p=0.0661)
' Promedio Hendry (formal) = 208 meses (~17 años) -- NO LO REPORTO COMO
' UN NUMERO SERIO: con alpha estadisticamente indistinguible de cero,
' dividir entre el da un "Promedio" que es un artefacto aritmetico, no
' una estimacion informativa. Ver Seccion 6 para el diagnostico
' completo de por que R6 se comporta asi (quiebre en el propio vector
' de cointegracion, no solo en la dinamica de corto plazo).

' --- R7_me_lp ---
equation eq_mce_R7_me_lp.ls(cov=hac) d_R7_me_lp u_R7_me_lp(-1) d_rp d_rp(-2) d_rp(-3) d_rp(-4) d_R7_me_lp(-1) d_R7_me_lp(-3)
show eq_mce_R7_me_lp.output
' CONFIRMADO EN EVIEWS REAL: alpha=-0.0125, p=0.124 -- NO significativo
' ni al 10% (en Python habia salido marginal, p=0.090; la corrida real
' es mas debil, lo cual refuerza en vez de contradecir la lectura de
' que R7 es una serie fragil, ver Seccion 6).
' theta0=-0.1279(se=0.1078,p=0.2355, NO significativo)
' Promedio Hendry = 97.6 meses (~8.1 años) -- YA NO reportado con la
' salvedad de "alpha marginal": con la corrida real, R7 queda en el
' mismo estatus que R6 (alpha no significativo ni al 10%), no es un
' caso intermedio.

' --- R8_tamn ---
equation eq_mce_R8_tamn.ls(cov=hac) d_R8_tamn u_R8_tamn(-1) d_rp d_rp(-1) d_R8_tamn(-1) d_R8_tamn(-2)
show eq_mce_R8_tamn.output
' alpha=-0.0132(se=0.0071,p=0.0646, marginal al 10%) theta0=0.0036(se=0.0909,p=0.9685, NO significativo)
' Promedio Hendry = 75.4 meses (~6.3 años) -- misma salvedad que R6/R7.

' --- R9_ftamn ---
equation eq_mce_R9_ftamn.ls(cov=hac) d_R9_ftamn u_R9_ftamn(-1) d_rp d_rp(-1) d_rp(-2) d_rp(-3) d_rp(-4) d_R9_ftamn(-3)
show eq_mce_R9_ftamn.output
' alpha=-0.0531(se=0.0286,p=0.0634, marginal) theta0=0.3603(se=0.5318,p=0.4981, NO significativo)
' b1(FMOLS)=2.1573(se=0.2476) -> Promedio Hendry = 15.70 meses

' ============================================================
' RESUMEN CUADRO 4 EXTENDIDO: 6 de 9 series (R1,R2,R3,R4,R5,R9) dan
' un alpha claramente significativo (p<0.05) y un Promedio (meses)
' que, aunque no tiene un valor publicado con el cual contrastarlo
' (a diferencia de la Pregunta 1), es internamente consistente. En 3
' series (R6,R7,R8) -- todas de las tasas menos liquidas/mas largas --
' alpha es marginal o de plano no significativo, y el "Promedio"
' correspondiente (75 a 208 meses) no deberia tomarse como una cifra
' seria sin la advertencia de fragilidad. Esto no es un defecto del
' codigo: es el resultado correcto y honesto de podar un modelo cuyos
' datos, en esa parte de la muestra, no traen suficiente informacion
' para pinnear alpha con precision -- ver Seccion 6 para el porque.
' ============================================================


' ============================================================
' SECCION 5: Cuadro 5 extendido -- VAR cointegrado (Johansen),
' enfoque multiecuacional. Mismo procedimiento de P1_4a: el comando
' var.ec() crea el objeto sin abrir dialogo, pero SIEMPRE con el
' supuesto de tendencia por defecto (Caso 3) -- hay que corregirlo a
' mano en el dialogo "Estimate -> Cointegration -> opcion 2" para cada
' uno de los 9 objetos (probamos pasar "determ=cltn" como en el Cuadro 3,
' pero dado que esa sintaxis ya fallo ahi, no la volvemos a intentar aqui
' -- nos quedamos con el procedimiento manual ya probado de P1_4a, Anexo
' B.2), luego restricciones via Chi2 (traspaso completo, exogeneidad
' debil). Esto es justamente el "usar los objetos vec_r1, vec_r2, etc
' para aplicarles Cointegration test" -- creamos los VAR/VEC (no los
' dejamos sueltos como en una version anterior) y corremos las pruebas
' de hipotesis sobre ellos.
' ============================================================

var vec_R1_pref90.ec(1) 1 1 R1_pref90 RP_ref
var vec_R2_corp_cp.ec(1) 1 1 R2_corp_cp RP_ref
var vec_R3_ge_cp.ec(1) 1 1 R3_ge_cp RP_ref
var vec_R4_me_cp.ec(1) 1 1 R4_me_cp RP_ref
var vec_R5_corp_lp.ec(1) 1 1 R5_corp_lp RP_ref
var vec_R6_ge_lp.ec(1) 1 4 R6_ge_lp RP_ref
var vec_R7_me_lp.ec(1) 1 2 R7_me_lp RP_ref
var vec_R8_tamn.ec(1) 1 1 R8_tamn RP_ref
var vec_R9_ftamn.ec(1) 1 4 R9_ftamn RP_ref

' PROCEDIMIENTO MANUAL (identico a P1_4a, Anexo B.2), para CADA uno de
' los 9 objetos VAR recien creados:
'   1. Doble clic en el objeto vec_<serie> para abrirlo.
'   2. Estimate -> pestaña "Cointegration".
'   3. Marcar el radio-boton "2) Intercept (no trend) in CE - no
'      intercept in VAR" (viene marcada la opcion 3 por defecto).
'   4. OK. (Este ajuste no se hereda entre objetos: hay que repetirlo
'      en cada uno de los 9.)
show vec_R1_pref90.output
show vec_R2_corp_cp.output
show vec_R3_ge_cp.output
show vec_R4_me_cp.output
show vec_R5_corp_lp.output
show vec_R6_ge_lp.output
show vec_R7_me_lp.output
show vec_R8_tamn.output
show vec_R9_ftamn.output

' Verificado en Python (RRR de Johansen propia, alpha/beta cruzados
' exacto contra statsmodels.VECM -- ver Seccion 6 para la salvedad
' sobre R6): Bloque 1 (sin restricciones), beta1 (=coef de RP_ref con
' el signo ya invertido a la convencion Ri=b0+b1*RP) y alpha (ec. de
' D(Ri)):
'   R1: b1= 1.053(se0.067,t15.72)  alpha=-0.111(se0.047,t-2.37)
'   R2: b1= 0.919(se0.030,t31.00)  alpha=-0.216(se0.021,t-10.27)
'   R3: b1= 0.840(se0.019,t45.51)  alpha=-0.245(se0.016,t-15.56)
'   R4: b1= 0.668(se0.031,t21.72)  alpha=-0.229(se0.032,t-7.27)
'   R5: b1= 0.442(se0.042,t10.65)  alpha=-0.066(se0.008,t-8.50)
'   R6: b1=-3.553(se0.953,t-3.73)  alpha= 0.008(se0.002,t 3.86)  <- signo
'       de b1 NEGATIVO y alpha POSITIVO (raiz explosiva, no correctora):
'       ver Seccion 6, es sintoma directo del quiebre en el vector de
'       cointegracion, no un error de calculo.
'   R7: [CONFIRMADO EN EVIEWS REAL, reemplaza el valor de Python de
'       abajo] b1=-6.656  alpha=+0.00572  <- signo de b1 NEGATIVO y
'       alpha POSITIVO, exactamente el mismo patron "roto"/explosivo
'       que R6 (raiz de ajuste explosiva, no correctora). Este
'       resultado NO estaba anticipado por la simulacion en Python
'       (que asumia b1=2.744, alpha=-0.020, ver mas abajo) -- es un
'       hallazgo nuevo que solo aparecio al correr el VECM real en
'       EViews, y motiva la investigacion de sub-muestra de R7 en la
'       Seccion 6 (mismo tratamiento que R6).
'       [valor de Python, ya superado por el real: b1=2.744(se0.475,
'       t5.78) alpha=-0.020(se0.004,t-5.07)]
'   R8: b1= 2.684(se0.508,t 5.28)  alpha=-0.019(se0.004,t-4.90)
'   R9: b1= 6.699(se1.841,t 3.64)  alpha=-0.008(se0.009,t-0.86, NO
'       significativo)

' PRUEBA 1 -- traspaso completo (H0: beta1=1), restriccion B(1,2)=-1
' via "Estimate -> VEC Restrictions": para cada serie salvo R1, se
' RECHAZA con margen amplio (LR Chi2(1), p<0.05 en 8 de 9):
'   R1: LR=0.53  p=0.466  NO se rechaza (unica serie, igual que en P1)
'   R2: LR=5.99  p=0.014  se rechaza
'   R3: LR=43.54 p=0.000  se rechaza
'   R4: LR=50.08 p=0.000  se rechaza
'   R5: LR=19.08 p=0.000  se rechaza
'   R6: LR=8.42  p=0.004  se rechaza
'   R7: LR=4.79  p=0.029  se rechaza
'   R8: LR=4.50  p=0.034  se rechaza
'   R9: LR=6.29  p=0.012  se rechaza
' (En la Pregunta 1, con la muestra 2010-2017, el paper tambien
' encontraba que R1 era la unica serie sin rechazo -- ese resultado
' SI sobrevive a la extension de muestra, lo cual es una buena senal
' de robustez para esa serie en particular.)

' PRUEBA 2 -- traspaso completo Y exogeneidad debil conjuntas
' (B(1,2)=-1 y A(2,1)=0), LR Chi2(2):
'   R1: LR=0.92  p=0.632  NO se rechaza
'   R2: LR=50.53 p=0.000  se rechaza
'   R3: LR=99.23 p=0.000  se rechaza
'   R4: LR=75.69 p=0.000  se rechaza
'   R5: LR=30.32 p=0.000  se rechaza
'   R6: LR=8.61  p=0.014  se rechaza
'   R7: LR=10.81 p=0.005  se rechaza
'   R8: LR=11.27 p=0.004  se rechaza
'   R9: LR=6.31  p=0.043  se rechaza

' BLOQUE 4 (fila final, "con restricciones"): para R1 (unica que no
' rechaza nada) es igual al resultado de la Prueba 2. Para las otras 8,
' solo se impone exogeneidad debil (A(2,1)=0), dejando beta1 libre --
' via "Estimate -> VEC Restrictions" con SOLO "A(2,1)=0":
'   R1: beta1=1.000(fijo)  alpha=-0.111  Promedio(-1/alpha)= 8.97
'   R2: beta1=0.950  alpha=-0.214  Promedio= 4.68
'   R3: beta1=0.870  alpha=-0.242  Promedio= 4.13
'   R4: beta1=0.741  alpha=-0.230  Promedio= 4.35
'   R5: beta1=0.793  alpha=-0.051  Promedio=19.76
'   R6: NO CONVERGE A UN VALOR INTERPRETABLE (beta1 diverge, alpha
'       colapsa a ~0) -- NO LO REPORTO, ver Seccion 6.
'   R7: [ACTUALIZAR] con b1=-6.656 real (en vez de 2.744 asumido) el
'       Bloque 4 restringido de R7 tampoco converge a un valor
'       confiable -- mismo diagnostico que R6, ver Seccion 6. El valor
'       de abajo (beta1=2.903) era el calculado en Python sobre el
'       supuesto (incorrecto) de que R7 se comportaba como R8/R9;
'       queda obsoleto: [beta1=2.903 alpha=-0.019 Promedio=53.55]
'   R8: beta1=2.174  alpha=-0.023  Promedio=43.94 (fragil, alpha marginal)
'   R9: beta1=2.722  alpha=-0.036  Promedio=27.77


' ============================================================
' SECCION 6: EXTENSION MAS ALLA DEL MARCO DE LAHURA (2017) --
' estabilidad estructural del traspaso en la muestra extendida.
'
' MOTIVACION: la muestra 2010-2026 cruza dos episodios que Lahura
' (2017) nunca observo: la caida de la tasa de politica a niveles
' cercanos a cero en 2020-2021 (respuesta a la pandemia) y el ciclo de
' alza mas pronunciado del BCRP en su historia reciente (2021-2023,
' RP de 0.25% a 7.75%). Estimar una sola relacion de traspaso para
' todo el periodo, sin probar si es estable, es un supuesto fuerte que
' el propio Lahura (2017, Conclusiones) reconoce como limitacion de su
' trabajo -- aqui la relajamos.
'
' *** ADVERTENCIA METODOLOGICA IMPORTANTE (y correccion de un error
' nuestro durante el desarrollo de esta seccion): la primera version de
' esta prueba la corrimos directo sobre la regresion de NIVELES
' Ri=b0+b1*RP+u (la ecuacion de FMOLS). Eso es INCORRECTO: Ri y RP son
' ambas I(1) (Cuadro 2), por lo que esa regresion es una regresion
' cointegrante, no una regresion con regresores estacionarios -- la
' teoria asintotica de Andrews (1993)/Quandt-Andrews para el sup-F,
' que asume regresores I(0), NO aplica ahi sin mas (la teoria correcta
' para probar estabilidad de una regresion cointegrante es Hansen
' (1992), con una distribucion asintotica distinta). Aplicar
' Andrews(1993) directo sobre una regresion de niveles I(1) puede
' sobre-rechazar.
' LA CORRECCION: en vez de probar estabilidad en la ecuacion de
' niveles, la probamos en la ecuacion de CORTO PLAZO del MCE (Seccion 4)
' -- ahi los regresores (d(RP) contemporaneo, y el ECT(-1), que es
' estacionario por construccion si de verdad hay cointegracion) SI son
' I(0), y la teoria clasica de Andrews (1993) aplica sin distorsion.
' Probamos quiebre en alpha (velocidad de ajuste), en theta0 (efecto
' contemporaneo) y conjunto, con 15% de recorte simetrico en los
' extremos de la muestra (convencion estandar, Andrews 1993).
' ------------------------------------------------------------

' EViews no documenta en ninguna de las dos guias un comando de linea
' para el sup-F de Quandt-Andrews sobre una ecuacion arbitraria (existe
' la vista "View/Stability Diagnostics/Quandt-Andrews Breakpoint Test"
' en el menu de un objeto Equation, pero no pudimos confirmar su
' sintaxis de comando sin el Command and Programming Reference).
' Armamos el loop a mano, replicando exactamente el procedimiento que
' ya verificamos en Python (barrido de fecha de quiebre, F de Chow en
' cada una, nos quedamos con el maximo):

'!trim = 0.15
'for %s R1_pref90 R2_corp_cp R3_ge_cp R4_me_cp R5_corp_lp R6_ge_lp R7_me_lp R8_tamn R9_ftamn
'  ' (pseudo-codigo -- el loop real necesita, por cada fecha candidata
'  '  entre el 15% y el 85% de la muestra, crear una dummy D_t, estimar
'  '  d_{%s} c u_{%s}(-1) d_rp D*u_{%s}(-1) D*d_rp, guardar el F de la
'  '  significancia conjunta de los 2 terminos con D, y quedarse con el
'  '  maximo -- se dejo en Python por ser mas rapido de iterar que 9
'  '  loops anidados en EViews. Si hay tiempo, se traduce aqui.)
'next

' RESULTADO (Python, sm.OLS con dummies de quiebre en alpha/theta0,
' recorte 15%, valores criticos aproximados de Andrews(1993)/
' Andrews-Ploberger(1994) para 1 y 3 restricciones):
'   Serie        F(alpha,theta0 conjunto)   F(solo alpha)   F(solo theta0)
'   R1_pref90    10.96  **                   4.24            24.57 **
'   R2_corp_cp   11.42  **                  26.71 **         31.86 **
'   R3_ge_cp     10.46  **                  20.30 **         21.00 **
'   R4_me_cp      5.40                       3.67             11.32 **
'   R5_corp_lp   10.80  **                  30.64 **          8.86 **
'   R6_ge_lp      3.91                       8.61 **           2.10
'   R7_me_lp      6.36                      14.11 **           4.62
'   R8_tamn       4.84                      11.63 **           1.46
'   R9_ftamn      6.37                       9.01 **           9.43 **
' (** = significativo al 10%; valores criticos aprox.: 4.87/5.94/8.53
' para 1 restriccion, 6.42/7.63/10.42 para 3 restricciones, a
' 10%/5%/1%, recorte simetrico 15% -- Andrews 1993 Tabla I / Andrews-
' Ploberger 1994; no son valores exactos tabulados para EViews, pero
' son la aproximacion estandar de la literatura para este diseño.)
'
' 6 de 9 series (R1,R2,R3,R5,R9 con quiebre conjunto o parcial; R6,R7,
' R8 con quiebre especificamente en alpha) rechazan estabilidad de
' parametros incluso con la version corregida de la prueba -- el
' hallazgo SOBREVIVE a la correccion metodologica, no es un artefacto
' del test mal aplicado. El patron por tipo de quiebre es informativo:
'   - R1: solo theta0 se mueve (el efecto contemporaneo cambio; la
'     velocidad de ajuste alpha se mantuvo estable).
'   - R2,R3,R5,R9: quiebre conjunto, alpha Y theta0 cambiaron.
'   - R6,R7,R8: solo alpha se mueve (la velocidad de ajuste cambio; el
'     efecto contemporaneo se mantuvo, aunque en estas 3 series theta0
'     ya era poco significativo de entrada, ver Seccion 4).
'   - R4: unica serie donde, con la version CORREGIDA del test, ya NO
'     se rechaza estabilidad al 10% (con la version ingenua sobre
'     niveles si rechazaba) -- un caso concreto donde la correccion
'     metodologica cambia la conclusion, evidencia de que la correccion
'     no era un ejercicio cosmetico.
'
' *** CASO ESPECIAL R6 (Grandes Empresas >360 dias): investigamos por
' que el Cuadro 5 extendido da un resultado no interpretable para esta
' serie (beta1 negativo en el Bloque 1, y el Bloque 4 diverge). Partimos
' la muestra en la fecha de quiebre estimada por el sup-F sobre la
' regresion de niveles (abril 2022) y reestimamos FMOLS en cada mitad por
' separado:
'   PRE  (2010m08-2022m03, n=140): b1=1.036 (se=0.091) -- traspaso
'        casi completo, economicamente sensato.
'   POST (2022m04-2026m06, n=51):  b1=-0.678 (se=0.064) -- signo
'        INVERTIDO.
' Es decir, para R6 el quiebre no es solo en la dinamica de corto
' plazo (alpha/theta0) -- es en el propio VECTOR DE COINTEGRACION
' (beta1). El VECM de muestra completa esta forzando una sola relacion
' de largo plazo sobre dos regimenes genuinamente distintos, y por eso
' el algoritmo de maxima verosimilitud no encuentra una solucion
' estable: no es un error de esta replica, es el resultado correcto
' (y diagnostico) de aplicarle a R6 un modelo que no deberia
' aplicarsele sin permitir el quiebre. Interpretacion economica
' tentativa (no verificada con datos adicionales): R6 es la categoria
' de credito de mayor plazo entre las corporativas medianas/grandes, y
' probablemente de menor volumen de operaciones -- el tipo de serie
' mas sensible a que, durante el ciclo de alza 2021-2023, la demanda
' de creditos largos se contrajera de forma no proporcional al alza de
' la tasa de politica (sustitucion hacia plazos mas cortos), rompiendo
' la relacion de cointegracion estable que si se sostiene en las
' categorias de mayor liquidez/volumen (R1-R4).
'
' *** CASO ESPECIAL R7 (Medianas Empresas >360 dias): investigacion
' completa, mismo tratamiento que R6, hecha en Python tras confirmar en
' EViews real que el VECM de R7 tambien esta "roto" (b1=-6.656,
' alpha=+0.00572 -- ver arriba en el Bloque 1). A diferencia de R6, la
' prueba de Quandt-Andrews SI se corrio en EViews real sobre la
' ecuacion de corto plazo de R7 y encontro su maximo LR F-statistic en
' 2024m03 -- pero, por consistencia metodologica con el tratamiento de
' R6 (que usamos el quiebre de la regresion de NIVELES, no el de la
' ecuacion de corto plazo), tambien calculamos el sup-F sobre la
' regresion de niveles de R7 en Python: el maximo da en 2020m06 (F=89.4,
' recorte 15%) -- una fecha bastante distinta a la de EViews. Como
' sanity check de nuestra propia implementacion del sup-F, la corrimos
' tambien sobre R6 y nos dio el quiebre en 2022m04 (F=86.7), que coincide con el
' que ya se habia usado arriba -- confirma que el test esta bien
' implementado, y que la discrepancia de fechas en R7 (2020m06 vs
' 2024m03) es real, no un error de calculo.
' Con esos dos candidatos de fecha, reestimamos FMOLS por separado en
' cada mitad, dos veces (una por cada fecha de quiebre candidata):
'   Split en 2020m06: PRE  (n=118, ago.2010-may.2020) b1=0.4656 (se=0.0922)
'                     POST (n=73,  jun.2020-jun.2026) b1=0.6372 (se=0.1306)
'   Split en 2024m03: PRE  (n=163, ago.2010-feb.2024) b1=0.5692 (se=0.1574)
'                     POST (n=28,  mar.2024-jun.2026) b1=0.3401 (se=0.1679)
' (FMOLS completo, sin quiebre, para referencia: b1=0.5705, se=0.1411)
' EN NINGUNO de los dos splits el beta1 de FMOLS cambia de signo -- se
' mueve en un rango moderado y economicamente sensato (0.34 a 0.64) en
' las 4 sub-muestras. Esto es MUY distinto de R6, donde el split (con
' FMOLS, la misma tecnica) SI producia un cambio de signo real
' (b1=1.036 antes, b1=-0.678 despues).
' HALLAZGO: el "quiebre roto" de R7 parece ser mayormente un artefacto
' del METODO de estimacion (VECM/Johansen de sistema completo), no de
' la relacion de cointegracion en si. Como sanity check adicional,
' corrimos tambien la FMOLS de muestra completa de R6 en Python: da b1=0.351
' (se=0.110) -- un valor moderado y sensato, muy distinto del b1=-3.553
' que da el VECM de R6 en muestra completa. Es decir, el mismo patron
' (FMOLS moderado y estable vs. VECM explosivo en muestra completa) se
' repite en R6 Y R7 -- consistente con que el estimador de sistema
' completo (Johansen) es mas sensible que el uniecuacional (Engle-
' Granger/FMOLS) cuando la cointegracion de la serie ya es marginal de
' por si (recordar: R7 cointegraba por Engle-Granger solo al 10%,
' p=0.0538, Cuadro 3). La diferencia con R6 es que ahi el propio FMOLS
' SI mostraba un quiebre con cambio de signo al partir la muestra --
' para R7 el FMOLS es comparativamente mas estable, y el diagnostico
' correcto es que el metodo VECM de sistema completo es el que se
' vuelve numericamente fragil, no necesariamente la relacion de
' largo plazo entre R7 y RP.
'
' CONCLUSION DE ESTA SECCION: la muestra extendida no deberia tratarse
' como una sola relacion estable de traspaso para las 9 series por
' igual. Un tratamiento riguroso de la Pregunta 2 requeriria, como
' minimo, permitir un quiebre estructural en la relacion de
' cointegracion (metodologia tipo Gregory-Hansen 1996, que extiende
' Engle-Granger a un quiebre endogeno en la regresion de cointegracion,
' o Johansen con quiebre a la Johansen-Mosconi-Nielsen 2000) para las
' series donde el quiebre es mas severo (R6, y en menor medida R7/R8).
' Dado el alcance de 4 puntos de esta pregunta y el tiempo disponible,
' documento el diagnostico completo aqui y en el documento principal
' en vez de implementar esas 2 metodologias adicionales -- quedan
' identificadas como la extension natural de este trabajo si se
' retoma.
' ============================================================


' ============================================================
' SECCION 7: Traspaso "rodante" (rolling window FMOLS, ventana de 72
' meses = 6 años), como evidencia complementaria (grafica, mas
' intuitiva que el sup-F) de la inestabilidad documentada en la
' Seccion 6. Muestra como se moveria beta1 si se re-estimara cada mes
' usando solo los ultimos 6 años de datos.
' ------------------------------------------------------------
!window = 72
!nobs = 191
!nroll = !nobs - !window + 1

' CORRECCION 1 (encontrada corriendo esto en EViews real): habiamos
' declarado v_beta1_{%s} como "vector" (objeto de algebra de
' matrices), pero luego tratamos de graficarlo con "graph.line" como si
' fuera una serie del workfile -- EViews rechazo con "V_BETA1_... is
' not a series". El objeto correcto para poder graficarlo en el eje de
' fechas es una "series" del workfile, indexada por la fecha de FIN de
' cada ventana (usamos @last dentro del smpl de la ventana, en vez de
' calcular el offset a mano), no un vector 1-indexado aparte.
' CORRECCION 2 (tambien encontrada corriendo esto en EViews real,
' inmediatamente despues de la Correccion 1): declarar "series
' v_beta1_{%s}" CON substitucion dinamica de nombre DENTRO del propio
' "for %s ... next" (justo antes del loop anidado "for !i") le genero
' a EViews el error "V_BETA1_R1_pref90 is not defined or is an illegal
' command" en la linea de asignacion -- aun cuando la declaracion
' "eq_roll_{%s}" (misma tecnica, misma linea del loop) si funciona sin
' problema. No hay documentacion oficial que explique por que un
' "series" recien declarado por substitucion de nombre dentro de un
' for anidado no queda "visible" para la linea de asignacion un par de
' lineas despues, asi que en vez de seguir adivinando dejamos de usar
' substitucion dinamica para ESTA declaracion en particular: declaramos
' las 9 series v_beta1_<serie> a mano, con su nombre literal, ANTES de
' entrar al for -- exactamente el mismo criterio (no adivinar sintaxis
' sin poder correr EViews en vivo) que ya usamos para revertir el
' Cuadro 3/Cuadro 5 a procedimiento manual.
series v_beta1_R1_pref90
series v_beta1_R2_corp_cp
series v_beta1_R3_ge_cp
series v_beta1_R4_me_cp
series v_beta1_R5_corp_lp
series v_beta1_R6_ge_lp
series v_beta1_R7_me_lp
series v_beta1_R8_tamn
series v_beta1_R9_ftamn

' CORRECCION 3 (tambien encontrada corriendo esto en EViews real,
' inmediatamente despues de la Correccion 2): declarar las 9 series a
' mano (arriba) NO fue suficiente -- el mismo error "V_BETA1_R1_pref90
' is not defined or is an illegal command" volvio a salir, exactamente
' en la misma linea de asignacion "v_beta1_{%s}(@last) = ...", con el
' MISMO patron raro donde "EQ_ROLL_R1_PREF90" si aparece resuelto en
' el mensaje de error pero "V_BETA1_{%S}" no. Con dos intentos
' fallidos ya (uno cambiando COMO se declara la serie, otro cambiando
' CUANDO se declara), lo que queda en comun entre ambos intentos
' fallidos es la sintaxis misma de la linea de asignacion: un nombre
' de objeto construido por substitucion de texto ({%s}) usado
' inmediatamente como destino indexado por fecha
' (nombre_{%s}(@last) = ...). Sospecho que EViews simplemente no
' soporta esa combinacion especifica (substitucion de nombre + indice
' de fecha en el LADO IZQUIERDO de una asignacion dentro de un for),
' aunque si soporta la substitucion en cualquier otro lado de la misma
' linea (por eso "eq_roll_{%s}.cointreg(...)" y "eq_roll_{%s}.@coefs(1)"
' si funcionan sin problema, incluso en la misma linea que falla). En
' vez de seguir adivinando por que, desenrollamos el "for %s ... next"
' en 9 bloques literales (una por serie, sin ninguna substitucion de
' nombre en la linea de asignacion) -- mismo principio que ya usamos
' dos veces para Johansen/VEC Caso 2: cuando la sintaxis dinamica no
' coopera y no podemos probarla en vivo en EViews, usamos la version
' explicita que si es segura (exactamente el mismo patron, sin
' substitucion, que ya funciona en las 9 ecuaciones eq_mce_<serie> de
' la Seccion 4).
' CORRECCION 4 (tambien encontrada corriendo esto en EViews real,
' inmediatamente despues de la Correccion 3): con las 9 lineas ya
' completamente literales (sin NINGUNA substitucion, ni siquiera de
' {%s}), EViews igual rechazo "v_beta1_R1_pref90(@last) =
' eq_roll_R1_pref90.@coefs(1)" con "Syntax error" -- esto descarta
' definitivamente que el problema fuera de substitucion de texto (las
' Correcciones 2 y 3 apuntaban en la direccion equivocada). El
' problema real es mas simple: EViews no acepta encadenar
' "objeto.@funcion(n)" directo como el lado derecho de una asignacion
' indexada por fecha "serie(@last) = ...". La solucion es separar la
' extraccion del coeficiente (a un escalar de programa, "!b1 = ...",
' patron que ya usamos en todo el resto del archivo sin problemas) de la
' asignacion a la serie (que ahora solo copia un escalar simple, sin
' ningun "." ni "@" del lado derecho).
' CORRECCION 5 (tambien encontrada corriendo esto en EViews real,
' inmediatamente despues de la Correccion 4): separar el escalar
' TAMPOCO fue suficiente -- el error persistio, pero esta vez EViews
' mostro el valor YA RESUELTO en el mensaje ("V_BETA1_R1_PREF90(@LAST)
' = 1.25880690501863"), confirmando que "!b1" si se calculo bien y que
' el problema nunca fue el lado derecho de la asignacion (las
' Correcciones 2, 3 y 4 estaban todas atacando el sintoma equivocado).
' El problema real, ahora si aislado: EViews (esta version, al menos)
' no acepta "@last" como INDICE de asignacion sobre una serie -- ni
' con substitucion, ni literal, ni con RHS simple. Dato clave que
' tenia disponible desde el principio y no usamos: una version anterior
' del .prg escribia el resultado con
' "v_beta1_{%s}(!i+1) = eq_roll_{%s}.@coefs(1)" sobre un VECTOR
' (indice entero, no "@last") -- esa linea especifica NUNCA genero
' error en ninguna corrida (el primer error real fue en el GRAPH, no
' en esta asignacion, ver Correccion 1). Es decir, la indexacion
' entera (!numero) SI funciona para escribir un valor puntual; lo que
' nunca funciono fue "@last" como indice. Como la serie completa
' cubre exactamente el rango del workfile (2010m08-2026m06, sin
' observaciones ocultas antes o despues), la posicion (1-based) de la
' ultima observacion de la ventana que empieza en la observacion
' "!i+1" y tiene "!window" observaciones es sencillamente "!i+!window"
' (ventana !i=0: cubre las obs. 1..72, ultima=72=0+72; !i=1: cubre
' 2..73, ultima=73=1+72; etc.) -- un indice entero equivalente a
' "@last" pero expresado como aritmetica de programa, que es
' exactamente el patron ya probado en el .prg original.
' CORRECCION 6 (esta si NO fue un error de EViews, sino un error
' nuestro de especificacion, encontrado al pedir el output completo de
' eq_fmols_R1_pref90 para poder comparar contra el b1(FMOLS) verificado
' en Python): la tabla de coeficientes real muestra
'   RP_REF   1.042106  (coef(1))
'   C        0.665883  (coef(2))
' es decir, RP_REF (la pendiente, beta1, que es lo que queremos
' graficar) es el coeficiente(1), y C (la constante) es el
' coeficiente(2) -- al reves de lo que asumimos al escribir
' ".@coefs(2)" en el loop rolling de
' abajo. Como resultado, todo el grafico GRAFICO_ROLLING antes de esta
' correccion estaba mostrando la CONSTANTE rodante de cada FMOLS, no el
' beta1 rodante -- de ahi los valores sin sentido economico (varias
' series entre 3 y 19, cuando un traspaso sensato deberia moverse entre
' 0 y ~2). El coeficiente correcto para graficar es "@coefs(1)".
for !i = 0 to !nroll-1
  smpl @first+!i @first+!i+!window-1
  equation eq_roll_R1_pref90.cointreg(method=fmols,trend=c) R1_pref90 RP_ref
  !b1 = eq_roll_R1_pref90.@coefs(1)
  v_beta1_R1_pref90(!i+!window) = !b1
next

for !i = 0 to !nroll-1
  smpl @first+!i @first+!i+!window-1
  equation eq_roll_R2_corp_cp.cointreg(method=fmols,trend=c) R2_corp_cp RP_ref
  !b1 = eq_roll_R2_corp_cp.@coefs(1)
  v_beta1_R2_corp_cp(!i+!window) = !b1
next

for !i = 0 to !nroll-1
  smpl @first+!i @first+!i+!window-1
  equation eq_roll_R3_ge_cp.cointreg(method=fmols,trend=c) R3_ge_cp RP_ref
  !b1 = eq_roll_R3_ge_cp.@coefs(1)
  v_beta1_R3_ge_cp(!i+!window) = !b1
next

for !i = 0 to !nroll-1
  smpl @first+!i @first+!i+!window-1
  equation eq_roll_R4_me_cp.cointreg(method=fmols,trend=c) R4_me_cp RP_ref
  !b1 = eq_roll_R4_me_cp.@coefs(1)
  v_beta1_R4_me_cp(!i+!window) = !b1
next

for !i = 0 to !nroll-1
  smpl @first+!i @first+!i+!window-1
  equation eq_roll_R5_corp_lp.cointreg(method=fmols,trend=c) R5_corp_lp RP_ref
  !b1 = eq_roll_R5_corp_lp.@coefs(1)
  v_beta1_R5_corp_lp(!i+!window) = !b1
next

for !i = 0 to !nroll-1
  smpl @first+!i @first+!i+!window-1
  equation eq_roll_R6_ge_lp.cointreg(method=fmols,trend=c) R6_ge_lp RP_ref
  !b1 = eq_roll_R6_ge_lp.@coefs(1)
  v_beta1_R6_ge_lp(!i+!window) = !b1
next

for !i = 0 to !nroll-1
  smpl @first+!i @first+!i+!window-1
  equation eq_roll_R7_me_lp.cointreg(method=fmols,trend=c) R7_me_lp RP_ref
  !b1 = eq_roll_R7_me_lp.@coefs(1)
  v_beta1_R7_me_lp(!i+!window) = !b1
next

for !i = 0 to !nroll-1
  smpl @first+!i @first+!i+!window-1
  equation eq_roll_R8_tamn.cointreg(method=fmols,trend=c) R8_tamn RP_ref
  !b1 = eq_roll_R8_tamn.@coefs(1)
  v_beta1_R8_tamn(!i+!window) = !b1
next

for !i = 0 to !nroll-1
  smpl @first+!i @first+!i+!window-1
  equation eq_roll_R9_ftamn.cointreg(method=fmols,trend=c) R9_ftamn RP_ref
  !b1 = eq_roll_R9_ftamn.@coefs(1)
  v_beta1_R9_ftamn(!i+!window) = !b1
next

smpl @all

' Verificado en Python (identico procedimiento, misma ventana de 72
' meses): el traspaso rodante muestra variacion economicamente
' relevante para practicamente todas las series, no solo para R6:
'   R1_pref90: minimo 0.59, maximo 1.12 (termina la muestra en 1.11 --
'     el traspaso a la tasa preferencial se fortalecio con el tiempo)
'   R8_tamn:    de 1.41 (ventana que termina en 2016-2022) a 0.47
'     (ventana que termina en 2026) -- caida grande y sostenida
'   R9_ftamn:   de 1.29 a 1.86 -- se acentua el "sobre-traspaso"
'     (beta1>1) hacia el final de la muestra
'   R5_corp_lp: pasa cerca de 0 en alguna ventana intermedia (min=-0.00)
'     -- consistente con ser la serie de traspaso mas fragil en toda
'     la Pregunta 1 y 2
' El grafico de estas 9 series de beta1 rodante (una por panel, igual
' esquema que Graficos 1-2) es, para nosotros, la pieza mas persuasiva de
' toda esta extension: mucho mas intuitivo para un lector que una
' tabla de estadisticos F.

graph gr_roll_R1_pref90.line v_beta1_R1_pref90
graph gr_roll_R2_corp_cp.line v_beta1_R2_corp_cp
graph gr_roll_R3_ge_cp.line v_beta1_R3_ge_cp
graph gr_roll_R4_me_cp.line v_beta1_R4_me_cp
graph gr_roll_R5_corp_lp.line v_beta1_R5_corp_lp
graph gr_roll_R6_ge_lp.line v_beta1_R6_ge_lp
graph gr_roll_R7_me_lp.line v_beta1_R7_me_lp
graph gr_roll_R8_tamn.line v_beta1_R8_tamn
graph gr_roll_R9_ftamn.line v_beta1_R9_ftamn

graph GRAFICO_ROLLING.merge gr_roll_R1_pref90 gr_roll_R2_corp_cp gr_roll_R3_ge_cp gr_roll_R4_me_cp gr_roll_R5_corp_lp gr_roll_R6_ge_lp gr_roll_R7_me_lp gr_roll_R8_tamn gr_roll_R9_ftamn
GRAFICO_ROLLING.align(3,3)
show GRAFICO_ROLLING

' ============================================================
' SECCION 8: FASE 2 -- ANALISIS DE ROBUSTEZ, SUBMUESTRA
' PRE-PANDEMIA (2010m08-2020m02). Complementa la Seccion 6/7 con un
' segundo enfoque para el mismo problema: repetimos TODO el analisis
' (no solo el traspaso) restringiendo la muestra al ultimo mes completo
' antes del estado de emergencia por COVID-19 en Peru (2020m02). Donde
' la Seccion 6 busca el quiebre estadisticamente (sup-F/Quandt-Andrews)
' sin asumir una fecha de antemano, aqui usamos un corte fijo con
' justificacion economica directa (el inicio de la pandemia), mucho mas
' facil de explicar a un lector no tecnico -- las dos vias son
' complementarias. Tambien incorporamos aqui el bucle de seleccion
' automatica de rezagos por Schwarz para Johansen, y el calculo
' explicito de "r" y "prob" en los Graficos 1-2.
'
' Tambien confirmamos en EViews real que el test de Johansen SI se
' puede correr por linea de comandos sin abrir el dialogo, siempre que
' se llame como VISTA de un objeto VAR/VEC ya creado (sintaxis
' "vec_objeto.coint(c, rezago_lo, rezago_hi)", con "c" = Caso
' 3/unrestricted constant y "b" = Caso 2/restricted constant como
' codigo de tendencia) -- distinto de lo que probamos en la Seccion 3
' (".coint()" sobre un GROUP, no sobre un VAR/VEC, que fallaba con
' "COINT command requires trend specification option"). No lo volvemos
' a probar por el tiempo que queda antes de la entrega, pero lo dejamos
' documentado aqui porque de funcionar reemplazaria el procedimiento
' manual del Anexo B.1 para toda futura extension de este trabajo.
' ============================================================

smpl 2010m08 2020m02

' --- 8.1 Graficos 1 y 2 (pre-pandemia): ya exportados como
' grafico1_ext_pre.png / grafico2_ext_pre.png (Anexo, figures/) -- no
' los regeneramos aqui, solo calculamos r y prob para que quede en el
' .prg el mismo numero que aparece en el documento.
for %s R1_pref90 R2_corp_cp R3_ge_cp R4_me_cp R5_corp_lp R6_ge_lp R7_me_lp R8_tamn R9_ftamn
  scalar r_{%s}_pre = @cor(RP_ref,{%s})
  scalar n_{%s}_pre = @obs({%s})
  scalar t_{%s}_pre = r_{%s}_pre*@sqrt(n_{%s}_pre-2)/@sqrt(1-r_{%s}_pre^2)
  scalar prob_{%s}_pre = 2*(1-@ctdist(@abs(t_{%s}_pre),n_{%s}_pre-2))
next

' Verificado en EViews real (114 obs., ago.2010-feb.2020):
'   R1=0.879(p=0.000) R2=0.899(p=0.000) R3=0.771(p=0.000) R4=0.591(p=3.7E-12)
'   R5=0.320(p=4.9E-04) R6=0.233(p=0.012) R7=0.642(p=1.1E-14) R8=0.709(p=0.000)
'   R9=0.496(p=1.8E-08)
' Frente a la muestra completa (Seccion 1), TAMN y FTAMN correlacionan
' bastante MAS con RP_ref en el periodo pre-pandemia (R8: 0.709 vs 0.371;
' R9: 0.496 vs 0.793 -- este ultimo al reves) -- consistente con que la
' muestra completa esta dominada por el ciclo de alza sincronizado
' 2021-2023, que infla la correlacion lineal simple entre todas las series.

' --- 8.2 Cuadro 2 (pre-pandemia): raiz unitaria, mismo criterio que
' la Seccion 2 (DF-GLS en niveles, ADF sin deterministicos en diferencias)
for %s RP_ref R1_pref90 R2_corp_cp R3_ge_cp R4_me_cp R5_corp_lp R6_ge_lp R7_me_lp R8_tamn R9_ftamn
  freeze(tab_ur_{%s}_pre_niv) {%s}.uroot(dfgls,const,info=sic)
  freeze(tab_ur_{%s}_pre_dif) d_{%s}.uroot(adf,none,info=sic)
next
' (d_{%s} ya existe de la Seccion 2 -- es la misma serie en diferencias,
' solo se reestima la prueba sobre la muestra recortada.)

' --- 8.3 Cuadro 3 (pre-pandemia): cointegracion, con el rezago del VAR
' seleccionado automaticamente por Schwarz en vez de fijarlo a mano --
' reemplaza nuestra propia tabla "N calibrado por serie" de la Seccion
' 3, pero SOLO para esta submuestra (dejamos la Seccion 3 de muestra
' completa tal como esta, ya verificada).
!maxlag_pre = 12
for %s R1_pref90 R2_corp_cp R3_ge_cp R4_me_cp R5_corp_lp R6_ge_lp R7_me_lp R8_tamn R9_ftamn

  equation eq_fmols_{%s}_pre.cointreg(method=fmols,trend=c) {%s} RP_ref
  eq_fmols_{%s}_pre.makeresid u_{%s}_pre
  freeze(tab_eg_{%s}_pre) u_{%s}_pre.uroot(adf,none,info=sic)

  group gv_{%s}_pre {%s} RP_ref
  scalar bestsc_{%s}_pre = na
  scalar bestlag_{%s}_pre = 1
  for !k = 1 to !maxlag_pre
    var vartmp.ls 1 !k gv_{%s}_pre
    scalar sc_now = vartmp.@schwarz
    if @isna(bestsc_{%s}_pre) or sc_now < bestsc_{%s}_pre then
      bestsc_{%s}_pre = sc_now
      bestlag_{%s}_pre = !k
    endif
    delete vartmp
  next
  scalar rezagos_{%s}_pre = bestlag_{%s}_pre

  !difhigh_pre = bestlag_{%s}_pre - 1
  if !difhigh_pre < 1 then
    !difhigh_pre = 1
  endif

  ' Caso 3 (unrestricted constant) -- especificacion principal para
  ' esta submuestra de Pregunta 2, distinta del Caso 2 que usamos en la
  ' Seccion 3/5 de muestra completa (ver nota de reconciliacion en
  ' content.tex, Seccion 2.2: mantenemos Caso 2 como el caso PRINCIPAL
  ' de todo este trabajo porque es el que reproduce EXACTO los 18
  ' valores del Cuadro 3 del paper en la Pregunta 1 -- pero reportamos
  ' aqui el Caso 3 integro, tal como lo verificamos, como pieza de
  ' evidencia adicional sobre la submuestra pre-pandemia).
  var vec_{%s}_pre.ec(1) 1 !difhigh_pre gv_{%s}_pre
  freeze(tab_joh_{%s}_pre_c3) vec_{%s}_pre.coint(c, 1 !difhigh_pre)

  ' Caso 2 (restricted constant), mismo rezago, como robustez adicional
  var vec_{%s}_c2_pre.ec(1,b) 1 !difhigh_pre gv_{%s}_pre
  freeze(tab_joh_{%s}_pre_c2) vec_{%s}_c2_pre.coint(b, 1 !difhigh_pre)
next

' Verificado en EViews real -- rezagos por Schwarz
' (114 obs.): R1=3 R2=3 R3=3 R4=4 R5=1 R6=4 R7=4 R8=3 R9=3
' Traza Johansen H0:r=0 (Caso3 / Caso2):
'   R1: 14.49/0.070  15.14->NO, R1=14.49(p=0.070) / 14.80(p=0.238)
'   R2: 12.48(p=0.135) / 12.75(p=0.384)
'   R3: 7.98(p=0.467) / 8.23(p=0.805)
'   R4: 15.17(p=0.056) / 15.94(p=0.177)
'   R5: 32.48(p=0.0001) / 33.07(p=0.0005)
'   R6: 21.74(p=0.0050) / 23.93(p=0.0149)
'   R7: 8.85(p=0.379) / 11.10(p=0.533)
'   R8: 10.61(p=0.236) / 12.13(p=0.437)
'   R9: 6.98(p=0.580) / 7.38(p=0.872)
' Con una muestra mas corta (114 obs. vs 191), la potencia del test cae:
' R2,R3,R7,R8,R9 dejan de rechazar H0 al 5% bajo ambos casos, cuando
' algunas si rechazaban en la muestra completa -- esperable, no es un
' error, es perdida de poder estadistico por tener menos datos.

' --- 8.4 Cuadro 4 (pre-pandemia): MCE lineal, mismo enfoque general de
' la Seccion 4 pero con una especificacion simple comun
' (c, ECT(-1), d(RP) contemporaneo, d(Ri)(-1)) en vez de la poda
' especifica por serie -- dejamos ambas visibles porque cada una
' responde a un objetivo distinto (la de la Seccion 4 busca el modelo
' parsimonioso optimo por serie; esta busca comparabilidad directa
' entre muestra completa y pre-pandemia con la MISMA especificacion en
' los dos casos).
for %s R1_pref90 R2_corp_cp R3_ge_cp R4_me_cp R5_corp_lp R6_ge_lp R7_me_lp R8_tamn R9_ftamn
  equation eq_mce_{%s}_pre.ls d({%s}) c u_{%s}_pre(-1) d(RP_ref) d({%s}(-1))
  scalar beta1_{%s}_pre  = eq_fmols_{%s}_pre.@coefs(1)
  scalar alpha_{%s}_pre  = eq_mce_{%s}_pre.@coefs(2)
  scalar theta0_{%s}_pre = eq_mce_{%s}_pre.@coefs(3)
  scalar promedio_{%s}_pre = -(beta1_{%s}_pre-theta0_{%s}_pre)/(beta1_{%s}_pre*alpha_{%s}_pre)
next

' Verificado en EViews real (114 obs.), beta1(SE) / alpha(SE) / Promedio:
'   R1: 0.855(0.088) / -0.146(0.040) / 0.77    R2: 1.057(0.096) / -0.136(0.032) / 5.05
'   R3: 0.665(0.078) / -0.200(0.032) / 4.30    R4: 0.452(0.087) / -0.234(0.047) / 3.30
'   R5: 0.297(0.111) / -0.052(0.018) / 17.02   R6: 0.176(0.101) / -0.068(0.015) / 7.00
'   R7: 0.485(0.118) / -0.031(0.025,NO sig.) / 21.76 (fragil, alpha no significativo)
'   R8: 1.927(0.340) / -0.024(0.019,NO sig.) / 37.70 (fragil, alpha no significativo)
'   R9: 0.959(0.310) / -0.222(0.064) / 4.46

' --- 8.5 Cuadro 5 (pre-pandemia): VECM, Caso 3 principal + Caso 2
' robustez, reutilizando vec_{%s}_pre / vec_{%s}_c2_pre ya estimados en
' 8.3 -- mismo principio de "no re-estimar el mismo sistema dos veces"
' aplicado en el resto de este archivo.
for %s R1_pref90 R2_corp_cp R3_ge_cp R4_me_cp R5_corp_lp R6_ge_lp R7_me_lp R8_tamn R9_ftamn
  freeze(tab_vec_{%s}_pre_c3) vec_{%s}_pre.output
  freeze(tab_vec_{%s}_pre_c2) vec_{%s}_c2_pre.output
next

' Verificado en EViews real -- beta1/alpha (Caso3):
'   R1: 0.689/-0.132  R2: 0.922/-0.099  R3: 0.728/-0.075  R4: 0.358/-0.194
'   R5: 0.684/-0.065  R6: 0.139/-0.057  R7: 1.035/-0.029  R8: 2.397/-0.034
'   R9: 1.415/-0.145
' *** HALLAZGO CLAVE, cruzado con la Seccion 6: en esta submuestra
' pre-pandemia, R6 (beta1=0.139) y R7 (beta1=1.035) recuperan signo
' correcto y magnitud economicamente sensata -- muy distinto del
' patron "roto" que ambas dan en el VECM de muestra completa (R6: b1=
' -3.55 a -12.8 segun el caso; R7: b1=-6.66, ver Seccion 5). Esto
' confirma, por una via completamente independiente (un corte de
' muestra fijo por fecha de pandemia, no un sup-F estimado), el mismo
' diagnostico que documentamos en la Seccion 6: la inestabilidad de R6
' y R7 en el VECM de muestra completa es real y esta ligada a la
' pandemia/ciclo de alza 2021-2023, no es un artefacto del analisis de
' quiebre. Dos metodologias distintas (sup-F propio vs. corte fijo por
' fecha de pandemia) llegando a la misma conclusion es la evidencia mas
' solida que tenemos en todo este trabajo de que el hallazgo de R6/R7
' es real.

smpl @all

save tasas_interes_lahura2017_ext_resultados
' ============================================================
' FIN. Datos: data/tasas_interes_lahura2017_ext.xlsx (191 obs.,
' descargado con data/bcrp_series_p2.py). Todos los numeros citados en
' los comentarios de este archivo fueron calculados y verificados en
' Python sobre exactamente estos mismos datos antes de escribir el
' codigo EViews de arriba -- pendiente de una corrida real en EViews
' para confirmacion final si el tiempo antes de la entrega lo permite.
' La Seccion 8 (submuestra pre-pandemia) esta integrada aqui con la
' nomenclatura de series de todo el archivo; sus numeros estan
' confirmados en EViews real (ver el informe complementario,
' Pregunta2_Informe.tex/pdf), no simulados en Python como el resto de
' este archivo.
' ============================================================
