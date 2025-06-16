
// Inciar la configuacion del mapa.
function inicarConfiguracionMapa() {

    console.log("Iniciando configuracion del mapa.");

    const lat = window.latitudEmpresa || 9.934739;
    const lng = window.longitudEmpresa || -84.087502;

    const map = L.map('map').setView([lat, lng], 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap'
    }).addTo(map);

    L.marker([lat, lng]).addTo(map);

}


// Esto es para que el DOM carge y se puedan ejecutar las funciones que seleccionan elementos del DOM.
document.addEventListener("DOMContentLoaded", function () {
    inicarConfiguracionMapa();
});