' ============================================================
' PREGUNTA 1.1 - PARTE A: correlaciones + los 9 graficos individuales
' Replica de los Graficos 1 y 2 de Lahura (2017)
'
' FLUJO EN 2 CORRIDAS (para poder editar los ejes a mano en el medio):
'   1a. Corre ESTE archivo primero.
'   2.  En EViews, ajusto manualmente la escala de los 9 graficos
'       individuales (mismo procedimiento que vengo usando: Series axis
'       assignment -> Right, Min/Max por eje, Overlap scales).
'   1b. Corre P1_1b_paneles_finales.prg para armar y mostrar los
'       paneles combinados GRAFICO_1 / GRAFICO_2 con los ejes ya
'       corregidos.
'
' PRERREQUISITO (hacer en EViews antes de correr este programa):
'   File > Open > Foreign Data as Workfile...
'   Archivo      : tasas_interes_lahura2017.xlsx  (carpeta ef_pucp/data)
'   Hoja         : tasas_bcrp
'   Identificador de fecha : columna "fecha" (formato 2010m08, ..., 2017m05)
'   Frecuencia   : Mensual -> EViews debe reconocer el rango solo:
'                  2010m08 2017m05  (82 obs.)
'   Nombres de series (primera fila = encabezados): se importan tal
'   cual estan en el Excel: R1_pref90 ... R17_ftipmn, RP_ref, R_interbank
'
' Para la Pregunta 1 solo se usan las 9 tasas ACTIVAS + RP_ref.
' (R10...R17 y R_interbank quedan en el workfile para la Pregunta 2,
'  que extiende el analisis a las tasas pasivas - no es parte de nuestra
'  entrega.)
' ============================================================

smpl 2010m08 2017m05

' ------------------------------------------------------------
' 1) Correlaciones r(Ri,RP) y su significancia (prob), para las
'    9 tasas activas, via regresion simple Ri = c + b*RP + u.
'    r = signo(b) * raiz(R2);  prob = p-valor de b
'    (identico al test de significancia de la correlacion de Pearson)
' ------------------------------------------------------------

for %s R1_pref90 R2_corp_cp R3_ge_cp R4_me_cp R5_corp_lp R6_ge_lp R7_me_lp R8_tamn R9_ftamn
  equation eq_{%s}.ls {%s} c RP_ref
  scalar r_{%s}    = @sign(eq_{%s}.@coefs(2)) * @sqrt(eq_{%s}.@r2)
  scalar prob_{%s} = eq_{%s}.@pvals(2)
next

' Tabla-resumen de correlaciones (equivalente a los valores "r" y "prob"
' que el paper muestra dentro de cada panel de los Graficos 1 y 2)
' NOTA: los objetos "table" en EViews se llenan por indexacion directa
' tabla(fila,columna) = valor -- no existe un metodo/vista ".setcell".
table(10,3) tab_corr_activas
tab_corr_activas(1,1) = "Tasa activa"
tab_corr_activas(1,2) = "r"
tab_corr_activas(1,3) = "prob"

tab_corr_activas(2,1) = "R1 Preferencial 90d"
tab_corr_activas(2,2) = r_R1_pref90
tab_corr_activas(2,3) = prob_R1_pref90
tab_corr_activas(3,1) = "R2 Corporativa <=360d"
tab_corr_activas(3,2) = r_R2_corp_cp
tab_corr_activas(3,3) = prob_R2_corp_cp
tab_corr_activas(4,1) = "R3 Grandes Emp. <=360d"
tab_corr_activas(4,2) = r_R3_ge_cp
tab_corr_activas(4,3) = prob_R3_ge_cp
tab_corr_activas(5,1) = "R4 Medianas Emp. <=360d"
tab_corr_activas(5,2) = r_R4_me_cp
tab_corr_activas(5,3) = prob_R4_me_cp
tab_corr_activas(6,1) = "R5 Corporativa >360d"
tab_corr_activas(6,2) = r_R5_corp_lp
tab_corr_activas(6,3) = prob_R5_corp_lp
tab_corr_activas(7,1) = "R6 Grandes Emp. >360d"
tab_corr_activas(7,2) = r_R6_ge_lp
tab_corr_activas(7,3) = prob_R6_ge_lp
tab_corr_activas(8,1) = "R7 Medianas Emp. >360d"
tab_corr_activas(8,2) = r_R7_me_lp
tab_corr_activas(8,3) = prob_R7_me_lp
tab_corr_activas(9,1) = "R8 TAMN"
tab_corr_activas(9,2) = r_R8_tamn
tab_corr_activas(9,3) = prob_R8_tamn
tab_corr_activas(10,1) = "R9 FTAMN"
tab_corr_activas(10,2) = r_R9_ftamn
tab_corr_activas(10,3) = prob_R9_ftamn

show tab_corr_activas

' ------------------------------------------------------------
' 2) Graficos individuales (RP_ref vs. cada tasa activa)
'    Bloque "nucleo": solo .line (vista basica de EViews, sin riesgo).
'    EViews muestra leyenda automaticamente en graficos de grupo.
' ------------------------------------------------------------

group gg_corp_cp RP_ref R2_corp_cp
graph gr_corp_cp.line gg_corp_cp

group gg_corp_lp RP_ref R5_corp_lp
graph gr_corp_lp.line gg_corp_lp

group gg_ge_cp RP_ref R3_ge_cp
graph gr_ge_cp.line gg_ge_cp

group gg_ge_lp RP_ref R6_ge_lp
graph gr_ge_lp.line gg_ge_lp

group gg_me_cp RP_ref R4_me_cp
graph gr_me_cp.line gg_me_cp

group gg_me_lp RP_ref R7_me_lp
graph gr_me_lp.line gg_me_lp

group gg_pref90 RP_ref R1_pref90
graph gr_pref90.line gg_pref90

group gg_tamn RP_ref R8_tamn
graph gr_tamn.line gg_tamn

group gg_ftamn RP_ref R9_ftamn
graph gr_ftamn.line gg_ftamn

' ============================================================
' FIN DE LA PARTE A. El programa se detiene aca a proposito.
'
' SIGUIENTE PASO (manual, en EViews, antes de correr la Parte B):
' Para cada uno de estos 9 graficos:
'   gr_corp_cp, gr_corp_lp, gr_ge_cp, gr_ge_lp, gr_me_cp, gr_me_lp,
'   gr_pref90, gr_tamn, gr_ftamn
'
' 1. Doble clic sobre la linea naranja (tasa de mercado) -> Graph Options
' 2. Axes & Scaling -> Data scaling
'    a) Series axis assignment: clic en fila "2" -> marcar "Right" -> Apply
'    b) Edit axis = "Left Axis" -> Left axis scale endpoints:
'       dropdown "User specified" -> Min = 2, Max = 5 -> Apply
'    c) Edit axis = "Right Axis" -> Right axis scale endpoints:
'       dropdown "User specified" -> Min/Max segun tabla:
'         gr_corp_cp : 3.0 / 6.5      gr_ge_lp  : 5.5  / 8.0
'         gr_corp_lp : 4.8 / 7.2      gr_me_cp  : 8.0  / 11.0
'         gr_ge_cp   : 4.4 / 7.6      gr_me_lp  : 9.6  / 11.6
'         gr_pref90  : 3.2 / 6.0      gr_tamn   : 15   / 20
'         gr_ftamn   : 18  / 24
'       -> Apply
'    d) Dual axis scaling -> "Overlap scales (lines cross)" -> Apply
' 3. OK para cerrar ese grafico. Repetir con el siguiente.
'
' Cuando termines los 9, corre P1_1b_paneles_finales.prg.
' =======================================================