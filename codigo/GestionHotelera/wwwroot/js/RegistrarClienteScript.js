//window.location.href = '@Url.Action("Informacion", "Currency")';


// Para lo que seria el ir actualizando el valor que se muestra en el imput de la ubicacion.
function iniciarUbicacionesDinamicas() {

    // Seleccionamos los elementos.
    const paisSelect = document.getElementById("pais");
    const provinciaSelect = document.getElementById("provincia");
    const cantonSelect = document.getElementById("canton");
    const distritoSelect = document.getElementById("distrito");
    const ubicacionCR = document.getElementById("ubicacionCR");

    // Validar que se pudo optener todo.
    if (!paisSelect || !provinciaSelect || !cantonSelect || !distritoSelect || !ubicacionCR) {

        return;
    }

    paisSelect.addEventListener("change", function () {
        ubicacionCR.style.display = (parseInt(this.value) === 1) ? "block" : "none";
        cantonSelect.innerHTML = '<option value="0" disabled selected>Seleccione un canton...</option>>';
        distritoSelect.innerHTML = '<option value="" disabled selected>Seleccione un distrito...</option>';
    });

    provinciaSelect.addEventListener("change", function () {
        const cantones = window.listaCantones || [];
        const filtrados = cantones.filter(c => c.idProvincia == this.value);
        cantonSelect.innerHTML = '<option value="0" disabled selected>Seleccione un canton...</option>';
        filtrados.forEach(c => {
            cantonSelect.innerHTML += `<option value="${c.idCanton}">${c.nombreCanton}</option>`;
        });
        distritoSelect.innerHTML = '<option value="" disabled selected>Seleccione un distrito...</option>';
    });

    cantonSelect.addEventListener("change", function () {
        const distritos = window.listaDistritos || [];
        const filtrados = distritos.filter(d => d.idCanton == this.value);
        distritoSelect.innerHTML = '<option value="" disabled selected>Seleccione un distrito...</option>';
        filtrados.forEach(d => {
            distritoSelect.innerHTML += `<option value="${d.idDistrito}">${d.nombreDistrito}</option>`;
        });
    });
}

// Para lo que seria la verificacion de los tekefonos.
function validarTelefonos(tel, estado = false) {
    if (tel === "" && !estado) {
        return true;
    }
    return /^[1-8]{1}[0-9]{7}$/.test(tel);
}

// Inciar el listener al evento submit del forms.
function inciarListenerFormRegitroClientes() {

   // document.addEventListener("DOMContentLoaded", () => {
        const form = document.getElementById("formRegistrarCliente");
        console.log("Evento argregado");

        // Validar que se encuentre el formulario.
        if (!form) {
            console.log("For no encontrado");

            return;
        }

        form.addEventListener("submit", function (event) {
            event.preventDefault(); 
            console.log("Empezando envio del formulario");
            //const formData = new FormData(form);
            registrarCliente();
        });
    //});

}

// Funcion para la parte del registro de cliente.
async function registrarCliente() {
    // Validar los datos del formulario.
    if (!validarDatosRegistroCliente()) {
        return;
    }

    console.log("Iniciando envio de datos.");
    await enviarDatosRegistroCliente();

}
// funcion para la validacion de los datos del formulario. Esto seria solo para las validaciones basicas, las demas se hacen en la base de datos.
function validarDatosRegistroCliente() {
    // Obtener los campos
    let cedula = document.getElementById('cedula').value.trim();
    let tipoID = document.getElementById('tipoIdentificacion').value;
    let nacimiento = document.getElementById('fecha').value;
    let pass = document.getElementById('contrasena').value;
    let confirm = document.getElementById('confirmar').value;

    let telefono1 = document.getElementById('telefono1ID').value.trim();
    let telefono2 = document.getElementById('telefono2ID').value.trim();
    let telefono3 = document.getElementById('telefono3ID').value.trim();

    let hoy = new Date();
    let fechaNac = new Date(nacimiento);

    // Validar que la contraseñas sean iguales.
    if (pass !== confirm) {
        alert("La contraseña y su confirmacion no coinciden.");
        return false;
    }


    // Validar los tipos de cedula.
    switch (tipoID) {
        case "Nacional":
            if (!/^[1-9]\d{8}$/.test(cedula)) {
                alert("La cedula nacional debe contener 9 valores que sena numericos.");
                return false;
            }
            break;

            // Cedula de menores.
        case "TIM":
            if (!/^[1-9]\d{8}$/.test(cedula)) {
                alert("La cedula de menores debe contener 9 valores que sena numericos.");
                return false;
            }
            break;
            //
        case "DIMEX":
            if (!/^\d{11,12}$/.test(cedula)) {
                alert("El DIMEX debe tener entre 11 y 12 valores.");
                return false;
            }
            break;

            // Vamos mal, pro que la entrada es de valores numericos, y el largo en la base de datos de la cedula es de 15.
        case "Pasaporte":
            if (!/^[A-Z0-9]{6,20}$/i.test(cedula)) {
                alert("El pasaporte debe contener entre 6 y 20 caracteres..");
                return false;
            }
            break;
        default:
            alert("Seleccione un tipo de identificacion valido.");
            return false;
    }

    // Validar la fecha de nacimiento.
    if (!nacimiento || fechaNac >= hoy) {
        alert("La fecha de nacimiento no puede ser mayor a la fecha actual.");
        return false;
    }

    if (!validarTelefonos(telefono1, true)) {
        alert("El telefono principal debe tener 8 digitos y comenzar con 1 a 8.");
        return false;
    }
    if (!validarTelefonos(telefono2) || !validarTelefonos(telefono3)) {
        alert("Los telefonos secundarios deben tener 8 digitos validos.");
        return false;
    }

    // Validar que la contraseña sea igual a la de la confirmacion.

    // Validar el formato de la cedula.

    // Validar que la fecha de nacimiento sea menor a la fecha actual.


    return true;
}



// Funcion para el envio de los datos del formulario al controlador.
async function enviarDatosRegistroCliente() {

    // Obtener los datos del formulario.
    const formData = new FormData(document.getElementById("formRegistrarCliente"));
    // Enviar los datos al controlador.
    try {
        const response = await fetch('/Cuenta/RegistrarCuentaCliente', {
            method: 'POST',
            body: formData
        });
        if (response.ok) {
            const resultado = await response.json();
            if (resultado.estado > 0) {
                alert("Cliente registrado exitosamente.");
                //window.location.href = '@Url.Action("Cuenta", "Login")';
                location.replace("/Cuenta/Login");

                //window.location.href = '/Cliente/Informacion'; // Redirigir a la pagina de informacion del cliente.
            } else {

                if (resultado.estado === -1) {
                    alert("Cedula de cliente o correo ya registrados, por favor reviselos. ");

                } else {
                    alert("Error al registrar el cliente");
                }

            }
        } else {
            alert("Error al registrar el cliente. Por favor, intente nuevamente.");
        }
    } catch (error) {
        console.error("Error al enviar los datos:", error);
        alert("Ocurrió un error al registrar el cliente. Por favor, intente nuevamente.");
    }
}




// Esto es para que el DOM carge y se puedan ejecutar las funciones que seleccionan elementos del DOM.
document.addEventListener("DOMContentLoaded", function () {
    iniciarUbicacionesDinamicas();
    inciarListenerFormRegitroClientes();
});



