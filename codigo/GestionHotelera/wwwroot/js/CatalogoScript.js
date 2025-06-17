
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


document.addEventListener("DOMContentLoaded", function () {
    //iniciarUbicacionesDinamicas();
    //inciarListenerFormRegitroEmpresa();
    //inicarConfiguracionMapa();
});