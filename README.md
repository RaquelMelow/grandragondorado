# Generar `menu_generado.html` desde XML + XSLT (VS Code)

## Prerrequisitos
- Tener **Visual Studio Code** instalado.
- Tener los archivos en la raíz del proyecto:
  - Entrada XML: `restaurante.xml`
  - Plantilla XSL: `estilos.xsl`
- Instalar la extensión **XSLT/XPath** (DeltaXML) en VS Code.

## Pasos (VS Code)
1. Abre esta carpeta en VS Code.
2. Abre el archivo `estilos.xsl`.
3. Abre la paleta de comandos (`Ctrl+Shift+P`).
4. Ejecuta el comando **`XSLT: Transform this file`** (o el equivalente de transformación XSLT de la extensión).
5. Cuando pida el XML de entrada, selecciona `restaurante.xml`.
6. Guarda el resultado como `menu_generado.html` en la raíz.

## Entrada y salida
- **Entrada:** `restaurante.xml` + `estilos.xsl`
- **Salida:** `menu_generado.html`

## Repetir la generación tras cambios
Cada vez que cambies `restaurante.xml` o `estilos.xsl`, repite los pasos 2–6 para regenerar `menu_generado.html`.

## Comprobación
Al abrir `menu_generado.html` en el navegador, debe verse:
- El título y marca de **Gran Dragón Dorado**.
- Navegación con secciones **Inicio**, **Menu** y **Trabaja con nosotros**.
- Tarjetas de platos con nombre, precio y botones “+ Añadir”.
- Tabla del menú con columnas **Nombre / Categoría / Precio / Stock / Picante**.
- Estilos aplicados desde `estilos.css` (no debería verse “sin formato”).
