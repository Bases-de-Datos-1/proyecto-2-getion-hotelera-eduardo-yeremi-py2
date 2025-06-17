
// Esto es para seleccionar un input de fecha y establecerle una fecha minima, se puede modificar para que establezca una fecha mazima.
function EstablecerFecha() {

    var fechaInput = document.getElementsByName('FechaAsignacionInput');
    var today = new Date();
    var day = String(today.getDate()).padStart(2, '0');
    var month = String(today.getMonth() + 1).padStart(2, '0'); // Enero es 0
    var year = today.getFullYear();

    var todayDate = year + '-' + month + '-' + day;
    fechaInput[0].setAttribute('min', todayDate);

};

function InicarInteractividadFiltros() {

    document.querySelectorAll(".btn-type").forEach(btn => {
        btn.addEventListener("click", () => {
            document.querySelectorAll(".btn-type").forEach(b => b.classList.remove("active"));
            btn.classList.add("active");

            document.querySelectorAll(".filter-section").forEach(s => s.classList.remove("active"));
            const target = btn.dataset.target;
            const filtro = document.getElementById("filtros-" + target);

            if (filtro) {
                filtro.classList.add("active");

                sessionStorage.setItem("filtroActivo", target); // Guardar los datos del filtro activo.

                
                IniciarBusqueda(); // Inciar la busqueda base en donde todo los filtros estan sin elementos.

            }
        });
    });

    document.querySelectorAll(".tag").forEach(tag => {
        tag.addEventListener("click", () => {
            tag.classList.toggle("active");
        });
    });


}



// >>> ===== Seccion para el incio de los selects dinamicos de ubicaciones. ===== <<<

// Funcion para inciar el proceso de incilizacion de las ubicaciones dinamicas.
function InciarUbicacionesDinamicas() {

    iniciarUbicacionesDinamicasHospedaje();
    iniciarUbicacionesDinamicasEmpresaHospedaje();
    iniciarUbicacionesDinamicasRecreacion();
    iniciarUbicacionesDinamicasServiciosRecreacion();
}

// Para la seccion de las habitaciones.
function iniciarUbicacionesDinamicasHospedaje() {

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

// Para la seccion de la empresa de hospedaje.
function iniciarUbicacionesDinamicasEmpresaHospedaje() {

    // Seleccionamos los elementos.
    const provinciaSelect = document.getElementById("provinciaHotel");
    const cantonSelect = document.getElementById("cantonHotel");
    const distritoSelect = document.getElementById("distritoHotel");

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

// Para la seccion de la empresa de recreacion.
function iniciarUbicacionesDinamicasRecreacion() {

    // Seleccionamos los elementos.
    const provinciaSelect = document.getElementById("provinciaRecreacion");
    const cantonSelect = document.getElementById("cantonRecreacion");
    const distritoSelect = document.getElementById("distritoRecreacion");

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

// Para la seccion de los servicios de recreaacion.
function iniciarUbicacionesDinamicasServiciosRecreacion() {

    // Seleccionamos los elementos.
    const provinciaSelect = document.getElementById("provinciaServicio");
    const cantonSelect = document.getElementById("cantonServicio");
    const distritoSelect = document.getElementById("distritoServicio");

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





// >>> ===== Seccion para el inico del proceso de busqueda. ===== <<<

// Llamar cuando se presiona el boton de inciar busqueda.
function IniciarBusqueda() {

    // Optener el filtro activivo.
    let filtroActivo = sessionStorage.getItem("filtroActivo");

    // Revisar a cual busuqeda hay que redirigir.
    if (filtroActivo === "hospedaje") {

        ProcesarBusquedaHospedaje(); 

    } else if (filtroActivo === "empresaHospedaje") {

        ProcesarBusquedaEmpresaHospedaje();

    } else if (filtroActivo === "empresaRecreacion") {

        ProcesarBusquedaEmpresaRereacion();

    } else {

        ProcesarBusquedaServicios();

    }

    return;

}




// >>> ===== Seccion para el procesamiento de las busqueda. ===== <<<

// >> Esta seria la funcion para procesar la busqueda del hospedaje, aqui se optendrian los datos de los filtros.
function ProcesarBusquedaHospedaje() {

    let barraBusqueda = document.getElementById("barraBusquedaInput").value;

    let fechaEntrada = document.getElementById("fechaEntradaInput").value;

    let fechaSalida = document.getElementById("fechaSalidaInput").value;

    let tipoCama = document.getElementById("tipoCamaSelect").value;

    let precioMinimo = document.getElementById("precioMinimoHabitacionInput").value;

    let precioMaximo = document.getElementById("precioMaximoHabitacionInput").value;

    // Ubicacion.
    let provincia = document.getElementById("provinciaHabitacion").value;

    let canton = document.getElementById("cantonHabitacion").value;

    let distrito = document.getElementById("distritoHabitacion").value;

    // Parsar los seleciconados de los selects a int: parseInt(seleccion)

    // Lista de comodidades seleccionadas.
    let  comodiadesSeleccionadas = Array.from(document.querySelectorAll('input[name="ListaComodidades"]:checked'))
        .map(checkbox => parseInt(checkbox.value));

    


    console.log("Comodidades seleccionadas:", comodiadesSeleccionadas);



    return;
}


// >> Esta seria la funcion para procesar la busqueda de las empresas de hospedaje, aqui se optendrian los datos de los filtros.
function ProcesarBusquedaEmpresaHospedaje() {

    let barraBusqueda = document.getElementById("barraBusquedaInput").value;

    // Ubicacion.
    let provincia = document.getElementById("provinciaHotel").value;

    let canton = document.getElementById("cantonHotel").value;

    let distrito = document.getElementById("distritoHotel").value;

    // Lista de comodidades seleccionadas.
    let comodiadesSeleccionadas = Array.from(document.querySelectorAll('input[name="ListaServiciosHoteles"]:checked'))
        .map(checkbox => parseInt(checkbox.value));

    console.log("Servicios de hotel seleccionados:", comodiadesSeleccionadas);

    let tipoAlojamiento = document.getElementById("alojamiento").value;


    return;

}


// >> Esta seria la funcion para procesar la busqueda de las empresas de recreacion, aqui se optendrian los datos de los filtros.
function ProcesarBusquedaEmpresaRereacion() {

    let barraBusqueda = document.getElementById("barraBusquedaInput").value;

    // Ubicacion.
    let provincia = document.getElementById("provinciaRecreacion").value;

    let canton = document.getElementById("cantonRecreacion").value;

    let distrito = document.getElementById("distritoRecreacion").value;

    // Servicios seleccionados.
    let serviciosSeleccionadas = Array.from(document.querySelectorAll('input[name="ListaServiciosEmpresaRecreacion"]:checked'))
        .map(checkbox => parseInt(checkbox.value));

    console.log("Servicios de recreacion seleccionados:", serviciosSeleccionadas);


    return;

}


// >> Esta seria la funcion para procesar la busqueda de los servicios, aqui se optendrian los datos de los filtros.
function ProcesarBusquedaServicios() {

    let barraBusqueda = document.getElementById("barraBusquedaInput").value;

    let precioMinimo = document.getElementById("precioMinimoServicioInput").value;

    let precioMaximo = document.getElementById("precioMaximoServicioInput").value;

    // Ubicacion.
    let provincia = document.getElementById("provinciaServicio").value;

    let canton = document.getElementById("cantonServicio").value;

    let distrito = document.getElementById("distritoServicio").value;

    // Actividades seleccionados.
    let actividadesSeleccionadas = Array.from(document.querySelectorAll('input[name="ListaActividadesServicio"]:checked'))
        .map(checkbox => parseInt(checkbox.value));

    console.log("Actividades de recreacion seleccionados:", actividadesSeleccionadas);


    return;

}



// >>> ===== Seccion para la consulta de datos al controlador. ===== <<<

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
            if (resultado.estado === 1) {
                alert("Empresa hospedaje registrado exitosamente.");
                //window.location.href = '@Url.Action("Cuenta", "Login")';
                location.replace("/Cuenta/Login");

                //window.location.href = '/Cuentaedirigir a la pagina de informacion del cliente.
            } else {
                alert("Error al registrar el cliente: " + result.message);
            }
        } else {
            alert("Error al registrar la empresa de hospedaje. Por favor, intente nuevamente.");
        }
    } catch (error) {
        console.error("Error al enviar los datos:", error);
        alert("Ocurrió un error al registrar la empresa de hospedaje. Por favor, intente nuevamente.");
    }
}







// >>> ===== Seccion para el renderizado de los elementos en las ventanas. ===== <<<

// Funcion para renderizar en la ventana los resultados de las habitaciones que llegen en la cosnulta.
function RenderizarDatosHabitaciones(datos) {

    return;
}

// Funcion para renderizar en la ventana los resultados de las empresas de hospedaje que llegen en la cosnulta.
function RenderizarDatosEmpresaHospedaje(datos) {

    return;
}

// Funcion para renderizar en la ventana los resultados de las empresa de recreacion que llegen en la cosnulta.
function RenderizarDatosEmpresaRecreacion(datos) {

    return;
}

// Funcion para renderizar en la ventana los resultados de los servicios que llegen en la cosnulta.
function RenderizarDatosServicios(datos) {

    return;
}





document.addEventListener("DOMContentLoaded", function () {

    //InciarUbicacionesDinamicas();
    InicarInteractividadFiltros();


});