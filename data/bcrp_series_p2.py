# ============================================================
# Descargador de datos -- Pregunta 2 (extension de la muestra)
# EF PUCP 2026-1
#
# Extiende exactamente el mismo pipeline de bcrp_series.ipynb
# (misma API, mismo principio de "una serie a la vez" para evitar
# el bug de orden del API multi-serie del BCRP) pero hasta el mes
# mas reciente disponible al momento de la descarga (jun-2026),
# en vez de detenerse en may-2017 como la muestra original de
# Lahura (2017). No dependo del archivo cuadro-029.xlsx que
# armaron mis companeras a mano (no lo tengo, y no puedo verificar
# su procedencia) -- prefiero descargar la serie oficial yo mismo,
# con el mismo codigo ya validado en la Pregunta 1.
#
# Muestra: agosto 2010 - junio 2026 (191 observaciones mensuales).
# ============================================================

import os, time
from pathlib import Path
import numpy as np
import pandas as pd
import requests

NOTEBOOK_DIR = Path(os.path.abspath(''))
OUT_XLSX = NOTEBOOK_DIR / 'tasas_interes_lahura2017_ext.xlsx'
OUT_CSV = NOTEBOOK_DIR / 'tasas_interes_lahura2017_ext.csv'

BASE_URL = 'https://estadisticas.bcrp.gob.pe/estadisticas/series/api'
_MESES = {'Ene': 1, 'Feb': 2, 'Mar': 3, 'Abr': 4, 'May': 5, 'Jun': 6,
          'Jul': 7, 'Ago': 8, 'Set': 9, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dic': 12}


def bcrp_una_serie_mensual(codigo, inicio, fin, retries=3):
    """Identica a la funcion de bcrp_series.ipynb (Pregunta 1), con
    un par de reintentos agregados porque la muestra ahora es casi
    2.5x mas larga y prefiero no perder toda la descarga por un
    timeout puntual de un solo request."""
    url = f"{BASE_URL}/{codigo}/json/{inicio}/{fin}"
    for intento in range(retries):
        try:
            resp = requests.get(url, timeout=30)
            resp.raise_for_status()
            data = resp.json()
            break
        except Exception:
            if intento == retries - 1:
                raise
            time.sleep(2)
    if not data.get('periods'):
        raise ValueError(f'API sin datos para {codigo}. URL: {url}')
    fechas, valores = [], []
    for p in data['periods']:
        mes_str, yr_str = p['name'].split('.')
        fechas.append(pd.Timestamp(year=int(yr_str), month=_MESES[mes_str], day=1))
        try:
            valores.append(float(p['values'][0]))
        except (ValueError, TypeError):
            valores.append(np.nan)
    return pd.Series(valores, index=pd.DatetimeIndex(fechas, name='fecha'), name=codigo)


# Mismos 9 codigos de tasas activas + RP_ref de la Pregunta 1 (P1_1a),
# nada nuevo que verificar aqui -- ya confirmados contra el catalogo
# del BCRP en esa parte del trabajo.
CODIGOS = {
    'R1_pref90': 'PN07809NM',
    'R2_corp_cp': 'PN07801NM',
    'R3_ge_cp': 'PN07802NM',
    'R4_me_cp': 'PN07803NM',
    'R5_corp_lp': 'PN07804NM',
    'R6_ge_lp': 'PN07805NM',
    'R7_me_lp': 'PN07806NM',
    'R8_tamn': 'PN07807NM',
    'R9_ftamn': 'PN07808NM',
    'RP_ref': 'PD04722MM',
}

INICIO = '2010-8'
FIN = '2026-6'  # mes mas reciente con dato completo al momento de correr esto

if __name__ == '__main__':
    series = {}
    for nombre, codigo in CODIGOS.items():
        s = bcrp_una_serie_mensual(codigo, INICIO, FIN)
        series[nombre] = s
        print(f'  OK {nombre:10s} ({codigo}) -- {len(s)} obs, {s.index.min():%Y-%m} a {s.index.max():%Y-%m}')
        time.sleep(0.3)

    panel = pd.DataFrame(series)
    faltantes = panel.isna().sum()
    faltantes = faltantes[faltantes > 0]
    print('Sin faltantes.' if faltantes.empty else f'ADVERTENCIA, faltantes:\n{faltantes}')
    print(f'Panel final: {panel.shape[0]} obs x {panel.shape[1]} series')

    panel_out = panel.reset_index()
    panel_out['fecha'] = panel_out['fecha'].dt.strftime('%Ym%m')
    cols = ['fecha'] + list(CODIGOS.keys())
    panel_out = panel_out[cols]
    panel_out.to_csv(OUT_CSV, index=False)
    panel_out.to_excel(OUT_XLSX, index=False, sheet_name='tasas_bcrp_ext')
    print(f'Exportado: {OUT_CSV.name} y {OUT_XLSX.name}')
