function seleccionarModo(modo) {
    const label = document.getElementById("labelFiltro");
    const input = document.getElementById("inputFiltro");

    if (modo === "reserva") {
        label.innerText = "Introduzca el ID de su reservación";
        input.placeholder = "Ej: 12345";
    } else if (modo === "tipo") {
        label.innerText = "Introduzca el ID del tipo de habitación";
        input.placeholder = "Ej: 1";
    } else if (modo === "numero") {
        label.innerText = "Introduzca el número de su Habitación";
        input.placeholder = "Ej: 203";
    }
}

function buscarFacturas() {
    const id = document.getElementById("inputFiltro").value;
    const inicio = document.getElementById("fechaInicio").value;
    const fin = document.getElementById("fechaFin").value;
    const resultado = document.querySelector(".resultados");

    resultado.innerText = `Mostrando resultados para ID: ${id}, entre ${inicio} y ${fin}`;
}


function InciarUbicacionesDinamicas() {

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


function formatearFecha(fechaString) {
    const fecha = new Date(fechaString);
    return fecha.toLocaleString('es-CR', {
        dateStyle: 'short',
        timeStyle: 'short'
    });
}

function formatearFechaCorta(fechaOnly) {
    const fecha = new Date(fechaOnly + "T00:00:00");
    return fecha.toLocaleDateString('es-CR', { dateStyle: 'medium' });
}

// Funcion para lo que seria desplesgar y mostrar los div para cada tipo de reportes.
function controlSeccionesV1(seccion) {
//    const parrafo = document.getElementById('miParrafo');
//    parrafo.classList.add('resaltado'); // Añade la clase 'resaltado'

//    const parrafo = document.getElementById('miParrafo');
    //    parrafo.classList.remove('resaltado');
    console.log("Seccion seleccionada: ", seccion)
    if (seccion === 'reserva') { // Consultar facturas por ID de reserva.
        const reservaEspecificaDiv = document.getElementById("ReservaEspecificaDiv");
        const tipoHabitacionEspecificaDiv = document.getElementById("TipoHabitacionEspecificaDiv");
        const habitacionEspecificaDiv = document.getElementById("HabitacionEspecificaDiv");
        const diaEspecificoDiv = document.getElementById("DiaEspecificoDiv");
        const mesEspecificoDiv = document.getElementById("mesEspecificoDiv");
        const anioEspecifivoDiv = document.getElementById("AnioEspecifivoDiv");
        const fechaEspecificaDiv = document.getElementById("fechaEspecificaDiv");
        const tiposHabitacionesDiv = document.getElementById("TiposHabitacionesDiv");
        const edadEspecificaDiv = document.getElementById("EdadEspecificaDiv");
        const demandaDiv = document.getElementById("demandaDiv");


        // Remover la clase hidden.
        reservaEspecificaDiv.classList.remove('hidden');

        // Añadir el hidden a las demas clase. No se que pasa en caso de que ya lo tengan.
        tipoHabitacionEspecificaDiv.classList.add('hidden');
        habitacionEspecificaDiv.classList.add('hidden');
        diaEspecificoDiv.classList.add('hidden');
        mesEspecificoDiv.classList.add('hidden');
        anioEspecifivoDiv.classList.add('hidden');
        fechaEspecificaDiv.classList.add('hidden');
        tiposHabitacionesDiv.classList.add('hidden');
        edadEspecificaDiv.classList.add('hidden');
        demandaDiv.classList.add('hidden');

        return;


    } else if (seccion === 'tipo') { // Consultar facturas por tipo de habitacion especifico.

        const reservaEspecificaDiv = document.getElementById("ReservaEspecificaDiv");
        const tipoHabitacionEspecificaDiv = document.getElementById("TipoHabitacionEspecificaDiv");
        const habitacionEspecificaDiv = document.getElementById("HabitacionEspecificaDiv");
        const diaEspecificoDiv = document.getElementById("DiaEspecificoDiv");
        const mesEspecificoDiv = document.getElementById("mesEspecificoDiv");
        const anioEspecifivoDiv = document.getElementById("AnioEspecifivoDiv");
        const fechaEspecificaDiv = document.getElementById("fechaEspecificaDiv");
        const tiposHabitacionesDiv = document.getElementById("TiposHabitacionesDiv");
        const edadEspecificaDiv = document.getElementById("EdadEspecificaDiv");
        const demandaDiv = document.getElementById("demandaDiv");



    } else if (seccion === 'numero') { // Consultar facturas por numero de habitacion especifico.

        const reservaEspecificaDiv = document.getElementById("ReservaEspecificaDiv");
        const tipoHabitacionEspecificaDiv = document.getElementById("TipoHabitacionEspecificaDiv");
        const habitacionEspecificaDiv = document.getElementById("HabitacionEspecificaDiv");
        const diaEspecificoDiv = document.getElementById("DiaEspecificoDiv");
        const mesEspecificoDiv = document.getElementById("mesEspecificoDiv");
        const anioEspecifivoDiv = document.getElementById("AnioEspecifivoDiv");
        const fechaEspecificaDiv = document.getElementById("fechaEspecificaDiv");
        const tiposHabitacionesDiv = document.getElementById("TiposHabitacionesDiv");
        const edadEspecificaDiv = document.getElementById("EdadEspecificaDiv");
        const demandaDiv = document.getElementById("demandaDiv");


    } else if (seccion === 'dia') { // Consultar facturas por dia especifico.

        const reservaEspecificaDiv = document.getElementById("ReservaEspecificaDiv");
        const tipoHabitacionEspecificaDiv = document.getElementById("TipoHabitacionEspecificaDiv");
        const habitacionEspecificaDiv = document.getElementById("HabitacionEspecificaDiv");
        const diaEspecificoDiv = document.getElementById("DiaEspecificoDiv");
        const mesEspecificoDiv = document.getElementById("mesEspecificoDiv");
        const anioEspecifivoDiv = document.getElementById("AnioEspecifivoDiv");
        const fechaEspecificaDiv = document.getElementById("fechaEspecificaDiv");
        const tiposHabitacionesDiv = document.getElementById("TiposHabitacionesDiv");
        const edadEspecificaDiv = document.getElementById("EdadEspecificaDiv");
        const demandaDiv = document.getElementById("demandaDiv");



    } else if (seccion === 'mes') { // Consultar facturas por mes.

        const reservaEspecificaDiv = document.getElementById("ReservaEspecificaDiv");
        const tipoHabitacionEspecificaDiv = document.getElementById("TipoHabitacionEspecificaDiv");
        const habitacionEspecificaDiv = document.getElementById("HabitacionEspecificaDiv");
        const diaEspecificoDiv = document.getElementById("DiaEspecificoDiv");
        const mesEspecificoDiv = document.getElementById("mesEspecificoDiv");
        const anioEspecifivoDiv = document.getElementById("AnioEspecifivoDiv");
        const fechaEspecificaDiv = document.getElementById("fechaEspecificaDiv");
        const tiposHabitacionesDiv = document.getElementById("TiposHabitacionesDiv");
        const edadEspecificaDiv = document.getElementById("EdadEspecificaDiv");
        const demandaDiv = document.getElementById("demandaDiv");


    } else if (seccion === 'fechas') { // Consultar facturas por rango de fechas.

        const reservaEspecificaDiv = document.getElementById("ReservaEspecificaDiv");
        const tipoHabitacionEspecificaDiv = document.getElementById("TipoHabitacionEspecificaDiv");
        const habitacionEspecificaDiv = document.getElementById("HabitacionEspecificaDiv");
        const diaEspecificoDiv = document.getElementById("DiaEspecificoDiv");
        const mesEspecificoDiv = document.getElementById("mesEspecificoDiv");
        const anioEspecifivoDiv = document.getElementById("AnioEspecifivoDiv");
        const fechaEspecificaDiv = document.getElementById("fechaEspecificaDiv");
        const tiposHabitacionesDiv = document.getElementById("TiposHabitacionesDiv");
        const edadEspecificaDiv = document.getElementById("EdadEspecificaDiv");
        const demandaDiv = document.getElementById("demandaDiv");


    } else if (seccion === 'tipoHabitacion') { // Conocer las reservas que han sido cerradas

        const reservaEspecificaDiv = document.getElementById("ReservaEspecificaDiv");
        const tipoHabitacionEspecificaDiv = document.getElementById("TipoHabitacionEspecificaDiv");
        const habitacionEspecificaDiv = document.getElementById("HabitacionEspecificaDiv");
        const diaEspecificoDiv = document.getElementById("DiaEspecificoDiv");
        const mesEspecificoDiv = document.getElementById("mesEspecificoDiv");
        const anioEspecifivoDiv = document.getElementById("AnioEspecifivoDiv");
        const fechaEspecificaDiv = document.getElementById("fechaEspecificaDiv");
        const tiposHabitacionesDiv = document.getElementById("TiposHabitacionesDiv");
        const edadEspecificaDiv = document.getElementById("EdadEspecificaDiv");
        const demandaDiv = document.getElementById("demandaDiv");


    } else if (seccion === 'edad') { // Consultar la edad de las personas que han reservado.

        const reservaEspecificaDiv = document.getElementById("ReservaEspecificaDiv");
        const tipoHabitacionEspecificaDiv = document.getElementById("TipoHabitacionEspecificaDiv");
        const habitacionEspecificaDiv = document.getElementById("HabitacionEspecificaDiv");
        const diaEspecificoDiv = document.getElementById("DiaEspecificoDiv");
        const mesEspecificoDiv = document.getElementById("mesEspecificoDiv");
        const anioEspecifivoDiv = document.getElementById("AnioEspecifivoDiv");
        const fechaEspecificaDiv = document.getElementById("fechaEspecificaDiv");
        const tiposHabitacionesDiv = document.getElementById("TiposHabitacionesDiv");
        const edadEspecificaDiv = document.getElementById("EdadEspecificaDiv");
        const demandaDiv = document.getElementById("demandaDiv");


    } else { // Este sera el de consultar las empresas mas demandas por fecha y ubicacion.

        const reservaEspecificaDiv = document.getElementById("ReservaEspecificaDiv");
        const tipoHabitacionEspecificaDiv = document.getElementById("TipoHabitacionEspecificaDiv");
        const habitacionEspecificaDiv = document.getElementById("HabitacionEspecificaDiv");
        const diaEspecificoDiv = document.getElementById("DiaEspecificoDiv");
        const mesEspecificoDiv = document.getElementById("mesEspecificoDiv");
        const anioEspecifivoDiv = document.getElementById("AnioEspecifivoDiv");
        const fechaEspecificaDiv = document.getElementById("fechaEspecificaDiv");
        const tiposHabitacionesDiv = document.getElementById("TiposHabitacionesDiv");
        const edadEspecificaDiv = document.getElementById("EdadEspecificaDiv");
        const demandaDiv = document.getElementById("demandaDiv");



    }



}


// Control para saber que divs se deben de mostrar.
function controlSecciones(seccion) {
    console.log("Sección seleccionada:", seccion);

    const mapeo = {
        reserva: "ReservaEspecificaDiv",
        tipo: "TipoHabitacionEspecificaDiv",
        numero: "HabitacionEspecificaDiv",
        dia: "DiaEspecificoDiv",
        mes: "mesEspecificoDiv",
        anio: "AnioEspecifivoDiv",
        fechas: "fechaEspecificaDiv",
        tipoHabitacion: "TiposHabitacionesDiv",
        edad: "EdadEspecificaDiv",
        demanda: "demandaDiv"
    };

    const secciones = document.querySelectorAll(".reserva-especifca-div");
    secciones.forEach(div => div.classList.add("hidden")); 

    const mostrar = mapeo[seccion];
    if (mostrar) {
        document.getElementById(mostrar)?.classList.remove("hidden"); 
    }
}



// Inciar listeners para los forms de las consultas.


function inicarListenersReportes() {

    // Seleccionar los elementos
    const reservaEspecifica = document.getElementById("reservaEspecificaID");

    const tipoHabitacionEspecificaForm = document.getElementById("tipoHabitacionEspecifica");

    const habitacionEspecificaForm = document.getElementById("habitacionEspecificaForm");

    const diaEspecificoForm = document.getElementById("diaEspecificoForm");

    const mesEspecificoForm = document.getElementById("mesEspecificoForm");

    const anioEspecificoForm = document.getElementById("anioEspecificoForm");

    const fechaEspecificaForm = document.getElementById("fechaEspecificaForm");

    const tiposHabitacionesForm = document.getElementById("tiposHabitacionesForm");

    const edadesForm = document.getElementById("edadesForm");

    const demadaForm = document.getElementById("demadaForm");




    // Agregar los listeners.
    reservaEspecifica.addEventListener("submit", function (event) {
        event.preventDefault();
        //console.log("Empezando envio del formulario");
        //const formData = new FormData(form);
        procesarBusquedaReservacion();
    });


    tipoHabitacionEspecificaForm.addEventListener("submit", function (event) {
        event.preventDefault();
        //console.log("Empezando envio del formulario");
        //const formData = new FormData(form);
        procesarTipoHabitacionEspecifica();
    });

    habitacionEspecificaForm.addEventListener("submit", function (event) {
        event.preventDefault();
        //console.log("Empezando envio del formulario");
        //const formData = new FormData(form);
        procesarHabitacionEspecifica();
    });

    diaEspecificoForm.addEventListener("submit", function (event) {
        event.preventDefault();
        //console.log("Empezando envio del formulario");
        //const formData = new FormData(form);
        procesarConsultaDiaEspecifico();
    });


    mesEspecificoForm.addEventListener("submit", function (event) {
        event.preventDefault();
        //console.log("Empezando envio del formulario");
        //const formData = new FormData(form);
        procesarConsultaPorMes();
    });


    anioEspecificoForm.addEventListener("submit", function (event) {
        event.preventDefault();
        //console.log("Empezando envio del formulario");
        //const formData = new FormData(form);
        procesarConsultaPorAnio();
    });

    fechaEspecificaForm.addEventListener("submit", function (event) {
        event.preventDefault();
        //console.log("Empezando envio del formulario");
        //const formData = new FormData(form);
        procesarConsultaPorRangoFechas();
    });

    tiposHabitacionesForm.addEventListener("submit", function (event) {
        event.preventDefault();
        //console.log("Empezando envio del formulario");
        //const formData = new FormData(form);
        procesarConsultaTiposDeHabitaciones();
    });


    edadesForm.addEventListener("submit", function (event) {
        event.preventDefault();
        //console.log("Empezando envio del formulario");
        //const formData = new FormData(form);
        procesarConsultaEdadReservas();
    });

    demadaForm.addEventListener("submit", function (event) {
        event.preventDefault();
        //console.log("Empezando envio del formulario");
        //const formData = new FormData(form);
        procesarConsultaDemandaHoteles();
    });




    return;
}




// Apartado para el procesamiento de los reportes.

function procesarReportes(tipoReporte) {

    if (tipoReporte === 'reservaEspecifica') { // Consultar facturas por ID de reserva.

        //const reservaEspecificaDiv = document.getElementById("ReservaEspecificaDiv");
        //const tipoHabitacionEspecificaDiv = document.getElementById("TipoHabitacionEspecificaDiv");


        procesarBusquedaReservacion();


        return;


    } else if (tipoReporte === 'tipo') { // Consultar facturas por tipo de habitacion especifico.






    } else if (tipoReporte === 'numero') { // Consultar facturas por numero de habitacion especifico.



    } else if (tipoReporte === 'dia') { // Consultar facturas por dia especifico.





    } else if (tipoReporte === 'mes') { // Consultar facturas por mes.




    } else if (tipoReporte === 'fechas') { // Consultar facturas por rango de fechas.




    } else if (tipoReporte === 'tipoHabitacion') { // Conocer las reservas que han sido cerradas


   
    } else if (tipoReporte === 'edad') { // Consultar la edad de las personas que han reservado.


    } else { // Este sera el de consultar las empresas mas demandas por fecha y ubicacion.





    }




}

// >>> ===== Seccion para el repotere de un reservacion especifica. ===== <<<

// Procesar el reporte para una habitacion especifica.
async function procesarBusquedaReservacion() {

    // Obtener los elementos que se ocupan para la consulta.

    const data = new FormData(document.getElementById("reservaEspecificaID"));

    // Validar los elementos optenidos.
    if (!validarDatosReservaEspecifica()) {
        return;
    }


    // Enviar el fetch con lo datos y recibir el resultado.
    console.log("Iniciando envio de datos.");
    let datos = await enviarConsultaReservaEspecifica(data);
    // Renderizar el resultado.

    if (datos.estado === 1) {

        renderizarResultadosReservaEspecifica(datos.reservacion);

    } else {

        alert('Ocurrio un eror con los datos recibido de la consulta. Por favor intentelo nuevamente.');
    }
    return;

}

// Validar que los datos a enviar esten correctos.
function validarDatosReservaEspecifica() {

    const idReservacion = document.getElementById("idReservacionInput");

    if (parseInt(idReservacion.value) < 0) {
        alert('No hay IDs de reservaciones negativos...')
        return false;
    }


    return true;
}

// Realizar la consulta para optener los datos requeridos.
async function enviarConsultaReservaEspecifica(datos) {

    try {
        const response = await fetch('/EmpresaHospedaje/ReporteReservaEspecifica', {
            method: 'POST',
            body: datos
        });
        if (response.ok) {

            const resultado = await response.json();
            console.log("Datos recibidos del reporte de reserva especifica: ", resultado);

            return resultado;

        } else {
            alert("Error al consultar el reporte por reserva especifica. Por favor, intente nuevamente.");
        }
    } catch (error) {
        console.error("Error al enviar los datos:", error);
        alert("Ocurrio un error al consultar el reporte por reserva especifica. Por favor, intente nuevamente.");
    }

}

// Renderizar los resultados optenidos.
function renderizarResultadosReservaEspecifica(reserva) {
    
    const contenedorResultados = document.getElementById('contenerdorResultados');

    contenedorResultados.innerHTML = '';

    // Renderizar los datos que se recibieron.

    //if (!Array.isArray(datos) || datos.length === 0) {
    //    contenedorResultados.innerHTML = '<p>No se encontraron resultados para esta búsqueda.</p>';
    //    return;
    //}

    //datos.forEach(reserva => {
        const tarjeta = document.createElement('div');
        tarjeta.style.border = '1px solid #ccc';
        tarjeta.style.padding = '15px';
        tarjeta.style.marginBottom = '20px';
        tarjeta.style.borderRadius = '6px';
        tarjeta.style.boxShadow = '0 2px 4px rgba(0, 0, 0, 0.1)';
        tarjeta.style.backgroundColor = '#fff';

        tarjeta.innerHTML = `
            <h4 style="margin-top: 0;">Reservación #${reserva.idReservacion}</h4>
            <p><strong>Habitación:</strong> ${reserva.numeroHabitacion}</p>
            <p><strong>Cliente:</strong> ${reserva.cliente}</p>
            <p><strong>Entrada:</strong> ${formatearFecha(reserva.fechaHoraIngreso)}</p>
            <p><strong>Salida:</strong> ${formatearFecha(reserva.fechaHoraSalida)}</p>
            <p><strong>Personas:</strong> ${reserva.cantidadPersonas}</p>
            <p><strong>Vehiculo:</strong> ${reserva.vehiculo}</p>
            <p><strong>Estadía total:</strong> ${reserva.estadiaTotal} noche${reserva.estadiaTotal === 1 ? '' : 's'}</p>
            <p><strong>Precio total:</strong> ₡${Number(reserva.precioTotal).toLocaleString()}</p>
            <p><strong>Estado:</strong> ${reserva.estado}</p>
        `;

        contenedorResultados.appendChild(tarjeta);
    //});

    return;


}



// >>> =====  ===== <<<

// Para el tipo de habitacion especifica.
async function procesarTipoHabitacionEspecifica() {
    const data = new FormData(document.getElementById("tipoHabitacionEspecifica"));
    if (!validarTipoHabitacionEspecifica()) {
        return;
    }

    let datos = await enviarConsultaTipoHabitacionEspecifica(data);
    if (datos.estado === 1) {
        renderizarResultadosFacturas(datos.facturas);
        console.log("Datos del resultado para tipo de habitacion: ", datos);
    } else {
        alert("Ocurrió un error con la consulta.");
    }
    return;
}

function validarTipoHabitacionEspecifica() {
    const select = document.getElementById("tipoHabitacionesSelect");
    if (parseInt(select.value) <= 0) {
        alert("Seleccione un tipo de habitacion valido.");
        return false;
    }
    return true;
}

async function enviarConsultaTipoHabitacionEspecifica(datos) {
    try {

        const response = await fetch('/EmpresaHospedaje/ReporteTipoHabitacionEspecifico', {
            method: 'POST',
            body: datos
        });

        if (response.ok) {

            return await response.json();

        } else {

            alert("Error en la respuesta a la consulta por tipo de habitacion.");

        }

    } catch (err) {
        alert("Error al consultar tipo de habitacion.");
        console.error(err);
    }
}

function renderizarResultadosTipoHabitacion(datos) {



}




// >>> =====  ===== <<<
async function procesarHabitacionEspecifica() {
    const data = new FormData(document.getElementById("habitacionEspecificaForm"));
    if (!validarHabitacionEspecifica()) {
        return;
    }

    let datos = await enviarConsultaHabitacionEspecifica(data);
    if (datos.estado === 1) {
        console.log("Consulta exitosa.", datos);

        renderizarResultadosFacturas(datos.facturas);
    } else {
        alert("Consulta fallida.");
    }
}

function validarHabitacionEspecifica() {
    const valor = parseInt(document.getElementById("habitacionEspecificaInput").value);
    if (isNaN(valor) || valor <= 0) {
        alert("Ingrese un numero de habitacion valido.");
        return false;
    }
    return true;
}

async function enviarConsultaHabitacionEspecifica(datos) {

    try {
        const response = await fetch('/EmpresaHospedaje/ReporteHabitacionEspecifica', {
            method: 'POST',
            body: datos
        });

        if (response.ok) {

            return await response.json();

        } else {
            alert("Error en la respuesta al consultar los reportes para una habitacion especifica.");
        }

    } catch (err) {
        alert("Error al consultar habitación.");
        console.error(err);
    }
}



// >>> =====  ===== <<<

async function procesarConsultaDiaEspecifico() {

    const data = new FormData(document.getElementById("diaEspecificoForm"));
    if (!validarDiaEspecifico()) {
        return;
    }

    const datos = await enviarConsultaDiaEspecifico(data);

    if (datos.estado === 1) {

        renderizarResultadosFacturas(datos.facturas);
        console.log("Consulta exitosa.", datos);


    } else {

        alert("No se pudo realizar la consulta por dia.");

    }
}

function validarDiaEspecifico() {
    const dia = document.getElementById("diaInput").value;
    if (!dia) {
        alert("Seleccione un día.");
        return false;
    }
    return true;
}

async function enviarConsultaDiaEspecifico(datos) {
    try {
        const response = await fetch('/EmpresaHospedaje/ReporteDiaEspecifico', {
            method: 'POST',
            body: datos
        });

        if (response.ok) {

            return await response.json();

        } else {

            alert("Error en la respuesta a la consulta del reporte de dia especifico.");

        }

    } catch (e) {
        alert("Error al consultar por dia.");
        console.error(e);
    }
}



// >>> =====  ===== <<<

async function procesarConsultaPorMes() {
    const data = new FormData(document.getElementById("mesEspecificoForm"));
    if (!validarConsultaMes()) {
        return;
    }

    const datos = await enviarConsultaPorMes(data);

    if (datos.estado === 1) {
        console.log("Consulta exitosa.", datos);

        renderizarResultadosFacturas(datos.facturas);

    } else {
        alert("Consulta por mes fallida.");
    }
}

function validarConsultaMes() {
    const mes = parseInt(document.getElementById("mesEspecificoSelect").value);
    if (mes <= 0 || mes > 12) {
        alert("Seleccione un mes valido.");
        return false;
    }
    return true;
}

async function enviarConsultaPorMes(datos) {
    try {
        const response = await fetch('/EmpresaHospedaje/ReporteMesEspecifico', {
            method: 'POST',
            body: datos
        });
        if (response.ok) {
            return await response.json();
        } else {
            alert("Error en la respuesta de los datos del reporte por mes.");
        }
    } catch (e) {
        alert("Error consultando por mes.");
        console.error(e);
    }
}


// >>> =====  ===== <<<

async function procesarConsultaPorAnio() {
    const data = new FormData(document.getElementById("anioEspecificoForm"));
    if (!validarConsultaAnio()) return;

    const datos = await enviarConsultaPorAnio(data);
    if (datos.estado === 1) {
        console.log("Consulta exitosa.", datos);


        renderizarResultadosFacturas(datos.facturas);

    } else {
        alert("Consulta por año fallida.");
    }
}

function validarConsultaAnio() {
    const anio = parseInt(document.getElementById("anioEspecificoInput").value);
    if (anio < 2000 || anio > new Date().getFullYear()) {
        alert("Ingrese un año valido.");
        return false;
    }
    return true;
}

async function enviarConsultaPorAnio(datos) {
    try {
        const response = await fetch('/EmpresaHospedaje/ReporteAnioEspecifico', {
            method: 'POST',
            body: datos
        });
        if (response.ok) {
            return await response.json();
        } else {
            alert("Error en la respuesta de los datos del reporte por año.");

        }
    } catch (e) {
        alert("Error consultando por año.");
        console.error(e);
    }
}

// >>> =====  ===== <<<

// Rango de fechas.
async function procesarConsultaPorRangoFechas() {
    const data = new FormData(document.getElementById("fechaEspecificaForm"));
    if (!validarRangoFechas()) {
        return;
    }

    const datos = await enviarConsultaRangoFechas(data);
    if (datos.estado === 1 && datos != -1) {
        console.log("Consulta exitosa.", datos);


        renderizarResultadosFacturas(datos.facturas);

    } else {
        alert("Consulta por rango de fechas fallida fallida.");
    }
}

function validarRangoFechas() {
    const inicio = document.getElementById("fechaInicioRango").value;
    const fin = document.getElementById("fechaFinRango").value;

    if (!inicio || !fin || new Date(inicio) > new Date(fin)) {
        alert("Ingrese un rango de fechas valido.");
        return false;
    }
    return true;
}

async function enviarConsultaRangoFechas(datos) {
    try {
        const response = await fetch('/EmpresaHospedaje/ReporteRangoDeFechas', {
            method: 'POST',
            body: datos
        });
        if (response.ok) {
            return await response.json();
        } else {
            alert("Error en la respuesta de los datos del reporte por rango de fechas..");
            return -1;
        }
    } catch (e) {
        alert("Error en el reporte por rango de fechas.");
        console.error(e);
    }
}



// >>> =====  ===== <<<

// Lista de tipo de habitaciones.
async function procesarConsultaTiposDeHabitaciones() {
    const data = new FormData(document.getElementById("tiposHabitacionesForm"));
    const seleccionados = data.getAll("ListaTiposHabitacion");

    console.log("Pass1")
    if (!validarConsultaTiposDeHabitaciones(seleccionados)) {
        return;
    }

    const datos = await enviarConsultaReporteTiposDeHabitacion(data);
    if (datos.estado === 1) {
        console.log("Consulta exitosa.", datos);
        renderizarResultadosReservaciones(datos.reservaciones);
    } else {
        alert("No se pudo consultar los tipos de habitacion.");
    }
}

function validarConsultaTiposDeHabitaciones(data) {

    if (!data.length) {
        alert("Selecciona al menos un tipo de habitacion.");
        return false;
    }
    return true;
}

async function enviarConsultaReporteTiposDeHabitacion(datos) {
    try {
        const response = await fetch('/EmpresaHospedaje/ReporteTiposDeHabitaciones', {
            method: 'POST',
            body: datos
        });
        if (response.ok) {
            return await response.json();
        } else {
            return -1;
        }
    } catch (e) {
        alert("Error en la consulta por múltiples tipos de habitación.");
        console.error(e);
    }
}




// >>> =====  ===== <<<
async function procesarConsultaEdadReservas() {
    const data = new FormData(document.getElementById("edadesForm"));

    const datos = await enviarConsultaEdades(data);
    if (datos.estado === 1) {
        renderizarRangoEdadReservas(datos.rangoEdades);
        console.log("Consulta exitosa.", datos);

    } else {
        alert("Consulta de edades fallida.");
    }
}


async function enviarConsultaEdades(datos) {
    try {
        const response = await fetch('/EmpresaHospedaje/ReporteRangoDeEdades', {
            method: 'POST',
            body: datos
        });
        if (response.ok) {
            return await response.json();
        } else {
            alert("Error en la respuesta de los datos del rango de edades.");

        }
    } catch (e) {
        alert("Error en consulta de edades.");
        console.error(e);
    }
}



// >>> =====  ===== <<<

// Rango de edades:
async function procesarConsultaDemandaHoteles() {
    const data = new FormData(document.getElementById("demadaForm"));

    if (!validarDemandaUbicacion()) return;

    const datos = await enviarConsultaDemandaHoteles(data);
    if (datos.estado === 1) {
        renderizarDemandaHoteles(datos.demandaHoteles);
        console.log("Consulta exitosa.", datos);

    } else {
        alert("No se pudieron obtener datos de demanda.");
    }
    return;
}

function validarDemandaUbicacion() {
    const fecha = document.getElementById("fechaDemandaInput").value;
    const provincia = parseInt(document.getElementById("provinciaHabitacion").value);
    const canton = parseInt(document.getElementById("cantonHabitacion").value);
    const distrito = parseInt(document.getElementById("distritoHabitacion").value);

    if (!fecha) {
        alert("Selecciona una fecha para la consulta.");
        return false;
    }

    // La ubicacion podia ser opcional.
    //if (provincia <= 0 || canton <= 0 || distrito <= 0) {
    //    alert("Completa la ubicacion completa: provincia, canton y distrito.");
    //    return false;
    //}

    return true;
}


async function enviarConsultaDemandaHoteles(datos) {
    try {
        const response = await fetch('/EmpresaHospedaje/ReporteHotelesConMayorDemanda', {
            method: 'POST',
            body: datos
        });
        if (response.ok) {
            const resultado = await response.json();
            console.log("Datos recibidos del reporte de demanda:", resultado);
            return resultado;
        } else {
            alert("Error en la respuesta del servidor.");
        }
    } catch (e) {
        alert("Error al consultar reporte de demanda.");
        console.error(e);
    }
}



function renderizarResultadosFacturas(facturas) {
    const contenedor = document.getElementById('contenerdorResultados');
    contenedor.innerHTML = '';

    if (!Array.isArray(facturas) || facturas.length === 0) {
        contenedor.innerHTML = '<p>No se encontraron facturas para mostrar.</p>';
        return;
    }

    facturas.forEach(factura => {
        const tarjeta = document.createElement('div');
        tarjeta.style.border = '1px solid #ccc';
        tarjeta.style.borderRadius = '6px';
        tarjeta.style.padding = '15px';
        tarjeta.style.marginBottom = '20px';
        tarjeta.style.boxShadow = '0 1px 3px rgba(0,0,0,0.1)';
        tarjeta.style.backgroundColor = '#fff';

        tarjeta.innerHTML = `
            <h4 style="margin-top: 0;">Factura #${factura.idFacturacion}</h4>
            <p><strong>Reservación:</strong> ${factura.idReservacion}</p>
            <p><strong>Fecha:</strong> ${formatearFechaCorta(factura.fechaFacturacion)}</p>
            <p><strong>Metodo de pago:</strong> ${factura.metodoPago}</p>
            <p><strong>Cliente:</strong> ${factura.cliente}</p>
            <p><strong>Habitación:</strong> ${factura.numeroHabitacion} (Tipo ID: ${factura.idTipoHabitacion})</p>
            <p><strong>Estadía:</strong> ${factura.estadiaTotal} noche${factura.estadiaTotal === 1 ? '' : 's'}</p>
            <p><strong>Personas:</strong> ${factura.cantidadPersonas}</p>
            <p><strong>Total:</strong> ₡${Number(factura.precioTotal).toLocaleString()}</p>
        `;

        contenedor.appendChild(tarjeta);
    });
}


function renderizarResultadosReservaciones(datos) {

    const contenedorResultados = document.getElementById('contenerdorResultados');

    contenedorResultados.innerHTML = '';

     //Renderizar los datos que se recibieron.

    if (!Array.isArray(datos) || datos.length === 0) {
        contenedorResultados.innerHTML = '<p>No se encontraron resultados para esta búsqueda.</p>';
        return;
    }

    datos.forEach(reserva => {
    const tarjeta = document.createElement('div');
    tarjeta.style.border = '1px solid #ccc';
    tarjeta.style.padding = '15px';
    tarjeta.style.marginBottom = '20px';
    tarjeta.style.borderRadius = '6px';
    tarjeta.style.boxShadow = '0 2px 4px rgba(0, 0, 0, 0.1)';
    tarjeta.style.backgroundColor = '#fff';

    tarjeta.innerHTML = `
            <h4 style="margin-top: 0;">Reservación #${reserva.idReservacion}</h4>
            <p><strong>Habitación:</strong> ${reserva.numeroHabitacion}</p>
            <p><strong>Cliente:</strong> ${reserva.cliente}</p>
            <p><strong>Entrada:</strong> ${formatearFecha(reserva.fechaHoraIngreso)}</p>
            <p><strong>Salida:</strong> ${formatearFecha(reserva.fechaHoraSalida)}</p>
            <p><strong>Personas:</strong> ${reserva.cantidadPersonas}</p>
            <p><strong>Vehiculo:</strong> ${reserva.vehiculo}</p>
            <p><strong>Estadía total:</strong> ${reserva.estadiaTotal} noche${reserva.estadiaTotal === 1 ? '' : 's'}</p>
            <p><strong>Precio total:</strong> ₡${Number(reserva.precioTotal).toLocaleString()}</p>
            <p><strong>Estado:</strong> ${reserva.estado}</p>
        `;

    contenedorResultados.appendChild(tarjeta);
    });

    return;


}

function renderizarRangoEdadReservas(datos) {
    const contenedor = document.getElementById('contenerdorResultados');
    contenedor.innerHTML = '';

    if (!datos || typeof datos !== 'object') {
        contenedor.innerHTML = '<p>No se pudo obtener el rango de edades.</p>';
        return;
    }

    const caja = document.createElement('div');
    caja.style.border = '1px solid #aaa';
    caja.style.borderRadius = '6px';
    caja.style.padding = '20px';
    caja.style.backgroundColor = '#f9f9f9';
    caja.style.marginBottom = '20px';
    caja.style.boxShadow = '0 2px 5px rgba(0,0,0,0.05)';
    caja.style.textAlign = 'center';

    caja.innerHTML = `
        <h4 style="margin-top: 0;">Rango de edades de clientes</h4>
        <p><strong>Minima:</strong> ${datos.edadMinima} años</p>
        <p><strong>Maxima:</strong> ${datos.edadMaxima} años</p>
    `;

    contenedor.appendChild(caja);
}

// Funcion para renderizar los datis de la demanda de las empresas.
function renderizarDemandaHoteles(lista) {
    const contenedor = document.getElementById('contenerdorResultados');
    contenedor.innerHTML = '';

    if (!Array.isArray(lista) || lista.length === 0) {
        contenedor.innerHTML = '<p>No se encontraron datos de demanda hotelera.</p>';
        return;
    }

    // Crear tabla
    const tabla = document.createElement('table');
    tabla.style.width = '100%';
    tabla.style.borderCollapse = 'collapse';
    tabla.style.marginTop = '10px';

    tabla.innerHTML = `
        <thead style="background-color: #f1f1f1;">
            <tr>
                <th style="padding: 10px; text-align: left;">#</th>
                <th style="padding: 10px; text-align: left;">Nombre del Hotel</th>
                <th style="padding: 10px; text-align: left;">Cédula Jurídica</th>
                <th style="padding: 10px; text-align: left;">Reservas</th>
            </tr>
        </thead>
        <tbody id="cuerpo-demanda"></tbody>
    `;

    contenedor.appendChild(tabla);

    const cuerpo = tabla.querySelector('#cuerpo-demanda');

    lista.forEach((empresa, index) => {
        const fila = document.createElement('tr');
        fila.innerHTML = `
            <td style="padding: 8px;">${index + 1}</td>
            <td style="padding: 8px;">${empresa.nombreEmpresa}</td>
            <td style="padding: 8px;">${empresa.idEmpresaHospedaje}</td>
            <td style="padding: 8px;">${empresa.cantidadReservas}</td>
        `;
        cuerpo.appendChild(fila);
    });
}



// >>> =====  ===== <<<


document.addEventListener("DOMContentLoaded", function () {

    InciarUbicacionesDinamicas();
    //InicarInteractividadFiltros();
    inicarListenersReportes();


});
