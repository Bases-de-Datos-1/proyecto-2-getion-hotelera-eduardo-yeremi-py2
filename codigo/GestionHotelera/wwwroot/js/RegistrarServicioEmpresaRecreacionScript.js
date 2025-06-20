// Inciar el listener al evento submit del forms.
function inciarListenerFormRegitroActividad() {

    // document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("registrarNuevoServicioId");
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
        registrarActividad();
    });
    //});

}




// Funcion para la parte del registro de cliente.
async function registrarActividad() {
    // Validar los datos del formulario.
    if (!validarDatosRegistroActividad()) {
        return;
    }

    console.log("Iniciando envio de datos.");
    await enviarDatosRegistroActividad();

}
// funcion para la validacion de los datos del formulario. Esto seria solo para las validaciones basicas, las demas se hacen en la base de datos.
function validarDatosRegistroActividad() {

    // Validar que la contraseña sea igual a la de la confirmacion.

    // Validar el formato de la cedula.

    // Validar que la fecha de nacimiento sea menor a la fecha actual.


    return true;
}

// Funcion para el envio de los datos del formulario al controlador.
async function enviarDatosRegistroActividad() {

    // Obtener los datos del formulario.

    const formData = new FormData(document.getElementById("registrarNuevoServicioId"));
    // Enviar los datos al controlador.
    try {
        const response = await fetch('/EmpresaRecreacion/RegistrarNuevoServicio', {
            method: 'POST',
            body: formData
        });
        if (response.ok) {

            const resultado = await response.json();
            console.log("Datos del regitro de la actividad: ", resultado);

            if (resultado.estadoGeneral > 0) {
                alert("Servicio registrado exitodamente con el ID: ", resultado.estadoGeneral.toString());
                location.replace("/EmpresaHospedaje/Menu?idEmpresa=no");

                //window.location.href = "@Url.Action('EmpresaHospedaje','Menu')";
                //window.location.href = `/Producto/Detalles?id=${id}`;
                //window.location.href = '/EmpresaHospedaje/Menu'; // Redirigir a la pagina de informacion del cliente.
            } else {
                alert("Error al registrar el servicio: " + result.message);
            }
        } else {
            alert("Error al registrar el servicio. Por favor, intente nuevamente.");
        }
    } catch (error) {
        console.error("Error al enviar los datos:", error);
        alert("Ocurrió un error al registrar el servicio. Por favor, intente nuevamente.");
    }
}






// Esto es para que el DOM carge y se puedan ejecutar las funciones que seleccionan elementos del DOM.
document.addEventListener("DOMContentLoaded", function () {
    inciarListenerFormRegitroActividad();

});