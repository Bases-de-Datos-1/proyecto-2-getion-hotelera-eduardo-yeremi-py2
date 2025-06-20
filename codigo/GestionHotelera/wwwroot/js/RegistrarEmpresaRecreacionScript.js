// Para lo que seria el ir actualizando el valor que se muestra en el imput de la ubicacion. // Cambiar lo de pais.
function iniciarUbicacionesDinamicas() {

    // Seleccionamos los elementos.
    //const paisSelect = document.getElementById("pais");
    const provinciaSelect = document.getElementById("provincia");
    const cantonSelect = document.getElementById("canton");
    const distritoSelect = document.getElementById("distrito");
    //const ubicacionCR = document.getElementById("ubicacionCR");

    // Validar que se pudo optener todo.!paisSelect || || !ubicacionCR
    if (!provinciaSelect || !cantonSelect || !distritoSelect) {

        return;
    }

    //paisSelect.addEventListener("change", function () {
    //    ubicacionCR.style.display = (parseInt(this.value) === 1) ? "block" : "none";
    //    cantonSelect.innerHTML = '<option value="">Seleccione un cantón</option>';
    //    distritoSelect.innerHTML = '<option value="">Seleccione un distrito</option>';
    //});

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


// Inciar el listener al evento submit del forms.
function inciarListenerFormRegitroEmpresa() {

    // document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("formRegistrarEmpresaRecreacion");
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
        registrarEmpresa();
    });
    //});

}



// Funcion para la parte del registro de cliente.
async function registrarEmpresa() {
    // Validar los datos del formulario.
    if (!validarDatosRegistroEmpresa()) {
        return;
    }

    console.log("Iniciando envio de datos.");
    await enviarDatosRegistroEmpresa();

}
// funcion para la validacion de los datos del formulario. Esto seria solo para las validaciones basicas, las demas se hacen en la base de datos.
function validarDatosRegistroEmpresa() {

    // Validar que la contraseña sea igual a la de la confirmacion.

    // Validar el formato de la cedula.

    // Validar que la fecha de nacimiento sea menor a la fecha actual.

    let cedula = document.getElementById('cedulaJuridica').value.trim();
    let pass = document.getElementById('contrasena').value;
    let confirm = document.getElementById('confirmar').value;
    let correo = document.getElementById('correo').value.trim();
    let telefono = document.getElementById('telefono1ID').value.trim();

    let provincia = document.getElementById('provincia').value;
    let canton = document.getElementById('canton').value;
    let distrito = document.getElementById('distrito').value;


    // Contraseñas diferentes.
    if (pass !== confirm) {
        alert("La contraseña y su confirmacion no coinciden.");
        return false;
    }

    // Revisar las ceculas.
    if (!/^\d{10,12}$/.test(cedula)) {
        alert("La cedula juridica debe contener entre 10 y 12 digitos.");
        return false;
    }

    // Revisar las provincias.
    if (provincia === '0' || canton === '0' || distrito === '0') {
        alert("Seleccione una provincia, canton y distrito validos.");
        return false;
    }

    if (!validarTelefonos(telefono, true)) {
        alert("En numero de telefono debe de tener digitos entre 1 y 8.");
        return false;
    }

    return true;
}

// Funcion para el envio de los datos del formulario al controlador.
async function enviarDatosRegistroEmpresa() {

    // Obtener los datos del formulario.

    const formData = new FormData(document.getElementById("formRegistrarEmpresaRecreacion"));
    // Enviar los datos al controlador.

    try {
        const response = await fetch('/Cuenta/RegistrarEmpresaDeRecreacion', {
            method: 'POST',
            body: formData
        });
        if (response.ok) {
            const resultado = await response.json();
            console.log("Datos del regitro de la empresa: ", resultado);
            //let result = resultado.estadoGeneral;
            if (resultado.estado > 0) {
                alert("Empresa hospedaje registrado exitosamente.");
                //window.location.href = '@Url.Action("Cuenta", "Login")';
                location.replace("/Cuenta/Login");

                //window.location.href = '/Cuentaedirigir a la pagina de informacion del cliente.
            } else {
                if (resultado.estado === -1) {
                    alert("Cedula de la empresa o correo ya registrados, por favor reviselos. ");

                } else {
                    alert("Error al registrar la empresa de recreacion.");
                }
            }
        } else {
            alert("Error al registrar la empresa de hospedaje. Por favor, intente nuevamente.");
        }
    } catch (error) {
        console.error("Error al enviar los datos:", error);
        alert("Ocurrió un error al registrar la empresa de hospedaje. Por favor, intente nuevamente.");
    }
}






// Esto es para que el DOM carge y se puedan ejecutar las funciones que seleccionan elementos del DOM.
document.addEventListener("DOMContentLoaded", function () {
    iniciarUbicacionesDinamicas();
    inciarListenerFormRegitroEmpresa();
});