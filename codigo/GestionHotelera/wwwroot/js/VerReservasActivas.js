async function terminarReserva(id) {

    let datos = JSON.stringify({ IdReservaTemporalM: id });
    let resultado = enviarDatosCerrarReserva(datos);

    if (resultado > 0) {
        alert("Reserva cerrada con exito.");
        window.location.reload();
    } else {
        alert("No se pudo cerrar la reservacion actual.");

    }
    return;
}


async function enviarDatosCerrarReserva(datos) {

    console.log("Datos a enviar: ", datos);

    // Enviar los datos al controlador.
    try {
        const response = await fetch('/EmpresaHospedaje/CerrarReserva', {
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
            alert("Error en la respuesta del cerrado de la reserva. Por favor, intente nuevamente.");
            return -1001;
        }
    } catch (error) {
        console.error("Error al enviar los datos:", error);
        alert("Error al enviar la solicitud de cerrar la reservacion. Por favor, intente nuevamente.");
        return -1002;

    }


}