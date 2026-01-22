# Versiones Anteriores - projectinit

Esta carpeta contiene versiones históricas del paquete projectinit para referencia y compatibilidad.

---

## 📦 Versiones Disponibles

### v1.0 (Estable - Diciembre 2025)

**Archivo**: `v1.0/projectinit.ado`

**Características:**
- Estructura básica AEA/JPAL/MIT
- Carpetas numeradas (01_data, 02_code, etc.)
- Master script y run_all.do
- Templates para cada etapa del análisis
- Soporte para replicación
- Cross-platform (Windows/Mac/Linux)

**Cuándo usar:**
- Proyectos que necesitan máxima estabilidad
- Entornos conservadores sin LaTeX/GitHub
- Compatibilidad con versiones antiguas de Stata 14

---

### v2.0 (Enhanced - Diciembre 2025)

**Archivo**: `v2.0/projectinit_v2.ado`

**Características:**
- Todo de v1.0 +
- Integración LaTeX (templates PUC y estándar)
- Automatización GitHub (gh CLI)
- Soporte bilingüe (Inglés/Español)
- Optimizado para microdata chilena/peruana (CASEN, ENAHO)
- Paths dinámicos con c(pwd)

**Cuándo usar:**
- Proyectos que requieren LaTeX integration
- Necesidad de soporte en español
- Trabajo con CASEN/ENAHO

---

### v2.1 (Enterprise - Enero 2026) ⭐ ACTUAL

**Archivo**: `/projectinit.ado` (raíz del proyecto)

**Características:**
- Todo de v2.0 +
- Cumplimiento completo J-PAL/DIME/AEA Data Editor
- Estructura de carpetas J-PAL numbered (01_Data, 02_Scripts, etc.)
- .gitignore de nivel DevOps
- Interfaz SMCL profesional con colores
- Validación de seguridad robusta
- Manejo de dependencias mejorado
- Metadata completa y documentación extensa

**Cuándo usar:**
- **RECOMENDADO para todos los proyectos nuevos**
- Máxima profesionalidad y features
- Cumplimiento estricto de estándares
- Publicación en journals (AEA, etc.)

---

## 🔄 Migración entre Versiones

### De v1.0 a v2.1

```stata
* Crear nuevo proyecto con v2.1
projectinit "MiProyecto_v21", root("C:/Research")

* Copiar datos del proyecto v1.0
copy "C:/OldProject/01_data/*" "C:/Research/MiProyecto_v21/01_Data/Raw/"
```

### De v2.0 a v2.1

Los proyectos v2.0 son compatible con v2.1. Solo hay cambios en nombres de carpetas:

```
v2.0              →  v2.1
────────────────────────────
data/             →  01_Data/
data/raw/         →  01_Data/Raw/
scripts/          →  02_Scripts/
results/          →  03_Outputs/
writing/          →  04_Writing/
```

---

## 📥 Usar una Versión Anterior

Si necesitas usar una versión específica:

```stata
* Copiar versión deseada
copy "versions/v1.0/projectinit.ado" "C:/Temp/projectinit_v1.ado"

* Agregar al adopath temporalmente
adopath + "C:/Temp"

* Renombrar
cd "C:/Temp"
!ren projectinit_v1.ado projectinit.ado

* Usar
projectinit "OldStyleProject", root("C:/Research")
```

---

## ⚠️ Notas Importantes

1. **Soporte Limitado**: Solo v2.1 recibe actualizaciones activas
2. **Seguridad**: Versiones antiguas pueden no tener últimas mejoras de seguridad
3. **Features**: Versiones antiguas no tienen todas las características
4. **Recomendación**: Usa v2.1 siempre que sea posible

---

## 📧 Soporte

Para preguntas sobre versiones:
- **Email**: mmedrano2@uc.cl
- **Issues**: https://github.com/MaykolMedrano/projectinit/issues

---

**Última actualización**: 21 enero 2026
