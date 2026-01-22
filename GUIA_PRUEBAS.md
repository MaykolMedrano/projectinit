# Guía de Pruebas - projectinit

**Autor**: Maykol Medrano
**Email**: mmedrano2@uc.cl
**Fecha**: 21 enero 2026

---

## 🚀 Opciones de Prueba

### Opción 1: Prueba Rápida Automatizada (⭐ RECOMENDADA)

**Duración**: 2-3 minutos

```stata
// 1. Abrir Stata
// 2. Ejecutar:
cd "C:/Users/User/OneDrive - Universidad Católica de Chile/Proyectos_GitHub/projectinit"
do PRUEBA_RAPIDA.do
```

**Qué hace este script:**
- ✅ Agrega projectinit al adopath
- ✅ Verifica que está instalado
- ✅ Crea proyecto básico
- ✅ Crea proyecto con replicación
- ✅ Prueba opción overwrite
- ✅ Muestra resumen completo

**Resultado esperado:**
```
RESUMEN DE LA PRUEBA
----------------------------------------------------------------------
Directorio de prueba: C:/Temp/projectinit_test
Proyectos creados:
  1. MiProyecto_v1 (básico)
  2. MiProyecto_Repl (con replicación)

✓ TODAS LAS PRUEBAS COMPLETADAS
```

---

### Opción 2: Prueba Manual Paso a Paso

**Duración**: 5 minutos

#### Paso 1: Agregar al adopath

```stata
clear all
set more off

// Agregar el directorio del proyecto al adopath
adopath + "C:/Users/User/OneDrive - Universidad Católica de Chile/Proyectos_GitHub/projectinit"

// Verificar que está disponible
which projectinit
```

**Resultado esperado:**
```
C:\Users\User\OneDrive - Universidad Católica de Chile\Proyectos_GitHub\projectinit\projectinit_v2_enhanced.ado
```

#### Paso 2: Ver ayuda

```stata
help projectinit
```

**Debe abrir la documentación del paquete.**

#### Paso 3: Crear proyecto de prueba básico

```stata
// Crear directorio temporal
mkdir "C:/Temp"

// Crear proyecto básico
projectinit "MiPrimeraPreuba", root("C:/Temp") verbose

// Verificar
cd "C:/Temp/MiPrimeraPreuba"
dir
```

**Estructura esperada:**
```
MiPrimeraPreuba/
├── 01_Data/
│   ├── Raw/
│   ├── De-identified/
│   ├── Intermediate/
│   └── Final/
├── 02_Scripts/
├── 03_Outputs/
├── run.do
├── README.md
└── .gitignore
```

#### Paso 4: Crear proyecto con opciones avanzadas

```stata
projectinit "ProyectoAvanzado", ///
    root("C:/Temp") ///
    replicate ///
    verbose
```

**Debe crear carpeta adicional:**
- `06_Replication/` con archivos de replicación

#### Paso 5: Probar con LaTeX (Opcional)

```stata
projectinit "Tesis_Economia", ///
    root("C:/Temp") ///
    lang(es) ///
    latex(standard) ///
    author("Maykol Medrano") ///
    verbose
```

**Estructura adicional:**
```
04_Writing/
├── main.tex
├── preamble.tex
├── macros.tex
├── sections/
└── references.bib
```

---

### Opción 3: Test Suite Completo

**Duración**: 10 minutos
**Para**: Verificación exhaustiva

```stata
cd "C:/Users/User/OneDrive - Universidad Católica de Chile/Proyectos_GitHub/projectinit"
do examples/test_projectinit.do
```

**Ejecuta ~15 tests incluyendo:**
- Creación básica
- Opciones de replicación
- Manejo de errores
- Validación de inputs
- Overwrite
- Casos límite

---

## 🧪 Pruebas Específicas por Versión

### Probar v1.0 (Estable)

```stata
// Usar archivo de instalación
cd "C:/Users/User/OneDrive - Universidad Católica de Chile/Proyectos_GitHub/projectinit/installation"
adopath + "C:/Users/User/OneDrive - Universidad Católica de Chile/Proyectos_GitHub/projectinit/installation"

projectinit "Test_v1", root("C:/Temp")
```

### Probar v2.0 (Enhanced)

```stata
// Usar archivo v2
cd "C:/Users/User/OneDrive - Universidad Católica de Chile/Proyectos_GitHub/projectinit"

projectinit "Test_v2", ///
    root("C:/Temp") ///
    lang(es) ///
    latex(puc) ///
    author("Maykol Medrano")
```

### Probar v2.1 (Enterprise)

```stata
// Usar archivo v2_enhanced (por defecto)
projectinit "Test_v21", ///
    root("C:/Temp") ///
    lang(en) ///
    latex(standard) ///
    author("Maykol Medrano") ///
    email("mmedrano2@uc.cl") ///
    verbose
```

---

## ✅ Checklist de Verificación

Después de ejecutar las pruebas, verifica:

### Archivos Creados
- [ ] Carpetas con estructura J-PAL/DIME
- [ ] `run.do` (master script)
- [ ] `README.md` con información del proyecto
- [ ] `.gitignore` configurado correctamente

### Si usaste `replicate`:
- [ ] Carpeta `06_Replication/` existe
- [ ] `replication.do` está presente
- [ ] `README_REPLICATION.md` incluido

### Si usaste `latex()`:
- [ ] Carpeta `04_Writing/` existe
- [ ] `main.tex` y `preamble.tex` presentes
- [ ] Subcarpetas `sections/`, `tables/`, `figures/`

### Funcionalidad
- [ ] Comando ejecuta sin errores
- [ ] Output es claro y formateado
- [ ] Opción `verbose` muestra información detallada
- [ ] `overwrite` funciona correctamente

---

## 🐛 Solución de Problemas

### Problema: "command projectinit not found"

**Solución:**
```stata
// Verificar adopath
adopath

// Agregar directorio
adopath + "C:/Users/User/OneDrive - Universidad Católica de Chile/Proyectos_GitHub/projectinit"

// Verificar de nuevo
which projectinit
```

### Problema: "cannot create directory"

**Causas posibles:**
1. El directorio root no existe
2. Sin permisos de escritura
3. Disco lleno

**Solución:**
```stata
// Verificar que root existe
cd "C:/Temp"  // Si falla, crear primero con: mkdir "C:/Temp"

// Probar con Desktop (siempre existe)
projectinit "Test", root("C:/Users/User/Desktop")
```

### Problema: Proyecto ya existe

**Solución:**
```stata
// Opción 1: Usar overwrite
projectinit "MiProyecto", root("C:/Temp") overwrite

// Opción 2: Usar otro nombre
projectinit "MiProyecto_v2", root("C:/Temp")

// Opción 3: Borrar manualmente
cd "C:/Temp"
shell rmdir /s /q "MiProyecto"  // Windows
// o: shell rm -rf "MiProyecto"  // Mac/Linux
```

---

## 📊 Verificar Instalación

### Test Mínimo (30 segundos)

```stata
// 1. Verificar comando existe
which projectinit
// Debe mostrar la ruta al archivo .ado

// 2. Ver ayuda
help projectinit
// Debe abrir ventana de ayuda

// 3. Crear proyecto simple
projectinit "QuickTest", root("C:/Temp")
// Debe completar sin errores

// 4. Verificar estructura
cd "C:/Temp/QuickTest"
dir
// Debe listar carpetas y archivos creados
```

**Si los 4 pasos funcionan: ✅ Instalación correcta**

---

## 🎯 Pruebas Recomendadas por Caso de Uso

### Para Tesis/Disertación

```stata
projectinit "Tesis_Doctoral", ///
    root("C:/Research") ///
    lang(es) ///
    latex(puc) ///
    author("Maykol Medrano") ///
    email("mmedrano2@uc.cl") ///
    replicate ///
    verbose
```

### Para Paper Journal

```stata
projectinit "Paper_AER", ///
    root("C:/Research") ///
    lang(en) ///
    latex(standard) ///
    author("Maykol Medrano") ///
    replicate ///
    verbose
```

### Para Proyecto con CASEN/ENAHO

```stata
projectinit "Analisis_Pobreza_2024", ///
    root("C:/Investigacion") ///
    lang(es) ///
    author("Maykol Medrano")
```

---

## 📝 Logging de Pruebas

Para guardar un log de tus pruebas:

```stata
log using "C:/Temp/projectinit_test.log", replace

// Ejecutar pruebas aquí
do PRUEBA_RAPIDA.do

log close
```

Luego puedes revisar `projectinit_test.log` para ver todos los resultados.

---

## 🔍 Próximos Pasos

Después de probar exitosamente:

1. **Usar en proyecto real:**
   ```stata
   projectinit "MiInvestigacion", ///
       root("C:/Research") ///
       author("Maykol Medrano") ///
       replicate
   ```

2. **Instalar permanentemente** (opcional):
   ```stata
   // Copiar archivos a directorio personal de Stata
   copy "projectinit_v2_enhanced.ado" "c:/ado/plus/p/projectinit.ado"
   ```

3. **Compartir con colegas:**
   - Enviar enlace a GitHub: https://github.com/MaykolMedrano/projectinit
   - O compartir archivos directamente

---

## 📧 Reportar Problemas

Si encuentras algún error:

1. **Anota:**
   - Versión de Stata (`about`)
   - Sistema operativo
   - Comando exacto que ejecutaste
   - Mensaje de error completo

2. **Reporta:**
   - GitHub Issues: https://github.com/MaykolMedrano/projectinit/issues
   - Email: mmedrano2@uc.cl

---

**¡Buena suerte con las pruebas!** 🚀

---

**Última actualización**: 21 enero 2026
**Versión**: 2.1.0 Enterprise
