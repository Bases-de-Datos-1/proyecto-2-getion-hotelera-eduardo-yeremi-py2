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
    secciones.forEach(div => div.classList.add("hidden")); // Oculta todas

    const mostrar = mapeo[seccion];
    if (mostrar) {
        document.getElementById(mostrar)?.classList.remove("hidden"); // Muestra la elegida
    }
}



// Apartado para el procesamiento de los reportes.

function procesarReportes(tipoReporte) {




}


async function procesarBusquedaReservacion() {

    // Obtener los elementos que se ocupan para la consulta.

    // Validar los elementos optenidos.

    // Enviar el fetch con lo datos y recibir el resultado.

    // Renderizar el resultado.


}

// Validar que los datos a enviar esten correctos.
function validarDatosReservaEspecifica() {

    return true;
}

// Realizar la consulta para optener los datos requeridos.
async function enviarConsultaReservaEspecifica(datos) {

}

// Renderizar los resultados optenidos.
function renderizarResultadosReservaEspecifica(datos) {

}






document.addEventListener("DOMContentLoaded", function () {

    InciarUbicacionesDinamicas();
    //InicarInteractividadFiltros();


});
