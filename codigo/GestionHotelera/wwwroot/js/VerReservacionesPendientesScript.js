function resolverReserva(idReservaTemporal, modo) {
    console.log("Reserva temporal: ", idReservaTemporal);
    if (modo === 'aceptada') {

        procesarAceptacionDeReserva(idReservaTemporal);

    } else {
        procesarRechazoDeReserva(idReservaTemporal)

        
    }

}


async function procesarAceptacionDeReserva(idReservaTemporal) {
    console.log("Na1");

    let datos = await enviarDatosAceptacionReservaTemporal(idReservaTemporal);
    console.log("Resultado: ", datos);
    if (datos.estado > 0) {
        alert("Reservacion registrada con el ID: ", datos.estado.toString());

        window.location.reload();
    } else {
        alert("No se ha podido aceptar la reserva.")
    }
    
}

async function enviarDatosAceptacionReservaTemporal(idReservaTemporal) {

    // Obtener los datos del formulario.
    const datos = JSON.stringify({ IdReservaTemporalM : idReservaTemporal });
    console.log("Datos: ", datos);

    // Enviar los datos al controlador.
    try {
        const response = await fetch('/EmpresaHospedaje/AceptarReservacion', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: datos
        });
        if (response.ok) {
            const resultado = await response.json();
            return resultado;

        } else {
            alert("Error al solicitar la reserva de la habitacion. Por favor, intente nuevamente.");
        }
    } catch (error) {
        console.error("Error al enviar los datos:", error);
        alert("Error al enviar la solicitud de reservacion. Por favor, intente nuevamente.");
    }

}


async function procesarRechazoDeReserva(idReservaTemporal) {

    console.log("Na2");

    let datos = await enviarDatosRechazoReservaTemporal(idReservaTemporal);
    console.log("Resultado: ", datos);

    if (datos.estado > 0) {
        alert("Reservacion rechazada exitosamente" );

        window.location.reload();
    } else {
        alert("No se ha podido rechazar la reserva.");
    }


}


async function enviarDatosRechazoReservaTemporal(idReservaTemporal) {

    // Obtener los datos del formulario.
    const datos = JSON.stringify({ IdReservaTemporalM: idReservaTemporal });
    console.log("Datos: ", datos);
    // Enviar los datos al controlador.
    try {
        const response = await fetch('/EmpresaHospedaje/RechazoReservacion', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: datos
        });
        if (response.ok) {
            const resultado = await response.json();
            return resultado;

        } else {
            alert("Error al solicitar la cancelacion de la reserva de la habitacion. Por favor, intente nuevamente.");
        }
    } catch (error) {
        console.error("Error al enviar los datos:", error);
        alert("Error al enviar la solicitud de cancelacion de la reservacion. Por favor, intente nuevamente.");
    }


}