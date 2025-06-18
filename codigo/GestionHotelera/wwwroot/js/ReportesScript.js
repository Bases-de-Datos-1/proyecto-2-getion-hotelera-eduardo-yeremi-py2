function seleccionarModo(modo) {
    const label = document.getElementById("labelFiltro");
    const input = document.getElementById("inputFiltro");

    if (modo === "reserva") {
        label.innerText = "Introduzca el ID de su reservación";
        input.placeholder = "Ej: 12345";
    } else if (modo === "tipo") {
        label.innerText = "Introduzca el ID del tipo de habitación";
        input.placeholder = "Ej: 1";
    } else if (modo === "numero") {
        label.innerText = "Introduzca el número de su Habitación";
        input.placeholder = "Ej: 203";
    }
}

function buscarFacturas() {
    const id = document.getElementById("inputFiltro").value;
    const inicio = document.getElementById("fechaInicio").value;
    const fin = document.getElementById("fechaFin").value;
    const resultado = document.querySelector(".resultados");

    resultado.innerText = `Mostrando resultados para ID: ${id}, entre ${inicio} y ${fin}`;
}


function InciarUbicacionesDinamicas() {

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



// Funcion para lo que seria desplesgar y mostrar los div para cada tipo de reportes.
function controlSecciones() {
//    const parrafo = document.getElementById('miParrafo');
//    parrafo.classList.add('resaltado'); // Añade la clase 'resaltado'

//    const parrafo = document.getElementById('miParrafo');
//    parrafo.classList.remove('resaltado');
}




document.addEventListener("DOMContentLoaded", function () {

    InciarUbicacionesDinamicas();
    //InicarInteractividadFiltros();


});
