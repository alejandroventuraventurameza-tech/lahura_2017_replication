' ============================================================
' PREGUNTA 1.2 - PARTE A: Cuadro 2, pruebas de raiz unitaria
' Replica de Lahura (2017), solo tasas ACTIVAS + tasa de politica
'
' Especificacion (igual al paper, Cuadro 2 y su nota):
'   Niveles     -> DF-GLS (Elliott, Rothenberg y Stock, 1996),
'                  solo intercepto (sin tendencia), rezagos por
'                  criterio de Schwarz.
'   Diferencias -> ADF, sin componentes deterministicos (ni
'                  intercepto ni tendencia), rezagos por Schwarz.
'
' PRERREQUISITO: mismo workfile de la Pregunta 1.1 ya abierto
'   (tasas_interes_lahura2017.xlsx importado, rango 2010m08 2017m05)
' ============================================================

smpl 2010m08 2017m05

' ------------------------------------------------------------
' Para cada una de las 9 tasas activas + la tasa de politica (10
' series en total, igual que las filas del Cuadro 2 del paper):
'   1) Crea la serie en primeras diferencias.
'   2) "Congela" (freeze) el resultado de la prueba DF-GLS en
'      niveles y de la prueba ADF en diferencias como un objeto
'      tabla en el workfile -- asi queda el output completo de
'      EViews (estadistico, valores criticos, prob.), igual que
'      si lo hicieras a mano por la ventana de cada serie
'      (View / Unit Root Test...).
' ------------------------------------------------------------

for %s R1_pref90 R2_corp_cp R3_ge_cp R4_me_cp R5_corp_lp R6_ge_lp R7_me_lp R8_tamn R9_ftamn RP_ref
  series d_{%s} = d({%s})

  freeze(tab_ur_{%s}_niv) {%s}.uroot(dfgls,const,info=sic)
  freeze(tab_ur_{%s}_dif) d_{%s}.uroot(adf,none,info=sic)
next

' ============================================================
' Resultado: por cada una de las 10 series tienes 2 tablas en el
' workfile: TAB_UR_<serie>_NIV (DF-GLS en niveles) y
' TAB_UR_<serie>_DIF (ADF en diferencias). El "t-Statistic" (o el
' estadistico DF-GLS) y su Prob. de cada tabla son los numeros del
' Cuadro 2.
'
' NOTA DE CONFIABILIDAD:
' - smpl, series, for/next, freeze(): sintaxis basica de EViews,
'   usada ya sin problemas en la Pregunta 1.1.
' - .uroot(dfgls,const,info=sic) / .uroot(adf,none,info=sic): esto
'   NO esta verificado contra tus manuales -- busque en la Guide II
'   (Cap. 42, Unit Root Testing) y solo documenta el dialogo GUI, no
'   la sintaxis de codigo. Los nombres de opcion que use (dfgls, adf,
'   const, none, info=sic) son los que EViews usa de forma estandar y
'   ampliamente documentada en cursos/ejemplos, pero no los pude
'   contrastar linea por linea como el resto. Corre esto primero
'   SOLO y avisame que sale (aunque sea con una sola serie) antes de
'   que sigamos con el Cuadro 3, que tiene comandos mas riesgosos
'   (cointegracion).
' ============================================================
