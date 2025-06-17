
// Esto es para seleccionar un input de fecha y establecerle una fecha minima, se puede modificar para que establezca una fecha mazima.
function EstablecerFecha() {

    var fechaInput = document.getElementsByName('FechaAsignacionInput');
    var today = new Date();
    var day = String(today.getDate()).padStart(2, '0');
    var month = String(today.getMonth() + 1).padStart(2, '0'); // Enero es 0
    var year = today.getFullYear();

    var todayDate = year + '-' + month + '-' + day;
    fechaInput[0].setAttribute('min', todayDate);

};

function InicarInteractividadFiltros() {

    document.querySelectorAll(".btn-type").forEach(btn => {
        btn.addEventListener("click", () => {
            document.querySelectorAll(".btn-type").forEach(b => b.classList.remove("active"));
            btn.classList.add("active");

            document.querySelectorAll(".filter-section").forEach(s => s.classList.remove("active"));
            const target = btn.dataset.target;
            const filtro = document.getElementById("filtros-" + target);

            if (filtro) {
                filtro.classList.add("active");

                sessionStorage.setItem("filtroActivo", target); // Guardar los datos del filtro activo.

                
                IniciarBusqueda(); // Inciar la busqueda base en donde todo los filtros estan sin elementos.

            }
        });
    });

    document.querySelectorAll(".tag").forEach(tag => {
        tag.addEventListener("click", () => {
            tag.classList.toggle("active");
        });
    });


}



// >>> ===== Seccion para el incio de los selects dinamicos de ubicaciones. ===== <<<

// Funcion para inciar el proceso de incilizacion de las ubicaciones dinamicas.
function InciarUbicacionesDinamicas() {

    iniciarUbicacionesDinamicasHospedaje();
    iniciarUbicacionesDinamicasEmpresaHospedaje();
    iniciarUbicacionesDinamicasRecreacion();
    iniciarUbicacionesDinamicasServiciosRecreacion();
}

// Para la seccion de las habitaciones.
function iniciarUbicacionesDinamicasHospedaje() {

    // Seleccionamos los elementos.
    const provinciaSelect = document.getElementById("provinciaHabitacion");
    const cantonSelect = document.getElementById("cantonHabitacion");
    const distritoSelect = document.getElementById("distritoHabitacion");

    if (!provinciaSelect || !cantonSelect || !distritoSelect) {

        return;
    }

    provinciaSelect.addEventListener("change", function () {
        const cantones = window.listaCantones || [];
        const filtrados = cantones.filter(c => c.idProvincia == this.value);
        cantonSelect.innerHTML = '<option value="0" disabled selected>Seleccione un canton</option>';
        filtrados.forEach(c => {
            cantonSelect.innerHTML += `<option value="${c.idCanton}">${c.nombreCanton}</option>`;
        });
        distritoSelect.innerHTML = '<option value="0" disabled selected>Seleccione un distrito</option>';
    });

    cantonSelect.addEventListener("change", function () {
        const distritos = window.listaDistritos || [];
        const filtrados = distritos.filter(d => d.idCanton == this.value);
        distritoSelect.innerHTML = '<option value="0" disabled selected>Seleccione un distrito</option>';
        filtrados.forEach(d => {
            distritoSelect.innerHTML += `<option value="${d.idDistrito}">${d.nombreDistrito}</option>`;
        });
    });
}

// Para la seccion de la empresa de hospedaje.
function iniciarUbicacionesDinamicasEmpresaHospedaje() {

    // Seleccionamos los elementos.
    const provinciaSelect = document.getElementById("provinciaHotel");
    const cantonSelect = document.getElementById("cantonHotel");
    const distritoSelect = document.getElementById("distritoHotel");

    if (!provinciaSelect || !cantonSelect || !distritoSelect) {

        return;
    }

    provinciaSelect.addEventListener("change", function () {
        const cantones = window.listaCantones || [];
        const filtrados = cantones.filter(c => c.idProvincia == this.value);
        cantonSelect.innerHTML = '<option value="0" disabled selected>Seleccione un canton</option>';
        filtrados.forEach(c => {
            cantonSelect.innerHTML += `<option value="${c.idCanton}">${c.nombreCanton}</option>`;
        });
        distritoSelect.innerHTML = '<option value="0" disabled selected>Seleccione un distrito</option>';
    });

    cantonSelect.addEventListener("change", function () {
        const distritos = window.listaDistritos || [];
        const filtrados = distritos.filter(d => d.idCanton == this.value);
        distritoSelect.innerHTML = '<option value="0" disabled selected>Seleccione un distrito</option>';
        filtrados.forEach(d => {
            distritoSelect.innerHTML += `<option value="${d.idDistrito}">${d.nombreDistrito}</option>`;
        });
    });
}

// Para la seccion de la empresa de recreacion.
function iniciarUbicacionesDinamicasRecreacion() {

    // Seleccionamos los elementos.
    const provinciaSelect = document.getElementById("provinciaRecreacion");
    const cantonSelect = document.getElementById("cantonRecreacion");
    const distritoSelect = document.getElementById("distritoRecreacion");

    if (!provinciaSelect || !cantonSelect || !distritoSelect) {

        return;
    }

    provinciaSelect.addEventListener("change", function () {
        const cantones = window.listaCantones || [];
        const filtrados = cantones.filter(c => c.idProvincia == this.value);
        cantonSelect.innerHTML = '<option value="0" disabled selected>Seleccione un canton</option>';
        filtrados.forEach(c => {
            cantonSelect.innerHTML += `<option value="${c.idCanton}">${c.nombreCanton}</option>`;
        });
        distritoSelect.innerHTML = '<option value="0" disabled selected>Seleccione un distrito</option>';
    });

    cantonSelect.addEventListener("change", function () {
        const distritos = window.listaDistritos || [];
        const filtrados = distritos.filter(d => d.idCanton == this.value);
        distritoSelect.innerHTML = '<option value="0" disabled selected>Seleccione un distrito</option>';
        filtrados.forEach(d => {
            distritoSelect.innerHTML += `<option value="${d.idDistrito}">${d.nombreDistrito}</option>`;
        });
    });
}

// Para la seccion de los servicios de recreaacion.
function iniciarUbicacionesDinamicasServiciosRecreacion() {

    // Seleccionamos los elementos.
    const provinciaSelect = document.getElementById("provinciaServicio");
    const cantonSelect = document.getElementById("cantonServicio");
    const distritoSelect = document.getElementById("distritoServicio");

    if (!provinciaSelect || !cantonSelect || !distritoSelect) {

        return;
    }

    provinciaSelect.addEventListener("change", function () {
        const cantones = window.listaCantones || [];
        const filtrados = cantones.filter(c => c.idProvincia == this.value);
        cantonSelect.innerHTML = '<option value="0" disabled selected>Seleccione un canton</option>';
        filtrados.forEach(c => {
            cantonSelect.innerHTML += `<option value="${c.idCanton}">${c.nombreCanton}</option>`;
        });
        distritoSelect.innerHTML = '<option value="0" disabled selected>Seleccione un distrito</option>';
    });

    cantonSelect.addEventListener("change", function () {
        const distritos = window.listaDistritos || [];
        const filtrados = distritos.filter(d => d.idCanton == this.value);
        distritoSelect.innerHTML = '<option value="0" disabled selected>Seleccione un distrito</option>';
        filtrados.forEach(d => {
            distritoSelect.innerHTML += `<option value="${d.idDistrito}">${d.nombreDistrito}</option>`;
        });
    });
}





// >>> ===== Seccion para el inico del proceso de busqueda. ===== <<<

// Llamar cuando se presiona el boton de inciar busqueda.
function IniciarBusqueda() {

    // Optener el filtro activivo.
    let filtroActivo = sessionStorage.getItem("filtroActivo");

    // Revisar a cual busuqeda hay que redirigir.
    if (filtroActivo === "hospedaje") {

        ProcesarBusquedaHospedaje(); 

    } else if (filtroActivo === "empresaHospedaje") {

        ProcesarBusquedaEmpresaHospedaje();

    } else if (filtroActivo === "empresaRecreacion") {

        ProcesarBusquedaEmpresaRecreacion();

    } else {

        ProcesarBusquedaServicios();

    }

    return;

}




// >>> ===== Seccion para el procesamiento de las busqueda. ===== <<<

// >> Esta seria la funcion para procesar la busqueda del hospedaje, aqui se optendrian los datos de los filtros.
async function ProcesarBusquedaHospedaje() {

    let barraBusqueda = document.getElementById("barraBusquedaInput").value.trim() || null;

    let fechaEntrada = document.getElementById("fechaEntradaInput").value || null;

    let fechaSalida = document.getElementById("fechaSalidaInput").value || null;

    let idTipoCama = parseInt(document.getElementById("tipoCamaSelect")?.value) || null;

    let precioMinimo = parseFloat(document.getElementById("precioMinimoHabitacionInput").value) || null;

    let precioMaximo = parseFloat(document.getElementById("precioMaximoHabitacionInput").value) || null;

    // Ubicacion.
    let idProvincia = parseInt(document.getElementById("provinciaHotel").value) || null;

    let idCanton = parseInt(document.getElementById("cantonHotel").value) || null;

    let idDistrito = parseInt(document.getElementById("distritoHotel").value) || null;

    // Parsar los seleciconados de los selects a int: parseInt(seleccion)

    // Lista de comodidades seleccionadas.
    let  comodiadesSeleccionadas = Array.from(document.querySelectorAll('input[name="ListaComodidades"]:checked'))
        .map(checkbox => parseInt(checkbox.value));

    console.log("Comodidades seleccionadas:", comodiadesSeleccionadas);


    const filtros = {
        barraBusqueda,
        fechaEntrada,
        fechaSalida,
        idTipoCama,
        listaComodidades: comodiadesSeleccionadas.length > 0 ? comodiadesSeleccionadas : null,
        precioMinimo,
        precioMaximo,
        idProvincia,
        idCanton,
        idDistrito
    };


    // Enviar la consulta con los datos que se obtuvieron.
    const datosEnviar = JSON.stringify(filtros);

    let datosRespuesta = await EnviaDatosHospedaje(datosEnviar);

    RenderizarDatosHabitaciones(datosRespuesta);

    return;
}


// >> Esta seria la funcion para procesar la busqueda de las empresas de hospedaje, aqui se optendrian los datos de los filtros.
async function ProcesarBusquedaEmpresaHospedaje() {

    let barraBusqueda = document.getElementById("barraBusquedaInput").value.trim() || null;

    // Ubicacion.
    let idProvincia = parseInt(document.getElementById("provinciaHotel").value) || null;

    let idCanton = parseInt(document.getElementById("cantonHotel").value) || null;

    let idDistrito = parseInt(document.getElementById("distritoHotel").value) || null;

    // Lista de comodidades seleccionadas.
    let comodiadesSeleccionadas = Array.from(document.querySelectorAll('input[name="ListaServiciosHoteles"]:checked'))
        .map(checkbox => parseInt(checkbox.value));

    console.log("Servicios de hotel seleccionados:", comodiadesSeleccionadas);

    let idTipoHotel = parseInt(document.getElementById("alojamiento").value) || null;

    // Aqui se guardarina los datos que se obtuvieron.

    const filtros = {
        barraBusqueda,
        idTipoHotel,
        listaServicios: comodiadesSeleccionadas.length > 0 ? comodiadesSeleccionadas : null,
        idProvincia,
        idCanton,
        idDistrito
    };


    const datosEnviar = JSON.stringify(filtros);

    let datosRespuesta = await EnviaDatosEmpresaHospedaje(datosEnviar);

    RenderizarDatosEmpresaHospedaje(datosRespuesta);

    return;

}


// >> Esta seria la funcion para procesar la busqueda de las empresas de recreacion, aqui se optendrian los datos de los filtros.
async function ProcesarBusquedaEmpresaRecreacion() {

    let barraBusqueda = document.getElementById("barraBusquedaInput").value.trim() || null;

    // Ubicacion.
    let idProvincia = parseInt(document.getElementById("provinciaRecreacion").value) || null;

    let idCanton = parseInt(document.getElementById("cantonRecreacion").value) || null;

    let idDistrito = parseInt(document.getElementById("distritoRecreacion").value) || null;

    // Servicios seleccionados.
    let serviciosSeleccionadas = Array.from(document.querySelectorAll('input[name="ListaServiciosEmpresaRecreacion"]:checked'))
        .map(checkbox => parseInt(checkbox.value));

    console.log("Servicios de recreacion seleccionados:", serviciosSeleccionadas);


    const filtros = {
        barraBusqueda,
        listaServicios: serviciosSeleccionadas.length > 0 ? serviciosSeleccionadas : null,
        idProvincia,
        idCanton,
        idDistrito
    };


    const datosEnviar = JSON.stringify(filtros);

    let datosRespuesta = await EnviaDatosEmpresaRecreacion(datosEnviar);

    RenderizarDatosEmpresaRecreacion(datosRespuesta);

    return;

}


// >> Esta seria la funcion para procesar la busqueda de los servicios, aqui se optendrian los datos de los filtros.
async function ProcesarBusquedaServicios() {

    let barraBusqueda = document.getElementById("barraBusquedaInput").value.trim() || null;

    let precioMinimo = parseFloat(document.getElementById("precioMinimoServicioInput").value) || null;

    let precioMaximo = parseFloat(document.getElementById("precioMaximoServicioInput").value) || null;

    // Ubicacion.
    let idProvincia = parseInt(document.getElementById("provinciaServicio").value) || null;

    let idCanton = parseInt(document.getElementById("cantonServicio").value) || null;

    let idDistrito = parseInt(document.getElementById("distritoServicio").value) || null;

    // Actividades seleccionados.
    let actividadesSeleccionadas = Array.from(document.querySelectorAll('input[name="ListaActividadesServicio"]:checked'))
        .map(checkbox => parseInt(checkbox.value));

    console.log("Actividades de recreacion seleccionados:", actividadesSeleccionadas);


    const filtros = {
        barraBusqueda,
        precioMinimo,
        precioMaximo,
        listaActividades: actividadesSeleccionadas.length ? actividadesSeleccionadas : null,
        idProvincia,
        idCanton,
        idDistrito
    };


    const datosEnviar = JSON.stringify(filtros);

    let datosRespuesta = await EnviaDatosServiciosRecreacion(datosEnviar);

    RenderizarDatosServicios(datosRespuesta);

    return;

}



// >>> ===== Seccion para la consulta de datos al controlador. ===== <<<

// Funcion fetch para el envio y optencion de datos al controlador. Se Recibe el Json ya creado.
async function EnviaDatosHospedaje(datos) {

    try {
        const response = await fetch('/Cliente/BuscarHabitaciones', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: datos
        });

        if (response.ok) {

            const resultado = await response.json();
            console.log("Datos del de la consulta de habitaciones: ", resultado);
            return resultado;
            //if (resultado.estado === 1) {

            //    return resultado.datosHabitaciones;
            //    //alert("Actividad registrada exitodamente.");
            //    //location.replace("/EmpresaRecreacion/Menu");

            //    //window.location.href = "@Url.Action('EmpresaHospedaje','Menu')";
            //    //window.location.href = `/Producto/Detalles?id=${id}`;
            //    //window.location.href = '/EmpresaHospedaje/Menu'; // Redirigir a la pagina de informacion del cliente.
            //} else {
            //    alert("Error en la respuesta de habitaciones: " + result.message);
            //}
        } else {
            alert("Error al buscar habitaciones. Por favor, intente nuevamente.");
        }
    } catch (error) {
        console.error("Error al enviar los datos:", error);
        alert("Ocurrió un error al buscar habitaciones. Por favor, intente nuevamente.");
    }

    return null;

}


// Funcion fetch para el envio y optencion de datos al controlador. Se Recibe el Json ya creado.
async function EnviaDatosEmpresaHospedaje(datos) {

    try {
        const response = await fetch('/Cliente/BuscarEmpresasHospedaje', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: datos
        });

        if (response.ok) {

            const resultado = await response.json();
            console.log("Datos del de la consulta de hoteles: ", resultado);
            return resultado;

            //if (resultado.estado === 1) {

            //    return resultado.datosHabitaciones;
            //    //alert("Actividad registrada exitodamente.");
            //    //location.replace("/EmpresaRecreacion/Menu");

            //    //window.location.href = "@Url.Action('EmpresaHospedaje','Menu')";
            //    //window.location.href = `/Producto/Detalles?id=${id}`;
            //    //window.location.href = '/EmpresaHospedaje/Menu'; // Redirigir a la pagina de informacion del cliente.
            //} else {
            //    alert("Error en la respuesta de hoteles: " + result.message);
            //}
        } else {
            alert("Error al buscar hoteles. Por favor, intente nuevamente.");
        }
    } catch (error) {
        console.error("Error al enviar los datos:", error);
        alert("Ocurrió un error al buscar hoteles. Por favor, intente nuevamente.");
    }

    return null;

}


// Funcion fetch para el envio y optencion de datos al controlador. Se Recibe el Json ya creado.
async function EnviaDatosEmpresaRecreacion(datos) {

    try {
        const response = await fetch('/Cliente/BuscarEmpresasRecreacion', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: datos
        });

        if (response.ok) {

            const resultado = await response.json();
            console.log("Datos del de la consulta de empresa de recreacion: ", resultado);
            return resultado;

            //if (resultado.estado === 1) {

            //    return resultado.datosHabitaciones;
            //    //alert("Actividad registrada exitodamente.");
            //    //location.replace("/EmpresaRecreacion/Menu");

            //    //window.location.href = "@Url.Action('EmpresaHospedaje','Menu')";
            //    //window.location.href = `/Producto/Detalles?id=${id}`;
            //    //window.location.href = '/EmpresaHospedaje/Menu'; // Redirigir a la pagina de informacion del cliente.
            //} else {
            //    alert("Error en la respuesta de habitaciones: " + result.message);
            //}
        } else {
            alert("Error al buscar las empresas de recreacion. Por favor, intente nuevamente.");
        }
    } catch (error) {
        console.error("Error al enviar los datos:", error);
        alert("Ocurrió un error al buscar las empresas de recreacion. Por favor, intente nuevamente.");
    }

    return null;

}


// Funcion fetch para el envio y optencion de datos al controlador. Se Recibe el Json ya creado.
async function EnviaDatosServiciosRecreacion(datos) {

    try {
        const response = await fetch('/Cliente/BuscarServiciosRecreacion', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: datos
        });

        if (response.ok) {

            const resultado = await response.json();
            console.log("Datos del de la consulta de servicios de recreacion: ", resultado);
            return resultado;

            //if (resultado.estado === 1) {

            //    return resultado.datosHabitaciones;
            //    //alert("Actividad registrada exitodamente.");
            //    //location.replace("/EmpresaRecreacion/Menu");

            //    //window.location.href = "@Url.Action('EmpresaHospedaje','Menu')";
            //    //window.location.href = `/Producto/Detalles?id=${id}`;
            //    //window.location.href = '/EmpresaHospedaje/Menu'; // Redirigir a la pagina de informacion del cliente.
            //} else {
            //    alert("Error en la respuesta de habitaciones: " + result.message);
            //}
        } else {
            alert("Error al buscar servicios de recreacion. Por favor, intente nuevamente.");
        }
    } catch (error) {
        console.error("Error al enviar los datos:", error);
        alert("Ocurrió un error al buscar servicios de recreacion. Por favor, intente nuevamente.");
    }

    return null;

}





// >>> ===== Seccion para el renderizado de los elementos en las ventanas. ===== <<<

// Funcion para renderizar en la ventana los resultados de las habitaciones que llegen en la cosnulta.
function RenderizarDatosHabitaciones(datos) {

    const contenedor = document.getElementById("contenedorResultados");
    contenedor.innerHTML = ""; // Limpiar resultados anteriores

    if (!datos || !datos.resultado || datos.resultado.length === 0) {
        contenedor.innerHTML = "<p> No se encontraron resultados con los filtros seleccionados.</p>";
        return;
    }

    datos.resultado.forEach(h => {
        const tarjeta = document.createElement("div");
        tarjeta.className = "resultado-tarjeta";
        tarjeta.innerHTML = `
            <h4>Habitación #${h.numeroHabitacion}</h4>
            <p><strong>Tipo:</strong> ${h.tipoHabitacion}</p>
            <p><strong>Ubicación:</strong> ${h.provincia}, ${h.canton}, ${h.distrito}</p>
            <p><strong>Empresa:</strong> ${h.idEmpresaHospedaje}</p>
        `;
        tarjeta.addEventListener("click", () => {
            //window.location.href = `/Habitaciones/DetalleHabitacion?id=${h.IdDatosHabitacion}`;
            console.log(`/Habitaciones/DetalleHabitacion?id=${h.idDatosHabitacion}`)
        });
        contenedor.appendChild(tarjeta);
    });


    return;
}

// Funcion para renderizar en la ventana los resultados de las empresas de hospedaje que llegen en la cosnulta.
function RenderizarDatosEmpresaHospedaje(datos) {


    const contenedor = document.getElementById("contenedorResultados");
    contenedor.innerHTML = ""; // Limpiar resultados anteriores

    if (!datos || !datos.resultado || datos.resultado.length === 0) {
        contenedor.innerHTML = "<p> No se encontraron resultados con los filtros seleccionados.</p>";
        return;
    }

    datos.resultado.forEach(e => {
        const tarjeta = document.createElement("div");
        tarjeta.className = "resultado-tarjeta";
        tarjeta.innerHTML = `
            <h4>${e.nombreHotel}</h4>
            <p><strong>Tipo:</strong> ${e.tipoHotel}</p>
            <p><strong>Ubicación:</strong> ${e.provincia}, ${e.canton}, ${e.distrito}</p>                        
        `;
        // ${e.SitioWeb ? `<p><a href="${e.SitioWeb}" target="_blank">Sitio Web</a></p>` <p><strong>Dirección:</strong> ${e.SenasExactas}</p>
        tarjeta.addEventListener("click", () => {
            //window.location.href = `/Habitaciones/DetalleHabitacion?id=${h.IdDatosHabitacion}`;
            console.log(`/EmpresaRecreacion/Menu?id=${e.cedulaJuridica}`)
        });
        contenedor.appendChild(tarjeta);
    });

    return;
}

// Funcion para renderizar en la ventana los resultados de las empresa de recreacion que llegen en la cosnulta.
function RenderizarDatosEmpresaRecreacion(datos) {

    const contenedor = document.getElementById("contenedorResultados");
    contenedor.innerHTML = ""; // Limpiar resultados anteriores

    if (!datos || !datos.resultado || datos.resultado.length === 0) {
        contenedor.innerHTML = "<p> No se encontraron resultados con los filtros seleccionados.</p>";
        return;
    }

    datos.resultado.forEach(e => {
        const tarjeta = document.createElement("div");
        tarjeta.className = "resultado-tarjeta";
        tarjeta.innerHTML = `
            <h4>${e.nombreEmpresa}</h4>
            <p><strong>Contacto:</strong> ${e.personaAContactar}</p>
            <p><strong>Ubicación:</strong> ${e.provincia}, ${e.canton}, ${e.distrito}</p>
        `;
        tarjeta.addEventListener("click", () => {
            //window.location.href = `/Habitaciones/DetalleHabitacion?id=${h.IdDatosHabitacion}`;
            console.log(`/Habitaciones/DetalleHabitacion?id=${e.cedulaJuridica}`)
        });
        contenedor.appendChild(tarjeta);
    });

    return;
}

// Funcion para renderizar en la ventana los resultados de los servicios que llegen en la cosnulta.
function RenderizarDatosServicios(datos) {

    const contenedor = document.getElementById("contenedorResultados");
    contenedor.innerHTML = ""; // Limpiar resultados anteriores

    if (!datos || !datos.resultado || datos.resultado.length === 0) {
        contenedor.innerHTML = "<p> No se encontraron resultados con los filtros seleccionados.</p>";
        return;
    }

    datos.resultado.forEach(s => {
        const tarjeta = document.createElement("div");
        tarjeta.className = "resultado-tarjeta";
        tarjeta.innerHTML = `
            <h4>${s.nombreServicio}</h4>
            <p><strong>Precio:</strong> ₡${s.precio.toLocaleString("es-CR", { minimumFractionDigits: 2 })}</p>
            
            <p><strong>Ubicación:</strong> ${s.provincia}, ${s.canton}, ${s.distrito}</p>
        `;
 
        tarjeta.addEventListener("click", () => {
            //window.location.href = `/Habitaciones/DetalleHabitacion?id=${h.IdDatosHabitacion}`;
            console.log(`/Sercivios/SeviciosView?id=${s.idServicio}`)
        });
        contenedor.appendChild(tarjeta);
    });


    return;
}





document.addEventListener("DOMContentLoaded", function () {

    InciarUbicacionesDinamicas();
    InicarInteractividadFiltros();


});