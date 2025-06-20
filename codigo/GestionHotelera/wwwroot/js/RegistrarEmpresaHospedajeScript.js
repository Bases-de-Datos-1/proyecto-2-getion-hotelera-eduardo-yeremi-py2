
//<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
//<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

//<div id="map" style="height: 400px; margin-bottom: 1rem;"></div>

// Para guardar las coodenadas.
//<input type="hidden" id="Latitud" name="Latitud" />
//<input type="hidden" id="Longitud" name="Longitud" />

// Para lo que seria el ir actualizando el valor que se muestra en el imput de la ubicacion. // Cambiar lo de pais.
function iniciarUbicacionesDinamicas() {

    // Seleccionamos los elementos.
    //const paisSelect = document.getElementById("pais");
    const provinciaSelect = document.getElementById("provincia");
    const cantonSelect = document.getElementById("canton");
    const distritoSelect = document.getElementById("distrito");

    // Validar que se pudo optener todo.!paisSelect || || !ubicacionCR
    if (!provinciaSelect || !cantonSelect || !distritoSelect ) {

        return;
    }

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

// Validar los telefonos.
function validarTelefonos(tel, estado = flase) {
    if (tel === "" && !estado) {
        return true;
    }
    return /^[1-8]{1}[0-9]{7}$/.test(tel);
}



// Inciar el listener al evento submit del forms.
function inciarListenerFormRegitroEmpresa() {

    // document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("formRegistroEmpresaHospedaje");
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

// Para inciar el listener del mapa.
function inicarConfiguracionMapa() {

    console.log("Iniciando configuracion del mapa.");
    const map = L.map('map').setView([9.934739, -84.087502], 13); // San Jose.

    // Mapa base.
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap'
    }).addTo(map);

    let marker;

    // Para la seleccion de la ubicacion.
    map.on('click', function (e) {
        const { lat, lng } = e.latlng;

        // Eliminar el marcador anterior si ya hay uno
        if (marker) map.removeLayer(marker);

        // Agregar un nuevo marcador
        marker = L.marker([lat, lng]).addTo(map);

        // Guardar las coordenadas en los inputs ocultos
        document.getElementById("latitud").value = lat.toString().replace(',', '.');
        document.getElementById("longitud").value = lng.toString().replace(',', '.');
        //document.getElementById("latitud").value = lat.toFixed(8);
        //document.getElementById("longitud").value = lng.toFixed(8);

    });

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
    let latitud = document.getElementById('latitud').value;
    let longitud = document.getElementById('longitud').value;
    let correo = document.getElementById('correo').value;
    let sitioWeb = document.getElementById('paginaWeb').value.trim();

    let provincia = document.getElementById('provincia').value;
    let canton = document.getElementById('canton').value;
    let distrito = document.getElementById('distrito').value;
    let instalacion = document.getElementById('alojamiento').value;

    let telefono1 = document.getElementById('telefono1ID').value.trim();
    let telefono2 = document.getElementById('telefono2ID').value.trim();
    let telefono3 = document.getElementById('telefono3ID').value.trim();

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

    // las coordenadas.
    if (latitud === '' || longitud === '') {
        alert("Debe seleccionar una ubicacion en el mapa.");
        return false;
    }

    // Este deberia de estar con el select diable
    if (instalacion === '0' || instalacion === '') {
        alert("Seleccione un tipo de instalación.");
        return false;
    }

    // Sitio web, 
    //if (sitioWeb !== "" && !/^https?:\/\/.+\..+/.test(sitioWeb)) {
    //    alert("El sitio web debe empezar con http:// o https:// y ser una URL valida.");
    //    return false;
    //}



    // Revisar la ubicacion
    if (provincia === '0' || canton === '0' || distrito === '0') {
        alert("Seleccione una provincia, canton y distrito validos.");
        return false;
    }

    // Revisar los telefonos.
    if (!validarTelefonos(telefono1, true)) {
        alert("El telefono principal debe tener 8 digitos y comenzar con 1 a 8.");
        return false;
    }
    if (!validarTelefonos(telefono2) || !validarTelefonos(telefono3)) {
        alert("Los telefonos secundarios deben tener 8 digitos validos.");
        return false;
    }


    return true;
}

// Funcion para el envio de los datos del formulario al controlador.
async function enviarDatosRegistroEmpresa() {

    // Obtener los datos del formulario.

    const formData = new FormData(document.getElementById("formRegistroEmpresaHospedaje"));
    // Enviar los datos al controlador.
    try {
        const response = await fetch('/Cuenta/RegistrarCuentaEmpresaHospedaje', {
            method: 'POST',
            body: formData
        });
        if (response.ok) {

            const resultado = await response.json();
            console.log("Datos del regitro de la empresa: ", resultado);
            let result = resultado.estadoGeneral;

            if (result[0] === 1) {
                alert("Empresa hospedaje registrado exitosamente.");
                //window.location.href = '@Url.Action("Cuenta", "Login")';
                location.replace("/Cuenta/Login");

                //window.location.href = '/Cliente/Informacion'; // Redirigir a la pagina de informacion del cliente.
            } else {
                if (resultado.estado === -1) {
                    alert("Cedula de la empresa o correo ya registrados, por favor reviselos. ");

                } else {
                    alert("Error al registrar la empresa.");
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
    inicarConfiguracionMapa();
});
