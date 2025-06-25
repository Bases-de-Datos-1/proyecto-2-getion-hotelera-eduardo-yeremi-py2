// Inciar el listener al evento submit del forms.
function inciarListenerFormRegitroTipoHabitacion() {

    // document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("registrarNuevoTipoHabitacion");
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
        registrarTipoHabitacion();
    });
    //});

}




// Funcion para la parte del registro de cliente.
async function registrarTipoHabitacion() {
    // Validar los datos del formulario.
    if (!validarDatosRegistroTipoHabitacion()) {
        return;
    }

    console.log("Iniciando envio de datos.");
    await enviarDatosRegistroTipoHabitacion();

}
// funcion para la validacion de los datos del formulario. Esto seria solo para las validaciones basicas, las demas se hacen en la base de datos.
function validarDatosRegistroTipoHabitacion() {

   

    let precio = parseFloat(document.querySelector('input[name="PrecioPorNoche"]').value);
    let tipoCama = document.getElementById('tipoCama').value;
    let imagenes = document.querySelector('input[name="ImagenesTipoHabitacion"]').files;
    let comodidades = document.querySelectorAll('input[name="ListaComodidades"]:checked');

    // Revisar el precio
    if (isNaN(precio) || precio <= 0) {
        alert("Ingrese un precio valido mayor a cero por noche.");
        return false;
    }

    // Revisar el tipo de cama.
    if (tipoCama === "0" || tipoCama === "") {
        alert("Debe seleccionar un tipo de cama.");
        return false;
    }

    // La cantidad de imagenes debe de ser mayor a cero.
    if (imagenes.length === 0) {
        alert("Debe seleccionar al menos una imagen para el tipo de habitacion.");
        return false;
    }

    // Se debe de seleccionar al menos una comodidad.
    if (comodidades.length === 0) {
        alert("Seleccione al menos una comodidad para la habitación.");
        return false;
    }

    return true;
}

// Funcion para el envio de los datos del formulario al controlador.
async function enviarDatosRegistroTipoHabitacion() {

    // Obtener los datos del formulario.
    const formData = new FormData(document.getElementById("registrarNuevoTipoHabitacion"));
    // Enviar los datos al controlador.
    try {
        const response = await fetch('/EmpresaHospedaje/RegistrarNuevoTipoDeHabitacion', {
            method: 'POST',
            body: formData
        });
        if (response.ok) {

            const resultado = await response.json();
            console.log("Datos del regitro de la habitacion: ", resultado);

            if (resultado.estadoGeneral > 0) {
                //alert("Tipo de habitacion registrada exitodamente con el ID: ", resultado.estadoGeneral.toString());
                alert(`Tipo de habitacion registrada exitosamente con el ID: ${resultado.estadoGeneral}`);

                location.replace("/EmpresaHospedaje/Menu?idEmpresa=no");

                //window.location.href = "@Url.Action('EmpresaHospedaje','Menu')";
                //window.location.href = `/Producto/Detalles?id=${id}`;
                //window.location.href = '/EmpresaHospedaje/Menu'; // Redirigir a la pagina de informacion del cliente.
            } else {

                if (resultado.estadoGeneral === -1) {
                    alert("Error: El nombre del tipo de habitacion se encuentra repetido.");
                } else {
                    alert("Error al registrar el tipo de habitacion.");
                }
            }

        } else {
            alert("Error al registrar el tipo de hbaitacion. Por favor, intente nuevamente.");
        }
    } catch (error) {
        console.error("Error al enviar los datos:", error);
        alert("Ocurrió un error al registrar el tipo de habitacion. Por favor, intente nuevamente.");
    }
}






// Esto es para que el DOM carge y se puedan ejecutar las funciones que seleccionan elementos del DOM.
document.addEventListener("DOMContentLoaded", function () {
    inciarListenerFormRegitroTipoHabitacion();

});
