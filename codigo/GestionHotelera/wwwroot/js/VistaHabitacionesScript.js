// Inciar la configuacion del mapa.
function inicarConfiguracionMapa() {

    console.log("Iniciando configuracion del mapa.");

    const lat = window.latitudEmpresa || 9.934739;
    const lng = window.longitudEmpresa || -84.087502;

    const map = L.map('map').setView([lat, lng], 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap'
    }).addTo(map);

    L.marker([lat, lng]).addTo(map);

}

// Establecer la fecha de los input de la fechas y hora de entrada y salida.
function EstablecerFecha() {

    const fechaEntrada = document.getElementById("entrada");
    const fechaSalida = document.getElementById("salida");

    const now = new Date();

    // Ajustar el formato a yyyy-MM-ddTHH:mm
    const anio = now.getFullYear();
    const mes = String(now.getMonth() + 1).padStart(2, '0');
    const dia = String(now.getDate()).padStart(2, '0');
    const hora = String(now.getHours()).padStart(2, '0');
    const minutos = String(now.getMinutes()).padStart(2, '0');

    const valorMin = `${anio}-${mes}-${dia}T${hora}:${minutos}`;

    fechaEntrada.min = valorMin;
    fechaSalida.min = valorMin;

    return;
};


// Inciar el listener al evento submit del forms.
function inciarListenerFormReservacion() {

    // document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("reservacionForm");
    console.log("Evento argregado");

    // Validar que se encuentre el formulario.
    if (!form) {

        console.log("Form no encontrado");
        return;
    }

    form.addEventListener("submit", function (event) {
        event.preventDefault();
        console.log("Empezando envio del formulario");
        //const formData = new FormData(form);
        reservarHabitacion();
    });
    //});

}




// Funcion para la parte del registro de cliente.
async function reservarHabitacion() {
    // Validar los datos del formulario.
    if (!validarReservacionHabitacion()) {
        return;
    }

    console.log("Iniciando envio de datos.");
    await enviarDatosReservacion();

}
// funcion para la validacion de los datos del formulario. Esto seria solo para las validaciones basicas, las demas se hacen en la base de datos.
function validarReservacionHabitacion() {

    // Validar que las fechas de entrada y salida tengan al menos un dia de diferencia.

    // Que la cantidad de personas sea mayor a cero.


    return true;
}

// Funcion para el envio de los datos del formulario al controlador.
async function enviarDatosReservacion() {

    // Obtener los datos del formulario.

    const formData = new FormData(document.getElementById("reservacionForm"));
    // Enviar los datos al controlador.
    try {
        const response = await fetch('/EmpresaHospedaje/RegistrarReservacionTemporal', {
            method: 'POST',
            body: formData
        });
        if (response.ok) {

            const resultado = await response.json();
            console.log("Datos del registro de la reserva.: ", resultado);

            if (resultado.estado === 1) {
                alert("Reserva registrada correctamente, pendiente de aceptacion por parte de la empresa.");


                return resultado;

            } else {
                alert("Error al registrar la reservacion: " + resultado.message);
            }
        } else {
            alert("Error al registrar la reservacion para esta habitacion. Por favor, intente nuevamente.");
        }
    } catch (error) {
        console.error("Error al enviar los datos:", error);
        alert("Ocurrió un error al registrar al registrar la habitacion. Por favor, intente nuevamente.");
    }
}







// Esto es para que el DOM carge y se puedan ejecutar las funciones que seleccionan elementos del DOM.
document.addEventListener("DOMContentLoaded", function () {
    inicarConfiguracionMapa();
    inciarListenerFormReservacion();
    EstablecerFecha();
});