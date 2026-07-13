' ============================================================
' PREGUNTA 1.2 - PARTE B: Cuadro 3, prueba de cointegracion
' Engle-Granger (columna izquierda del Cuadro 3 del paper)
' Solo tasas ACTIVAS (9 pares con RP_ref)
'
' Metodologia (igual a la nota del Cuadro 3 del paper):
'   1) Estimar el vector de cointegracion Ri = b0 + b1*RP + u
'      por FMOLS (Phillips y Hansen, 1990).
'   2) Prueba de cointegracion Engle-Granger (1987) sobre esa
'      misma ecuacion, con REZAGO FIJO especifico por serie (el
'      paper NO usa seleccion automatica -- confirmado al validar
'      R1_pref90: con lag=8 fijo el z-statistic da prob=0.0003,
'      que coincide con el 0.000 del Cuadro 3; con seleccion
'      automatica por Schwarz daba lag=0 y prob=0.289, que NO
'      coincide). Los 9 rezagos son los que reporta el propio
'      Cuadro 3 del paper.
'   3) Se reporta el z-statistic (MacKinnon, 1996), que es el que
'      usa el paper (no el tau-statistic).
'
' PRERREQUISITO: mismo workfile de 1.1/1.2a ya abierto
' ============================================================

smpl 2010m08 2017m05

' ------------------------------------------------------------
' Paso 1: vector de cointegracion por FMOLS para las 9 tasas
' activas (constante como unico determinista, igual que el
' paper: Ri = b0 + b1*RP + u). Esto SI puede ir en loop, porque
' la especificacion es identica para las 9 series.
' ------------------------------------------------------------
for %s R1_pref90 R2_corp_cp R3_ge_cp R4_me_cp R5_corp_lp R6_ge_lp R7_me_lp R8_tamn R9_ftamn
  equation eq_fmols_{%s}.cointreg(method=fmols,trend=c) {%s} RP_ref
next

' ------------------------------------------------------------
' Paso 2: prueba de cointegracion Engle-Granger, CON REZAGO FIJO
' por serie (no puede ir en un solo loop porque cada serie tiene
' un rezago distinto, tal como reporta el Cuadro 3 del paper).
' Sintaxis CONFIRMADA por prueba directa en tu EViews:
'   .coint(method=eg, lag=N)
' (validado exacto contra R1_pref90: z-statistic=-37.43798,
' prob=0.0003, "Fixed lag specification (lag=8)")
' ------------------------------------------------------------
freeze(tab_eg_R1_pref90) eq_fmols_R1_pref90.coint(method=eg, lag=8)
freeze(tab_eg_R2_corp_cp) eq_fmols_R2_corp_cp.coint(method=eg, lag=12)
freeze(tab_eg_R3_ge_cp)   eq_fmols_R3_ge_cp.coint(method=eg, lag=8)
freeze(tab_eg_R4_me_cp)   eq_fmols_R4_me_cp.coint(method=eg, lag=1)
freeze(tab_eg_R5_corp_lp) eq_fmols_R5_corp_lp.coint(method=eg, lag=8)
freeze(tab_eg_R6_ge_lp)   eq_fmols_R6_ge_lp.coint(method=eg, lag=9)
freeze(tab_eg_R7_me_lp)   eq_fmols_R7_me_lp.coint(method=eg, lag=1)
freeze(tab_eg_R8_tamn)    eq_fmols_R8_tamn.coint(method=eg, lag=4)
freeze(tab_eg_R9_ftamn)   eq_fmols_R9_ftamn.coint(method=eg, lag=7)

' ============================================================
' Resultado: por cada una de las 9 tasas activas tienes:
'   EQ_FMOLS_<serie>  -> ecuacion de cointegracion FMOLS
'   TAB_EG_<serie>    -> tabla Engle-Granger con tau-statistic Y
'                        z-statistic (con sus p-valores). El
'                        z-statistic y su Prob. son los numeros
'                        que van en el Cuadro 3.
'
' VALORES OBJETIVO DEL PAPER (Cuadro 3, prob. del z-statistic,
' H0: no cointegracion):
'   R1_pref90=0.000 (lag=8)   R6_ge_lp  =0.707 (lag=9)
'   R2_corp_cp=0.000 (lag=12) R7_me_lp  =0.837 (lag=1)
'   R3_ge_cp  =0.230 (lag=8)  R8_tamn   =0.611 (lag=4)
'   R4_me_cp  =0.004 (lag=1)  R9_ftamn  =0.175 (lag=7)
'   R5_corp_lp=0.350 (lag=8)
'
' NOTA DE CONFIABILIDAD:
' - .cointreg(method=fmols,trend=c): confirmado como comando real
'   (Guide II, cap. 28, pag. 296); ya corrio sin error en tu
'   EViews en las pruebas anteriores.
' - .coint(method=eg, lag=N): CONFIRMADO por prueba directa tuya
'   en EViews (no es un comando documentado en la Guide II, que
'   solo muestra la ruta GUI -- pero replicamos exacto el mismo
'   resultado que arroja el dialogo View/Cointegration Test con
'   Test Method=Engle-Granger y Lag method=Fixed(User-specified),
'   asi que la sintaxis esta verificada empiricamente, no es una
'   suposicion).
' - Los 9 rezagos (8,12,8,1,8,9,1,4,7) son los que reporta el
'   propio Cuadro 3 del paper -- no son estimados por nosotros.
' ============================================================
