document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector("form");
    form.addEventListener("submit", function (e) {
        const email = form.querySelector("input[type='email']");
        const password = form.querySelector("input[type='password']");

        if (!email.value || !password.value) {
            e.preventDefault();
            alert("Por favor, complete todos los campos.");
        }
    });
});
