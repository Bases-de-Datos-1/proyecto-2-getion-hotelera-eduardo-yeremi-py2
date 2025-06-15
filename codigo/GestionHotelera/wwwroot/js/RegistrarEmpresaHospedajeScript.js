
//<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
//<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

//<div id="map" style="height: 400px; margin-bottom: 1rem;"></div>

//<!--Campos ocultos para guardar coordenadas-- >
//<input type="hidden" id="Latitud" name="Latitud" />
//<input type="hidden" id="Longitud" name="Longitud" />

// Para lo que seria el ir actualizando el valor que se muestra en el imput de la ubicacion. // Cambiar lo de pais.
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
        cantonSelect.innerHTML = '<option value="">Seleccione un cantón</option>';
        distritoSelect.innerHTML = '<option value="">Seleccione un distrito</option>';
    });

    provinciaSelect.addEventListener("change", function () {
        const cantones = window.listaCantones || [];
        const filtrados = cantones.filter(c => c.idProvincia == this.value);
        cantonSelect.innerHTML = '<option value="">Seleccione un cantón</option>';
        filtrados.forEach(c => {
            cantonSelect.innerHTML += `<option value="${c.idCanton}">${c.nombreCanton}</option>`;
        });
        distritoSelect.innerHTML = '<option value="">Seleccione un distrito</option>';
    });

    cantonSelect.addEventListener("change", function () {
        const distritos = window.listaDistritos || [];
        const filtrados = distritos.filter(d => d.idCanton == this.value);
        distritoSelect.innerHTML = '<option value="">Seleccione un distrito</option>';
        filtrados.forEach(d => {
            distritoSelect.innerHTML += `<option value="${d.idDistrito}">${d.nombreDistrito}</option>`;
        });
    });
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

// Para inciar el listener del mapa.
function inicarConfiguracionMapa() {
    const map = L.map('map').setView([9.934739, -84.087502], 13); // San José, CR

    // Agregar el mapa base (puede cambiarse a otro proveedor si querés)
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap'
    }).addTo(map);

    let marker;

    map.on('click', function (e) {
        const { lat, lng } = e.latlng;

        // Eliminar el marcador anterior si ya hay uno
        if (marker) map.removeLayer(marker);

        // Agregar un nuevo marcador
        marker = L.marker([lat, lng]).addTo(map);

        // Guardar las coordenadas en los inputs ocultos
        document.getElementById("Latitud").value = lat;
        document.getElementById("Longitud").value = lng;
    });

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
            if (resultado.estado) {
                alert("Cliente registrado exitosamente.");
                //window.location.href = '@Url.Action("Cuenta", "Login")';

                //window.location.href = '/Cliente/Informacion'; // Redirigir a la pagina de informacion del cliente.
            } else {
                alert("Error al registrar el cliente: " + result.message);
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
    //iniciarUbicacionesDinamicas();
    //inciarListenerFormRegitroClientes();
    //inicarConfiguracionMapa();
});
