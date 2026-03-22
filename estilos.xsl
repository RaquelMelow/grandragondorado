<?xml version="1.0" encoding="UTF-8"?><!--
     estilos.xsl - Gran Dragon Dorado
     XPath avanzado:
     FILTROS     : plato[@categoria='X'], plato[picante/@nivel > 2], plato[stock > 0]
     ORDENACION  : xsl:sort select="precio" order="ascending"
     xsl:sort select="picante/@nivel" order="descending"
     MATEMATICAS : count(), sum() div count(), format-number(precio * stock,'#.00')
     precio maximo via sort + position()=1
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  <!-- ============================================================
       TEMPLATE RAIZ
       ============================================================ -->
  <xsl:template match="/">    <!-- ============================================================
         VARIABLES: todo el XPath avanzado se calcula AQUI,
         antes del HTML. Asi VS Code no marca errores dentro del HTML.
         ============================================================ -->    <!-- Datos del restaurante -->
    <xsl:variable name="nombre" select="menu/@nombre"/>
    <xsl:variable name="direccion" select="menu/@direccion"/>
    <!-- MATEMATICA 1: count total de platos -->
    <xsl:variable name="totalPlatos" select="count(menu/plato)"/>
    <!-- MATEMATICA 2: precio medio = sum / count -->
    <xsl:variable name="precioMedio" select="format-number(sum(menu/plato/precio) div count(menu/plato),'#.00')"/>
    <!-- FILTRO + count: platos con nivel de picante mayor que 2 -->
    <xsl:variable name="nPickantes" select="count(menu/plato[picante/@nivel &gt; 2])"/>
    <!-- MATEMATICA 3: precio maximo usando predicado XPath -->
    <xsl:variable name="maxPrecio">
      <xsl:for-each select="menu/plato[not(../plato/precio &gt; precio)]">
        <xsl:value-of select="format-number(precio,'#.00')"/>
      </xsl:for-each>
    </xsl:variable>    <!-- FILTRO por categoria: counts individuales -->
    <xsl:variable name="nEntrantes" select="count(menu/plato[@categoria='Entrante'])"/>
    <xsl:variable name="nCarnes" select="count(menu/plato[@categoria='Carne'])"/>
    <xsl:variable name="nVegetarianos" select="count(menu/plato[@categoria='Vegetariano'])"/>
    <xsl:variable name="nPostres" select="count(menu/plato[@categoria='Postre'])"/>
    <xsl:variable name="nBebidas" select="count(menu/plato[@categoria='Bebida'])"/>
    <html lang="es">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>
          <xsl:value-of select="$nombre"/>
        </title>
        <link rel="preconnect" href="https://fonts.googleapis.com"/>
        <link rel="stylesheet" type="text/css" href="estilos.css"/>
      </head>
      <body>        <!-- NAV -->
        <nav id="main-nav">
          <div class="nav-logo" onclick="goTo('home')">&#x9F99; GDD</div>
          <div class="nav-links">
            <a onclick="goTo('home')" data-page="home" class="active">Inicio</a>
            <a onclick="goTo('menu')" data-page="menu">Menu</a>
            <a onclick="goTo('trabaja')" data-page="trabaja">Trabaja con nosotros</a>
            <button class="cart-btn" onclick="goTo('menu')">              &#x1F9FA; Cesta              <span class="cart-count" id="cart-count">0</span>
            </button>
          </div>
        </nav>        <!-- ======================================================
             HOME
             ====================================================== -->
        <div id="page-home" class="page active">
          <section class="hero">
            <div class="hero-bg"></div>
            <div class="hero-content">
              <div class="hero-eyebrow">                Desde 1988 &#xB7; <xsl:value-of select="$direccion"/>
              </div>
              <h1>Gran Dragon<br/>
                <span>Dorado</span>
              </h1>
              <p class="hero-subtitle">Cocina imperial china con alma canaria</p>
              <div class="hero-ctas">
                <button class="btn-primary" onclick="goTo('menu')">Ver carta</button>
                <button class="btn-secondary" onclick="goTo('trabaja')">Trabaja con nosotros</button>
              </div>
            </div>
            <div class="scroll-hint" onclick="irA('.features')">Descubre</div>
          </section>
          <div class="features">
            <div class="feature">
              <div class="feature-icon">&#x1F962;</div>
              <h3>Cocina Autentica</h3>
              <p>Recetas de Sichuan y Canton, sin concesiones</p>
            </div>
            <div class="feature">
              <div class="feature-icon">&#x1F6F5;</div>
              <h3>Para Llevar</h3>
              <p>Pedido online listo en 25 minutos</p>
            </div>
            <div class="feature">
              <div class="feature-icon">&#x1FAD6;</div>
              <h3>Te Ceremonial</h3>
              <p>Seleccion de tes importados de Fujian</p>
            </div>
          </div>        <!-- STATS: referencias a variables pre-calculadas -->
          <div class="xpath-stats">
            <div class="xstat">
              <strong>
                <xsl:value-of select="$totalPlatos"/>
              </strong>
              <span>Platos en carta</span>
            </div>
            <div class="xstat">
              <strong>
                <xsl:value-of select="$precioMedio"/>
                &#x20AC;</strong>
              <span>Precio medio</span>
            </div>
            <div class="xstat">
              <strong>
                <xsl:value-of select="$nPickantes"/>
              </strong>
              <span>Platos picantes</span>
            </div>
            <div class="xstat">
              <strong>
                <xsl:value-of select="$maxPrecio"/>
                &#x20AC;</strong>
              <span>Plato mas caro</span>
            </div>
          </div>

          <section class="tabla-section">
            <h2>Tabla completa de platos</h2>
            <p>Vista tabular ordenada por nivel de picante (descendente) y precio (ascendente). Incluye filtros y calculos XPath.</p>
            <div class="table-wrap">
              <table class="menu-table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Categoria</th>
                    <th>Plato</th>
                    <th>Precio (€)</th>
                    <th>Stock</th>
                    <th>Picante</th>
                    <th>Valor inventario (€)</th>
                  </tr>
                </thead>
                <tbody>
                  <xsl:for-each select="menu/plato[stock &gt;= 10 and precio &gt;= 4]">
                    <xsl:sort select="picante/@nivel" data-type="number" order="descending"/>
                    <xsl:sort select="precio" data-type="number" order="ascending"/>
                    <tr>
                      <td><xsl:value-of select="@id"/></td>
                      <td><xsl:value-of select="@categoria"/></td>
                      <td><xsl:value-of select="nombre"/></td>
                      <td><xsl:value-of select="format-number(precio,'#.00')"/></td>
                      <td><xsl:value-of select="stock"/></td>
                      <td><xsl:value-of select="picante/@nivel"/></td>
                      <td><xsl:value-of select="format-number(precio * stock,'#.00')"/></td>
                    </tr>
                  </xsl:for-each>
                </tbody>
                <tfoot>
                  <tr>
                    <td colspan="6">Suma de precios filtrados (XPath: sum(menu/plato[stock &gt;= 10 and precio &gt;= 4]/precio))</td>
                    <td>
                      <xsl:value-of select="format-number(sum(menu/plato[stock &gt;= 10 and precio &gt;= 4]/precio),'#.00')"/>
                    </td>
                  </tr>
                </tfoot>
              </table>
            </div>
          </section>
          <footer>
            <div class="footer-col">
              <h4>Donde estamos</h4>
              <p>
                <xsl:value-of select="$direccion"/>
                <br/>
                Santa Cruz de Tenerife<br/>
                922 000 000</p>
            </div>
            <div class="footer-col">
              <h4>Horario</h4>
              <p>Lun-Vie: 13h-16h &#xB7; 20h-00h<br/>
                Sab-Dom: 13h-00h</p>
            </div>
            <div class="footer-col">
              <h4>Siguenos</h4>
              <p>@grandragondonado<br/>
                Instagram &#xB7; Facebook &#xB7; TripAdvisor</p>
            </div>
          </footer>
          <div class="footer-bottom">            &#xA9; 2025 <xsl:value-of select="$nombre"/>
            &#xB7; Todos los derechos reservados          </div>
        </div>      <!-- ======================================================
             MENU
             ====================================================== -->
        <div id="page-menu" class="page">
          <section class="menu-hero">
            <div class="menu-hero-bg"></div>
            <div class="menu-hero-content">
              <div class="eyebrow">La Carta &#xB7; 2025</div>
              <h1>Menu<br/>
                <em>Imperial</em>
              </h1>
              <p class="sub">
                <xsl:value-of select="$totalPlatos"/>
                platos entre la tradicion de Sichuan, el frescor cantones y el producto local canario.              </p>
              <div class="hero-ctas">
                <button class="btn-primary" onclick="irA('#menu-tabs-anchor')">Ver la carta</button>
              </div>
            </div>
            <div class="hero-scroll-down" onclick="irA('#menu-tabs-anchor')">Explorar</div>
          </section>      <!-- Tabs con count por categoria (FILTRO XPATH) -->
          <div class="menu-tabs" id="menu-tabs-anchor">
            <button class="tab-btn active" data-cat="Todos" onclick="filterMenu(this,'Todos')">Todos</button>
            <button class="tab-btn" data-cat="Entrante" onclick="filterMenu(this,'Entrante')">              Entrantes (<xsl:value-of select="$nEntrantes"/>
              )            </button>
            <button class="tab-btn" data-cat="Carne" onclick="filterMenu(this,'Carne')">              Carnes (<xsl:value-of select="$nCarnes"/>
              )            </button>
            <button class="tab-btn" data-cat="Vegetariano" onclick="filterMenu(this,'Vegetariano')">              Vegetariano (<xsl:value-of select="$nVegetarianos"/>
              )            </button>
            <button class="tab-btn" data-cat="Postre" onclick="filterMenu(this,'Postre')">              Postres (<xsl:value-of select="$nPostres"/>
              )            </button>
            <button class="tab-btn" data-cat="Bebida" onclick="filterMenu(this,'Bebida')">              Bebidas (<xsl:value-of select="$nBebidas"/>
              )            </button>
          </div>
          <div class="menu-layout">
            <div class="menu-items-grid" id="menu-grid">          <!-- FILTRO stock>0 + ORDEN precio asc -->
              <xsl:for-each select="menu/plato[stock &gt; 0]">
                <xsl:sort select="precio" data-type="number" order="ascending"/>
                <xsl:apply-templates select="."/>
              </xsl:for-each>
            </div>
            <div class="basket-panel">
              <div class="basket-header">
                <h3>&#x1F9FA; Tu pedido</h3>
              </div>
              <div class="basket-type-toggle">
                <button class="toggle-opt active" id="tog-sala" onclick="setOrderType('sala',this)">                  &#x1F37D; En sala                </button>
                <button class="toggle-opt" id="tog-llevar" onclick="setOrderType('llevar',this)">                  &#x1F6F5; Para llevar                </button>
              </div>
              <div class="basket-items" id="basket-items">
                <div class="basket-empty">
                  <span>&#x1F962;</span>Tu cesta esta vacia                </div>
              </div>
              <div class="basket-footer">
                <div class="basket-total">
                  <span>Total</span>
                  <span id="basket-total">0,00 &#x20AC;</span>
                </div>
                <button class="order-btn" id="order-btn" disabled="disabled" onclick="sendOrder()">                  Enviar pedido                </button>
              </div>
            </div>
          </div>
          <footer>
            <div class="footer-col">
              <h4>Donde estamos</h4>
              <p>
                <xsl:value-of select="$direccion"/>
                <br/>
                Santa Cruz de Tenerife<br/>
                922 000 000</p>
            </div>
            <div class="footer-col">
              <h4>Horario</h4>
              <p>Lun-Vie: 13h-16h &#xB7; 20h-00h<br/>
                Sab-Dom: 13h-00h</p>
            </div>
            <div class="footer-col">
              <h4>Para llevar</h4>
              <p>Pedidos minimo 15 &#x20AC;<br/>
                Entrega en 25-35 min<br/>
                Zona centro Santa Cruz</p>
            </div>
          </footer>
          <div class="footer-bottom">            &#xA9; 2025 <xsl:value-of select="$nombre"/>
            &#xB7; Todos los derechos reservados          </div>
        </div>  <!-- ======================================================
             TRABAJA
             ====================================================== -->
        <div id="page-trabaja" class="page">
          <section class="trabaja-hero">
            <div class="trabaja-hero-bg"></div>
            <div class="trabaja-hero-content">
              <div class="eyebrow">Unete a la familia</div>
              <h1>Trabaja con<br/>
                <em>nosotros</em>
              </h1>
              <p class="sub">                Buscamos personas apasionadas por la gastronomia, el servicio de excelencia y la cultura asiatica.              </p>
              <div class="hero-chips">
                <div class="hero-chip">
                  <strong>4</strong>Puestos abiertos</div>
                <div class="hero-chip">
                  <strong>37</strong>Anos de historia</div>
                <div class="hero-chip">
                  <strong>+18</strong>Personas en equipo</div>
              </div>
              <div style="margin-top:36px">
                <button class="btn-primary" onclick="irA('.positions-section')">Ver puestos disponibles</button>
              </div>
            </div>
            <div class="hero-scroll-down" onclick="irA('.values-strip')">Descubrir</div>
          </section>
          <div class="values-strip">
            <div class="value-item">
              <div class="v-icon">&#x1F331;</div>
              <h4>Crecimiento</h4>
              <p>Formacion continua y plan de carrera</p>
            </div>
            <div class="value-item">
              <div class="v-icon">&#x1F91D;</div>
              <h4>Equipo</h4>
              <p>Ambiente familiar y multicultural</p>
            </div>
            <div class="value-item">
              <div class="v-icon">&#x1F35C;</div>
              <h4>Pasion</h4>
              <p>Amor genuino por la cocina asiatica</p>
            </div>
            <div class="value-item">
              <div class="v-icon">&#x1F48E;</div>
              <h4>Calidad</h4>
              <p>Estandares de excelencia en todo</p>
            </div>
          </div>
          <div class="positions-section">
            <div class="positions-title">Puestos disponibles</div>
            <div class="position-card" onclick="togglePosition(this)">
              <div class="position-head">
                <h3>Cocinero/a Partida Wok</h3>
                <div class="position-meta">
                  <span class="pos-badge full">Jornada completa</span>
                  <span class="pos-arrow">&#x2228;</span>
                </div>
              </div>
              <div class="position-body">
                <p>Buscamos un perfil con experiencia en cocina asiatica o wok.</p>
                <ul>
                  <li>Minimo 2 anos en cocina profesional</li>
                  <li>Conocimiento de tecnicas chinas (vaporera, wok, ahumado)</li>
                  <li>Se valorara experiencia en restaurante asiatico</li>
                </ul>
              </div>
            </div>
            <div class="position-card" onclick="togglePosition(this)">
              <div class="position-head">
                <h3>Ayudante de Cocina</h3>
                <div class="position-meta">
                  <span class="pos-badge part">Media jornada</span>
                  <span class="pos-arrow">&#x2228;</span>
                </div>
              </div>
              <div class="position-body">
                <p>Apoyo en produccion, mise en place y limpieza.</p>
                <ul>
                  <li>Sin experiencia minima requerida</li>
                  <li>Disponibilidad fines de semana y festivos</li>
                </ul>
              </div>
            </div>
            <div class="position-card" onclick="togglePosition(this)">
              <div class="position-head">
                <h3>Camarero/a de Sala</h3>
                <div class="position-meta">
                  <span class="pos-badge full">Jornada completa</span>
                  <span class="pos-arrow">&#x2228;</span>
                </div>
              </div>
              <div class="position-body">
                <p>Atencion al cliente en sala y asesoramiento sobre la carta.</p>
                <ul>
                  <li>Experiencia minima 1 ano en sala</li>
                  <li>Dominio de espanol; ingles muy valorado</li>
                </ul>
              </div>
            </div>
            <div class="position-card" onclick="togglePosition(this)">
              <div class="position-head">
                <h3>Repartidor/a Para Llevar</h3>
                <div class="position-meta">
                  <span class="pos-badge part">Media jornada</span>
                  <span class="pos-arrow">&#x2228;</span>
                </div>
              </div>
              <div class="position-body">
                <p>Gestion de pedidos para llevar, zona centro Santa Cruz.</p>
                <ul>
                  <li>Carne de moto o coche (imprescindible)</li>
                  <li>Turno de tarde-noche (19h-00h)</li>
                </ul>
              </div>
            </div>
          </div>
          <div class="apply-section">
            <h2>Envianos tu candidatura</h2>
            <p>Rellena el formulario y nos pondremos en contacto contigo en 48 horas</p>
            <div class="apply-form">
              <div class="form-group">
                <label>Nombre</label>
                <input type="text" placeholder="Tu nombre"/>
              </div>
              <div class="form-group">
                <label>Apellidos</label>
                <input type="text" placeholder="Tus apellidos"/>
              </div>
              <div class="form-group">
                <label>Email</label>
                <input type="email" placeholder="tu@email.com"/>
              </div>
              <div class="form-group">
                <label>Telefono</label>
                <input type="tel" placeholder="+34 600 000 000"/>
              </div>
              <div class="form-group">
                <label>Puesto de interes</label>
                <select>
                  <option value="">Selecciona un puesto</option>
                  <option>Cocinero/a Partida Wok</option>
                  <option>Ayudante de Cocina</option>
                  <option>Camarero/a de Sala</option>
                  <option>Repartidor/a Para Llevar</option>
                  <option>Candidatura espontanea</option>
                </select>
              </div>
              <div class="form-group">
                <label>Disponibilidad</label>
                <select>
                  <option value="">Selecciona</option>
                  <option>Inmediata</option>
                  <option>En 2 semanas</option>
                  <option>En 1 mes</option>
                </select>
              </div>
              <div class="form-group full">
                <label>Cuentanos sobre ti</label>
                <textarea placeholder="Experiencia, motivacion, por que quieres unirte..."></textarea>
              </div>
              <button class="submit-btn" onclick="submitForm()">Enviar candidatura</button>
            </div>
          </div>
          <footer>
            <div class="footer-col">
              <h4>Contacto RRHH</h4>
              <p>empleo@grandragondonado.es<br/>
                922 000 001</p>
            </div>
            <div class="footer-col">
              <h4>Donde estamos</h4>
              <p>
                <xsl:value-of select="$direccion"/>
                <br/>
                Santa Cruz de Tenerife</p>
            </div>
            <div class="footer-col">
              <h4>Siguenos</h4>
              <p>@grandragondonado<br/>
                Instagram &#xB7; LinkedIn</p>
            </div>
          </footer>
          <div class="footer-bottom">            &#xA9; 2025 <xsl:value-of select="$nombre"/>
            &#xB7; Todos los derechos reservados          </div>
        </div><!-- TOAST -->
        <div class="order-toast" id="toast">
          <div id="toast-title">Pedido enviado!</div>
          <p id="toast-msg">Preparamos tu pedido ahora mismo.</p>
        </div><!-- Script 1: array dishes generado desde XML -->
        <script>
          <xsl:text>var dishes=[</xsl:text>
          <xsl:for-each select="menu/plato">
            <xsl:sort select="precio" data-type="number" order="ascending"/>
            <xsl:if test="position() &gt; 1">
              <xsl:text>,</xsl:text>
            </xsl:if>
            <xsl:text>{id:'</xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:text>',cat:'</xsl:text>
            <xsl:value-of select="@categoria"/>
            <xsl:text>',name:'</xsl:text>
            <xsl:value-of select="nombre"/>
            <xsl:text>',price:</xsl:text>
            <xsl:value-of select="precio"/>
            <xsl:text>,spice:</xsl:text>
            <xsl:value-of select="picante/@nivel"/>
            <xsl:text>}</xsl:text>
          </xsl:for-each>
          <xsl:text>];</xsl:text>
        </script><!-- Script 2: logica JS (CDATA protege los caracteres especiales) -->
        <script>//  <![CDATA[
var cart={},orderType='sala';
function filterMenu(btn,cat){
  document.querySelectorAll('.tab-btn').forEach(function(b){b.classList.remove('active');});
  btn.classList.add('active');
  document.querySelectorAll('.menu-card').forEach(function(c){
    c.classList.toggle('visible', cat==='Todos' || c.getAttribute('data-cat')===cat);
  });
}
function addToCart(id){cart[id]=(cart[id]||0)+1;renderCart();}
function changeQty(id,delta){ cart[id]=(cart[id]||0)+delta;
  if(cart[id]<=0){delete cart[id];}
  renderCart();
}
function renderCart(){
  var items=document.getElementById('basket-items');
  var totalEl=document.getElementById('basket-total');
  var btn=document.getElementById('order-btn');
  var countEl=document.getElementById('cart-count');
  var ids=Object.keys(cart); countEl.textContent=ids.reduce(function(s,k){return s+cart[k];},0);
  if(!ids.length){ items.innerHTML='<div class="basket-empty"><span>&#x1F962;</span>Tu cesta esta vacia</div>'; totalEl.textContent='0,00 EUR'; btn.disabled=true;
    return;
  }
  var total=0; items.innerHTML=ids.map(function(id){
    var d=dishes.find(function(x){return x.id===id;});
    var sub=d.price*cart[id]; total+=sub;
    return '<div class="basket-item">'
      +'<div class="bi-name">'+d.name+'</div>'
      +'<div class="bi-qty">'
        +'<button class="qty-btn" onclick="changeQty(\''+id+'\',-1)">-</button>'
        +'<span class="qty-num">'+cart[id]+'</span>'
        +'<button class="qty-btn" onclick="changeQty(\''+id+'\',1)">+</button>'
      +'</div>'
      +'<div class="bi-price">'+sub.toFixed(2).replace('.',',')+' EUR</div>'
    +'</div>';
  }).join(''); totalEl.textContent=total.toFixed(2).replace('.',',')+' EUR'; btn.disabled=false;
}
function setOrderType(type,btn){ orderType=type;
  document.querySelectorAll('.toggle-opt').forEach(function(b){b.classList.remove('active');});
  btn.classList.add('active'); document.getElementById('order-btn').textContent=type==='sala'?'Enviar a cocina':'Confirmar para llevar';
}
function sendOrder(){
  if(!Object.keys(cart).length){return;}
  var toast=document.getElementById('toast'); document.getElementById('toast-title').textContent=orderType==='sala'?'Pedido a cocina!':'Pedido para llevar!'; document.getElementById('toast-msg').textContent=orderType==='sala'?'Tu pedido ha llegado a cocina!':'Listo en 25 minutos.';
  toast.classList.add('show'); cart={};renderCart();
  setTimeout(function(){toast.classList.remove('show');},4000);
}
function goTo(page){
  document.querySelectorAll('.page').forEach(function(p){p.classList.remove('active');});
  var el=document.getElementById('page-'+page);
  el.classList.add('active'); el.scrollTop=0;
  document.querySelectorAll('.nav-links a').forEach(function(a){
    a.classList.toggle('active', a.getAttribute('data-page')===page);
  });
}
function irA(sel){
  var page=document.querySelector('.page.active');
  var target=document.querySelector(sel);
  if(page && target){page.scrollTo({top:page.scrollTop+target.getBoundingClientRect().top-70,behavior:'smooth'});}
}
function togglePosition(card){card.classList.toggle('open');}
function submitForm(){
  var toast=document.getElementById('toast'); document.getElementById('toast-title').textContent='Candidatura enviada'; document.getElementById('toast-msg').textContent='Nos pondremos en contacto en 48 horas.';
  toast.classList.add('show');
  setTimeout(function(){toast.classList.remove('show');},4000);
}
function watchScroll(){
  document.querySelectorAll('.page').forEach(function(p){
    p.addEventListener('scroll',function(){
      if(p.classList.contains('active')){
        document.getElementById('main-nav').classList.toggle('scrolled',p.scrollTop>60);
      }
    },{passive:true}); }); } window.goTo=goTo; window.irA=irA; window.filterMenu=filterMenu; window.addToCart=addToCart; window.changeQty=changeQty; window.setOrderType=setOrderType; window.sendOrder=sendOrder; window.togglePosition=togglePosition; window.submitForm=submitForm;
renderCart();
setOrderType('sala',document.getElementById('tog-sala'));
watchScroll();
//]]></script>
      </body>
    </html>
  </xsl:template><!-- ============================================================
       TEMPLATE plato: genera cada tarjeta del menu
       FILTRO: badge picante segun nivel
       OPERACION: format-number(precio,'#.00') y precio*stock en data-valor
       ============================================================ -->
  <xsl:template match="plato">
    <div class="menu-card visible">
      <xsl:attribute name="data-cat">
        <xsl:value-of select="@categoria"/>
      </xsl:attribute>
      <xsl:attribute name="data-valor">
        <xsl:value-of select="format-number(precio * stock,'#.00')"/>
      </xsl:attribute>
      <xsl:if test="picante/@nivel &gt;= 4">
        <div class="spice-flag">&#x1F336; Muy picante</div>
      </xsl:if>
      <xsl:if test="picante/@nivel = 2 or picante/@nivel = 3">
        <div class="spice-flag">&#x1F336; Picante</div>
      </xsl:if>
      <div class="menu-card-top">
        <h3>
          <xsl:value-of select="nombre"/>
        </h3>
        <div class="card-price">
          <xsl:value-of select="format-number(precio,'#.00')"/>
          <xsl:text> &#x20AC;</xsl:text>
        </div>
      </div>
      <div class="card-desc">
        <xsl:value-of select="descripcion"/>
      </div><!-- Puntos de picante via choose inline -->
      <div class="spice-dots">
        <xsl:call-template name="dot">
          <xsl:with-param name="p" select="1"/>
          <xsl:with-param name="n" select="picante/@nivel"/>
        </xsl:call-template>
        <xsl:call-template name="dot">
          <xsl:with-param name="p" select="2"/>
          <xsl:with-param name="n" select="picante/@nivel"/>
        </xsl:call-template>
        <xsl:call-template name="dot">
          <xsl:with-param name="p" select="3"/>
          <xsl:with-param name="n" select="picante/@nivel"/>
        </xsl:call-template>
        <xsl:call-template name="dot">
          <xsl:with-param name="p" select="4"/>
          <xsl:with-param name="n" select="picante/@nivel"/>
        </xsl:call-template>
        <xsl:call-template name="dot">
          <xsl:with-param name="p" select="5"/>
          <xsl:with-param name="n" select="picante/@nivel"/>
        </xsl:call-template>
      </div>
      <xsl:variable name="pid" select="@id"/>
      <button class="add-btn">
        <xsl:attribute name="onclick">
          <xsl:text>addToCart('</xsl:text>
          <xsl:value-of select="$pid"/>
          <xsl:text>')</xsl:text>
        </xsl:attribute>        + Anadir      </button>
    </div>
  </xsl:template><!-- ============================================================
       TEMPLATE auxiliar: un punto de picante
       ============================================================ -->
  <xsl:template name="dot">
    <xsl:param name="p"/>
    <xsl:param name="n"/>
    <div>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$p &lt;= $n">spice-dot hot</xsl:when>
          <xsl:otherwise>spice-dot</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </div>
  </xsl:template>
</xsl:stylesheet>