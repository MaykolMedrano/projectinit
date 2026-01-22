****************************************************
* PRUEBA RÁPIDA - projectinit
* Autor: Maykol Medrano
* Fecha: 21 enero 2026
* Propósito: Testear rápidamente las 3 versiones
****************************************************

clear all
set more off

di as txt ""
di as txt "{hline 70}"
di as result "{bf:PRUEBA RÁPIDA - projectinit}"
di as txt "Autor: Maykol Medrano"
di as txt "{hline 70}"
di as txt ""

* Configurar directorio de prueba
local test_dir "C:/Temp/projectinit_test"
capture mkdir "`test_dir'"

di as txt "Directorio de prueba: `test_dir'"
di as txt ""

****************************************************
* PASO 1: Agregar el paquete al adopath
****************************************************
di as txt "{bf:PASO 1:} Agregando projectinit al adopath..."

local pkg_dir "C:/Users/User/OneDrive - Universidad Católica de Chile/Proyectos_GitHub/projectinit"
adopath + "`pkg_dir'"

di as result "  ✓ Agregado al adopath"
di as txt ""

****************************************************
* PASO 2: Verificar que el comando existe
****************************************************
di as txt "{bf:PASO 2:} Verificando instalación..."

capture which projectinit
if _rc == 0 {
    di as result "  ✓ projectinit encontrado"
}
else {
    di as error "  ✗ ERROR: projectinit no encontrado"
    exit 111
}
di as txt ""

****************************************************
* PASO 3: Prueba Básica (v1.0)
****************************************************
di as txt "{bf:PASO 3:} Creando proyecto básico..."
di as txt "Comando: projectinit \"MiProyecto_v1\", root(\"`test_dir'\") verbose"
di as txt ""

capture projectinit "MiProyecto_v1", root("`test_dir'") verbose

if _rc == 0 {
    di as txt ""
    di as result "  ✓ Proyecto creado exitosamente"
    di as txt ""

    * Verificar estructura
    di as txt "{bf:Verificando estructura creada:}"
    cd "`test_dir'/MiProyecto_v1"
    dir
}
else {
    di as error "  ✗ ERROR: Falló la creación (código: `=_rc')"
}

di as txt ""
di as txt "{hline 70}"

****************************************************
* PASO 4: Prueba con Replicación
****************************************************
di as txt "{bf:PASO 4:} Creando proyecto con replicación..."
di as txt "Comando: projectinit \"MiProyecto_Repl\", root(\"`test_dir'\") replicate verbose"
di as txt ""

capture projectinit "MiProyecto_Repl", root("`test_dir'") replicate verbose

if _rc == 0 {
    di as txt ""
    di as result "  ✓ Proyecto con replicación creado exitosamente"
    di as txt ""

    * Verificar que existe carpeta de replicación
    cd "`test_dir'/MiProyecto_Repl"
    capture confirm file "04_replication"
    if _rc == 0 {
        di as result "  ✓ Carpeta de replicación encontrada"
    }
}
else {
    di as error "  ✗ ERROR: Falló la creación con replicación (código: `=_rc')"
}

di as txt ""
di as txt "{hline 70}"

****************************************************
* PASO 5: Prueba de Overwrite
****************************************************
di as txt "{bf:PASO 5:} Probando opción overwrite..."
di as txt "Comando: projectinit \"MiProyecto_v1\", root(\"`test_dir'\") overwrite"
di as txt ""

capture projectinit "MiProyecto_v1", root("`test_dir'") overwrite

if _rc == 0 {
    di as txt ""
    di as result "  ✓ Overwrite funcionó correctamente"
}
else {
    di as error "  ✗ ERROR: Falló overwrite (código: `=_rc')"
}

di as txt ""
di as txt "{hline 70}"

****************************************************
* RESUMEN FINAL
****************************************************
di as txt ""
di as txt "{bf:RESUMEN DE LA PRUEBA}"
di as txt "{hline 70}"
di as txt ""
di as txt "Directorio de prueba: {it:`test_dir'}"
di as txt ""
di as txt "Proyectos creados:"
di as txt "  1. MiProyecto_v1 (básico)"
di as txt "  2. MiProyecto_Repl (con replicación)"
di as txt ""
di as result "{bf:✓ TODAS LAS PRUEBAS COMPLETADAS}"
di as txt ""
di as txt "Para explorar los proyectos creados:"
di as txt "  cd \"`test_dir'\""
di as txt "  dir"
di as txt ""
di as txt "Para probar v2.0 con LaTeX (si tienes GitHub CLI):"
di as txt "  projectinit \"Proyecto_v2\", root(\"`test_dir'\") lang(es) latex(standard) author(\"Maykol Medrano\")"
di as txt ""
di as txt "{hline 70}"

****************************************************
* LIMPIEZA (OPCIONAL - COMENTADO)
****************************************************
* Si quieres limpiar después de la prueba, descomenta:
* cd "`test_dir'"
* shell rmdir /s /q "MiProyecto_v1"
* shell rmdir /s /q "MiProyecto_Repl"
