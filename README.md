# Réplica de Lahura (2017)

Réplica y extensión de Erick Lahura (2017), *"El efecto traspaso de la tasa de interés de
política monetaria en Perú: Evidencia reciente"* (Revista Estudios Económicos 33, BCRP)

El documento final (`template/content.tex`, compilado en Overleaf) es la fuente de verdad
del trabajo. Este README resume su contenido y el estado de cada resultado para que pueda
seguirse sin necesidad de compilar el PDF.

## Qué hace este proyecto

Lahura (2017) estima el *pass-through* de la tasa de interés de política monetaria del BCRP
hacia 9 tasas de interés activas del sistema bancario peruano, usando modelos de corrección
de errores (MCE) lineales y no lineales, bajo dos enfoques: uniecuacional (FMOLS + MCE) y
multiecuacional (VAR cointegrado / Johansen). La Pregunta 1 del examen pide replicar los
Gráficos 1–2 y los Cuadros 2–5 del paper (agosto 2010 – mayo 2017); la Pregunta 2 pide
extender esa réplica (sin el MCE no lineal) a una muestra más reciente.

## Estructura del repositorio

```
ef_pucp/
├── template/
│   ├── content.tex           documento principal (LaTeX)
│   ├── referencias.bib       bibliografía (BibLaTeX, estilo APA 7)
│   └── figures/
│       ├── grafico1.png      réplica del Gráfico 1 del paper
│       └── grafico2.png      réplica del Gráfico 2 del paper
├── codes/                    11 scripts EViews, uno por cuadro/paso (ver Anexo A del documento)
│   ├── P1_1a_correlaciones_graficos.prg
│   ├── P1_1b_paneles_finales.prg
│   ├── P1_2a_cuadro2_raizunitaria.prg
│   ├── P1_2b_cuadro3_englegranger.prg
│   ├── P1_2c_cuadro3_resumen.prg
│   ├── P1_3a_cuadro4_mce_lineal.prg
│   ├── P1_3b_cuadro4_resumen.prg
│   ├── P1_3c_cuadro4_mce_no_lineal.prg
│   ├── P1_4a_cuadro5_var_johansen.prg
│   ├── P1_4b_cuadro5_resumen.prg
│   └── P1_4c_cuadro5_mce_no_lineal.prg
├── data/
│   ├── bcrp_series.ipynb                     script de descarga de datos (API BCRP)
│   ├── tasas_interes_lahura2017.xlsx / .csv  panel exportado, listo para EViews
│   ├── tasas_interes_lahura2017.wf1          workfile de EViews
│   ├── BCRPData-metadata-*.csv               catálogo de series BCRP (verificación de códigos)
│   └── historico_bcrp/                       tablas BCRP históricas (verificación de vintage TAMN)
├── nota_semanal/                             5 Notas Semanales BCRP (verificación de vintage TAMN)
├── referencias_pdf/                          [solo local, excluido de GitHub — ver .gitignore]
│                                              paper de Lahura + 3 fuentes metodológicas citadas
│                                              (Heffernan 1997, Sander-Kleimeier 2004, Hofmann-Mizen
│                                              2004) + PDF del enunciado del examen
├── .gitignore
└── README.md                                 este archivo
```

`codes/` debe mantenerse como carpeta hermana de `template/`: `content.tex` referencia los
11 `.prg` con rutas relativas (`../codes/...`) y las dos figuras con rutas relativas dentro
de `template/figures/`. Si se sube a Overleaf, hay que replicar exactamente esta jerarquía
de carpetas o la compilación falla con "File not found".

`referencias_pdf/` y el PDF del examen se excluyen del repositorio de GitHub (ver
`.gitignore`) por dos razones: los artículos académicos tienen copyright de terceros
(Econometrica, Economica, Journal of International Money and Finance), y el enunciado del
examen no debería quedar público por si el profesor lo reutiliza en otro semestre. Ambos se
conservan solo en la copia local del proyecto, con nomenclatura `Apellido_NombreDelPaper`.
`nota_semanal/` y `data/historico_bcrp/` tampoco se suben (material voluminoso de una
verificación puntual ya documentada en el Anexo C del PDF, no esencial para reproducir los
resultados principales).

## Datos

Fuente: API pública de BCRPData (`https://estadisticas.bcrp.gob.pe/estadisticas/series/api/`),
descargada serie por serie (nunca varias series en una sola URL, por un bug de orden
documentado de esa API) con `data/bcrp_series.ipynb`. Muestra: agosto 2010 – mayo 2017
(82 observaciones mensuales, sin datos faltantes), igual que Lahura (2017, p. 11).

Códigos de serie usados en la réplica (Cuadro 29 de la Nota Semanal del BCRP):

| Variable | Descripción | Código BCRP |
|---|---|---|
| R1 | Preferencial corporativa a 90 días | `PN07809NM` |
| R2 | Corporativa ≤360 días | `PN07801NM` |
| R3 | Grandes Empresas ≤360 días | `PN07802NM` |
| R4 | Medianas Empresas ≤360 días | `PN07803NM` |
| R5 | Corporativa >360 días | `PN07804NM` |
| R6 | Grandes Empresas >360 días | `PN07805NM` |
| R7 | Medianas Empresas >360 días | `PN07806NM` |
| R8 | TAMN | `PN07807NM` |
| R9 | FTAMN | `PN07808NM` |
| RP | Tasa de referencia de política monetaria | `PD04722MM` |

El notebook también descarga, para uso futuro (no usado en esta réplica), las 8 tasas
pasivas R10–R17 y la tasa interbancaria del Cuadro 1 del paper (19 series en total).

## Metodología (resumen)

1. **Cuadro 2** — Raíz unitaria: DF-GLS en niveles, ADF en primeras diferencias, rezagos por
   criterio de Schwarz.
2. **Cuadro 3** — Cointegración: Engle-Granger sobre el residuo FMOLS y Johansen (traza),
   ambos frente a la tasa de política.
3. **Cuadro 4 (uniecuacional, lineal)** — Vector de cointegración por FMOLS
   (Phillips-Hansen 1990) y luego un MCE parsimonioso por MCO/HAC; el número de meses
   promedio hasta el equilibrio usa la fórmula de Hendry (1995):
   `Promedio = -(β1 - θ0) / (β1·α)`.
4. **Cuadro 5 (multiecuacional, lineal)** — Vector de cointegración y MCE estimados
   simultáneamente por máxima verosimilitud (VAR cointegrado / Johansen), con pruebas de
   traspaso completo (β1=1) y exogeneidad débil de la tasa de política.
5. **Cuadros 4' y 5' (no lineal, extra crédito)** — MCE con velocidad de ajuste asimétrica
   según el signo del término de corrección de errores (umbral en cero), estimado por
   MCO/HAC (4') o SUR (5').

El paper no publica el algoritmo exacto de poda "general-a-específico" para llegar a los
modelos parsimoniosos, ni la fórmula exacta del Promedio en el caso no lineal. Donde la
poda manual en EViews no reproducía a la primera los valores publicados, se usó Python
como banco de pruebas (búsqueda combinatoria de especificaciones) antes de confirmar la
especificación ganadora en EViews real — nunca al revés. Detalle completo en el Anexo C
del documento.

## Estado de la réplica

| Bloque | Series exactas | Detalle |
|---|---|---|
| Cuadro 2 (raíz unitaria) | 18/18 valores | Exacto |
| Cuadro 3 (cointegración) | 18/18 valores | Exacto |
| Cuadro 4 (MCE lineal, uniecuacional) | 6/9 series exactas en todos sus valores | Corporativa >360d: Promedio impreso matemáticamente imposible dado el resto de la fila (probable errata, 17.0→7.0); Medianas Empresas >360d: 4 valores primarios exactos, Promedio no reproducible por una razón matemática identificada (θ0 > β1 anula la fórmula de Hendry); TAMN: 6 valores primarios exactos, Promedio (69.2) no reproducido pese a 4 hipótesis descartadas con evidencia (búsqueda de especificación, fórmula general, cita adicional, vintage de datos) |
| Cuadro 5 (VAR cointegrado, lineal) | 9/9 series exactas | Exacto, incluyendo el hallazgo de que el bloque restringido requiere estimación conjunta (SUR), no ecuación por ecuación |
| Cuadro 4' (MCE no lineal, uniecuacional) | 5/5 series replicadas | Grandes Empresas >360d tiene una ambigüedad de fórmula del Promedio identificada y resuelta, documentada en el Anexo A.6 |
| Cuadro 5' (MCE no lineal, multiecuacional) | 0/2 exactas, ambas aproximadas | Grandes/Medianas Empresas ≤360d: α replicado con margen de error acotado (verificado en EViews real vía SUR); Promedio corregido tras detectar que usa la fórmula de Hendry (no -1/α) — ver Anexo C.6 |

En síntesis: de las 4 tablas principales (Cuadros 2–5), 2 replican al 100% y 2 tienen
discrepancias puntuales y documentadas (nunca silenciosas). El extra crédito (Cuadros 4'
y 5') está resuelto en 5 de 7 filas exactas/casi exactas, con las 2 restantes (Cuadro 5')
acotadas y explicadas con margen de error explícito. Cada discrepancia está documentada con su propia línea de investigación en el
Anexo C del documento y en los comentarios del script `.prg` correspondiente — no se deja
ningún resultado sin explicar sin dejar constancia del proceso de verificación.

## Cómo reproducir

1. **Datos:** correr `data/bcrp_series.ipynb` (Python 3, `pandas`/`reques
