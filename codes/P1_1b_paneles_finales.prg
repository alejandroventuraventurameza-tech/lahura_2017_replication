' ============================================================
' PREGUNTA 1.1 - PARTE B: paneles combinados finales
' Correr DESPUES de:
'   1) Haber corrido P1_1a_correlaciones_graficos.prg
'   2) Haber ajustado a mano la escala de los 9 graficos individuales
'      (ejes, dual axis, overlap - ver instrucciones al final de la
'      Parte A)
' ============================================================

' ------------------------------------------------------------
' 3) Paneles combinados, replicando el layout del paper:
'    Grafico 1 (a-f): prestamos corporativos, GE y ME, corto y largo plazo
'    Grafico 2 (a-c): preferencial 90d, TAMN, FTAMN
' ------------------------------------------------------------

graph GRAFICO_1.merge gr_corp_cp gr_corp_lp gr_ge_cp gr_ge_lp gr_me_cp gr_me_lp
GRAFICO_1.align(3,2)
show GRAFICO_1

graph GRAFICO_2.merge gr_pref90 gr_tamn gr_ftamn
GRAFICO_2.align(3,1)
show GRAFICO_2

' ============================================================
' Con esto ya tienes: (a) tab_corr_activas con los r y prob de las 9
' tasas activas (de la Parte A), y (b) GRAFICO_1 / GRAFICO_2 con los
' 9 paneles ya con la escala ajustada, igual que el paper.
' El resto de este archivo es opcional / cosmetico.
' ============================================================

' ------------------------------------------------------------
' 4) OPCIONAL - anotar r y prob directamente sobre cada panel
'    (para que se vea igual al paper, que imprime "r=.., prob=.."
'    dentro de cada grafico). Si esta seccion da error, borrala:
'    no afecta nada de lo generado arriba, es solo estetica.
' ------------------------------------------------------------

' NOTA: ".addtext" no evalua expresiones ("texto" + @str(...) + "texto")
' pasadas directo como argumento -- las toma como texto literal. Por eso
' el string se arma antes en una variable %macro (eso si evalua @str/+),
' y recien ahi se pasa con {%nombre}.
'
' CORRECCION 2: @str(x,"%.2f") tira error ("Bad number format %.3f").
' El codigo de formato tipo C (%.2f) no es el que usa EViews -- y el
' codigo real (@str usa algo tipo "f.2") esta documentado solo en el
' "Command and Programming Reference", que no esta en ninguna de mis
' dos guias (confirmado, lo busque en las dos). Para no arriesgar otro
' codigo de formato sin verificar, redondeo el numero primero con
' aritmetica simple (@round) y despues uso @str(x) SIN argumento de
' formato -- esa forma de un solo argumento es basica y segura.

for %s R2_corp_cp R5_corp_lp R3_ge_cp R6_ge_lp R4_me_cp R7_me_lp R1_pref90 R8_tamn R9_ftamn
  scalar r2_{%s}    = @round(r_{%s}*100)/100
  scalar prob3_{%s} = @round(prob_{%s}*1000)/1000
next

%t_corp_cp  = "Corporativa <=360d:  r=" + @str(r2_R2_corp_cp) + "  prob=" + @str(prob3_R2_corp_cp)
gr_corp_cp.addtext(t) {%t_corp_cp}

%t_corp_lp  = "Corporativa >360d:  r=" + @str(r2_R5_corp_lp) + "  prob=" + @str(prob3_R5_corp_lp)
gr_corp_lp.addtext(t) {%t_corp_lp}

%t_ge_cp    = "Grandes Emp. <=360d:  r=" + @str(r2_R3_ge_cp) + "  prob=" + @str(prob3_R3_ge_cp)
gr_ge_cp.addtext(t) {%t_ge_cp}

%t_ge_lp    = "Grandes Emp. >360d:  r=" + @str(r2_R6_ge_lp) + "  prob=" + @str(prob3_R6_ge_lp)
gr_ge_lp.addtext(t) {%t_ge_lp}

%t_me_cp    = "Medianas Emp. <=360d:  r=" + @str(r2_R4_me_cp) + "  prob=" + @str(prob3_R4_me_cp)
gr_me_cp.addtext(t) {%t_me_cp}

%t_me_lp    = "Medianas Emp. >360d:  r=" + @str(r2_R7_me_lp) + "  prob=" + @str(prob3_R7_me_lp)
gr_me_lp.addtext(t) {%t_me_lp}

%t_pref90   = "Preferencial 90d:  r=" + @str(r2_R1_pref90) + "  prob=" + @str(prob3_R1_pref90)
gr_pref90.addtext(t) {%t_pref90}

%t_tamn     = "TAMN:  r=" + @str(r2_R8_tamn) + "  prob=" + @str(prob3_R8_tamn)
gr_tamn.addtext(t) {%t_tamn}

%t_ftamn    = "FTAMN:  r=" + @str(r2_R9_ftamn) + "  prob=" + @str(prob3_R9_ftamn)
gr_ftamn.addtext(t) {%t_ftamn}

' Si quiero que las anotaciones aparezcan tambien en los paneles
' combinados, tengo que volver a correr el bloque 3 (merge + align +
' show) de arriba despues de este bloque 4.

' ============================================================
' NOTA DE CONFIABILIDAD:
' - graph.merge / .align: confirmadas -- me corrieron bien al probarlas,
'   y equivalen exactamente a "Combining Graphs" de la Guide I
'   (Cap. 16): seleccionar varios graficos + combinar.
' - .addtext: confirmada, con la correccion del macro (%texto) para
'   que evalue @str/+ antes de pasarlo como argumento, Y la correccion
'   del formato de @str (sin argumento de formato tipo "%.2f", que no
'   es sintaxis de EViews; en su lugar, redondeo con @round primero).
' - Escala de ejes / dual scale / overlap: no tiene sintaxis de codigo
'   verificada en ninguna de las dos guias que tienes (son puramente
'   GUI en la documentacion). Por eso se hace a mano, en la Parte A.
' =================================================